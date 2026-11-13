#!/usr/bin/env bash
# Prepara um vídeo para análise visual temporal pelo Claude, sem API key.
# Uso: prepare-visual-analysis.sh <URL-ou-arquivo> [diretório-de-saída]

set -euo pipefail

INPUT="${1:-}"
OUTPUT_DIR="${2:-/tmp/sofia-visual}"
SCENE_THRESHOLD="${SOFIA_SCENE_THRESHOLD:-0.28}"
SAMPLE_SECONDS="${SOFIA_SAMPLE_SECONDS:-auto}"
COOKIE_BROWSER="${SOFIA_COOKIE_BROWSER:-}"

if [[ -z "$INPUT" ]]; then
  echo "Uso: $0 <URL-ou-arquivo> [diretório-de-saída]" >&2
  exit 2
fi

for dependency in ffmpeg ffprobe; do
  if ! command -v "$dependency" >/dev/null 2>&1; then
    echo "Dependência ausente: $dependency" >&2
    exit 3
  fi
done

mkdir -p "$OUTPUT_DIR" "$OUTPUT_DIR/cenas" "$OUTPUT_DIR/amostras" "$OUTPUT_DIR/contatos"

if [[ -f "$INPUT" ]]; then
  VIDEO_PATH="$INPUT"
  printf '%s\n' "$INPUT" > "$OUTPUT_DIR/origem.txt"
else
  if ! command -v yt-dlp >/dev/null 2>&1; then
    echo "Dependência ausente: yt-dlp" >&2
    exit 3
  fi

  download_args=(
    --no-playlist
    --write-info-json
    --write-auto-subs
    --write-subs
    --sub-langs "pt.*,pt,en.*,en"
    --sub-format "vtt/best"
    --write-thumbnail
    --merge-output-format mp4
    -f "bv*+ba/b"
    -o "$OUTPUT_DIR/video.%(ext)s"
  )
  if [[ -n "$COOKIE_BROWSER" ]]; then
    download_args+=(--cookies-from-browser "$COOKIE_BROWSER")
  fi

  echo "Baixando vídeo. Para TikTok privado ou restrito, defina SOFIA_COOKIE_BROWSER=chrome, safari, edge ou firefox." >&2
  yt-dlp "${download_args[@]}" "$INPUT"
  VIDEO_PATH="$(find "$OUTPUT_DIR" -maxdepth 1 -type f \( -name 'video.mp4' -o -name 'video.webm' -o -name 'video.mkv' -o -name 'video.mov' \) | head -1)"
  if [[ -z "$VIDEO_PATH" ]]; then
    echo "O vídeo não foi baixado. A plataforma pode exigir login ou impedir downloads." >&2
    exit 4
  fi
  printf '%s\n' "$INPUT" > "$OUTPUT_DIR/origem.txt"
fi

ffprobe -v error -show_entries format=duration:stream=index,codec_type,codec_name,width,height,r_frame_rate \
  -of json "$VIDEO_PATH" > "$OUTPUT_DIR/metadata-tecnica.json"

DURATION="$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$VIDEO_PATH")"
if [[ "$SAMPLE_SECONDS" == "auto" ]]; then
  # Cerca de 60 quadros; nunca mais rápido que 2 fps nem mais lento que 1/15 s.
  SAMPLE_SECONDS="$(python3 - "$DURATION" <<'PY'
import sys
duration = max(float(sys.argv[1] or 0), 1.0)
print(f"{min(15.0, max(0.5, duration / 60.0)):.3f}")
PY
)"
fi

# Quadros por mudança visual: preservam cortes e transições relevantes.
ffmpeg -hide_banner -loglevel error -i "$VIDEO_PATH" \
  -vf "select='gt(scene,${SCENE_THRESHOLD})',scale='min(960,iw)':-2,format=yuvj420p,showinfo" \
  -vsync vfr "$OUTPUT_DIR/cenas/cena-%05d.jpg" 2> "$OUTPUT_DIR/cenas.log" || true

# Linha do tempo uniforme: impede que trechos sem corte desapareçam da análise.
ffmpeg -hide_banner -loglevel error -i "$VIDEO_PATH" \
  -vf "fps=1/${SAMPLE_SECONDS},scale='min(960,iw)':-2" \
  -q:v 3 "$OUTPUT_DIR/amostras/t-%05d.jpg"

# Áudio completo para transcrição/percepção de ritmo, quando houver.
ffmpeg -hide_banner -loglevel error -i "$VIDEO_PATH" -vn -ac 1 -ar 16000 \
  -c:a mp3 -b:a 64k "$OUTPUT_DIR/audio.mp3" || true

# Folhas de contato cronológicas, 20 quadros por página.
ffmpeg -hide_banner -loglevel error -pattern_type glob -i "$OUTPUT_DIR/amostras/*.jpg" \
  -vf "scale=320:-2,tile=5x4:padding=8:margin=8" -vsync vfr \
  "$OUTPUT_DIR/contatos/linha-do-tempo-%03d.jpg" || true

python3 - "$OUTPUT_DIR" "$SAMPLE_SECONDS" "$VIDEO_PATH" <<'PY'
from pathlib import Path
import json, sys

root = Path(sys.argv[1])
step = float(sys.argv[2])
video_path = str(Path(sys.argv[3]).resolve())
samples = sorted((root / "amostras").glob("*.jpg"))
scenes = sorted((root / "cenas").glob("*.jpg"))
timeline = []
for index, path in enumerate(samples):
    seconds = index * step
    timeline.append({
        "arquivo": str(path),
        "segundos_aproximados": seconds,
        "timestamp": f"{int(seconds // 60):02d}:{int(seconds % 60):02d}",
    })
(root / "manifesto-visual.json").write_text(json.dumps({
    "video": video_path,
    "audio": str(root / "audio.mp3") if (root / "audio.mp3").exists() else None,
    "amostragem_segundos": step,
    "quadros_uniformes": timeline,
    "quadros_de_cena": [str(p) for p in scenes],
    "aviso": "Amostras uniformes e mudanças de cena; timestamps são aproximados.",
}, ensure_ascii=False, indent=2))
PY

echo "$OUTPUT_DIR"
echo "Manifesto: $OUTPUT_DIR/manifesto-visual.json"
echo "Linha do tempo: $OUTPUT_DIR/contatos/linha-do-tempo-001.jpg"
echo "Quadros individuais: $OUTPUT_DIR/amostras/"
echo "Mudanças de cena: $OUTPUT_DIR/cenas/"

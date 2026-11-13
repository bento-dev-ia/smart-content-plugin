#!/usr/bin/env python3
"""Prepara vídeo local/URL para Claude ver quadros e ouvir a linha do tempo, sem API key."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys


def run(args: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, text=True, check=check, capture_output=False)


def output(args: list[str]) -> str:
    return subprocess.check_output(args, text=True).strip()


def require(*commands: str) -> None:
    missing = [name for name in commands if not shutil.which(name)]
    if missing:
        raise SystemExit("Dependências ausentes: " + ", ".join(missing))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", help="URL de YouTube/Instagram/TikTok ou arquivo local")
    parser.add_argument("--output", default="/tmp/sofia-visual")
    parser.add_argument("--max-frames", type=int, default=80)
    parser.add_argument("--start", type=float, default=0.0, help="Segundo inicial da janela")
    parser.add_argument("--end", type=float, help="Segundo final da janela")
    parser.add_argument("--cookies-from-browser", default=os.getenv("SOFIA_COOKIE_BROWSER"))
    args = parser.parse_args()

    require("ffmpeg", "ffprobe")
    root = Path(args.output).expanduser().resolve()
    for folder in (root, root / "frames", root / "scenes", root / "contacts"):
        folder.mkdir(parents=True, exist_ok=True)

    source = Path(args.input).expanduser()
    if source.is_file():
        video = source.resolve()
    else:
        require("yt-dlp")
        command = [
            "yt-dlp", "--no-playlist", "--write-info-json", "--write-auto-subs",
            "--write-subs", "--sub-langs", "pt.*,pt,en.*,en", "--sub-format", "vtt/best",
            "--write-thumbnail", "--merge-output-format", "mp4", "-f", "bv*+ba/b",
            "-o", str(root / "video.%(ext)s"),
        ]
        if args.cookies_from_browser:
            command += ["--cookies-from-browser", args.cookies_from_browser]
        command.append(args.input)
        print("Baixando vídeo. TikTok/Instagram restrito pode exigir --cookies-from-browser.", file=sys.stderr)
        run(command)
        candidates = [p for p in root.glob("video.*") if p.suffix.lower() in {".mp4", ".webm", ".mkv", ".mov"}]
        if not candidates:
            raise SystemExit("O vídeo não foi baixado; a plataforma pode exigir login.")
        video = candidates[0]

    source_duration = float(output(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "default=nw=1:nk=1", str(video)]))
    start = max(0.0, args.start)
    end = min(source_duration, args.end) if args.end is not None else source_duration
    if end <= start:
        raise SystemExit("Janela inválida: --end precisa ser maior que --start.")
    duration = end - start
    interval = min(15.0, max(0.5, duration / max(1, args.max_frames)))
    window = ["-ss", str(start), "-to", str(end)] if start or end < source_duration else []

    metadata = output(["ffprobe", "-v", "error", "-show_entries", "format=duration:stream=index,codec_type,codec_name,width,height,r_frame_rate", "-of", "json", str(video)])
    (root / "metadata.json").write_text(metadata, encoding="utf-8")

    run(["ffmpeg", "-hide_banner", "-loglevel", "error", *window, "-i", str(video), "-vf", f"fps=1/{interval:.3f},scale='min(960,iw)':-2", "-q:v", "3", str(root / "frames" / "t-%05d.jpg")])
    run(["ffmpeg", "-hide_banner", "-loglevel", "error", *window, "-i", str(video), "-vf", "select='gt(scene,0.28)',scale='min(960,iw)':-2,format=yuvj420p", "-vsync", "vfr", str(root / "scenes" / "scene-%05d.jpg")], check=False)
    run(["ffmpeg", "-hide_banner", "-loglevel", "error", *window, "-i", str(video), "-vn", "-ac", "1", "-ar", "16000", "-c:a", "mp3", "-b:a", "64k", str(root / "audio.mp3")], check=False)
    run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-pattern_type", "glob", "-i", str(root / "frames" / "*.jpg"), "-vf", "scale=320:-2,tile=5x4:padding=8:margin=8", "-vsync", "vfr", str(root / "contacts" / "timeline-%03d.jpg")], check=False)

    frames = sorted((root / "frames").glob("*.jpg"))
    manifest = {
        "video": str(video), "audio": str(root / "audio.mp3") if (root / "audio.mp3").exists() else None, "duration_seconds": duration,
        "source_duration_seconds": source_duration, "window_start_seconds": start, "window_end_seconds": end,
        "sample_interval_seconds": interval,
        "frames": [{"path": str(frame), "seconds": round(start + i * interval, 3)} for i, frame in enumerate(frames)],
        "scene_frames": [str(p) for p in sorted((root / "scenes").glob("*.jpg"))],
        "contact_sheets": [str(p) for p in sorted((root / "contacts").glob("*.jpg"))],
    }
    (root / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(root)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

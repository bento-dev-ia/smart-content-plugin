#!/usr/bin/env node
// Análise nativa opcional: envia o vídeo completo ao Gemini Files API.

import fs from "node:fs";
import path from "node:path";
import { GoogleGenAI, createPartFromUri } from "@google/genai";

const videoPath = process.argv[2];
const outputPath = process.argv[3] || "gemini-analise-visual.json";

if (!videoPath || !fs.existsSync(videoPath)) {
  console.error("Uso: analyze-video-gemini.mjs <video> [arquivo-de-saída.json]");
  process.exit(2);
}
if (!process.env.GEMINI_API_KEY) {
  console.error("GEMINI_API_KEY não configurada. Use a análise visual local, que não precisa de chave.");
  process.exit(3);
}

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
const uploaded = await ai.files.upload({ file: videoPath });
let file = uploaded;
while (file.state === "PROCESSING") {
  await new Promise((resolve) => setTimeout(resolve, 3000));
  file = await ai.files.get({ name: file.name });
}
if (file.state === "FAILED") {
  throw new Error(`O Gemini não conseguiu processar o vídeo: ${file.name}`);
}

const prompt = `Analise o vídeo visual e temporalmente, não apenas a fala. Responda em JSON válido, sem markdown.
Inclua: resumo_visual, timeline com timestamps e descrição de cada mudança relevante, cortes_e_transicoes,
enquadramento_e_camera, gestos_e_expressoes, texto_na_tela, objetos_e_acoes, ritmo_visual,
sincronia_audio_imagem, hook_visual, payoff_visual, cta_visual, pontos_fortes, problemas,
evidencias_com_timestamp e incertezas. Não invente o que não estiver perceptível.`;

const response = await ai.models.generateContent({
  model: process.env.SOFIA_GEMINI_MODEL || "gemini-2.5-flash",
  contents: [createPartFromUri(file.uri, file.mimeType), prompt],
  config: { responseMimeType: "application/json" },
});

fs.writeFileSync(outputPath, response.text, "utf8");
console.log(path.resolve(outputPath));


---
name: analisar
description: Analisa visualmente vídeos locais ou de YouTube, Instagram e TikTok, junto da fala, métricas e comentários. Use quando o usuário enviar um vídeo ou link e pedir análise de conteúdo, retenção, roteiro, edição ou formato.
---

# Analisar Vídeo

## Trigger

Usuário cola link(s) de vídeo ou pede para analisar conteúdo.

## Antes de analisar — pergunte (1-2 perguntas)

Não saia analisando sem saber pra quê:

1. "Por que quer analisar esse vídeo?" (aprender, copiar formato, comparar)
2. "Tem algo específico que te chamou atenção?" (abertura, roteiro, comentários)

Se já ficou claro pelo contexto, pule direto.

## Escolha da rota de captura

Escolha pela superfície e não tente uma rota que o ambiente sabidamente bloqueia. Não peça ao usuário que escolha o encanamento.

1. **Arquivo local ou enviado:** análise completa com `scripts/prepare-visual-analysis.py`.
2. **Claude Code/Cowork Desktop via yt-dlp:** análise completa de YouTube, Instagram e TikTok; tente `SOFIA_COOKIE_BROWSER` se a sessão for necessária.
3. **Claude Chat com Apify:** metadados, capa, transcrição e comentários. Analise visualmente só a capa; o Chat não consegue baixar o MP4 retornado pelo actor.
4. **Claude Chat sem Apify:** apenas informações públicas encontradas sobre o vídeo ou perfil; diga a limitação e ofereça upload.

Não diga “não consigo analisar vídeo”. Diga qual camada ficou inacessível e ofereça upload ou execução no Claude Code/Cowork Desktop. Nunca descreva edição ou timestamp que não foi realmente inspecionado.

No Claude Chat + Apify, declare uma vez que só a capa foi inspecionada e que cortes, gestos e texto na tela ao longo do vídeo exigem o arquivo no Claude Code/Cowork Desktop. Não tente `yt-dlp` contra TikTok/Instagram no Chat e não tente baixar URLs assinadas de `api.apify.com` com `curl` ou `web_fetch`: esses hosts são bloqueados pelo sandbox.

## Visão, superfície e modelo

Claude não recebe MP4 como modalidade visual nativa. A abordagem oficial é decompor o vídeo em imagens ordenadas e cruzá-las com timestamps e transcrição; GIF animado usa somente o primeiro quadro.

- Todos os modelos Claude atuais têm visão. Quando houver seleção, prefira **Claude Opus 5** para análise exigente ou **Claude Sonnet 5** para equilíbrio entre velocidade e qualidade.
- Para texto pequeno, muitos quadros ou detalhes de edição, use Claude 4.7 ou posterior, que tem resolução visual nativa maior. Não bloqueie a tarefa se a superfície não permitir escolher.
- Claude Chat aceita até 20 imagens por mensagem: inspecione lotes cronológicos numerados e só conclua ao terminar todos. Folhas de contato são visão geral; abra quadros individuais para ler texto, gesto e objeto.
- Cowork Desktop é a melhor rota sem API key porque combina arquivo local e execução de código. No Cowork web/mobile, o Desktop precisa estar aberto para fornecer arquivos locais e navegador.
- Em vídeo longo, faça uma varredura ampla e depois uma segunda passada focada nos intervalos relevantes. Não trate amostragem esparsa como observação contínua.

## Captura via Apify no Claude Chat

Use as ferramentas do conector, nunca download de URL assinada pelo shell:

1. Chame `clockworks/tiktok-video-scraper` uma vez por vídeo com:

```json
{
  "postURLs": ["URL_LIMPA"],
  "shouldDownloadVideos": true,
  "shouldDownloadCovers": true,
  "downloadSubtitlesOptions": "TRANSCRIBE_ALL_VIDEOS"
}
```

Use `DOWNLOAD_SUBTITLES` quando a legenda nativa bastar e custo menor for prioridade. O custo observado de `TRANSCRIBE_ALL_VIDEOS` fica perto de US$ 0,05 por vídeo, mas é apenas estimativa e pode mudar.

2. Em `get-dataset-items`, leia `diggCount`, `shareCount`, `playCount`, `commentCount`, `collectCount`, `videoMeta.transcriptionLink` e `videoMeta.coverUrl`.
3. Extraia `{storeId}` e `{key}` dos dois links e chame `get-key-value-store-record`: a transcrição volta como texto e a capa como imagem renderizada. Inspecione a capa e compare seu texto com a primeira frase.
4. Não busque `videoMeta.downloadAddr` no Chat. Arquivo grande vira URL assinada inacessível nesse sandbox.
5. Chame `clockworks/tiktok-comments-scraper` uma vez por vídeo com `postURLs: [URL_LIMPA]` e `commentsPerPost: 20`. Leia `text`, `diggCount`, `uniqueId`, `createTimeISO` e ordene por `diggCount` decrescente antes de selecionar os principais. O custo observado para 20 comentários fica perto de US$ 0,025, sujeito a mudança.

Embora `postURLs` aceite arrays, use uma chamada por URL para manter métricas, transcrição, capa e comentários rastreáveis até a seção correta do dashboard.

## Fluxo

### 1. Preparação visual obrigatória (agente: pesquisador)

Não diga que analisou o visual sem abrir e inspecionar os quadros gerados.

1. Execute o preparador com uma pasta nova por vídeo:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/scripts/prepare-visual-analysis.py" "URL_OU_ARQUIVO" --output "/tmp/sofia-visual-IDENTIFICADOR"
```

2. Leia `manifest.json` e abra com a ferramenta de imagens **todas** as folhas de `contacts/`, na ordem.
3. Se houver mudança rápida, texto pequeno ou ação ambígua, abra os quadros correspondentes de `frames/` e `scenes/`.
4. Cruze os timestamps aproximados com a legenda ou com `audio.mp3`. A linha do tempo uniforme evita perder ações sem corte; os quadros de cena preservam mudanças visuais.
5. Rode uma segunda passada mais densa no trecho quando a visão geral indicar uma mudança decisiva ou ambígua, usando `--start SEGUNDO --end SEGUNDO --max-frames 40`.
6. Se `GEMINI_API_KEY` estiver disponível e o usuário autorizar enviar o vídeo ao Google, complemente com análise nativa:

```bash
node "${CLAUDE_PLUGIN_ROOT}/scripts/analyze-video-gemini.mjs" "CAMINHO_VIDEO_DO_MANIFESTO" "/tmp/sofia-visual-IDENTIFICADOR/gemini.json"
```

A rota local é o padrão e não exige chave. A rota Gemini é opcional. Nunca envie vídeo a terceiros sem avisar.

### 2. Pesquisa de fala e reação (agente: pesquisador)

- Transcrição completa
- Top 20 comentários
- Métricas (views, likes, comments)
- Hook isolado

**TikTok e Instagram seguem o mesmo padrão de evidência, mas a camada disponível depende da superfície.** No Claude Code/Cowork Desktop, baixe vídeo, legenda e metadados com `yt-dlp`; se exigir sessão, tente `SOFIA_COOKIE_BROWSER`. No Chat, pule direto para o actor apropriado do Apify e não prometa quadros do meio. Sem comentários, continue com as camadas realmente disponíveis e declare apenas essa ausência.

### 3. Análise visual e bloco a bloco (agente: analista-de-principios)

Comece com uma leitura visual baseada em evidências:

- hook visual dos primeiros segundos;
- cortes, câmera, enquadramento, gestos e expressões;
- texto na tela e relação entre imagem e fala;
- ritmo visual e mudanças com timestamps;
- limitações do que não foi possível confirmar.

**Formato obrigatório:** roteiro em blockquote, análise embaixo em 1-2 frases. Sempre nomeie o princípio.

```markdown
> "Frase do roteiro"

(Princípio) O que faz e por que funciona. Se fraco: como melhorar.

> "Próxima frase"

(Princípio + Princípio) Comentário curto.
```

**Regras de concisão:**
- Máximo 2 frases por bloco
- Não repita o que a frase diz
- Se não tem nada pra comentar, agrupe com a próxima
- Se algo está fraco ou faltando: diga qual princípio e sugira melhoria

### 4. Insights de comentários (3-4 linhas)
- Reação dominante
- O que mais comentaram e o que isso revela

### 5. Resumão

```markdown
## Resumo
- **Jeito de gravar:** [formato de `references/formatos/`] — regras respeitadas? [1 frase]
- **Hook visual:** [o que aparece + timestamp]
- **Ritmo de edição:** [cortes, mudanças e sincronização]
- **Ângulo:** [arquétipo A1–A15 de `knowledge/arquetipos-nichos-bolhas.md`]
- **Ordem da história:** [estrutura de `references/estruturas-de-roteiro/`]
- **Ideia:** [1 frase]
- **Por que funciona:** [1-2 motivos]
- **Ponto mais forte:** [o que carrega]
- **O que dá pra aprender:** [padrão aplicável]
- **Princípios presentes:** [lista curta]
- **Princípios que faltam:** [se relevante]
```

### 6. Salvar
`Sofia/Pesquisas/{canal}/{titulo}/`

### 7. Próximos passos
> "O que quer fazer?
> 1. Escrever um roteiro inspirado nisso (vou te perguntar antes)
> 2. Comparar com outro vídeo
> 3. Salvar padrões na base de conhecimento
> 4. Exportar"

### 8. Artifact obrigatório

Ao terminar, acione a skill `dashboard` e gere um artifact organizado com a análise completa. Em superfícies com Artifacts, apresente-o diretamente na conversa. No Claude Code ou ambiente sem Artifact, gere HTML autocontido a partir de `${CLAUDE_PLUGIN_ROOT}/templates/dashboard.html` e salve em `Sofia/Analises/dashboard.html`.

**Uma solicitação gera exatamente um dashboard.** Se houver vários vídeos, só gere o artifact depois que todos estiverem analisados. O topo deve ter comparação de métricas, ranking de abertura, padrão comum e principal variável diferente; abaixo, uma seção completa e navegável por vídeo. Preserve análises anteriores ao atualizar o dashboard acumulativo e use URL/ID para não duplicar vídeo.

O artifact deve conter, para cada vídeo: dados, diagnóstico, hook com nota, evidências visuais com imagens e timestamps, linha do tempo, relação imagem–fala, cortes/câmera/gestos/texto em tela, roteiro anotado, comentários, aprendizados e limitações. Na resposta textual, mostre só os três achados principais e o link do artifact.

## Múltiplos vídeos

Analise cada vídeo em área temporária própria, mas não crie dashboard individual. Gere um único artifact do lote com:
- métricas e taxa curtidas/views lado a lado;
- capas e aberturas comparadas;
- o que têm em comum;
- o padrão mais forte;
- a principal variável que mudou;
- análise completa de cada vídeo.

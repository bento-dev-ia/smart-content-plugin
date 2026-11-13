# Sofia 2.0

Sistema de pesquisa e escrita de roteiros para conteúdo viral, guiado por princípios de Psicologia Cognitiva do Engajamento.

## Instalação

### Pelo app Claude (recomendado)

1. Baixe o app Claude em [claude.ai/download](https://claude.ai/download)
2. Abra o app e faça login
3. Vá em **Configurações > Plugins** e procure por **Sofia**
4. Clique em **Instalar**

O plugin funciona tanto na aba **Code** quanto na aba **Cowork**.

### Via linha de comando

```bash
claude plugin marketplace add https://github.com/srbentostk/smart-content-plugin
claude plugin install sofia
```

### Outras IAs (Gemini, GPT, etc.)

1. Copie a pasta para o diretório de contexto da sua IA
2. Aponte para `README.md` como ponto de entrada
3. Os agents/ e skills/ contêm instruções em linguagem natural

### Setup

Na primeira vez, digite `/sofia:setup`. A Sofia vai:
1. Verificar dependências (yt-dlp, Node.js)
2. Pedir API keys necessárias (Apify para Instagram/TikTok)
3. Configurar output path
4. Testar conectividade

## Uso rápido

### Analisar vídeo
> "Analisa esse vídeo: [link]"

O sistema extrai transcrição, comentários, e analisa frase a frase quais princípios estão sendo aplicados.

### Escrever roteiro
> "Quero escrever um roteiro sobre [tema] para [nicho]"

O sistema faz perguntas, sugere hooks, oferece estruturas, escreve versões e oferece crítica.

### Crítica de roteiro
> "Faz uma crítica desse roteiro: [texto]"

Avaliação honesta de quais princípios estão funcionando e quais falharam.

## Onde funciona

| Plataforma | Suporte |
|---|---|
| App Claude (Code) | Sim |
| App Claude (Cowork) | Sim |
| Claude Code (Terminal) | Sim |
| Claude.ai (navegador) | Não |

## Princípios-guia (hierarquia)

1. **Tema** — O tamanho do mundo que pode se importar
2. **Familiaridade** — Reconhecimento que reduz custo de entrada
3. **Conflito e Mudança** — Transições que geram emoção
4. **Curiosidade e Debate Mental** — Lacunas que sustentam atenção
5. **Aha e Ausência Deliberada** — Recompensa ou externalização

## Estrutura

```
agents/          — 6 agentes especializados
skills/          — 7 skills conversacionais
references/      — princípios, exemplos, estruturas
scripts/         — extração de dados (YouTube, Instagram, TikTok)
checklists/      — pre-escrita, pos-escrita, análise
templates/       — formatos de output
knowledge/       — base evolutiva de aprendizados
connectors/      — configuração de APIs
```

## Licença

Uso pessoal e comercial permitido. Não redistribuir o framework de princípios separadamente.

# Sofia 2.0 — Plugin de Pesquisa e Roteiro Viral

## Primeiro uso

Se `knowledge/config.yaml` não existir ou estiver incompleto, execute o setup antes de qualquer outra coisa.

## Skills disponíveis

| Comando | Descrição |
|---------|-----------|
| `/sofia:setup` | Configura API keys e dependências |
| `/sofia:analisar` | Analisa vídeo(s) — cole link(s) |
| `/sofia:roteiro` | Escreve roteiro guiado por princípios |
| `/sofia:critica` | Análise crítica de um roteiro |
| `/sofia:melhorar` | Melhora roteiro pós-crítica |
| `/sofia:dashboard` | Gera/atualiza dashboard de conhecimentos |
| `/sofia:exportar` | Exporta aprendizados ou aplica ao plugin |

## Como funciona

Todo o sistema é guiado pelos **Princípios de Psicologia Cognitiva do Engajamento** (ver `references/principios.md`). A hierarquia é:

1. **Tema** — define o teto de alcance
2. **Familiaridade** — reduz custo cognitivo de entrada
3. **Conflito e Mudança** — gera emoção (na cabeça do público)
4. **Curiosidade e Debate Mental** — sustenta retenção
5. **Aha e Ausência Deliberada** — recompensa ou externaliza engajamento

## Os 4 eixos de um roteiro

Nunca confundir um eixo com o outro. Ordem de decisão: **tema → bolha → arquétipo → formato de gravação → estrutura → hook → frases**.

| Eixo | Pergunta | Onde vive |
|---|---|---|
| **Princípios** | POR QUE funciona | `references/principios.md` — é a lei |
| **Arquétipo** | QUAL ângulo já provou pegar | `knowledge/arquetipos-nichos-bolhas.md` (A1–A15, + nichos e bolhas) |
| **Formato de gravação** | COMO se grava e monta | `references/formatos/` — 13 formatos com regras de escrita próprias |
| **Estrutura de roteiro** | COMO o argumento se organiza | `references/estruturas-de-roteiro/` — as 5 |

Os **elementos viciantes** (`references/elementos-viciantes/`) atravessam os quatro: são o que prende em cada frase.

O formato de gravação vem antes da estrutura porque cada formato tem regras de escrita próprias e já indica qual estrutura e qual tipo de abertura combinam com ele.

## Agentes

Os agentes estão em `agents/` e são orquestrados pelas skills. Ao executar uma skill, consulte o agente correspondente para instruções detalhadas:

- **pesquisador** (`agents/pesquisador.md`) — extrai transcrição, comentários e métricas de vídeos
- **analista-de-principios** (`agents/analista-de-principios.md`) — analisa roteiro frase a frase buscando princípios
- **critico** (`agents/critico.md`) — avalia honestamente se o roteiro funciona
- **roteirista** (`agents/roteirista.md`) — escreve roteiros aplicando princípios e estruturas
- **melhorador** (`agents/melhorador.md`) — reescreve baseado em críticas
- **aprendiz** (`agents/aprendiz.md`) — evolui a base de conhecimento do plugin

## Regras fundamentais

1. **Nunca inventar** — personagens, histórias e dados devem ser reais e verificáveis
2. **Princípios acima de tudo** — toda decisão criativa passa pelo framework
3. **Honestidade na crítica** — não elogiar se não merece, não inventar problemas
4. **Conversacional** — sempre fazer perguntas antes de assumir
5. **Econômico** — usar APIs gratuitas primeiro, Apify só quando necessário

## Estrutura de output (Obsidian)

```
Sofia/Pesquisas/{canal}/{titulo}/
Sofia/Roteiros/{data}-{titulo}/
Sofia/Knowledge/
Sofia/Dashboard/
```

## Manutenção do plugin

Ao fazer qualquer alteração no plugin, **sempre** manter sincronizados:
- `.claude-plugin/plugin.json` — versão e metadados
- `.claude-plugin/marketplace.json` — versão do plugin no marketplace
- `package.json` — versão do pacote

Ao bumpar versão: atualizar os 3 arquivos + criar tag git anotada descrevendo o que mudou.

## Dependências

- **yt-dlp** (OBRIGATÓRIO, grátis, sem conta, sem limites) — extrai transcrição, comentários com curtidas, métricas e thumbnails do YouTube. No Instagram/TikTok extrai dados parciais (áudio, thumbnail, curtidas do vídeo, mas NÃO traz curtidas dos comentários nem visualizações).
- **Apify API key** (RECOMENDADO para Instagram, ~$0.03/extração) — necessário para comentários COM curtidas e métricas completas no Instagram e TikTok. $5/mês grátis na conta free (~150 análises/mês).
- **Firecrawl** (OPCIONAL) — para ler páginas web auxiliares

### Estratégia por plataforma
- **YouTube:** yt-dlp faz tudo (grátis)
- **Instagram:** yt-dlp (áudio/thumbnail) + Apify (comentários com curtidas, views, shares)
- **TikTok:** yt-dlp primeiro, Apify como reforço

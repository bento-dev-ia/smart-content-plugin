---
name: roteiro
description: Escreve roteiro para conteúdo viral de forma conversacional, guiado pelos princípios de Psicologia Cognitiva do Engajamento. Faz perguntas, sugere hooks, oferece versões e análise crítica.
---

# Escrever Roteiro

## Trigger

Usuário quer criar um novo roteiro/conteúdo.

## Fluxo conversacional

### Fase 0: Verificar estilo de escrita

Antes de tudo, verificar se existe perfil de estilo:

1. **Se `knowledge/estilos/` tem perfis:**
   - **Um perfil só** → Usar automaticamente. Avisar: "Vou escrever no seu estilo ({nome})."
   - **Vários perfis** → Perguntar: "Pra qual perfil estou escrevendo?" + listar opções

2. **Se NÃO tem perfis:**
   Na primeira interação, oferecer:
   > "Antes de escrever, quer que eu aprenda seu estilo de escrita? Se me mandar 3-5 dos seus melhores roteiros, eu aprendo como você fala e escrevo no seu tom. Se preferir, posso escrever sem estilo personalizado por enquanto."

   Se disser sim → Seguir fluxo de aprendizado de estilo (mesmo da skill setup, seção 7).
   Se disser não → Continuar usando `references/como-escrever-bem.md` como guia de escrita geral.

### Fase 1: Investigação do tema e da bolha

**REGRA:** Não avance para hooks ou escrita sem ter clareza total sobre o tema, a bolha e o contexto emocional do público. Faça perguntas uma a uma ou em blocos curtos — adapte conforme as respostas.

**Bloco 1 — O básico:**
1. "Qual é o tema ou assunto do vídeo?"
2. "Qual é seu nicho / quem é seu público?"
3. "Qual é a IDEIA que você quer que o público saia acreditando?" (a crença)

**Bloco 2 — A bolha e o contexto emocional:**
4. "O que as pessoas da sua bolha estão comentando sobre esse tema agora? Tem alguma polêmica, debate ou opinião dividida?"
5. "Qual é a emoção que seu público JÁ carrega sobre esse assunto? (raiva, frustração, curiosidade, medo, esperança...)"
6. "Tem algum personagem, caso real ou situação específica que seu público já conhece e que se conecta com esse tema?"
7. "Existe alguma crença popular sobre esse tema que está errada ou que você discorda?"

**Bloco 3 — Contexto criativo:**
8. "Tem alguma referência de vídeo que gosta?"
9. "Qual formato de gravação você consegue fazer?" — consultar o catálogo completo em `references/formatos/README.md` e sugerir opções compatíveis com o tema, a intenção e os recursos reais do usuário. O catálogo tem 23 formatos; não se limite aos exemplos mais antigos.
10. "Tem alguma restrição? (duração, tom, assuntos a evitar)"

Se o usuário não souber a ideia, ajude:
- "Que conflito universal toca esse tema para o maior número de pessoas possível?"
- "Que emoção seu público JÁ carrega sobre isso?"
- "Que polêmica ou discussão existe na sua bolha sobre isso?"

**Antes de avançar — validação obrigatória:**
Avaliar internamente e ser honesto com o usuário:
- O tema é GRANDE o suficiente? (atinge muitas pessoas?)
- Existe conflito real que acontece NA CABEÇA do público?
- Tem familiaridade suficiente para o público entrar rápido?

Se o tema for pequeno ou fraco, diga e sugira como ampliar.

### Fase 2: Arquétipo, formato de gravação e estrutura

**2a — Formato de gravação.** Antes da estrutura, definir COMO vai gravar. Consultar `references/formatos/README.md` (seção "Como escolher" e a tabela que casa arquétipo com formato) e sugerir 2-3 formatos compatíveis com o tema E com o que o usuário consegue produzir:
> "Pelo tema, esses jeitos de gravar funcionam melhor:
> 1. [Formato] — [o que é, em 1 linha]
> 2. [Formato] — [o que é]
> Qual dá pra fazer?"

Depois de escolhido, abrir `references/formatos/<formato>.md` e usar as **Regras de escrita** dele como lei durante toda a escrita.

**2b — Arquétipo e estrutura.** Consultar `knowledge/arquetipos-nichos-bolhas.md` (escolher o ARQUÉTIPO/ângulo pela bolha/nicho do tema — ele já aponta a estrutura sugerida) e `references/estruturas-de-roteiro/` (as 5 estruturas oficiais), e sugerir 2-3 estruturas:
> "Com base no que você me disse, sugiro essas estruturas:
> 1. [Nome] — [descrição curta de como funciona]
> 2. [Nome] — [descrição curta]
> 3. [Nome] — [descrição curta]
> Qual prefere? Posso escrever em mais de uma se quiser comparar."

### Fase 3: Hook (3-5 sugestões)

Gerar hooks variados, cada um usando princípios diferentes. **O Hook 1 é sempre um choque de crença** (hipótese em teste, ver `knowledge/hooks-que-funcionam.md`): contraria o que o público acredita e diz o que ele gostaria que fosse verdade. Mostrar junto: crença → desejo → onde o vídeo paga.

```
Hook 1: [frase] 
→ Usa: Conflito universal + curiosidade
→ Por que funciona: [1 linha]

Hook 2: [frase]
→ Usa: Familiaridade + contraste
→ Por que funciona: [1 linha]

Hook 3: [frase]
→ Usa: Polêmica/debate mental
→ Por que funciona: [1 linha]

Hook 4: [frase]
→ Usa: Aha antecipado + loop
→ Por que funciona: [1 linha]

(Hook 5 opcional: experimental)
```

Perguntar: "Qual hook te chamou mais atenção? Pode escolher um, combinar, ou escrever uma versão melhor."

### Fase 4: Roteiro completo

Com hook definido, escrever **2-3 versões**:
- Cada versão usa estrutura/abordagem diferente
- Todas aplicam os princípios rigorosamente
- Todas seguem `references/regras-universais.md`
- Consultar `references/elementos-viciantes/` e aplicar

Para cada versão, incluir nota curta:
> "Versão 1 — Estrutura: [nome]. Foco em: [princípio dominante]"

### Fase 5: Escolha e refinamento

Perguntar: "Qual versão prefere? Quer que eu ajuste algo?"

Se o usuário pedir ajustes, fazer sem reescrever tudo.

### Fase 6: Análise crítica (sugestão)

> "Quer que eu rode uma análise crítica nesse roteiro? Vou avaliar se os princípios estão bem aplicados e se tem pontos fracos."

Se sim → ativar agentes `analista-de-principios` e `critico`.

### Fase 7: Melhorias (se aplicável)

Se a crítica identificar problemas:
> "A análise encontrou [N] pontos para melhorar. Quer que eu reescreva aplicando as sugestões?"

Se sim → ativar agente `melhorador`.

### Fase 8: Lista de gravação (Obsidian)

Sempre que o roteiro chegar a `status: PRONTO PARA GRAVAR`, ou quando o usuário pedir para ver/priorizar o que está pronto para gravar (mesmo sem ter acabado de escrever nada nesta conversa), gerar a lista de abertura rápida:

**Por quê:** links `obsidian://` não funcionam quando clicados a partir do chat. O formato que funciona é nome de arquivo (sem `.md`) para colar no Quick Switcher (`Cmd+O`).

**Formato:**
1. Dar o caminho absoluto da pasta UMA vez, em bloco de código.
2. Listar cada roteiro pronto, em ORDEM DE PRIORIDADE (não alfabética/numérica), cada nome de arquivo exato (sem `.md`) em seu próprio bloco de código.
3. Critério de priorização, nessa ordem:
   - **Notícia com prazo de validade** (arquétipo A2 Newsjacking, ou qualquer roteiro com `⚠️ Honestidade` avisando sobre data/fato que muda) vem primeiro, e quanto mais dias desde a `data` do frontmatter, maior a urgência — sinalizar explicitamente quantos dias se passaram e que os fatos precisam ser reconferidos antes de gravar.
   - Depois, roteiros que terminam num gatilho de DM/comentário ligado a uma dor de vendas real do momento (ex.: primeira venda sem audiência, não dar conta de prospectar/postar) — checar `knowledge/dashboard-insights.md` e o TO-DO/plano ativo do vault se precisar confirmar qual dor está em foco agora.
   - Por último, conteúdo evergreen (educativo, comparação, funcionalidade sem prazo) — sempre disponíveis, sem pressa de data.
4. Se algum roteiro newsjacking já passou de ~5-7 dias da `data` do frontmatter, avisar explicitamente que o conteúdo pode estar defasado e perguntar se ainda vale a pena gravar como está ou se precisa de uma atualização rápida antes.

## Regras durante toda escrita

- SEMPRE consultar `references/principios.md` antes de escrever
- Consultar `knowledge/arquetipos-nichos-bolhas.md` (arquétipo/ângulo certo por bolha/nicho, com a estrutura sugerida) e `knowledge/dashboard-insights.md` (assuntos/dores/hooks que já deram views) ao escolher tema, dor e hook
- SEMPRE consultar `references/como-escrever-bem.md` — escrever como a pessoa fala, não como se escreve
- SEMPRE rodar `references/sem-slop.md` antes de entregar qualquer versão: matar advérbio em -mente, travessão no corpo, "não é X, é Y", frase de efeito e voz passiva
- Se existe perfil de estilo do usuário em `knowledge/estilos/`, SEGUIR o tom, ritmo, palavras e tipo de abertura do perfil
- NUNCA inventar personagens, histórias ou dados
- Se usar pessoa real, DEVE ser verificável com fonte
- Gerar familiaridade, curiosidade, evitar redundância
- O tema é a decisão mais importante — validar antes de tudo
- Moral da história DEVE conectar com a vida do público
- Usar linguagem da bolha do público
- Frases curtas. Escrever como quem fala, não como quem escreve redação
- "E", "Aí", "Mas" pra começar frases — é roteiro, não texto acadêmico
- Verbos de ação + detalhes específicos > adjetivos genéricos
- Ler em voz alta — se não soa natural, reescrever

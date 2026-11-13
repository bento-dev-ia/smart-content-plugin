---
name: dashboard
description: Gera a dashboard de analise de video — pagina visual com roteiro anotado, hooks, comentarios e insights. Oferece opcao de salvar para aprender.
---

# Dashboard de Analise

## Trigger

Apos a analise completa de um ou mais videos, ou quando o usuario pede para gerar dashboard.

## Unidade do artifact

- Uma solicitação de análise gera **um único dashboard**.
- Um vídeo vira um item. Vários vídeos viram vários itens no mesmo artifact, nunca arquivos individuais.
- Só renderize depois que todo o lote estiver analisado.
- Ao atualizar `Sofia/Analises/dashboard.html`, preserve os itens anteriores e faça upsert por URL/ID para não duplicar vídeos.
- Em lote, abra com comparação de métricas, taxa curtidas/views, ranking de hooks, padrão comum e principal variável que mudou; depois mostre a análise completa de cada vídeo.

## O que a dashboard mostra

A dashboard e uma pagina visual (HTML ou artefato) que apresenta:

### 1. Header
- Titulo do video
- Criador/canal
- Plataforma
- Link para o original

### 2. Diagnostico
- Ideia vendida
- Tamanho do tema
- O que carrega o video
- O que poderia amplificar

### 3. Hook (destaque)
- Texto do hook
- Tags dos principios presentes
- Analise de por que funciona
- Nota 1-10

### 4. Evidências visuais e linha do tempo
- Quadros realmente inspecionados, com timestamp aproximado
- Hook visual, cortes, câmera, enquadramento, gestos e texto em tela
- Relação entre imagem, fala e música
- Mudanças de ritmo e momentos de payoff
- Limitações e trechos que não foi possível confirmar

### 5. Roteiro anotado frase a frase
Para cada frase do roteiro:
- Tags coloridas dos principios identificados
- Explicacao curta de como funciona
- Texto original da frase

Classes de principio para as tags:
- `tema` — roxo
- `familiaridade` — verde
- `conflito` — vermelho
- `curiosidade` — azul
- `contraste` — amarelo
- `aha` — roxo claro
- `moral` — teal
- `debate` — laranja
- `identificacao` — azul claro
- `linguagem` — verde claro
- `ritmo` — rosa

### 6. Comentarios mais curtidos com insights
Para cada comentario:
- Autor
- Numero de likes
- Texto
- Insight: o que esse comentario revela sobre o debate mental do publico

### 7. Botoes de acao
- **Salvar para aprender** — ao clicar, Sofia incorpora:
  - Hooks na colecao de hooks (`knowledge/hooks-que-funcionam.md`)
  - Roteiro anotado como nova referencia (`references/exemplos-analisados/`)
  - Padroes identificados (`knowledge/padroes-aprendidos.md`)
  - Insights de comentarios
- **Exportar .md** — gera arquivo markdown com toda a analise

## Como gerar

### Em Claude Code / terminal
Gerar HTML usando o template `templates/dashboard.html`:
- Substituir todo o JSON dentro de `<script id="sofia-data" type="application/json">` pelos itens reais
- Manter o array como JSON válido e um objeto por vídeo
- Salvar em `Sofia/Analises/dashboard.html`

### Em ambientes com artefatos (Claude.ai, etc.)
Gerar como artefato interativo diretamente na conversa.

## Fluxo de "Salvar para aprender"

Quando o usuario clica "Salvar para aprender":

1. **Hooks** — extrair hook + analise, adicionar em `knowledge/hooks-que-funcionam.md`
2. **Roteiro como referencia** — salvar roteiro anotado completo em `references/exemplos-analisados/` como novo exemplo que os agentes podem consultar ao escrever
3. **Padroes** — extrair padroes de estrutura/principios e adicionar em `knowledge/padroes-aprendidos.md`
4. **Insights de comentarios** — salvar insights relevantes

Ao incorporar, o agente `aprendiz` e ativado para:
- Verificar se o hook/padrao ja existe (nao duplicar)
- Formatar no padrao correto de cada arquivo
- Confirmar com o usuario o que foi adicionado

## Regras

- A dashboard e de LEITURA e APRESENTACAO — bonita e clara
- Nunca gerar um dashboard por vídeo quando a solicitação contém vários vídeos
- O botao "Salvar para aprender" e a unica acao que modifica o plugin
- Sempre mostrar o que vai ser salvo antes de salvar
- HTML funciona offline, sem dependencias externas
- Se o ambiente suporta artefatos, preferir artefato

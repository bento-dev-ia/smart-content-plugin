---
description: Gera a dashboard de analise de video — pagina visual com roteiro anotado, hooks, comentarios e insights. Oferece opcao de salvar para aprender.
---

# Dashboard de Analise

## Trigger

Apos analise de video completa, ou quando o usuario pede para gerar dashboard.

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

### 4. Roteiro anotado frase a frase
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

### 5. Comentarios mais curtidos com insights
Para cada comentario:
- Autor
- Numero de likes
- Texto
- Insight: o que esse comentario revela sobre o debate mental do publico

### 6. Botoes de acao
- **Salvar para aprender** — ao clicar, Sofia incorpora:
  - Hooks na colecao de hooks (`knowledge/hooks-que-funcionam.md`)
  - Roteiro anotado como nova referencia (`references/exemplos-analisados/`)
  - Padroes identificados (`knowledge/padroes-aprendidos.md`)
  - Insights de comentarios
- **Exportar .md** — gera arquivo markdown com toda a analise

## Como gerar

### Em Claude Code / terminal
Gerar HTML usando o template `templates/dashboard.html`:
- Preencher os placeholders (`<!-- SOFIA:campo -->`) com dados reais
- Salvar em `Sofia/Dashboard/` ou mostrar inline

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
- O botao "Salvar para aprender" e a unica acao que modifica o plugin
- Sempre mostrar o que vai ser salvo antes de salvar
- HTML funciona offline, sem dependencias externas
- Se o ambiente suporta artefatos, preferir artefato

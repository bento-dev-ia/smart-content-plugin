---
description: Exporta conhecimentos como arquivos .md ou aplica aprendizados diretamente no plugin para melhorar escrita futura.
---

# Exportar e Aprender

## Trigger

Usuário pede para exportar resultados ou pede para o plugin "aprender" com uma análise.

## Modos

### Modo 1: Exportar como .md
Gerar arquivo(s) markdown com:
- Análise completa formatada
- Hooks coletados
- Insights de comentários
- Padrões identificados

Output em pasta escolhida pelo usuário ou `Sofia/Exports/`.

### Modo 2: Aprender (atualizar plugin)
Ativar agente `aprendiz` para:
1. Extrair padrões da análise recente
2. Adicionar hooks à coleção
3. Identificar novos elementos viciantes
4. Atualizar `knowledge/` com novos aprendizados
5. Sugerir melhorias em references/agents (com confirmação)

### Modo 3: Exportar base completa
Gerar arquivo único com toda a base de conhecimento:
- Todos os hooks coletados
- Todos os padrões aprendidos
- Todas as métricas agregadas
- Útil para backup ou migração

## Fluxo

1. Perguntar: "O que quer fazer?"
   - Exportar última análise como .md
   - Aprender com a última análise (atualizar base)
   - Exportar toda a base de conhecimento
   - Aplicar melhorias nos agentes/skills

2. Executar modo escolhido

3. Confirmar:
   - Se exportar: mostrar caminho do arquivo
   - Se aprender: mostrar o que foi adicionado/atualizado
   - Se melhorar plugin: mostrar diff e pedir confirmação

## Regras

- Nunca modificar agents/ ou skills/ sem confirmação explícita
- Sempre mostrar o que vai ser alterado antes de alterar
- Exportações não afetam a base de conhecimento
- Aprendizados são aditivos (não sobrescrevem, adicionam)

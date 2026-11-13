---
description: Configura o plugin Sofia 2.0 - verifica dependências, pede API keys, configura output. Use na primeira execução ou quando config.yaml estiver incompleto.
---

# Setup do Sofia 2.0

## REGRA OBRIGATÓRIA: TUDO EM PORTUGUÊS

**TODAS as mensagens, perguntas, explicações, erros e confirmações devem ser escritas em português do Brasil.**
Nunca use inglês em nenhuma interação com o usuário durante o setup. Isso inclui:
- Títulos e subtítulos das perguntas
- Opções de resposta
- Mensagens de status e progresso
- Mensagens de erro e sucesso
- Descrições de ferramentas e funcionalidades

## Fluxo

### 1. Detectar ambiente (silencioso)
Executar sem mostrar ao usuário:
- Verificar OS (macOS, Linux, Windows): `uname -s`
- Verificar se Node.js está instalado: `node --version`
- Verificar se yt-dlp está instalado: `yt-dlp --version`
- Verificar se existe Obsidian Vault: `find ~ -name ".obsidian" -maxdepth 4 -type d 2>/dev/null | head -5`
- Ler config atual se existir: `knowledge/config.yaml`

### 2. Instalar o que estiver faltando (automático, sem pedir nada ao usuário)

**REGRA: O usuário NÃO sabe usar Terminal. NUNCA peça para ele instalar nada manualmente. Instale tudo automaticamente usando a ferramenta Bash.**

Se yt-dlp não estiver instalado, instalar automaticamente SEM perguntar:
- Avisar: "Vou instalar o yt-dlp (ferramenta para extrair texto dos vídeos)... aguarde um momento."
- macOS: executar `brew install yt-dlp` via Bash. Se brew não existir, executar `curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash` primeiro.
- Linux: executar `pip3 install yt-dlp` via Bash
- Windows: executar `winget install yt-dlp --accept-package-agreements --accept-source-agreements` via Bash
- Depois de instalar, verificar novamente: `yt-dlp --version`
- Se der certo: "✅ yt-dlp instalado com sucesso!"
- Se falhar: "Não consegui instalar o yt-dlp automaticamente. Peça ajuda a alguém técnico para instalar o yt-dlp no seu computador."

Se Node.js não estiver instalado, instalar automaticamente SEM perguntar:
- Avisar: "Vou instalar o Node.js (necessário para alguns recursos)... aguarde um momento."
- macOS: `brew install node`
- Linux: `curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs`
- Windows: `winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements`

### 3. Mostrar resultado da verificação
Depois que tudo estiver instalado (ou já estava), mostrar ao usuário um resumo claro:

> **Sofia 2.0 — Configuração inicial**
>
> Verifiquei seu computador e instalei o que precisava. Aqui está o resultado:
>
> ✅ Node.js instalado (v22.x)
> ✅ yt-dlp instalado (2025.x)
> ✅ Obsidian Vault encontrado em /caminho/do/vault

### 3. Perguntar sobre Apify (para Instagram/TikTok)
Usar a ferramenta AskUserQuestion com estas opções EM PORTUGUÊS:

Pergunta: "Você tem uma API key do Apify? (Necessário para analisar vídeos do Instagram e TikTok)"

Opções:
- "Sim, tenho uma" → Pedir a key com mensagem: "Cole sua API key do Apify aqui:"
- "Não tenho, quero criar conta" → Mostrar instruções com link direto:
  > Para criar sua conta e pegar a API key:
  > 1. Acesse: **https://console.apify.com/sign-up**
  > 2. Crie sua conta (tem $5 grátis por mês)
  > 3. Depois de criar, acesse: **https://console.apify.com/account/integrations**
  > 4. Copie o token que aparece na seção "Personal API tokens"
  > 5. Cole aqui:
- "Não quero configurar agora" → Pular. Avisar: "Sem o Apify, a Sofia funciona para YouTube mas não consegue pegar comentários do Instagram e TikTok."

### 4. Configurar onde salvar
Se encontrou Obsidian Vault, sugerir automaticamente:

> Encontrei seu Obsidian Vault em: `/caminho/do/vault`
> Vou salvar as análises e roteiros lá dentro, na pasta `Sofia/`.

Usar AskUserQuestion EM PORTUGUÊS:

Pergunta: "Onde quer que a Sofia salve as análises e roteiros?"

Opções:
- "Obsidian Vault em /caminho/do/vault (recomendado)" → Usar esse caminho
- "Escolher outro local" → Pedir caminho: "Digite o caminho completo da pasta:"

Se NÃO encontrou Obsidian Vault:
> Não encontrei nenhum Obsidian Vault no seu computador.

Perguntar: "Onde quer que a Sofia salve as análises e roteiros?"

Opções:
- "Criar pasta Sofia na área de trabalho" → Usar `~/Desktop/Sofia/`
- "Escolher outro local" → Pedir caminho

### 5. Salvar config
Criar/atualizar `knowledge/config.yaml` com todas as configurações coletadas.
Incluir data do setup e marcar `setup_completo: true`.

### 6. Teste rápido
Executar um teste silencioso:
```bash
yt-dlp --dump-json "https://www.youtube.com/watch?v=dQw4w9WgXcQ" 2>/dev/null | head -1
```
Se funcionar, confirmar. Se falhar, avisar o usuário.

### 7. Oferecer aprendizado de estilo de escrita

Depois de tudo configurado, perguntar:

> **Quer que a Sofia aprenda seu estilo de escrita?**
>
> Se sim, eu vou ler alguns dos seus melhores roteiros e aprender como você fala: tom de voz, ritmo das frases, palavras que usa, como abre os vídeos, o que evitar. Depois, quando escrever roteiros pra você, vou usar o seu jeito de escrever.

Usar AskUserQuestion EM PORTUGUÊS:

Pergunta: "Quer personalizar o estilo de escrita da Sofia?"

Opções:
- "Sim, quero que aprenda meu estilo" → Ir pro fluxo de aprendizado (abaixo)
- "Depois, quero usar primeiro" → Pular. Avisar: "Quando quiser, é só me pedir pra aprender seu estilo."

**Se sim — Fluxo de aprendizado de estilo:**

1. Perguntar sobre clientes:
   > "Você escreve roteiros só pra um perfil (o seu) ou pra clientes diferentes?"

   - **Um perfil só** → Criar 1 perfil em `knowledge/estilos/{nome}.md`
   - **Vários clientes** → Criar 1 perfil por cliente em `knowledge/estilos/{cliente}.md`. Explicar: "Cada cliente vai ter seu próprio estilo salvo. Quando for escrever, vou perguntar pra qual cliente."

2. Pedir roteiros:
   > "Me manda de 3 a 5 dos seus melhores roteiros (os que performaram melhor ou que mais representam como você fala). Pode colar aqui ou me mandar o link do arquivo."

3. Digerir e aprender:
   Para cada roteiro, extrair silenciosamente:
   - Tom de voz (sério, brincalhão, direto, provocador, reflexivo)
   - Ritmo (frases curtas ou longas, pausas, cadência)
   - Palavras e expressões recorrentes
   - Tipo de abertura mais comum
   - Tipo de fechamento mais comum
   - Estruturas preferidas
   - O que NÃO faz (identificar ausências como padrão)

4. Mostrar o perfil ao usuário pra validação:
   > "Aprendi isso sobre seu estilo. Veja se faz sentido:"
   > [mostrar perfil resumido]
   > "Tem algo errado ou que eu deva ajustar?"

5. Salvar em `knowledge/estilos/{nome}.md` seguindo o template `_template.md`

6. Perguntar:
   > "Tem algo que você sabe que deve EVITAR nos roteiros? (palavra, tom, tipo de conteúdo)"

   Adicionar na seção "O que EVITAR" do perfil.

### 8. Mensagem final
Mostrar ao usuário:

> **✅ Sofia 2.0 configurada com sucesso!**
>
> Agora você pode usar estes comandos:
>
> 📊 `/sofia:analisar` + link do vídeo — analisa por que um vídeo funciona
> ✍️ `/sofia:roteiro` — escreve um roteiro para vídeo viral
> 🔍 `/sofia:critica` — avalia um roteiro com honestidade
> 🔧 `/sofia:melhorar` — melhora um roteiro depois da crítica
> 📈 `/sofia:dashboard` — gera um painel visual bonito
> 💾 `/sofia:exportar` — salva tudo em arquivos organizados
>
> **Dica:** comece com `/sofia:analisar` + o link de um vídeo que você admira!

## Config template

```yaml
sofia:
  apify_api_key: ""
  obsidian_vault_path: ""
  output_format: "obsidian"
  ambiente: "claude-code"
  setup_completo: true
  data_setup: ""
  estilo:
    configurado: false
    multiplos_clientes: false
    perfis: []
```

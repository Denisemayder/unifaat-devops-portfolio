# RESPOSTAS — Aula 08: GitHub Actions e CI Pipelines

**Aluna:** Denise Maider Batista de Macedo
**RA:** 6325028

## 1. Questões de múltipla escolha

**Questão 1 — Alternativa B**

A execução de um workflow é disparada pelos eventos configurados no campo `on:` do arquivo YAML, como `push`, `pull_request` e `workflow_dispatch`.

**Questão 2 — Alternativa C**

A palavra-chave `needs` estabelece dependências entre jobs. Assim, uma etapa só executa após a conclusão bem-sucedida das etapas das quais depende.

**Questão 3 — Alternativa C**

As credenciais AWS devem ser armazenadas nos GitHub Secrets e referenciadas no workflow por meio da sintaxe `${{ secrets.NAME }}`. Não devem ser incluídas diretamente no código.

**Questão 4 — Alternativa B**

Os approval gates permitem exigir aprovação humana antes de executar deploys em ambientes sensíveis, como produção.

## 2. Pipeline CI da TechNova

O pipeline foi organizado na seguinte sequência:

Push ou Pull Request → ESLint → Testes Jest com Coverage → Docker Build

- **Lint:** verifica a qualidade e as regras de padronização do código.
- **Test:** executa os testes automatizados e gera o relatório de cobertura.
- **Build:** verifica se a imagem Docker pode ser construída corretamente.

O workflow é acionado em Pull Requests e em pushes para a branch main.

As três etapas são obrigatórias. Se uma falhar, as etapas dependentes não serão executadas.

O time acompanha os resultados pela aba Actions e pelas verificações dos Pull Requests.

## 3. Segurança das credenciais

### Cenário 1 — Arquivo .env publicado

**Causa:** o desenvolvedor adicionou credenciais ao repositório usando `git add .`.

**Impacto:** um atacante que obtenha as chaves pode acessar recursos AWS conforme as permissões associadas às credenciais.

**Prevenção:** incluir arquivos .env no .gitignore, utilizar GitHub Secrets e implementar verificações de segredos antes dos commits.

**Detecção:** utilizar ferramentas de secret scanning e verificar alertas e registros de acesso.

**Correção:** revogar ou substituir imediatamente as credenciais expostas. Apagar o arquivo em outro commit não elimina os dados do histórico do Git.

### Cenário 2 — Secrets nos logs

**Causa:** o workflow imprime informações sensíveis durante a execução.

**Impacto:** credenciais podem ser expostas nos logs, especialmente quando transformadas ou processadas por outras ferramentas.

**Prevenção:** nunca imprimir secrets nos logs. Utilizar variáveis de ambiente apenas nas etapas necessárias.

**Detecção:** revisar os workflows, analisar logs e utilizar verificações automatizadas para identificar possíveis vazamentos.

O mascaramento automático do GitHub não garante proteção absoluta.

### Cenário 3 — Pull Request malicioso

**Causa:** um contribuidor externo tenta modificar o workflow para obter credenciais.

**Impacto:** caso consiga acesso aos secrets, o atacante pode utilizá-los para acessar serviços externos.

**Prevenção:** limitar permissões do GITHUB_TOKEN, revisar contribuições externas e evitar executar código não confiável com acesso a secrets.

**Detecção:** revisar alterações em workflows, monitorar execuções e acompanhar atividades suspeitas.

Por padrão, workflows acionados por pull_request de forks não recebem os secrets do repositório principal.

## 4. Evidência prática

Durante a atividade, foi introduzido propositalmente um erro de ESLint.

O GitHub Actions identificou a falha e interrompeu as etapas dependentes.

Após a correção, os três jobs foram executados com sucesso:

- ESLint: aprovado.
- Jest com Coverage: aprovado.
- Docker Build: aprovado.

Essa experiência demonstrou a importância da integração contínua para detectar problemas antes da integração do código.

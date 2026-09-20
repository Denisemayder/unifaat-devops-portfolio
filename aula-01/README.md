# Aula 01 — Fundamentos de Git e Docker

## O que aprendi

### Git
- O Git é um sistema de controle de versão distribuído: cada dev possui uma cópia completa do histórico localmente.
- Os arquivos transitam entre: Working Directory, Staging Area e Repository. Fluxo: editar → `git add` → `git commit`.
- Branches permitem desenvolver funcionalidades isoladamente sem afetar o código principal.
- Conventional Commits (feat:, fix:, docs:) tornam o histórico legível e auditável.
- O .gitignore impede que node_modules/ e .env sejam versionados acidentalmente.

### Docker
- Containers resolvem o problema funciona na minha máquina ao empacotar app com todas as dependências.
- Diferente de VMs, containers compartilham o kernel do host: são leves (MB vs GB) e rápidos.
- O Dockerfile é a receita da imagem. Cada instrução cria uma camada cacheável.
- Copiar package.json antes do código-fonte otimiza o build: a camada do `npm install` só é refeita quando as dependências mudam.
- O .dockerignore evita copiar node_modules/ e .git/ para a imagem.

## Comandos Git praticados

```bash
git init
git status
git add .
git checkout -b feature/aula-01-app
git checkout main
git merge feature/aula-01-app
git push -u origin main
git log --oneline
```

## Comandos Docker praticados

```bash
docker build -t portfolio-aula01:1.0 .
docker run -d --name portfolio-test -p 3000:3000 portfolio-aula01:1.0
docker ps
docker logs portfolio-test
docker stop portfolio-test
docker rm portfolio-test
```

## Como executar este container

```bash
cd aula-01/app
docker build -t portfolio-aula01:1.0 .
docker run -d --name portfolio-test -p 3000:3000 portfolio-aula01:1.0
curl http://localhost:3000
curl http://localhost:3000/health
```

## Dificuldades encontradas

- Container não rodava no WSL2: integração com Docker Desktop não estava ativa. Solução: Settings > Resources > WSL Integration.
- Diferença entre merge fast-forward e three-way merge ficou clara com git log --oneline --graph.

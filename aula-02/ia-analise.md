# Análise do Uso de IA — Aula 02 TF

## Prompt Utilizado

"Crie um docker-compose.yml para uma aplicação Node.js 20 com Express que usa
PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000.
O PostgreSQL precisa de volume nomeado para persistência. Todos os serviços devem
estar na mesma rede bridge customizada. Use variáveis de ambiente com interpolação
de arquivo .env. Adicione healthchecks, depends_on com condition, e restart policy
unless-stopped."

## Output Original do Kiro

Ambiente TechNova — API + PostgreSQL + Redis
# Aula 02 — Docker Compose

services:
  # Serviço da API Node.js
  api:
    build: .
    container_name: technova-api
    ports:
      - "3000:3000"
    environment:
      - PORT=${PORT}
      - DB_HOST=${DB_HOST}
      - DB_PORT=${DB_PORT}
      - DB_NAME=${DB_NAME}
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - REDIS_HOST=${REDIS_HOST}
      - REDIS_PORT=${REDIS_PORT}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    restart: unless-stopped
    networks:
      - technova-network

  # Banco de dados PostgreSQL
  postgres:
    image: postgres:15-alpine
    container_name: technova-postgres
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
    networks:
      - technova-network

  # Cache Redis
  redis:
    image: redis:7-alpine
    container_name: technova-redis
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: unless-stopped
    networks:
      - technova-network

# Volume nomeado para persistência do PostgreSQL
volumes:
  postgres-data:

# Rede customizada
networks:
  technova-network:
    driver: bridge


## Alterações que Fiz Manualmente

| O que mudei | Por quê |
|------------|---------|
| Ajustei os nomes dos containers | Para seguir o padrão technova- |
| Revisei as variáveis de ambiente | Para garantir consistência com o .env |

## O que o Kiro Acertou

- Estrutura geral do docker-compose.yml
- Healthchecks para PostgreSQL e Redis
- Uso de variáveis de ambiente

## O que o Kiro Errou ou Omitiu

- ele ja quer fazer a atividade sozinha , nao que seja um erro mais tira a minha oportunidade de entender e aprender o que esta cento feito.

## Minha Avaliação

- **Tempo economizado usando IA:** 20 horas
- **Tempo gasto validando/corrigindo:** 4 horas
- **Nota para o output da IA (1-10):** 8
- **Usaria novamente para este tarefa?** Sim — ótimo ponto de partida

# Etapa 1: Instalar dependências
FROM node:20-alpine AS dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

# Etapa 2: Imagem final de produção
FROM node:20-alpine AS production

ENV NODE_ENV=production

WORKDIR /app

COPY --from=dependencies /app/node_modules ./node_modules

COPY --chown=node:node server.js ./

EXPOSE 3000

USER node

CMD ["node", "server.js"]

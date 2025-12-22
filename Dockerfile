# Etapa de build
FROM node:20.9.0 AS builder
WORKDIR /app

# Copia apenas os arquivos necessários para instalar dependências
COPY package*.json ./
RUN npm install

# Copia o restante da aplicação
COPY . .

# Gera o build de produção do Next.js
RUN npm run build

# Etapa de produção: imagem mais leve para rodar o app
FROM node:20.9.0-alpine
WORKDIR /app

# Define ambiente de produção
ENV NODE_ENV=production

# Copia apenas os artefatos de produção necessários
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Exponha a porta do Next.js
EXPOSE 3000

# Inicia o servidor do Next.js
CMD ["npm", "start"]

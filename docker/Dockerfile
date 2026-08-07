# ===========================
# Stage 1 - Build React App
# ===========================
FROM node:22-alpine AS builder

WORKDIR /app

COPY app/package*.json ./

RUN npm install

COPY app/ .

RUN npm run build

# ===========================
# Stage 2 - Nginx
# ===========================
FROM nginx:1.29-alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

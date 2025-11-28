# --- Stage 1: Build Stage ---
FROM node:18-alpine as builder

WORKDIR /app

# Copy package.json dan package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy seluruh source code
COPY . .

# Build project untuk production
# Hasil build biasanya ada di folder 'dist'
RUN npm run build

# --- Stage 2: Production Stage (Nginx) ---
FROM nginx:alpine

# Hapus config default Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copy config custom kita (untuk handle routing SPA)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy hasil build dari Stage 1 ke folder Nginx
# Pastikan path '/app/dist' sesuai. Vue standar outputnya ke 'dist'.
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

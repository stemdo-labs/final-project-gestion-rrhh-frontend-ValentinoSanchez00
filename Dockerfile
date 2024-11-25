# Etapa 1: Construcción
FROM node:18-alpine AS build
WORKDIR /app

# Copiamos los archivos de dependencias
COPY package.json package-lock.json ./
RUN npm install

# Copiamos el resto de los archivos
COPY . .

# Ejecutamos la construcción de la aplicación
RUN npm run build

# Etapa 2: Servidor de producción con Nginx
FROM nginx:stable-alpine

COPY nginx.conf /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/conf.d/default.conf

# Copiamos los archivos de construcción desde la primera etapa
COPY --from=build /app/build /usr/share/nginx/html

# Exponemos el puerto 80 para servir la aplicación
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]

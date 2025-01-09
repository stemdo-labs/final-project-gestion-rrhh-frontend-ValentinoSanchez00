# Etapa 1: Construcción
FROM node:16-alpine AS build
# Establecer directorio de trabajo
WORKDIR /app
# Copiar archivos necesarios
COPY package.json package-lock.json ./
# Instalar dependencias
RUN npm ci
# Copiar el resto del código fuente
COPY . .
# Construir la aplicación para producción
RUN npm run build
 
# Etapa 2: Producción
FROM nginx:alpine
# Copiar el build al directorio de Nginx
COPY --from=build /app/build /usr/share/nginx/html
# Copiar la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf
# Exponer el puerto 80 para servir la aplicación
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
# stage1 as builder
FROM node:10-alpine

WORKDIR /app

# copy the package.json to install dependencies
COPY package.json package-lock.json ./

# Install the dependencies and make the folder
RUN npm install

COPY . .

# Build the project and copy the files
RUN npm run build


FROM nginx:alpine

#!/bin/sh
COPY --from=0 /app/nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=0 /app/out /usr/share/nginx/html
RUN ls /usr/share/nginx/

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
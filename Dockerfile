FROM node:16-alpine

WORKDIR /

COPY package.json package-lock.json ./

RUN npm ci

COPY server.js ./

ENTRYPOINT [ "node" , "server.js" ]
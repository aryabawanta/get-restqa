# The instructions for the first stage
FROM node:12-alpine as builder
LABEL maintainer="RestQa <team@restqa.io>"
LABEL app="get_restqa"
LABEL name="get restqa"
LABEL description="A light application to support your restqa setup"
LABEL repository="https://github.com/restqa/get-restqa"
LABEL url="https://restqa.io/get-restqa"

WORKDIR /app
RUN apk --no-cache add python make g++

COPY package*.json ./
RUN npm install --production
RUN npm ci --only=production
RUN npm run build


FROM nginx:1.15-alpine

COPY --from=build /app  /usr/share/nginx/html

EXPOSE 80

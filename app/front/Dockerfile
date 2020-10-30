FROM node:15-alpine3.10

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package*.json /usr/src/app/
RUN npm install

COPY app.js /usr/src/app/

EXPOSE 80
CMD [ "node", "app.js" ]

FROM php:8.1-cli

COPY . /usr/src/app
WORKDIR /usr/src/app

EXPOSE 80

CMD [ "php", "-S", "0.0.0.0:80", "-t", "/usr/src/app", "/usr/src/app/index.php"]
# Main PHP docker-image
FROM php:7.2-cli-alpine

WORKDIR /app

COPY ./app/ /app

RUN set -ex \
 && php -v \
 && date -u +'%Y-%m-%dT%H:%M:%SZ'

CMD ["php", "/app/info.php"]

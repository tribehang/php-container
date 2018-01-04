FROM nginx:1.10

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /var/www/html

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
        apt-utils \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        gnupg-curl

RUN apt-key adv --fetch-keys https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install \
        curl \
        git \
        unzip \
        php7.2-fpm \
        php7.2\
        php7.2-intl \
        php7.2-mysql \
        php7.2-sqlite3 \
        php7.2-gd \
        php7.2-curl \
        php7.2-opcache \
        php7.2-mbstring \
        php7.2-xml \
        php7.2-json \
        php7.2-zip \
        php7.2-bcmath \
        php7.2-dev

RUN apt-get -y --no-install-recommends install gcc make

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && \
    rm -rf /usr/local/src/* /var/lib/apt/lists/* /tmp/* /var/tmp/**

ADD ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
ADD ./docker/php/fpm/www.conf /etc/php/7.2/fpm/pool.d/www.conf
ADD ./docker/php/mods/opcache.ini /etc/php/7.2/mods-available/opcache.ini
ADD ./docker/run.sh /run.sh

ADD ./docker/php/custom.ini /etc/php/7.2/fpm/conf.d/100-custom.ini

RUN nginx -t

EXPOSE 80 443

CMD ["/bin/sh", "/run.sh"]

FROM php:8.2.3-apache

WORKDIR /var/www/html

#mod rewrite
RUN a2enmod rewrite

RUN apt update -y && apt install -y libicu-dev \
    unzip zip apt-transport-https libpq-dev \
    zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libjpeg62-turbo-dev

#composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#pdo postgresql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install gettext intl pdo pdo_pgsql pgsql gd

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
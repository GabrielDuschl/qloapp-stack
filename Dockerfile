FROM php:8.1-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libxml2-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        soap \
        mysqli \
        pdo_mysql \
        zip \
        gd \
    && a2enmod rewrite \ 
    && rm -rf /var/lib/apt/lists/*

COPY ./php/custom-php.ini /usr/local/etc/php/conf.d/custom-php.ini

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

WORKDIR /var/www/html

COPY ./qloapps/ /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80


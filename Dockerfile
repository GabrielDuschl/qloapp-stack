# ----------------------------------------
# QloApps: Eigenes Dockerfile (Beispiel)
# ----------------------------------------

FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip

RUN a2enmod rewrite

WORKDIR /var/www/html
RUN git clone https://github.com/Qloapps/Qloapps.git . \
    && chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]

FROM php:8.1-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \                    # damit wir später klonen können
        unzip \                  # QloApps liefert evtl. ZIP‐Pakete aus
        libxml2-dev \            # SOAP‐Extension benötigt libxml‐Header
        libzip-dev \             # ZIP‐Extension
        libpng-dev \             # GD‐Extension (Grafik)
        libjpeg-dev \
        libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install soap mysqli pdo_mysql zip gd

RUN a2enmod rewrite \
    && sed -ri -e 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

WORKDIR /var/www/html

RUN git clone --depth 1 https://github.com/QloApps/qloapps.git . \
    && chown -R www-data:www-data /var/www/html


EXPOSE 80


# 1) Basis-Image und System-/PHP-Extensions wie gehabt
FROM php:8.1-apache

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      git unzip libxml2-dev libzip-dev \
      libpng-dev libjpeg-dev libfreetype6-dev \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install soap mysqli pdo_mysql zip gd \
 && a2enmod rewrite \
 && sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

WORKDIR /var/www/html

# 2) Git-Clone, Admin-Ordner umbenennen, Cache leeren, Rechte setzen
ARG ADMIN_DIR=login
RUN git clone --depth 1 --branch develop https://github.com/GabrielDuschl/QloApp.git . \
 && mv admin "${ADMIN_DIR}" \
 && rm -rf var/cache/* \
 && chown -R www-data:www-data /var/www/html

# 3) Inline EntryPoint: löscht /install, sobald settings.inc.php existiert
ENTRYPOINT ["sh","-c","\
    if [ -f /var/www/html/config/settings.inc.php ]; then \
      echo '[entrypoint] Installation gefunden – entferne /install'; \
      rm -rf /var/www/html/install; \
    fi; \
    exec docker-php-entrypoint apache2-foreground\
"]

EXPOSE 80

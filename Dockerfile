from php:7.0-apache
RUN apt-get update && apt-get install --no-install-recommends git libpq-dev tar locales libpng-dev libxml2-dev libicu-dev -y && \
    sed -i 's/# pt_BR.UTF-8/pt_BR.UTF8/' /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/bin/dumb-init

RUN chmod +x /usr/bin/dumb-init && \
    docker-php-ext-install pdo_pgsql mysqli pgsql zip gd xmlrpc soap intl opcache && \
    a2enmod rewrite && a2enmod ssl

COPY files/moodle.conf /etc/apache2/sites-available/default.conf
COPY files/moodle.php.ini /usr/local/etc/php/conf.d/moodle.ini
COPY files/docker-entrypoint.sh /entrypoint

WORKDIR /var/www/html
ENTRYPOINT ["/usr/bin/dumb-init","/entrypoint"]
CMD ["run"]

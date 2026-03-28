FROM debian:bookworm-slim

# 1. Install PHP and dependencies
# Añadimos limpieza extra para que la imagen sea mínima
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# 3. Create directory BEFORE copying config
RUN mkdir -p /run/php && mkdir -p /var/www/wordpress

# 4. Copy configuration files (Lo que cambia a menudo, al FINAL para el caché)
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wpscript.sh /usr/local/bin/wpscript.sh

RUN chmod +x /usr/local/bin/wpscript.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wpscript.sh"]

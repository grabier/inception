FROM debian:bookworm

#php extensions curl y mdbclient
RUN apt-get update && \
	apt-get install -y \
		php8.2-fpm php8.2-mysql php8.2-cli php8.2-curl php8.2-gd php8.2-mbstring \
		php8.2-xml php8.2-zip curl unzip mariadb-client git procps && \
	rm -rf /var/lib/apt/lists/*

#install wpcli de cliente
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

#creamos wpdir y permiss
RUN mkdir -p /var/www
WORKDIR /var/www
RUN sed -i "s/listen = .*/listen = 0.0.0.0:9000/" /etc/php/8.2/fpm/pool.d/www.conf

#cp config y script ala dockervm
COPY tools/script.sh /usr/local/bin/script.sh

#dar permiss
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/script.sh"]
FROM debian:bookworm

#nginx y openssl install
RUN apt-get update && apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

#ssl certfic directory y creamos el certi
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-subj "/C=ES/ST=Malaga/L=Malaga/O=42Malaga/OU=Student/CN=gmontoro.42.fr"

#ajust web permisss
RUN chown -R www-data /var/www/ && \
	chmod -R 755 /var/www/

#que copie el config al docker nuestro
COPY conf/nginx.conf /etc/nginx/nginx.conf

#config tls uy logs por defect
RUN sed -i 's|listen 80 default_server;|listen 80 default_server;\n 	listen 443 ssl default_server;|' /etc/nginx/sites-available/default && \
	sed -i 's|listen \[::\]:80 default_server;|listen [::]:80 default_server;\n 	listen [::]:443 ssl default_server;|' /etc/nginx/sites-available/default && \
	sed -i 's|# SSL configuration|ssl_certificate /etc/nginx/ssl/nginx.crt;\n		ssl_certificate_key /etc/nginx/ssl/nginx.key;\n 	ssl_protocols TLSv1.2 TLSv1.3;|' /etc/nginx/sites-available/default

#poner el puertel https
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
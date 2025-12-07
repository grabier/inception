FROM debian:bookworm

#install mdb y utils
RUN apt-get update && \
	apt-get install -y mariadb-server mariadb-client procps && \
	rm -rf /var/lib/apt/lists/*

RUN echo "[mysqld]" >> /etc/mysql/mariadb.conf.d/50-server.cnf \
	&& echo "bind-address = 0.0.0.0" >> /etc/mysql/mariadb.conf.d/50-server.cnf


#cp config y script ala dockervm
COPY conf/my-cnf.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/script.sh /usr/local/bin/script.sh

#dar permiss
RUN chmod +x /usr/local/bin/script.sh

#puerto
EXPOSE 3306

#entrypointtt
CMD ["/usr/local/bin/script.sh"]


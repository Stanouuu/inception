FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /var/run/mysql
RUN mkdir -p /var/run/mysqld
RUN	chown mysql:mysql /var/run/mysqld/ \
	&& chmod -R 755 /var/run/mysqld/
RUN	chown mysql:mysql /var/lib/mysql/ \
	&& chmod -R 755 /var/lib/mysql/

COPY ./tools/mariadb.sh /var/mariadb.sh

RUN chmod +x /var/mariadb.sh

CMD ["sh", "/var/mariadb.sh"]

service mariadb start
# service mysql start

echo "Starting..."

exec mysqld &

touch /tmp/sqltmp
chmod 777 /tmp/sqltmp

echo "CREATE DATABASE IF NOT EXISTS $SQL_DB; \n\
CREATE USER IF NOT EXISTS $SQL_USER@'localhost' IDENTIFIED BY '$SQL_USER_PASSWORD'; \n\
GRANT ALL PRIVILEGES ON $SQL_DB.* TO $SQL_USER@'localhost' IDENTIFIED BY '$SQL_USER_PASSWORD'; \n\
ALTER USER root@'localhost' IDENTIFIED BY '$SQL_USER_PASSWORD'; \n\
FLUSH PRIVILEGES;" >> /tmp/sqltmp

cat /tmp/sqltmp

mysql < /tmp/sqltmp

rm /tmp/sqltmp

echo "Restarting"


echo "mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown" 
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
# ps -ef | grep mysqld_safe 
# mysql -h 127.0.0.1 -P 3306 -u root -p

echo "..."

exec mysqld_safe

echo "Restart complete."

echo "MariaDB database and user were created successfully! "

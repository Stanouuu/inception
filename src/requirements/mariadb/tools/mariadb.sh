service mysql start

mysqld_safe &

echo "Starting..."

while ! mysqladmin ping --silent; do
    echo "Loading..."
    sleep 1
done


touch /tmp/sqltmp
chmod 777 /tmp/sqltmp




echo "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE; \n\
CREATE USER IF NOT EXISTS $SQL_USER@'%' IDENTIFIED BY '$SQL_USER_PASSWORD'; \n\
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO $SQL_USER@'%' IDENTIFIED BY '$SQL_USER_PASSWORD'; \n\
ALTER USER root@'%' IDENTIFIED BY '$SQL_USER_PASSWORD'; \n\
FLUSH PRIVILEGES;" >> /tmp/sqltmp

cat /tmp/sqltmp

mysql < /tmp/sqltmp

rm /tmp/sqltmp

echo "Restarting..."

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

echo "Restart complete."

exec mysqld_safe

service mysql start

mysqld_safe &

echo "Starting..."

while ! mysqladmin ping --silent; do
    echo "Loading..."
    sleep 1
done


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

echo "Restarting..."

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

echo "Restart complete."

exec mysqld_safe

service mysql start

if systemctl is-active --quiet mariadb; then
    sudo systemctl stop mariadb
fi


mysqld_safe --nowatch &

echo "Starting..."

while ! mysqladmin ping --silent; do
    echo "Loading..."
    sleep 1
done

# echo "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE; \
# CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_USER_PASSWORD'; \
# GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%'; \
# FLUSH PRIVILEGES;" | mysql -u root -p$SQL_ROOT_PASSWORD

touch /tmp/sqltmp
chmod 777 /tmp/sqltmp




echo "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`; \n\
CREATE USER IF NOT EXISTS \`$SQL_USER\`@'%' IDENTIFIED BY '$SQL_USER_PASSWORD'; \n\
GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO \`$SQL_USER\`@'%'; \n\
ALTER USER root@localhost IDENTIFIED BY '$SQL_ROOT_PASSWORD'; \n\
FLUSH PRIVILEGES;" >> /tmp/sqltmp

cat /tmp/sqltmp

echo  -u root -p$SQL_ROOT_PASSWORD 

mysql -u root -p$SQL_ROOT_PASSWORD < /tmp/sqltmp

rm /tmp/sqltmp

echo "Restarting..."

mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

echo "Restart complete."

exec mysqld_safe

mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

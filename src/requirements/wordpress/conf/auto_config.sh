#!/bin/sh

cd /var/www/html/wordpress

# Check if WordPress is already installed
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    # Create WordPress configuration
    wp config create --allow-root --dbname="${SQL_DATABASE}" \
                     --dbuser="${SQL_USER}" \
                     --dbpass="${SQL_USER_PASSWORD}" \
                     --dbhost="${SQL_HOST}" \
                     --url="https://${WP_DOMAIN}";

    # Install WordPress
    wp core install --allow-root \
                    --url="https://${WP_DOMAIN}" \
                    --title="${SITE_TITLE}" \
                    --admin_user="${SQL_ROOT_USER}" \
                    --admin_password="${SQL_ROOT_PASSWORD}" \
                    --admin_email="${SQL_ROOT_EMAIL}";

    # Create a WordPress user
    wp user create --allow-root "${WP_USER}" "${WP_EMAIL}" \
                   --role=author \
                   --user_pass="${WP_USER_PASSWORD}";

    # Flush WordPress cache
    wp cache flush --allow-root

    #wp core update --allow-root

    wp plugin install contact-form-7 --activate --allow-root

    wp language core install en_US --activate --allow-root

    # Delete default themes and plugins
    wp plugin delete hello --allow-root
    wp theme install twentytwenty \
        --activate \
        --allow-root \
        --path=/var/www/html/wordpress

    wp rewrite structure '' --hard --allow-root
    wp rewrite flush --hard --allow-root

    mv /tmp/sources/cv.html /var/www/html/wordpress
fi

# Check if the PHP run directory exists, create if not
if [ ! -d /run/php ]; then
    mkdir /run/php;
fi

exec /usr/sbin/php-fpm7.4 -F -R
echo "PHP-FPM launching successfully! "
#!/bin/sh

cd /var/www/html/wordpress

# Check if WordPress is already installed
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    # Create WordPress configuration
    wp config create --allow-root --dbname="${SQL_DATABASE}" \
                     --dbuser="${SQL_USER}" \
                     --dbpass="${SQL_PASSWORD}" \
                     --dbhost="${SQL_HOST}" \
                     --url="https://${DOMAIN_NAME}";

    # Install WordPress
    wp core install --allow-root \
                    --url="https://${DOMAIN_NAME}" \
                    --title="${SITE_TITLE}" \
                    --admin_user="${ADMIN_USER}" \
                    --admin_password="${ADMIN_PASSWORD}" \
                    --admin_email="${ADMIN_EMAIL}";

    # Create a WordPress user
    wp user create --allow-root "${USER1_LOGIN}" "${USER1_MAIL}" \
                   --role=author \
                   --user_pass="${USER1_PASS}";

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




# #!/bin/bash
# #set -eux

# cd /var/www/html/wordpress

# if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
# wp config create	--allow-root --dbname=${SQL_DATABASE} \
# 			--dbuser=${SQL_USER} \
# 			--dbpass=${SQL_PASSWORD} \
# 			--dbhost=${SQL_HOST} \
# 			--url=https://${DOMAIN_NAME};

# wp core install	--allow-root \
# 			--url=https://${DOMAIN_NAME} \
# 			--title=${SITE_TITLE} \
# 			--admin_user=${ADMIN_USER} \
# 			--admin_password=${ADMIN_PASSWORD} \
# 			--admin_email=${ADMIN_EMAIL};

# wp user create		--allow-root \
# 			${USER1_LOGIN} ${USER1_MAIL} \
# 			--role=author \
# 			--user_pass=${USER1_PASS} ;

# wp cache flush --allow-root

# # it provides an easy-to-use interface for creating custom contact forms and managing submissions, as well as supporting various anti-spam techniques
# wp plugin install contact-form-7 --activate

# # set the site language to English
# wp language core install en_US --activate

# # remove default themes and plugins
# wp theme delete twentynineteen twentytwenty
# wp plugin delete hello

# # set the permalink structure
# wp rewrite structure '/%postname%/'

# fi

# if [ ! -d /run/php ]; then
# 	mkdir /run/php;
# fi

# # start the PHP FastCGI Process Manager (FPM) for PHP version 7.3 in the foreground
# exec /usr/sbin/php-fpm7.3 -F -R
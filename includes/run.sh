#!/bin/bash

/letsencrypt/letsencrypt-auto certonly --renew-by-default --webroot -w /var/www/html `if [ -z "$EMAIL" ]; then echo "--register-unsafely-without-email"; else echo "--email $EMAIL"; fi` -d $HOST --agree-tos --text `if [ "$MODE" != "PRODUCTION" ]; then echo "--test-cert"; fi`

ln -s /etc/apache2/sites-available/001-default-le-ssl.conf /etc/apache2/sites-enabled/001-default-le-ssl.conf
rm /etc/apache2/sites-enabled/000-default.conf
mv /etc/apache2/sites-available/new-default.conf /etc/apache2/sites-available/000-default.conf
ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

apache2ctl -k restart

supervisorctl start letsencrypt-renew

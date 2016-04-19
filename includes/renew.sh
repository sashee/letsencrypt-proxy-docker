#!/bin/bash

# From https://community.letsencrypt.org/t/how-to-completely-automating-certificate-renewals-on-debian/5615
DAYS_REMAINING=87;

get_days_exp() {
  local d1=$(date -d "`openssl x509 -in $1 -text -noout|grep "Not After"|cut -c 25-`" +%s)
  local d2=$(date -d "now" +%s)
  # Return result in global variable
  DAYS_EXP=$(echo \( $d1 - $d2 \) / 86400 |bc)
}
get_days_exp "/etc/letsencrypt/live/${HOST}/cert.pem"

echo "Expire in ${DAYS_EXP} days"

if [ "$DAYS_EXP" -gt "$DAYS_REMAINING" ]; then
	echo "Renewal is not necessary."
else
	echo "Renewing"
	/letsencrypt/letsencrypt-auto certonly --renew-by-default --webroot -w /var/www/html --register-unsafely-without-email -d $HOST --agree-tos --text --test-cert 

	apache2ctl -k restart
fi

sleep 1d

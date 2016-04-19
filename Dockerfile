FROM ubuntu:15.10

RUN apt-get update

RUN apt-get install -y git apache2 bc supervisor

RUN a2enmod proxy_http
RUN a2enmod ssl

RUN git clone https://github.com/letsencrypt/letsencrypt

RUN letsencrypt/letsencrypt-auto --help > /dev/null

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD includes/run.sh /run.sh
ADD includes/renew.sh /renew.sh
RUN chmod +x /run.sh
RUN chmod +x /renew.sh

EXPOSE 443
EXPOSE 80

ADD apache_config /etc/apache2/sites-available/

CMD ["/usr/bin/supervisord"]

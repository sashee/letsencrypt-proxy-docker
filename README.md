# Let's Encrypt Proxy on Docker

This is fully automated dockerized proxy that let's you add HTTPS termination with minimal config.
It uses Let's Encrypt for valid certificates and automation. It handles certification issuance as well as renewal.
It has minimal downtime every 2 months, when the Apache proxy is restarted to use the new certificate.

## Usage

The image needs just a few configurations:

* Expose ports 80 and 443
* Add a network bridge to your service and call it _proxied_
* Set the hostname for the certificate
* Set the port your app is using
* Test it and then set production mode

An example config:

```
version: '2'
services:
  proxy:
    image: sashee/letsencrypt-proxy-docker
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - angular
    networks:
      - proxy
    environment:
      # Set your host
      #- HOST=<yourhost>
      - PORT=80
      # Set your email
      #- EMAIL=<your email>
      # Turn on production mode
      #- MODE=PRODUCTION
    links:
      - angular:proxied
  angular:
    image: thanhson1085/angular-admin-seed
    networks:
      - proxy
networks:
  proxy:
```

Change the `angular` part to your app, and update the `link` above.

## Production mode

Let's Encrypt limits the number of certificates issued for a given host every 7 days.
You should test your setup without setting the MODE, and if everything is ok, only then set it to PRODUCTION.
If you test with live certificates, then you can easily find yourself limited and then you have to wait a week to continue.

## Domain name

If you don't have a domain name, you can use [nip.io](http://nip.io) to test it out.

Please note that AWS domains are blacklisted and will not work.

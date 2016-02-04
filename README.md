# Jiggy Dev Box

## Install vbguests plugin for vagrant:
vagrant plugin install vagrant-vbguest

## Clone jiggy frontend and API
make sure jiggy frontend and API are clones into ../jiggy and ../jiggy-api

## Startup your Vagrant box
vagrant up

## Add this to your hostfile
192.168.33.110     dev.jiggy.nl   api.jiggy.dev

## Notes
- Apache runs as vagrant, therefor it has write access to all files. So make notes of things you need write access to!
- Currently every time you run vagrant provision, the wp-config.php and database will be reset.
- You can change from jiggy.nl to jiggy.fr by changing the language and dbname in /scripts/puppet/manifests/allict.pp
- Default login is info@jiggy.(nl|fr) with Welkom01 as password
- PHPMyAdmin is running as alias, so you can open it as http://jiggy.dev/phpmyadmin
- You could import the SSL certificate using this trick: 
  http://project.efuture.nl/wiki/it/google-chrome-mac-os-x-and-self-signed-ssl-certificates 

## Other instructions
To start SOLR, log in to the server using vagrant ssh, 
start a screen and run the following command:

    /bin/sh /var/www/vhosts/api.jiggy.dev/tools/solr-start.sh
    
connect to SOLR using the following URL:

    http://dev.jiggy.nl:8983/solr    
When doing a data import, use the following custom parameters:

    db_host=localhost&db_name=jiggy_wordpress&db_user=root&db_password=
To start ActiveMQ, log in to the server using vagrant ssh and run:

    /usr/bin/php /var/www/vhosts/api.jiggy.dev/tools/activemq-check.php
To start Memcached, log in to the server using vagrant ssh and run:
    
    /etc/init.d/memcached
or start them up manually like this:
    
    /usr/bin/memcached -d -m 32 -p 11211 -u memcached -l 127.0.0.1 -c 10000

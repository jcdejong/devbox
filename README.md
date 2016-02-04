# Jiggy Dev Box

## Install vbguests plugin for vagrant:
vagrant plugin install vagrant-vbguest

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

## ToDo
- fix hostname, so you don't have to change activemq.pid.location manually :)

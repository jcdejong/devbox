# Jiggy Dev Box

## Install vbguests plugin for vagrant:
vagrant plugin install vagrant-vbguest

## Startup your Vagrant box
vagrant up

## Add this to your hostfile
33.33.33.10     dev.jiggy.nl   api.jiggy.dev

## Notes
- Apache runs as vagrant, therefor it has write access to all files. So make notes of things you need write access to!
- Currently every time you run vagrant provision, the wp-config.php and database will be reset.
- You can change from jiggy.nl to jiggy.fr by changing the language and dbname in /scripts/puppet/manifests/allict.pp
- Default login is info@jiggy.(nl|fr) with Welkom01 as password
- PHPMyAdmin is running as alias, so you can open it as http://jiggy.dev/phpmyadmin

## ToDo
- fix hostname, so you don't have to change activemq.pid.location manually :)
- to use nfs, you need to do install some things first on your basebox unfortunately:
  vagrant ssh
  sudo yum install -y nfs-utils nfs-common portmap
  vagrant reload
- jeroen.dev.jiggy.nl aanmaken :)
- use memcached?

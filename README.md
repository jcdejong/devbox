# Winlabels Dev Box

## Install vbguests plugin for vagrant:
vagrant plugin install vagrant-vbguest

## Startup your Vagrant box
vagrant up

## Add this to your hostfile
33.33.33.13     dev.campaigntracker.nl  dev.wineenreisnaar.nl

## Notes
- Apache runs as vagrant, therefor it has write access to all files. So make notes of things you need write access to!
- Currently every time you run vagrant provision, the wp-config.php and database will be reset.
- PHPMyAdmin is running as alias, so you can open it as http://<domain>/phpmyadmin
- Default CT login is probably admin / Welkom11 ;)

## ToDo

class allict::project::database() {

    exec { 'create-db':
        unless => "/usr/bin/mysql -uroot campaigntracker",
        command => "/usr/bin/mysql -uroot -e \"create database campaigntracker;\"",
        require => Service["mysql"],
    }

    exec { 'create-client-db':
        unless => "/usr/bin/mysql -uroot campaigntracker_onedream",
        command => "/usr/bin/mysql -uroot -e \"create database campaigntracker_onedream;\"",
        require => Service["mysql"],
    }

    exec { 'import-init-data':
        unless => "/usr/bin/mysql -uroot campaigntracker -e 'select * from user limit 1'",
        command => "/usr/bin/mysql -uroot < /var/www/vhosts/dev.campaigntracker.nl/data/vagrant_base_db.sql",
        require => Exec["create-db"],
    }
#
#    exec { 'import-changelog':
#        unless => "/usr/bin/mysql -uroot ${dbname} -e 'select * from changelog limit 1'",
#        command => "/usr/bin/mysql -uroot ${dbname} < /var/www/vhosts/api.jiggy.dev/data/db/dbdeploy.sql",
#        require => Exec["create-db"]
#    }
#
#    exec { 'impot-init-changelog':
#        command => "/usr/bin/mysql -uroot ${dbname} < /var/www/vhosts/api.jiggy.dev/data/db/dbdeploy_${language}-init.sql",
#        require => Exec["import-changelog"]
#    }
#
#    exec { 'simple-dbdeploy':
#        command => "/usr/bin/php /var/www/vhosts/api.jiggy.dev/tools/simple-dbdeploy.php --env=vagrant",
#        require => [
#            Package['php'],
#            Exec["impot-init-changelog"],
#        ],
#        logoutput => true,
#    }
}

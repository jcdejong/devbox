class allict::project::database($dbname = "jiggy_wordpress") {

    exec { 'create-db':
        unless => "/usr/bin/mysql -uroot ${dbname}",
        command => "/usr/bin/mysql -uroot -e \"create database ${dbname};\"",
        require => Service["mysql"],
    }

    exec { 'import-init-data':
        command => "/usr/bin/mysql -uroot ${dbname} < /var/www/vhosts/api.jiggy.dev/data/db/jiggy_wordpress_fr-init.sql",
        require => Exec["create-db"],
    }
}
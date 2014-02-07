class allict::project::database($dbname = "jiggy_wordpress", $language = "nl") {

    exec { 'create-db':
        unless => "/usr/bin/mysql -uroot ${dbname}",
        command => "/usr/bin/mysql -uroot -e \"create database ${dbname};\"",
        require => Service["mysql"],
    }

    exec { 'import-init-data':
        command => "/usr/bin/mysql -uroot ${dbname} < /var/www/vhosts/api.jiggy.dev/data/db/jiggy_wordpress_${language}-init.sql",
        require => Exec["create-db"],
    }

    exec { 'import-changelog':
        unless => "/usr/bin/mysql -uroot ${dbname} -e 'select * from changelog limit 1'",
        command => "/usr/bin/mysql -uroot ${dbname} < /var/www/vhosts/api.jiggy.dev/data/db/dbdeploy.sql",
        require => Exec["create-db"]
    }

    exec { 'impot-init-changelog':
        command => "/usr/bin/mysql -uroot ${dbname} < /var/www/vhosts/api.jiggy.dev/data/db/dbdeploy_${language}-init.sql",
        require => Exec["import-changelog"]
    }

    exec { 'simple-dbdeploy':
        command => "/usr/bin/php /var/www/vhosts/api.jiggy.dev/tools/simple-dbdeploy.php --env=vagrant",
        require => [
		Exec["impot-init-changelog"],
		Package['php'],
	],
        logoutput => true,
    }
}

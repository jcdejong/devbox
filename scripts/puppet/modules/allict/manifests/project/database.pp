class allict::project::database($dbname = "jiggy_wordpress", $language = "nl") {

    file { "mysql-config":
        path    => "/etc/my.cnf.d/server.cnf",
        owner   => 'root',
        group   => 'root',
        require => [
            Package['MariaDB-server'],
        ],
        source => "/vagrant/scripts/puppet/modules/allict/files/mysql.conf",
        notify  => Service["mysql"],
    }

    exec { 'create-db':
        unless => "/usr/bin/mysql -uroot ${dbname}",
        command => "zcat /vagrant/dbs/dump.sql.gz | /usr/bin/mysql -uroot",
        require => [
            Service["mysql"],
            File["mysql-config"],
        ]
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
            Package['php'],
            Exec["impot-init-changelog"],
            Service["mysql"],
        ],
        logoutput => true,
    }
}

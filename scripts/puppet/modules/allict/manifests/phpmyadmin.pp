class allict::phpmyadmin {

    # Install PHPMyAdmin on /phpmyadmin
    package { "phpMyAdmin" :
        ensure  => present,
        require => Exec['epel-rpm'],
    }

    # Setup our own phpmyadmin configuration file
    file { "/etc/httpd/conf.d/phpMyAdmin.conf" :
        source  => "/vagrant/scripts/puppet/modules/allict/files/phpmyadmin-vhost.conf",
        require => [
            Package['apache'],
            Package["phpMyAdmin"],
        ],
        notify  => Service["httpd"]
    }

    # Setup our own phpmyadmin configuration file
    file { "/etc/phpMyAdmin/config.inc.php" :
        source  => "/vagrant/scripts/puppet/modules/allict/files/phpmyadmin.conf",
        require => Package["phpMyAdmin"]
    }
}
class allict::phpmyadmin {

    # Install PHPMyAdmin on /phpmyadmin
    package { "phpMyAdmin" :
        ensure  => present,
        require => [
            Package['php'],
            Exec['epel-rpm'],
        ],
    }

    # Setup our own phpmyadmin configuration file
    file { "/etc/httpd/conf.d/phpMyAdmin.conf" :
        source  => "/vagrant/scripts/puppet/modules/allict/files/phpmyadmin-vhost.conf",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => [
            Package['apache'],
            Package["phpMyAdmin"],
        ],
        notify  => Service["httpd"]
    }

    # Setup our own phpmyadmin configuration file
    file { "/etc/phpMyAdmin/config.inc.php" :
        source  => "/vagrant/scripts/puppet/modules/allict/files/phpmyadmin.conf",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package["phpMyAdmin"]
    }
}
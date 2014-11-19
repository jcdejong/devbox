class allict::phpmyadmin {

    # Install PHPMyAdmin on /phpmyadmin
    package { "phpMyAdmin" :
        ensure  => present,
        require => [
            Package['php'],
            Exec['epel-workaround'],
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
    file { "/usr/share/phpMyAdmin/config.inc.php" :
        source  => "/vagrant/scripts/puppet/modules/allict/files/phpmyadmin.conf",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package["phpMyAdmin"]
    }
    
    # somehow the default locations for config.inc.php are not read.. so workaround :)
    exec { "phpmyadmin-config-workaround" :
        command => "sed -i.bak \"s/\\['AllowNoPassword'\\] = false/\\['AllowNoPassword'\\] = true/g\" /usr/share/phpMyAdmin/libraries/config.default.php",
        creates =>  "/usr/share/phpMyAdmin/libraries/config.default.php.bak",
        require => Package["phpMyAdmin"]
    }
}
class allict::web($xdebug = false) {

    # Install Apache
    package { "apache" :
        name   => "httpd",
        ensure => present,
    }

    # Enable the repository for PHP 5.3
    file { 'ius-repo' :
        path    => '/etc/yum.repos.d/ius.repo',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => '/vagrant/scripts/puppet/modules/allict/files/ius.repo',
        ensure  => present,
    }

    # Install PHP
    package { "php" :
        name   => "php55u",
        ensure => present,
        require => [
            File['ius-repo'],
        ],
    }

    # Install some default packages
    $web_packages = [
        "mod_ssl", "httpd-devel", "php55u-mbstring", "php55u-imap", "php55u-cli", "php55u-process", "php55u-mysqlnd", "php55u-devel", "php55u-gd",
        "php55u-mcrypt", "php55u-xmlrpc", "php55u-xml", "php55u-soap", "php55u-pear", "pcre-devel", "zlib-devel",
        "libmemcached10", "libmemcached10-devel", "php55u-opcache", "php55u-pecl-memcached", "php55u-pecl-memcache",
    ]
    package { $web_packages :
        ensure  => present,
        require => [
            Package['apache'],
            Package['php'],
        ],
        notify  => Service["httpd"],
    }

    # Custom apache config
    file { 'apache-conf' :
        path    => '/etc/httpd/conf.d/000_tuning.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => '/vagrant/scripts/puppet/modules/allict/files/apache.conf',
        ensure  => present,
        require => [
            Package['apache'],
        ],
        notify  => Service["httpd"],
    }

    # Custom php config
    file { 'php-conf' :
        path    => '/etc/php.d/allict.ini',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => '/vagrant/scripts/puppet/modules/allict/files/php.conf',
        ensure  => present,
        require => [
            Package['apache'],
            Package['php55u'],
        ],
        notify  => Service["httpd"],
    }

    # Make sure Apache is running
    service { 'httpd':
        name    => $service_name,
        ensure  => running,
        enable  => true,
        require => [
            Package['apache'],
        ],
    }

    # Change user / group, workaround for write access...
    exec { "UsergroupChange" :
        command => "sed -i 's/User apache/User vagrant/ ; s/Group apache/Group vagrant/' /etc/httpd/conf/httpd.conf",
        onlyif  => "grep -c 'User apache' /etc/httpd/conf/httpd.conf",
        require => Package["apache"],
        notify  => Service['httpd'],
    }

    file { "/var/lib/php/session" :
        owner  => "root",
        group  => "vagrant",
        mode   => 0770,
        require => Package["php55u"],
    }

    # Enable multiple vhosts
    exec { "apache-vhosts" :
        command => "echo 'NameVirtualHost *:80' >> /etc/httpd/conf.d/000_ports.conf",
        onlyif  => "grep -c '80' /etc/httpd/conf.d/000_ports.conf",
        require => Package["apache"],
        notify  => Service['httpd'],
    }

    # enable SSL
    exec { "mod_ssl" :
        command => "echo 'NameVirtualHost *:443' >> /etc/httpd/conf.d/000_ports.conf",
        onlyif  => "grep -c '443' /etc/httpd/conf.d/000_ports.conf",
        require => Package["apache"],
        notify  => Service['httpd'],
    }

    if $xdebug {
        package { "xdebug" :
            name   => "php-pecl-xdebug",
            ensure => present,
            require => [
                Package['php55u'],
                Package['apache'],
            ],
            notify  => Service["httpd"],
        }
    }
}

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
    package { "php56u" :
        name   => "php56u",
        ensure => present,
        require => [
            File['ius-repo'],
        ],
    }

    # Install some default packages
    $web_packages = [
        "mod_ssl", "httpd-devel", "php56u-imap", "php56u-cli", "php56u-process", "php56u-mysqlnd", "php56u-devel", "php56u-gd",
        "php56u-mcrypt", "php56u-xmlrpc", "php56u-xml", "php56u-soap", "php56u-pear", "pcre-devel", "zlib-devel",
        "libmemcached10", "libmemcached10-devel", "php56u-opcache", "php56u-pecl-memcached", "php56u-pecl-memcache",
    ]
    package { $web_packages :
        ensure  => present,
        require => [
            Package['apache'],
            Package['php56u'],
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

    # Enable multiple vhosts
    file { 'apache-vhosts' :
        path    => '/etc/httpd/conf.d/000_ports.conf',
        content => 'NameVirtualHost *:80',
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
            Package['php56u'],
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
        require => Package["php56u"],
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
                Package['php56u'],
                Package['apache'],
            ],
            notify  => Service["httpd"],
        }
    }
}

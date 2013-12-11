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
        name   => "php53u",
        ensure => present,
        require => [
            File['ius-repo'],
        ],
    }

    # Install some default packages
    $web_packages = [
        "httpd-devel", "php53u-imap", "php53u-cli", "php53u-process", "php53u-mysql", "php53u-devel", "php53u-gd",
        "php53u-mcrypt", "php53u-xmlrpc", "php53u-xml", "php53u-soap", "php53u-pear", "php-pear-Net-URL",
        "php-pear-Net-Socket", "php-pear-Net-FTP", "php-pear-Net-SMTP", "php-pear-Net-DIME",
        "php-pear-Mail-mimeDecode", "php-pear-Mail-Mime", "php-pear-Mail", "php-pear-HTTP-Request",
        "php-pear-MDB2-Driver-mysql", "pcre-devel", "zlib-devel", "libmemcached", "libmemcached-devel",
        "php53u-pecl-apc", "php53u-pecl-memcached", "php53u-pecl-memcache",
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
            Package['php'],
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

    if $xdebug {
        package { "xdebug" :
            name   => "php53u-pecl-xdebug",
            ensure => present,
            require => [
                Package['php'],
                Package['apache'],
            ],
            notify  => Service["httpd"],
        }
    }
}
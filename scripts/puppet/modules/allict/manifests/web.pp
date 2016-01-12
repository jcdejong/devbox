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
        name   => "php",
        ensure => present,
        require => [
            File['ius-repo'],
        ],
    }

    # Install some default packages
    $web_packages = [
        "mod_ssl", "httpd-devel", "php-imap", "php-cli", "php-process", "php-mysql", "php-devel", "php-gd",
        "php-mcrypt", "php-xmlrpc", "php-xml", "php-soap", "php-pear", "php-pear-Net-URL",
        "php-pear-Net-Socket", "php-pear-Net-FTP", "php-pear-Net-SMTP", "php-pear-Net-DIME",
        "php-pear-Mail-mimeDecode", "php-pear-Mail-Mime", "php-pear-Mail", "php-pear-HTTP-Request",
        "php-pear-MDB2-Driver-mysql", "pcre-devel", "zlib-devel", "libmemcached", "libmemcached-devel",
        "php-pecl-apc", "php-pecl-memcached", "php-pecl-memcache",
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
        content => "NameVirtualHost *:80\nNameVirtualHost *:443",
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
        require => Package["php"],
    }

    if $xdebug {
        package { "xdebug" :
            name   => "php-pecl-xdebug",
            ensure => present,
            require => [
                Package['php'],
                Package['apache'],
            ],
            notify  => Service["httpd"],
        }
    }
}

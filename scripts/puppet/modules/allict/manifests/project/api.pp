class allict::project::api($docroot = "/vagrant/httpdocs/", $port = 80) {

    file { "vhost-api":
        path    => "/etc/httpd/conf.d/${name}.conf",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => [
            Package['apache'],
        ],
        content => template('/vagrant/scripts/puppet/modules/allict/templates/vhost.conf.erb'),
        notify  => Service["httpd"],
    }

    file { ['/var/www/vhosts/api.jiggy.dev/library', '/var/www/vhosts/api.jiggy.dev/library/Doctrine', '/var/www/vhosts/api.jiggy.dev/library/Doctrine/Proxies', '/var/www/vhosts/api.jiggy.dev/logs']:
        ensure => 'directory',
        owner  => 'vagrant',
        group  => 'apache',
        mode   => 775,
        require => Package['apache'],
    }

    file { "e-ngine.ini":
        path    => "/var/www/vhosts/api.jiggy.dev/application/configs/e-ngine.ini",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => [
            Package['apache'],
        ],
        source => '/var/www/vhosts/api.jiggy.dev/application/configs/e-ngine.ini.fr',
    }

    file { "application.ini":
        path    => "/var/www/vhosts/api.jiggy.dev/application/configs/application.ini",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => [
            Package['apache'],
        ],
        source => '/var/www/vhosts/api.jiggy.dev/application/configs/application.ini.fr',
    }
}
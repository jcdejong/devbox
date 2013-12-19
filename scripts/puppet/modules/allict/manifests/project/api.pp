class allict::project::api($docroot = "/vagrant/httpdocs/", $port = 80, $language = "nl") {

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

    file { ['/var/www/vhosts/api.jiggy.dev/library', '/var/www/vhosts/api.jiggy.dev/library/Doctrine', '/var/www/vhosts/api.jiggy.dev/library/Doctrine/Proxies']:
        ensure => 'directory',
        require => Package['apache'],
    }

    file { "e-ngine.ini":
        path    => "/var/www/vhosts/api.jiggy.dev/application/configs/e-ngine.ini",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/api.jiggy.dev/application/configs/e-ngine.ini.${language}",
    }

    file { "application.ini":
        path    => "/var/www/vhosts/api.jiggy.dev/application/configs/application.ini",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/api.jiggy.dev/application/configs/application.ini.${language}",
    }
}
class allict::project::campaigntracker($docroot = "/vagrant/httpdocs/", $port = 80, $sslport = 443) {

    file { "vhost-campaigntracker":
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

    file { "application.ini":
        path    => "/var/www/vhosts/dev.campaigntracker.nl/application/configs/application.ini",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/dev.campaigntracker.nl/scripts/application.ini",
    }

    file { "admin_htaccess":
        path    => "/var/www/vhosts/dev.campaigntracker.nl/httpdocs/admin/.htaccess",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/dev.campaigntracker.nl/scripts/htaccess",
    }

    file { "soap_htaccess":
        path    => "/var/www/vhosts/dev.campaigntracker.nl/httpdocs/soap/.htaccess",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/dev.campaigntracker.nl/scripts/htaccess",
    }

    file { "lightweight.wsdl":
        path    => "/var/www/vhosts/dev.campaigntracker.nl/httpdocs/soap/lightweight.wsdl",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/dev.campaigntracker.nl/scripts/lightweight.wsdl",
    }
}

# Set default path for Exec calls
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}

node default {

    # Default CentOS setup
    class { "allict::setup" : }

    # Include our web server
    class { "allict::web" :
        xdebug => true,
    }

    # Include our database server
    class { "allict::mariadb" : }

    # Set up phpMyAdmin
    class { "allict::phpmyadmin" : }

    # Set up memcached
    class { "allict::memcached" : }

    # Set up project
    class { "allict::project::campaigntracker" :
        name => "dev.campaigntracker.nl",
        docroot => "/var/www/vhosts/dev.campaigntracker.nl/httpdocs/",
        port => 80,
        sslport => 443,
    }

    class { "allict::project::wineenreis" :
        name => "dev.wineenreisnaar.nl",
        docroot => "/var/www/vhosts/dev.wineenreisnaar.nl/httpdocs/",
        port => 80,
        sslport => 443,
    }

    class { "allict::project::database" : }

}

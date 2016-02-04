# Set default path for Exec calls
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}

node default {

    # Default CentOS setup
    class { "allict::setup" : }

    # Include our web server
    class { "allict::web" :
        xdebug => false,
    }

    # Include our database server
    class { "allict::mariadb" : }

    # Set up phpMyAdmin
    class { "allict::phpmyadmin" : }

    # Set up memcached
    class { "allict::memcached" : }

    # Set up project
    class { "allict::project::www" :
        name => "dev.jiggy.nl",
        docroot => "/var/www/vhosts/dev.jiggy.nl/httpdocs/",
        port => 80,
        sslport => 443,
        language => "nl",
    }

    class { "allict::project::api" :
        name => "api.jiggy.dev",
        docroot => "/var/www/vhosts/api.jiggy.dev/public/",
        port => 80,
        sslport => 443,
        language => "nl",
    }

    class { "allict::project::database" :
        dbname => "jiggy_wordpress",
        language => "nl",
    }

}

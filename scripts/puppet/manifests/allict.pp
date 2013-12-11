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
    class { "allict::project" :
        name => "allict.dev",
        docroot => "/vagrant/httpdocs/",
        port => 80,
    }

}
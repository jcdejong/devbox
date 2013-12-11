class allict::mariadb() {

    # Enable the repository
    file { 'mariadb-repo' :
        path    => '/etc/yum.repos.d/MariaDB.repo',
        source  => '/vagrant/scripts/puppet/modules/allict/files/mariadb.repo',
        ensure  => present,
    }

    $mariadb = [
        "MariaDB-server",
        "MariaDB-client",
    ]
    package { $mariadb :
        ensure  => present,
        require => File['mariadb-repo'],
    }

    # Make sure MySQL is running
    service { 'mysql':
        ensure  => running,
        enable  => true,
        require => [
            Package['MariaDB-server'],
        ],
    }
}
class allict::memcached {

    # Install Memcached
    package { "memcached" :
        name   => "memcached",
        ensure => present,
    }

}
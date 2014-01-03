class allict::project::www($docroot = "/vagrant/httpdocs/", $port = 80, $language = "nl") {

    file { "vhost-www":
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

    file { ['jiggy-logs']:
        path   => '/var/log/jiggy/',
        ensure => 'directory',
        owner  => 'vagrant',
        group  => 'apache',
        mode    => '775',
        require => Package['apache'],
    }

    file { "wp-config.php":
        path    => "/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php.svn.${language}",
    }

    #\27 is a single quote.. I had some problems escaping everything ;)
    exec { "/bin/sed -i -e's/\\x27DB_USER\\x27, \\x27\\(.*\\)\\x27/\\x27DB_USER\\x27, \\x27root\\x27/' '/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php'":
        onlyif => "/usr/bin/test `/bin/grep 'DB_USER' '/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php'| grep 'root' | /usr/bin/wc -l` -ne 1",
        require => [
            File['wp-config.php'],
        ],
    }

    exec { "/bin/sed -i -e's/\\x27DB_PASSWORD\\x27, \\x27\\(.*\\)\\x27/\\x27DB_PASSWORD\\x27, \\x27\\x27/' '/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php'":
        onlyif => "/usr/bin/test `/bin/grep 'DB_PASSWORD' '/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php'| grep \"''\" | /usr/bin/wc -l` -ne 1",
        require => [
            File['wp-config.php'],
        ],
    }

    exec { "/bin/sed -i -e's/\\x27DB_HOST\\x27, \\x27\\(.*\\)\\x27/\\x27DB_HOST\\x27, \\x27localhost\\x27/' '/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php'":
        onlyif => "/usr/bin/test `/bin/grep 'DB_HOST' '/var/www/vhosts/jiggy.dev/httpdocs/wp-config.php'| grep 'localhost' | /usr/bin/wc -l` -ne 1",
        require => [
            File['wp-config.php'],
        ],
    }

    exec { 'jiggy-update-wp':
        command => "/usr/bin/php /var/www/vhosts/api.jiggy.dev/tools/cacli.php wp:setup --env=development wp:setup -wpurl=http://jiggy.dev -apiurl=http://api.jiggy.dev -logdir=/var/log/jiggy --quiet",
        require => [
            Package['apache'],
            File['jiggy-logs'],
            File['e-ngine.ini'], #from api
            File['application.ini'], #from api
        ],
    }

    #set jiggy.dev and api.jiggy.dev in hosts-file
    exec { "/bin/echo '127.0.0.1    api.jiggy.dev jiggy.dev' >> /etc/hosts":
        onlyif => "/usr/bin/test `/bin/grep 'jiggy.dev' '/etc/hosts' | /usr/bin/wc -l` -ne 1",
    }

/*
    file { "w3-total-cache-config.php":
        path    => "/var/www/vhosts/jiggy.dev/httpdocs/wp-content/w3-total-cache-config.php",
        require => [
            Package['apache'],
        ],
        source => "/var/www/vhosts/jiggy.dev/httpdocs/wp-content/w3-total-cache-config.php.${language}",
    }
*/
}
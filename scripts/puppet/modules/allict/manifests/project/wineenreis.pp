class allict::project::wineenreis($docroot = "/vagrant/httpdocs/", $port = 80, $sslport = 443) {

    file { "vhost-winlabel":
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

    #set host in hostfile
    exec { "/bin/echo '127.0.0.1    dev.wineenreisnaar.nl' >> /etc/hosts":
        onlyif => "/usr/bin/test `/bin/grep 'dev.wineenreisnaar.nl' '/etc/hosts' | /usr/bin/wc -l` -ne 1",
    }
}

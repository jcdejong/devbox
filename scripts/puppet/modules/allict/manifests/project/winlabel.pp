class allict::project::winlabel($docroot = "/vagrant/httpdocs/", $port = 80, $language = "nl") {

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
}

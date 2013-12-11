class allict::setup {
    
    # Subversion
    package { "subversion" :
        name => "subversion",
        ensure => present,
    }

    # Git
    package { "git-core" :
        name => "git",
        ensure => present,
    }

    # Enable EPEL Repo
    exec { "epel-rpm" :
        command => "wget http://mirror.i3d.net/pub/fedora-epel/6/i386/epel-release-6-8.noarch.rpm -O /tmp/epel-release-6-8.noarch.rpm",
        creates =>  "/tmp/epel-release-6-8.noarch.rpm",
    }
    exec { "epel-repo" :
        command => "rpm -Uvh /tmp/epel-release-6-8.noarch.rpm",
        creates =>  "/etc/yum.repos.d/epel.repo",
        require => Exec['epel-rpm'],
    }

    # Install some default packages
    $default_packages = [
        "mc", "strace", "sysstat", "mlocate", "ncftp", "wget", "cronie", "kernel-devel", "gcc", "rsync", "unzip", "screen"
    ]
    package { $default_packages :
        ensure => present,
        require => Exec['epel-repo'],
    }
    
    # Setup timezone
    file { "timezone" :
        path    => "/etc/localtime",
        source  => "/usr/share/zoneinfo/Europe/Amsterdam",
        owner   => "root",
        group   => "root",
        mode    => 0644,
    }

    # Make sure cron is running
    service { 'crond':
      ensure  => running,
      enable  => true,
    }

    # Disable firewalling for now
    service { "iptables":
        enable => "false",
        ensure => "stopped",
    }
    service { "ip6tables":
        enable => "false",
        ensure => "stopped",
    }
}
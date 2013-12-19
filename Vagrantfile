# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Use a standard box
    config.vm.box = 'centos-64-x64-vbox4210'
    config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box'

    # Define our virtual machine settings
    config.vm.define :allict do |allict|

        allict.vm.hostname = "jiggy.local"
        allict.vm.network :private_network, ip: "33.33.33.10"

        allict.vm.synced_folder "./../jiggy", "/var/www/vhosts/jiggy.dev/", :nfs => true
        allict.vm.synced_folder "./../jiggy-api", "/var/www/vhosts/api.jiggy.dev/", :nfs => true

        # Here we customize our virtualbox provider. If there are others, add them accordingly below
        allict.vm.provider :virtualbox do |vbox|
            vbox.gui = true

            vbox.customize [
                'modifyvm', :id,
                '--chipset', 'ich9',               # solves kernel panic issue on some host machines
                '--memory', '2048',
                '--cpus', '4',
                "--natdnshostresolver1", "on"
            ]

            #'--cpuexecutioncap', '50',          # no matter how much CPU is used in the VM, no more than 50% would be used on your own host machine
            #'--uartmode1', 'file', 'C:\\base6-console.log',     # uncomment to change log location on Windows

        end

        # Provision through puppet
        allict.vm.provision :puppet do |puppet|
            puppet.manifests_path = "scripts/puppet/manifests"
            puppet.module_path = "scripts/puppet/modules"
            puppet.manifest_file = "allict.pp"
            puppet.options = [
                '--verbose',
#                '--debug',
            ]
        end
    end
end

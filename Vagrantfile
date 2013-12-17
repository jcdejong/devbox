Vagrant::configure("2") do |config|

    # Use a standard box
    config.vm.box = 'centos-64-x64-vbox4210'
    config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box'

    # Define our virtual machine settings
    config.vm.define :allict do |allict|

        allict.vm.hostname = "allict.dev"
        allict.vm.network :private_network, ip: "33.33.33.10"
        allict.vm.synced_folder "./../jiggy", "/var/www/vhosts/jiggy.dev/", :nfs => false
        allict.vm.synced_folder "./../jiggy-api", "/var/www/vhosts/api.jiggy.dev/", :nfs => false

        # Here we customize our virtualbox provider. If there are others, add them accordingly below
        allict.vm.provider :virtualbox do |vbox|
            vbox.gui = false

            vbox.memory = 1024

            vbox.customize [
                'modifyvm', :id,
                '--chipset', 'ich9',               # solves kernel panic issue on some host machines
                '--uartmode1', 'file', 'C:\\base6-console.log',     # uncomment to change log location on Windows
                '--cpuexecutioncap', '50'          # no matter how much CPU is used in the VM, no more than 50% would be used on your own host machine
            ]
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
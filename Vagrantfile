# -*- mode: ruby -*-
# vi: set ft=ruby :
current_dir = File.expand_path(File.dirname(__FILE__))

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
REQUIRED_VAGRANT_PLUGINS = %w( vagrant-berkshelf vagrant-omnibus )
Vagrant.require_version '>= 1.5.0'
REQUIRED_VAGRANT_PLUGINS.each do |plugin_name|
  unless Vagrant.has_plugin?(plugin_name)
    puts "#{plugin_name} plugin not found: install via `vagrant plugin install #{plugin_name}`"
    exit
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.omnibus.chef_version = '12'
  config.berkshelf.enabled = true

  config.vm.hostname = 'simple-nat-cookbook-berkshelf'
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network :private_network, type: 'dhcp'
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision :shell, inline: <<EOF
echo "updating os package database"
export DEBIAN_FRONTEND=noninteractive
apt-get update -yq > /dev/null
echo "updating os packages"
apt-get upgrade -yq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" > /dev/null
EOF


  config.vm.provision :chef_solo do |chef|
    chef.json = {
      mysql: {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      },
      "iptables-ng": {
        rules: {
          filter: {
            INPUT: {
              default: "ACCEPT [0:0]"
            }
          }
        }
      }
    }

    chef.run_list = [
      'recipe[simple-nat::default]'
    ]
  end
end

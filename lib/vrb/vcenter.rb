module Vrb

  require 'yaml'

  VIM = RbVmomi::VIM
  VCENTER_CONFIG_FILE = '~/.fog'

  file = File.open(File.expand_path(VCENTER_CONFIG_FILE)).read
  config = YAML.load(file)[:default]
  VCENTER_SERVER = config[:vsphere_server]
  VCENTER_USERNAME = config[:vsphere_username]
  VCENTER_PASSWORD = config[:vsphere_password]

  class Vcenter

    attr_reader :mob

    def initialize(
        host     = VCENTER_SERVER,
        user     = VCENTER_USERNAME,
        password = VCENTER_PASSWORD
      )

      @mob = VIM.connect(
        :host => host,
        :user => user,
        :password => password,
        :insecure => true
      )
    end

    def inspect
      return "#{self.class}(#{@mob.host})"
    end

    #TODO: is this useful?
    def get_vm_by_path(path)
      vm_mob = @mob.searchIndex.FindByInventoryPath(:inventoryPath => path)
      VM.new(@mob, vm_mob)
    end

    #FIXME
    def get_host(name)
      puts "Not implemented yet"
    end

    def get_datacenter(name)
      dcs = list_datacenters(true) #true = return_as_mobs and not String
      dc_mob = dcs.select { |d| d.name =~ /#{name}/ }.first or fail "Sorry! #{name} is unknown"
      Datacenter.new(@mob, dc_mob)
    end

    def list_datacenters(return_as_mobs = false)
      if return_as_mobs
        @mob.rootFolder.children.grep(VIM::Datacenter)
      else
        mobs = @mob.rootFolder.children.grep(VIM::Datacenter)
        mobs.collect { |mob| mob.name }
      end
    end
  end
end

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
      "#{@mob.serviceInstance.serverClock}: #{self.class}(#{@mob.host})"
    end
  end
end

module Vrb

  require 'yaml'

  #FIXME: do not hardcode the config file
  #FIXME: have our own config file
  #FIXME: all these constants seem redundant
  #
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
      info = []
      i = @mob.serviceInstance.content.about
      info << "vcenterHost: #{VCENTER_SERVER}"
      info << "vcenterTime: #{@mob.serviceInstance.serverClock}"
      info << "vcenterUser: #{VCENTER_USERNAME}"
      info << "apiType: #{i.apiType}"
      info << "apiVersion: #{i.apiVersion}"
      info << "build: #{i.build}"
      info << "fullName: #{i.fullName}"
      info << "instanceUuid: #{i.instanceUuid}"
      info << "licenseProductName: #{i.licenseProductName}"
      info << "licenseProductVersion: #{i.licenseProductVersion}"
      info << "localeBuild: #{i.localeBuild}"
      info << "localeVersion: #{i.localeVersion}"
      info << "name: #{i.name}"
      info << "osType: #{i.osType}"
      info << "productLineId: #{i.productLineId}"
      info << "vendor: #{i.vendor}"
      info << "version: #{i.version}"
      info
    end

    def to_s
      "#{VCENTER_USERNAME}@#{VCENTER_SERVER}"
    end

    def datacenter(name)
      dcs = datacenters
      dc_mob = dcs.select { |d| d.name =~ /#{name}/ }.first or fail "Sorry! #{name} is unknown"
      Datacenter.new(@mob, dc_mob)
    end

    def datacenters(return_as_mobs = true)
      if return_as_mobs
        @mob.rootFolder.children.grep(VIM::Datacenter)
      else
        mobs = @mob.rootFolder.children.grep(VIM::Datacenter)
        mobs.collect { |mob| mob.name }
      end
    end
  end
end

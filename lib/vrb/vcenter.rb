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

    #TODO: this should return a bunch of info about the vcenter connected to
    #
    def inspect
      info = []
      i = @mob.serviceInstance.content.about
      info << "vcenterHost: #{VCENTER_SERVER}"
      info << "vcenterTime: #{@mob.serviceInstance.serverClock}"
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
  end
end

# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','vrb','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'vrb'
  s.version = Vrb::VERSION
  s.author = ['Justin Clayton', 'Mick Pollard']
  s.email = ['justinclayton@example.com', 'aussielunix@gmail.com']
  s.homepage = 'https://github.com/justinclayton/vrb'
  s.platform = Gem::Platform::RUBY
  s.summary = 'work with the vsphere API'
  s.files = Dir['Gemfile', 'vrb.gemspec', 'lib/**/*']
  s.require_paths << 'lib'
  s.add_runtime_dependency('rbvmomi')
  s.add_development_dependency('rake')
  s.add_development_dependency('bundler')
end

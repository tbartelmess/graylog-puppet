source 'https://rubygems.org'

group :development, :test do
  gem 'rake'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-system-puppet', '~>2.0', :git => 'https://github.com/tbartelmess/rspec-system-puppet.git'
  gem 'rspec-system-serverspec', '~>1.0', :git => 'https://github.com/tbartelmess/rspec-system-serverspec.git'
  gem 'puppet-lint', '~> 0.3.2'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby

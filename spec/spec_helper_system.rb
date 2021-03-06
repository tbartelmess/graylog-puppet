require 'rspec-system/spec_helper'
require 'rspec-system-puppet/helpers'
require 'rspec-system-serverspec/helpers'
require 'tempfile'

include Serverspec::Helper::RSpecSystem
include Serverspec::Helper::DetectOS


def install_module(name)
  shell('puppet module list') do |r|
    if not r.stdout.include? name
      shell("puppet module install --ignore-dependencies  #{name}")
    end
  end
end



class String
  # Provide ability to remove indentation from strings, for the purpose of
  # left justifying heredoc blocks.
  def unindent
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

include RSpecSystemPuppet::Helpers
RSpec.configure do |c|

  puts c
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Enable colour in Jenkins
  c.tty = true

  # Puppet helpers
  c.include RSpecSystemPuppet::Helpers
  c.extend RSpecSystemPuppet::Helpers

  # This is where we 'setup' the nodes before running our tests
  c.before :suite do
    # Install puppet
    puppet_install

    # Copy this module into the module path of the test node
    shell('rm -rf /etc/puppet/modules/graylog/')
    puppet_module_install(:source => proj_root, :module_name => 'graylog')
    install_module 'puppetlabs/concat'
    install_module 'puppetlabs/stdlib'
    install_module 'puppetlabs/mongodb'
    install_module 'elasticsearch/elasticsearch'
    file = Tempfile.new('foo')
    begin
      file.write(<<-EOS)
---
:logger: noop
      EOS
      file.close
      rcp(:sp => file.path, :dp => '/etc/puppet/hiera.yaml')
    ensure
      file.unlink
    end
  end
end


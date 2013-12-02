require 'spec_helper'

describe 'graylog::install', :type => :class do
  let (:pre_condition) do
    "include graylog::server"
  end
  let :facts do
    {
      :concat_basedir => tmpfilename('install_config'),
    }
  end
  it { should contain_concat__fragment('main_configuration') }
end

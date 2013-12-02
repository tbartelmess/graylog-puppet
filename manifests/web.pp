class graylog::web {
  file{"/tmp/download_graylog_web.sh":
    ensure  => present,
    content => template('graylog/download_graylog_web.sh.erb'),
    mode    => '777',
  }

  exec{"Download and install graylog web interface ${graylog::server::version}":
    command => "/tmp/download_graylog_web.sh",
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    require => [File["/tmp/download_graylog_web.sh"]],
    unless  => "/bin/cat ${graylog::server::web_interface_install_location}/version | grep ${graylog::server::version}"
  } ->

  file {$graylog::server::web_interface_install_location:
    ensure => directory,
    owner  => $graylog::server::user,
    group  => $graylog::server::user,
    recurse => true
  } ->

  file {$graylog::server::web_interface_config_file:
    ensure  => present,
    content => template('graylog/graylog2-web-interface.conf.erb'),
  } ->

  file {"$graylog::server::web_interface_install_location/conf/graylog2-web-interface.conf":
    ensure => link,
    target => $graylog::server::web_interface_config_file
  } ->

  file {$graylog::server::web_interface_application_config_file:
    ensure  => present,
    content => template('graylog/web-interface-application.conf.erb')
  } ->

  file {"$graylog::server::web_interface_install_location/conf/application.conf":
    ensure => link,
    target => $graylog::server::web_interface_application_config_file
  } ->


  file {"/etc/init.d/graylog2-web-interface":
    ensure  => present,
    content => template("graylog/centos_webinterface_init.erb"),
    mode    => '777'
  }

  service {"graylog2-web-interface":
    ensure  => running,
    require => '/etc/init.d/graylog2-web-interface'
  }
}

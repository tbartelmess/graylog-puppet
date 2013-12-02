class graylog::install {
  if !defined(Class['concat::setup']) {
    include concat::setup
  }

  user {$graylog::server::user:
    ensure => present,
  }

  file{$graylog::server::config_location:
    ensure  => directory,
    owner   => $graylog::server::user,
    require => [User[$graylog::server::user]]
  }

  file{$graylog::server::run_folder:
    ensure  => directory,
    owner   => $graylog::server::user,
    require => [User[$graylog::server::user]]
  }

  file{$graylog::server::log_folder:
    ensure  => directory,
    owner   => $graylog::server::user,
    require => [User[$graylog::server::user]]
  }

  concat::fragment {'graylog_server_main':
    target  => $graylog::server::config_file,
    content => template('graylog/graylog2_conf/main.erb'),
    order   => 1
  }

   concat { $graylog::server::config_file:
    owner   => $graylog::server::user,
    mode    => '0640',
    warn    => true,
    require => [File[$graylog::server::config_location],
                User[$graylog::server::user]]
  }

  ensure_packages([$graylog::server::java_package])

  file{"/tmp/download_graylog.sh":
    ensure  => present,
    content => template('graylog/download_graylog.sh.erb'),
    mode    => '777',
  }

  file {$graylog::server::install_location:
    ensure  => directory,
    owner   => $graylog::server::user,
    require => User[$graylog::server::user]
  }

  exec{"Download Graylog2 ${graylog::server::version}":
    command => "/tmp/download_graylog.sh",
    unless  => "/usr/bin/java ${graylog::server::jar_file} --version | grep ${graylog::server::version}",
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    require => [File["/tmp/download_graylog.sh"],
                File[$graylog::server::install_location],
                Package[$graylog::server::java_package]]
  }
  file {$graylog::server::jar_file:
    ensure    => present,
    owner     => $graylog::server::user,
    require   => User[$graylog::server::user],
    subscribe => Exec["Download Graylog2 ${graylog::server::version}"]
  }
  file {"/etc/init.d/graylog2":
    ensure  => present,
    content => template("graylog/centos_init.erb"),
    mode    => '777'
  }
  if $graylog::server::configure_mongodb {
    $db_host = $graylog::server::mongodb_host
    $db_port = $graylog::server::mongodb_port
    $db_name = $graylog::server::mongodb_database
    $mongo_users_file = "${graylog::server::config_location}/mongo_users.js"
    class { 'mongodb':
      enable_10gen => true,
    }
    file {$mongo_users_file:
      ensure  => present,
      content => template('graylog/mongo_users.js.erb'),
      require => [File[$graylog::server::config_location]]
    }

    $db_connection = "${db_host}:${db_port}/${db_name}"
    exec {"Create mongodb users":
      subscribe   => File[$mongo_users_file],
      refreshonly => true,
      command     => "mongo ${db_connection} ${graylog::server::config_location}/mongo_users.js",
      path        => ['/usr/bin'],
      require     => [File[$mongo_users_file],
                      Service['mongod']]
    }

    Class['mongodb'] -> Service['graylog2']

  }
  if $graylog::server::configure_elasticsearch {
    class { 'elasticsearch':
      package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.noarch.rpm',
      config => {
        'cluster.name' => 'graylog2',
      }
    }
    Class['elasticsearch'] -> Service['graylog2']
  }

  service {'graylog2':
    ensure => running,
    require => [File['/etc/init.d/graylog2']]
  }
}

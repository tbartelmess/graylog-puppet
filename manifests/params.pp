class graylog::params {
  $version = '0.20.0-preview.7'
  $github_url = 'https://github.com/Graylog2'
  $github_server_project = 'graylog2-server'
  $github_webinterface_project = 'graylog2-web-interface'
  $releases_url = 'releases/download'
  $server_download_url = "${github_url}/${github_server_project}/${releases_url}/${version}/graylog2-server-${version}.tgz"
  $webinterface_download_url = "${github_url}/${github_webinterface_project}/${releases_url}/${version}/graylog2-web-interface-${version}.tgz"

  $user = 'graylog2'

  $install_location = '/opt/graylog2'
  $plugin_location = "${install_location}/plugins"
  $jar_file = "${install_location}/graylog2-server.jar"

  $config_location = "/etc/graylog2"
  $config_file = "${config_location}/graylog2.conf"
  $run_folder = '/var/run/graylog2'
  $log_folder = '/var/log/graylog2'
  $pidfile = "${run_folder}/graylog2.pid"
  $lockfile = "${run_folder}/graylog2.lock"
  $logfile = "${log_folder}/graylog2.log"

  $rest_listen_uri = "127.0.0.1:12900"


  $is_master = true

  $configure_elasticsearch = true
  $elasticsearch_max_docs_per_index = 20000000
  $elasticsearch_index_prefix = graylog2
  $elasticsearch_max_number_of_indices = 20
  $elasticsearch_shards = 4
  $elasticsearch_replicas = 0

  $elasticsearch_discovery_zen_ping_multicast_enabled = 'true'
  $elasticsearch_discovery_zen_ping_unicast_hosts = '127.0.0.1:9300'

  $mongodb_useauth = true
  $mongodb_user = 'graylog2'
  $mongodb_password = 'graylog2'
  $mongodb_host = '127.0.0.1'
  $mongodb_database = 'graylog2'
  $mongodb_port = 27017
  $mongodb_max_connections = 100
  $mongodb_threads_allowed_to_block_multiplier = 5
  $configure_mongodb = true

  case $::osfamily {
    'RedHat': {
      $java_package = 'java-1.7.0-openjdk'
    }
  }


  $web_interface_install_location = "${install_location}/web-interface"
  $web_interface_config_file = "${config_location}/graylog2-web-interface.conf"
  $web_interface_application_config_file = "${config_location}/graylog2-web-interface-application.conf"
  $web_interface_port = 9500
  $web_interface_address = '0.0.0.0'
  $web_interface_logfile = "${log_folder}/graylog2-web-interface.log"
  $web_interface_lockfile = "${run_folder}/graylog2-web-interface.lock"
}

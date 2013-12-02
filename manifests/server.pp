class graylog::server (
  $ensure = present,
  $password_secret,
  $root_password_sha2,
  $server_download_url = $graylog::params::server_download_url,
  $webinterface_download_url = $graylog::params::webinterface_download_url,

  $install_location = $graylog::params::install_location,
  $plugin_location = $graylog::params::plugin_location,
  $config_location = $graylog::params::config_location,
  $config_file = $graylog::params::config_file,

  $is_master = $graylog::params::is_master,

  $configure_elasticsearch = $graylog::params::configure_elasticsearch,
  $elasticsearch_max_docs_per_index = $graylog::params::elasticsearch_max_docs_per_index,
  $elasticsearch_index_prefix = $graylog::params::elasticsearch_index_prefix,
  $elasticsearch_max_number_of_indices = $graylog::params::elasticsearch_max_number_of_indices,
  $elasticsearch_shards = $graylog::params::elasticsearch_shards,
  $elasticsearch_replicas = $graylog::params::elasticsearch_replicas,

) inherits graylog::params {
  notice ('foo')
  if !defined(Class['concat::setup']) {
    include concat::setup
  }
  class { "graylog::install": } ->
  class { "graylog::web": }
}

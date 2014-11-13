class kibana (
  $download_url = "https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.tar.gz",
  $install_directory = "/usr/share/kibana",
){

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  # Get file name
  $filenameArray = split($download_url, '/')
  $basefilename = $filenameArray[-1]
  $basename = regsubst($basefilename, '^(.+)\.(zip|tgz|tar\.\w+)$', '\1')

  # Create install directory
  file { $install_directory:
    ensure => "directory"
  }->
  # Get kibana
  exec { "kibana_download":
    command => "curl -o $install_directory/kibana.tar.gz -L $download_url",
  }->
  # Untar kibana and copy to instalation path
  exec { "kibana_extract":
    command => "tar xf $install_directory/kibana.tar.gz -C $install_directory",
  }->
  #Remove temp files
  file {"remove_temp_files":
    ensure => absent,
    path => "$install_directory/kibana.tar.gz"
  }
  # Add alias to kibana on apache and restart on config change
  exec { "kibana_apache_signup":
    command => "echo 'alias /kibana /usr/share/kibana/$basename' > /etc/apache2/sites-enabled/kibana.conf",
    notify => Service["apache2"]
  }
}
class kibana (
  $downloadUrl = "https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.tar.gz",
){

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

# Get kibana
  exec { "kibana_download":
    command => "curl -O -L $downloadUrl",
  }->
# Untar kibana and copy to instalation path
  exec { "kibana_extract":
    command => "tar xf kibana-$version.tar.gz",
  }->
  exec { "kibana_move":
    command => "cp -R kibana-$version /usr/share/kibana",
  }->
# Add alias to kibana on apache
  exec { "kibana_apache_signup":
    command => "echo 'alias /kibana /usr/share/kibana' > /etc/apache2/sites-enabled/kibana.conf"
  }->
# Restart apache service
  exec { "kibana_apache_reload":
      command => "service apache2 reload"
  }
}
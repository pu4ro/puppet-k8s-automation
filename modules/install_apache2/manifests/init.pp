class install_apache2 {
  # Ensure Apache2 is installed and running
  package { 'apache2':
    ensure => installed,
  }

  service { 'apache2':
    ensure => running,
    enable => true,
    require => Package['apache2'],
  }
}

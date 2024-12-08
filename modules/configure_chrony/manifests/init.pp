class configure_chrony {
  # Deploy Chrony configuration
  file { '/etc/chrony/chrony.conf':
    ensure  => file,
    content => template('configure_chrony/chrony_client.erb'),
    require => Package['chrony'],
  }

  # Ensure Chrony is installed and running
  package { 'chrony':
    ensure => installed,
  }

  service { 'chronyd':
    ensure => running,
    enable => true,
    require => Package['chrony'],
  }
}

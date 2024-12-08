class configure_sysctl {
  file { '/etc/sysctl.d/k8s.conf':
    ensure  => file,
    content => template('configure_sysctl/k8s.erb'),
    notify  => Exec['reload_sysctl'],
  }

  exec { 'reload_sysctl':
    command     => '/sbin/sysctl --system',
    refreshonly => true,
  }
}

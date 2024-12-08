class install_containerd {
  # Install Containerd
  package { 'containerd.io':
    ensure => installed,
  }

  # Deploy NVIDIA runtime configuration (optional)
  file { '/etc/containerd/config.toml':
    ensure  => file,
    content => template('install_containerd/containerd_nvidia.erb'),
    require => Package['containerd.io'],
  }

  service { 'containerd':
    ensure => running,
    enable => true,
    require => Package['containerd.io'],
  }
}

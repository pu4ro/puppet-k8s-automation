class kubernetes::setup {
  # Ensure directory for manifests
  file { '/etc/kubernetes/manifests':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Deploy kubeadm-init.yaml
  file { '/root/kubeadm-init.yaml':
    ensure  => file,
    content => template('kubernetes/kubeadm-init.erb'),
  }

  # Deploy kube-vip.yaml
  file { '/etc/kubernetes/manifests/kube-vip.yaml':
    ensure  => file,
    content => template('kubernetes/kube-vip.erb'),
    require => File['/etc/kubernetes/manifests'],
  }

  include kubernetes::install
}

class kubernetes::install {
  # Initialize Kubernetes
  exec { 'kubeadm_init':
    command => '/usr/bin/kubeadm init --config=/root/kubeadm-init.yaml',
    unless  => 'test -f /etc/kubernetes/admin.conf',
    require => File['/root/kubeadm-init.yaml'],
  }

  # Copy kubeconfig
  exec { 'copy_kubeconfig':
    command => 'mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && chown $(id -u):$(id -g) $HOME/.kube/config',
    require => Exec['kubeadm_init'],
  }
}

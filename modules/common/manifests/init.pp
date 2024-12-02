class common {
  # 호스트 이름 설정
  exec { 'set_hostname':
    command => "hostnamectl set-hostname ${::hostname}",
    unless  => "hostnamectl status | grep 'Static hostname: ${::hostname}'",
    path    => ['/bin', '/usr/bin'],
  }

  # /etc/hosts 업데이트
  file_line { 'update_hosts_file':
    path  => '/etc/hosts',
    line  => "127.0.1.1 ${::hostname}",
    match => '^127\.0\.1\.1.*',
  }

  # SELinux 비활성화 (RedHat 계열)
  if $facts['os']['family'] == 'RedHat' {
    exec { 'disable_selinux':
      command => 'setenforce 0',
      path    => ['/bin', '/usr/bin'],
      onlyif  => 'getenforce | grep -i enforcing',
    }

    file { '/etc/selinux/config':
      ensure  => present,
      content => template('common/selinux_config.erb'),
      mode    => '0644',
      require => Exec['disable_selinux'],
    }
  }

  # Swap 비활성화
  exec { 'disable_swap':
    command => 'swapoff -a',
    path    => ['/bin', '/usr/bin'],
  }

  file_line { 'disable_swap_in_fstab':
    path  => '/etc/fstab',
    match => '.*swap.*',
    line  => '# Disabled by Puppet - Swap disabled',
    ensure => absent,
  }

  # Kernel 모듈 추가
  file { '/etc/modules-load.d/k8s.conf':
    ensure  => file,
    content => "br_netfilter\nip_vs\nip_vs_rr\nip_vs_wrr\nip_vs_sh\noverlay\nxt_REDIRECT\nxt_owner\nnf_nat\niptable_nat\niptable_mangle\niptable_filter\n",
    mode    => '0644',
  }

  exec { 'load_kernel_modules':
    command => '/sbin/modprobe br_netfilter ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh overlay xt_REDIRECT xt_owner nf_nat iptable_nat iptable_mangle iptable_filter',
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    refreshonly => true,
    subscribe => File['/etc/modules-load.d/k8s.conf'],
  }

  # /etc/hosts 파일 템플릿 적용
  file { '/etc/hosts':
    ensure  => file,
    content => template('common/hosts.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}

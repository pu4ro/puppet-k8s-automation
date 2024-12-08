# site.pp: Main manifest
node default {
  include common
  include kubernetes::setup
  include configure_chrony
  include configure_sysctl
  include install_containerd
  include install_apache2
}
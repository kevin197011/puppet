# Class: base::service
#
#
class base::service () inherits base::params {
  service { 'sshd':
    ensure => 'running',
    enable => true,
  }

  service { 'nginx':
    ensure => 'running',
    enable => 'true',
    # require => Package['nginx'],
  }
}

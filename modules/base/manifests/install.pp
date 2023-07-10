# Class: base::install
#
#
class base::install inherits base::params {
  package { 'vim':
    ensure => 'present',
  }

  package { 'nginx':
    ensure => 'present'
  }
}

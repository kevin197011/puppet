# Class: base::config
#
#
class base::config inherits base::params {
  file { '/tmp/base.txt':
    content => 'base test',
  }
}

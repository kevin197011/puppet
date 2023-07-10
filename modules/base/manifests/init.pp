# Class: base
#
#
class base inherits base::params {
  # resources
  contain base::install
  contain base::config
  contain base::service
}

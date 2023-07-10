# This file was automatically generated on 2023-07-10 12:31:48 +0800.
# Use the 'puppet generate types' command to regenerate this file.

# @summary
#   Manage MySQL plugins.
# 
# @example
#   mysql_plugin { 'some_plugin':
#     soname => 'some_pluginlib.so',
#   }
Puppet::Resource::ResourceType3.new(
  'mysql_plugin',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The name of the library
    # 
    # Values can match `/^\w+\.\w+$/`.
    Puppet::Resource::Param(Pattern[/^\w+\.\w+$/], 'soname')
  ],
  [
    # The name of the MySQL plugin to manage.
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `mysql_plugin`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mysql
    # : Manages MySQL plugins.
    # 
    #   * Required binaries: `mysql`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)

# This file was automatically generated on 2023-07-10 12:31:48 +0800.
# Use the 'puppet generate types' command to regenerate this file.

# @summary
#   Manage a MySQL database.
# 
# @api private
Puppet::Resource::ResourceType3.new(
  'mysql_database',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The CHARACTER SET setting for the database
    # 
    # Values can match `/^\S+$/`.
    Puppet::Resource::Param(Pattern[/^\S+$/], 'charset'),

    # The COLLATE setting for the database
    # 
    # Values can match `/^\S+$/`.
    Puppet::Resource::Param(Pattern[/^\S+$/], 'collate')
  ],
  [
    # The name of the MySQL database to manage.
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `mysql_database`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mysql
    # : Manages MySQL databases.
    # 
    #   * Required binaries: `mysql`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)

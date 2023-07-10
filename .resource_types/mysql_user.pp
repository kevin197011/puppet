# This file was automatically generated on 2023-07-10 12:31:48 +0800.
# Use the 'puppet generate types' command to regenerate this file.

# @summary
# Manage a MySQL user. This includes management of users password as well as privileges.
Puppet::Resource::ResourceType3.new(
  'mysql_user',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The password hash of the user. Use mysql::password() for creating such a hash.
    # 
    # Values can match `/\w*/`.
    Puppet::Resource::Param(Pattern[/\w*/], 'password_hash'),

    # The authentication plugin of the user.
    # 
    # Values can match `/\w+/`.
    Puppet::Resource::Param(Pattern[/\w+/], 'plugin'),

    # Max concurrent connections for the user. 0 means no (or global) limit.
    # 
    # Values can match `/\d+/`.
    Puppet::Resource::Param(Pattern[/\d+/], 'max_user_connections'),

    # Max connections per hour for the user. 0 means no (or global) limit.
    # 
    # Values can match `/\d+/`.
    Puppet::Resource::Param(Pattern[/\d+/], 'max_connections_per_hour'),

    # Max queries per hour for the user. 0 means no (or global) limit.
    # 
    # Values can match `/\d+/`.
    Puppet::Resource::Param(Pattern[/\d+/], 'max_queries_per_hour'),

    # Max updates per hour for the user. 0 means no (or global) limit.
    # 
    # Values can match `/\d+/`.
    Puppet::Resource::Param(Pattern[/\d+/], 'max_updates_per_hour'),

    # Options to that set the TLS-related REQUIRE attributes for the user.
    Puppet::Resource::Param(Any, 'tls_options')
  ],
  [
    # The name of the user. This uses the 'username@hostname' or username@hostname.
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `mysql_user`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mysql
    # : manage users for a mysql database.
    # 
    #   * Required binaries: `mysql`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)

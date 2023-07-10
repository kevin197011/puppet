# This file was automatically generated on 2023-07-10 12:31:48 +0800.
# Use the 'puppet generate types' command to regenerate this file.

# @summary
#   Manage a MySQL login path.
# @see
#   https://dev.mysql.com/doc/refman/8.0/en/mysql-config-editor.html
# @example
#   mysql_login_path { 'local_socket':
#     owner    => 'root',
#     host     => 'localhost',
#     user     => 'root',
#     password => Sensitive('secure'),
#     socket   => '/var/run/mysql/mysql.sock',
#     ensure   => present,
#   }
# 
#   mysql_login_path { 'local_tcp':
#     owner    => 'root',
#     host     => '127.0.0.1',
#     user     => 'root',
#     password => Sensitive('more_secure'),
#     port     => 3306,
#     ensure   => present,
#   }
# 
# This type provides Puppet with the capabilities to store authentication credentials in an obfuscated login path file
# named .mylogin.cnf created with the mysql_config_editor utility. Supports only MySQL Community Edition > v5.6.6.
Puppet::Resource::ResourceType3.new(
  'mysql_login_path',
  [
    # Whether this resource should be present or absent on the target system. (a Enum[present, absent])
    # 
    # Valid values are `absent`, `present`.
    Puppet::Resource::Param(Enum['absent', 'present'], 'ensure'),

    # Host name to be entered into the login path. (a Optional[String])
    # 
    # Values can match `//`.
    Puppet::Resource::Param(Pattern[//], 'host'),

    # Username to be entered into the login path. (a Optional[String])
    # 
    # Values can match `//`.
    Puppet::Resource::Param(Pattern[//], 'user'),

    # Password to be entered into login path (a Optional[Sensitive[String[1]]])
    Puppet::Resource::Param(Any, 'password'),

    # Socket path to be entered into login path (a Optional[String])
    # 
    # Values can match `//`.
    Puppet::Resource::Param(Pattern[//], 'socket'),

    # Port number to be entered into login path. (a Optional[Integer[0,65535]])
    # 
    # Values can match `/^-?\d+$/`.
    Puppet::Resource::Param(Pattern[/^-?\d+$/], 'port')
  ],
  [
    # Name of the login path you want to manage. (a String)
    # 
    # Values can match `//`.
    Puppet::Resource::Param(Pattern[//], 'name', true),

    # The user to whom the logon path should belong. (a String)
    # 
    # Values can match `//`.
    Puppet::Resource::Param(Pattern[//], 'owner', true)
  ],
  {
    /^(?<name>.*[^-])-(?<owner>.*)$/ => ['name', 'owner'],
    /^(?<name>.*)$/ => ['name']
  },
  true,
  false)

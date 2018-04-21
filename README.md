# adjoin_fx
The adjoin_fx cookbook provides you with resource to perform a join on a machine to a particular Active Directory
## Requirements
### Cookbooks
N/A

### Chef
* `>= 12.14`

### Platforms
* windows2008r2
* windows2012r2
* windows2016
* rhel7
* centos7
* ubuntu1604
* debian8
* debian9

## Resources
### adjoin_fx
The adjoin_fx resoource is a resource that allows you to join a machine to a domain.
You can use it on rhel or windows.

#### Properties

| Name | Type | Required | Default | Platform Family | Description |
| ---- | ---- | -------- | ------- | --------------- | ----------- |
| `username` | `String` | `true` | - | `All` | Username used to join the machine |
| `password` | `String` | `true` | - | `All` | Password used to join the machine |
| `domain` | `String ` | `true` | - | `All` | Domain to Join |
| `target_ou` | `String` | `false` | - | `All` | OU in which the Server Object will reside |
| `server` | `String` | `false` | - | `All` | FQDN of specific DC to used for joining |
| `membership_software` | `['samba', 'adcli']` | `false` | - | `['rhel', 'debian']` | Membership software to use |
| `os_name` | `String` | `false` | - | `['rhel']` | String that will fill the os name attribute in the AD |
| `os_version` | `String` | `false` | - | `['rhel']` | String that will fill the os version attribute in the AD |
| `one_time_password` | `String` | `false` | - | `['rhel', 'debian']` | One time password to join the domain |
| `client_software` | `['sssd', 'winbind']` | `false` | - | `['rhel', 'debian']` | Client software to use |
| `server_software` | `['active-directory', 'ipa']` | `false` | - | `['rhel', 'debian']` | Type of AD you're joining |
| `no_password` | `[true, false]` | `false` | `false` | `['rhel', 'debian']` | Do not specify a password for joining |
| `handle_reboot` | `[true, false]` | `false` | `true` | `windows` | Reboots the server after joining the machine, be aware that it won't handle launching chef after the reboot you will have to handle that yourself |
| `new_name` | `String` | `false` | - | `windows` | New server name |
| `pass_thru` | `[true, false]` | `false` | `false` | `windows` | Adds Pass-Thru option to joining command |

##### Notes

* On windows2008, the domain name should be resolvable on the network, altough people are used to this, it shouldn't be needed, as it is not on newer versions.

### adjoin_fx_configure
The adjoin_fx_configure resource allows you to configure a linux machine that has
been joined to the domain using realmd.

#### Properties

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `domain` | `String` | `true` | - | Domain on which to apply the configuration |
| `login_groups` | `Array` | `false` | - | Array of String, each string represents an AD groups that will be allowed to login |
| `login_users` | `Array` | `false` | - | Array of String, each string represents an AD user (without the domain) that will be allowed to login |
| `deny_all` | `[true, false]` | `false` | - | Specifies if you want to run a deny all, if login groups or users have been specified, this command will be executed before the others. This will help you make sure only the specified groups are allowed to login |

## Versionning
This cookbook will follow semantic versionning 2.0.0 as described [here](https://semver.org/)

## Lisence
MIT

## Contributing
Put link vers contributing here

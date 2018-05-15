# consul_fx
This cookbook provides a resource that allows you to install consul.

## Requirements
### Chef
`>= 12.14`

### Cookbooks
* `unzip_fx`

### Platforms
* ubuntu1604
* centos6
* centos7
* redhat6
* redhat7
* debian8
* debian9

## Resources
### consul_fx
The consul_fx resource allows you to install and configure consul.

#### Properties

| Name | Type | Required | Default | Platform Familly or OS | Description |
| ---- | ---- | -------- | ------- | ---------------------- | ----------- |
| `url` | `String` | `false` | - | `All` | URL of the consul zip (if not set, will fetch from hashicorp) |
| `checksum` | `String` | `false` | - | `All` | Checksum of the consul version |
| `version` | `String` | `false` | `0.7.5` | `All` | Version of consul |
| `user` | `String` | `false` | `consul` | `All` | User that will run consul |
| `group` | `String` | `false` | `consul` | `All` | Group in which consul will be |
| `shell` | `String` | `false` | `/sbin/nologin` | `Linux` | Shell for the consul user |
| `service_name` | `String` | `false` | `consul` | `All` | Name of the consul service |
| `install_directory` | `String` | `false` | `/opt/consul` | `All` | Directory where consul will be installed |
| `data_directory` | `String` | `false` | `/var/lib/consul` | `All` | Directory where consul will save its data |
| `cache_dir` | `String` | `false` | `Chef::Config['file_cache_path']` | `All` | Directory where consul will save it's temporary files |
| `configuration` | `Hash` | `true` | - | `All` | Hash representing consul's configuration. |

## Versionning
This cookbook will follow semantic versionning 2.0.0 as described [here](https://semver.org/)

## Lisence
MIT

## Contributing
Put link vers contributing here


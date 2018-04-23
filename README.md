# vault_fx
This cookbook provides a resource that allows you to install vault.

## Requirements
### Chef
`>= 12.14`

### Cookbooks
* `unzip_fx`

### Platforms
* ubuntu1604
* centos7
* redhat7
* debian8
* debian9

## Resources
### vault_fx
The vault_fx resource allows you to install and configure vault.

#### Properties

| Name | Type | Required | Default | Platform Familly or OS | Description |
| ---- | ---- | -------- | ------- | ---------------------- | ----------- |
| `url` | `String` | `false` | - | `All` | URL of the vault zip (if not set, will fetch from hashicorp) |
| `checksum` | `String` | `false` | - | `All` | Checksum of the vault version |
| `version` | `String` | `false` | `0.7.5` | `All` | Version of vault |
| `user` | `String` | `false` | `vault` | `All` | User that will run vault |
| `group` | `String` | `false` | `vault` | `All` | Group in which vault will be |
| `service_name` | `String` | `false` | `vault` | `All` | Name of the vault service |
| `install_directory` | `String` | `false` | `/opt/vault` | `All` | Directory where vault will be installed |
| `data_directory` | `String` | `false` | `/var/lib/vault` | `All` | Directory where vault will save its data |
| `cache_dir` | `String` | `false` | `Chef::Config['file_cache_path']` | `All` | Directory where vault will save it's temporary files |
| `configuration` | `Hash` | `true` | - | `All` | Hash representing vault's configuration. |
| `log_level` | `String` | `false` | - | `All` | Log level for vault |

## Versionning
This cookbook will follow semantic versionning 2.0.0 as described [here](https://semver.org/)

## Lisence
MIT

## Contributing
Put link vers contributing here

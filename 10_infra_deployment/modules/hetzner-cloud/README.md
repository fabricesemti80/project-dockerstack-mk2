<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | ~> 1.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | ~> 1.45 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_firewall.server_fw](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |
| [hcloud_server.server](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_snapshot.fresh_install_snapshot](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/snapshot) | resource |
| [hcloud_ssh_key.server_ssh_key](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_ipv4"></a> [enable\_ipv4](#input\_enable\_ipv4) | Enable IPv4 | `bool` | n/a | yes |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enable IPv6 | `bool` | n/a | yes |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the firewall | `string` | n/a | yes |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of firewall rules | <pre>list(object({<br/>    direction  = string<br/>    protocol   = string<br/>    port       = string<br/>    source_ips = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Server location (e.g., hel1) | `string` | n/a | yes |
| <a name="input_server_image"></a> [server\_image](#input\_server\_image) | Server image (e.g., ubuntu-22.04) | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Name of the server | `string` | n/a | yes |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | Server type (e.g., cx23) | `string` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | Name of the SSH key | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Public SSH key content | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data script for server initialization.<br/><br/>Example usage:<br/>user\_data = <<EOF<br/>#cloud-config<br/>runcmd:<br/>  - echo "Simple Hetzner initialization script"<br/>  - apt-get update<br/>  - echo "Hetzner initialization complete"<br/>EOF | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_ipv4_address"></a> [server\_ipv4\_address](#output\_server\_ipv4\_address) | The public IPv4 address of the server. |
| <a name="output_server_ipv6_address"></a> [server\_ipv6\_address](#output\_server\_ipv6\_address) | The public IPv6 address of the server. |
| <a name="output_server_name"></a> [server\_name](#output\_server\_name) | The name of the server. |
| <a name="output_snapshot_id"></a> [snapshot\_id](#output\_snapshot\_id) | The ID of the snapshot created from the server |
<!-- END_TF_DOCS -->
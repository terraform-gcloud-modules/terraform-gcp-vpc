## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_create\_subnetworks | (Optional) When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the '10.128.0.0/9' address range. When set to 'false', the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. Default is 'false'. | `bool` | `false` | no |
| delete\_default\_routes\_on\_create | (Optional) If set to true, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted. | `bool` | `false` | no |
| description | (Optional) An optional description of the VPC. The resource must be recreated to modify this field.Default is ''. | `string` | `""` | no |
| enable\_endpoint\_independent\_mapping | Enable endpoint-independent mapping on the NAT. Recommended false unless required for specific application compatibility. | `bool` | `null` | no |
| enable\_nat | Enable or disable Cloud NAT for the VPC. Set to true to create NAT resources. | `bool` | `false` | no |
| enable\_private\_ip\_alloc | Enable allocation of a private IP address range for VPC peering. | `bool` | `false` | no |
| enable\_service\_networking | Whether to enable service networking | `bool` | `false` | no |
| enable\_static\_route | Set to true to create one or more static routes. | `bool` | `false` | no |
| enable\_ula\_internal\_ipv6 | (Optional) Enable ULA internal ipv6 on this network. Enabling this feature will assign a /48 from google defined ULA prefix fd20::/20. | `bool` | `false` | no |
| environment | Environment name | `string` | `"dev"` | no |
| google\_compute\_network\_enabled | Specifies whether the Google Compute Engine network should be enabled | `bool` | `true` | no |
| google\_compute\_shared\_vpc\_host\_enabled | Set to false to disable the creation of Google Compute Engine shared VPC host project. | `bool` | `true` | no |
| host\_project\_id | Google Cloud Project ID | `string` | `""` | no |
| icmp\_idle\_timeout\_sec | Timeout (seconds) for ICMP connections through NAT. Default GCP value is 30. | `number` | `null` | no |
| internal\_ipv6\_range | (Optional) When enabling ula internal ipv6, caller optionally can specify the /48 range they want from the google defined ULA prefix fd20::/20. The input must be a valid /48 ULA IPv6 address and must be within the fd20::/20. Operation will fail if the speficied /48 is already in used by another resource. If the field is not speficied, then a /48 range will be randomly allocated from fd20::/20 and returned via this field. | `string` | `null` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| max\_ports\_per\_vm | Maximum number of NAT ports allocated per VM. null means no limit (dynamic port allocation). | `number` | `null` | no |
| min\_ports\_per\_vm | Minimum number of NAT ports allocated per VM. This defines how many simultaneous outbound connections a VM can make through NAT. | `number` | `64` | no |
| module\_depends\_on | (Optional) A list of external resources the module depends\_on. Default is '[]'. | `any` | `[]` | no |
| module\_enabled | (Optional) Whether to create resources within the module or not. Default is 'true'. | `bool` | `true` | no |
| mtu | (Optional) Maximum Transmission Unit in bytes. The minimum value for this field is 1460 and the maximum value is 1500 bytes. Default is '1460'. | `string` | `1460` | no |
| name | (Optional) The name of the VPC. The name will be used to prefix all associacted resources also. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression "[a-z]([-a-z0-9]\*[a-z0-9])?" which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. Default is "main". | `string` | `""` | no |
| nat\_ip\_allocate\_option | Specifies how NAT IPs are allocated. Options: 'AUTO\_ONLY' for automatic IP allocation, 'MANUAL\_ONLY' for manually specified IPs. | `string` | `"AUTO_ONLY"` | no |
| nat\_log\_enable | Enable or disable logging for Cloud NAT. Set to true to log NAT activity. | `bool` | `false` | no |
| nat\_log\_filter | Filter for NAT logs. Options: 'ALL', 'ERRORS\_ONLY', 'TRANSLATIONS\_ONLY'. | `string` | `"ALL"` | no |
| nat\_network\_tier | Network tier for NAT external IPs. PREMIUM for global routing (recommended). STANDARD for regional. | `string` | `"PREMIUM"` | no |
| nat\_subnetworks | Explicit subnet list for NAT. Used only when source\_subnetwork\_ip\_ranges\_to\_nat = LIST\_OF\_SUBNETWORKS. Each object: { name, source\_ip\_ranges\_to\_nat }. | `any` | `[]` | no |
| prefix\_length | List of prefix lengths for the private IP allocations | `list(number)` | `[]` | no |
| private\_ip\_alloc\_name | List of names for the private IP allocations | `list(string)` | `[]` | no |
| project\_id | (Optional) The ID of the project in which the resource belongs. If it is not set, the provider project is used. | `string` | `"clouddrove-123"` | no |
| region | The region in which the Cloud NAT and Cloud Router will be deployed. | `string` | `"us-central1"` | no |
| routing\_mode | (Optional) The network-wide routing mode to use. If set to 'REGIONAL', this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router. If set to 'GLOBAL', this network's cloud routers will advertise routes with all subnetworks of this network, across regions. Possible values are 'REGIONAL' and 'GLOBAL'. Default is 'REGIONAL'. | `string` | `"REGIONAL"` | no |
| service\_project\_id | Project ID of the service project | `string` | `""` | no |
| source\_subnetwork\_ip\_ranges\_to\_nat | Determines which IP ranges in the subnetworks should use NAT. Options include 'ALL\_SUBNETWORKS\_ALL\_IP\_RANGES' or a list of specific subnetwork IP ranges. | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| static\_routes | List of static route objects. Each supports:<br>  name                (required) - Unique route name<br>  dest\_range          (required) - Destination CIDR (e.g. "0.0.0.0/0")<br>  description         (optional)<br>  priority            (optional, default 1000)<br>  tags                (optional) list of network tags to apply route to<br>  next\_hop\_gateway    (optional) - e.g. "default-internet-gateway"<br>  next\_hop\_ip         (optional) - IP of next hop<br>  next\_hop\_instance   (optional) - Self link of next hop instance<br>  next\_hop\_vpn\_tunnel (optional) - Self link of VPN tunnel<br>  next\_hop\_ilb        (optional) - IP or self link of internal LB<br>Only ONE next\_hop\_\* should be set per route. | `any` | `[]` | no |
| tcp\_established\_idle\_timeout\_sec | Timeout (seconds) for established TCP connections through NAT. Default GCP value is 1200. | `number` | `null` | no |
| tcp\_transitory\_idle\_timeout\_sec | Timeout (seconds) for transitory TCP connections through NAT. Default GCP value is 30. | `number` | `null` | no |
| udp\_idle\_timeout\_sec | Timeout (seconds) for UDP connections through NAT. Default GCP value is 30. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| host\_project\_id | The ID of the Google Cloud project acting as the host project for the Shared VPC. |
| labels\_id | The full label ID generated by the labels module. Used as the base name for all resources. |
| nat\_id | The ID of the Cloud NAT gateway. |
| nat\_name | The name of the Cloud NAT gateway. |
| nat\_region | The region the Cloud NAT gateway is deployed in. |
| nat\_router | The Cloud Router name this NAT gateway is attached to. |
| nat\_router\_id | The ID of the Cloud Router. |
| nat\_router\_name | The name of the Cloud Router. |
| nat\_router\_self\_link | The self\_link of the Cloud Router. Can be referenced by other router resources. |
| private\_ip\_alloc\_addresses | List of reserved private IP addresses. |
| private\_ip\_alloc\_ids | List of private IP allocation resource IDs. |
| private\_ip\_alloc\_names | List of private IP allocation names. |
| private\_ip\_alloc\_self\_links | List of private IP allocation self\_links. |
| service\_networking\_connection\_id | The ID of the private service networking connection. |
| service\_networking\_peering\_ranges | Reserved peering ranges used by the service networking connection. |
| service\_project\_id | The ID of the Google Cloud project acting as the service project for the Shared VPC. |
| static\_route\_ids | List of static route IDs. |
| static\_route\_names | List of static route names. |
| static\_route\_self\_links | List of static route self\_links. |
| vpc\_gateway\_ipv4 | The default IPv4 gateway address of the network. |
| vpc\_id | The unique identifier of the VPC network. |
| vpc\_mtu | The MTU configured on the VPC. |
| vpc\_name | The name of the VPC network. |
| vpc\_routing\_mode | The routing mode of the VPC (REGIONAL or GLOBAL). |
| vpc\_self\_link | The URI (self\_link) of the VPC network. Pass this to subnet/firewall modules. |


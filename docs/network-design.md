# Network Design

## VPC
| Property | Value |
|---|---|
| Name | pacs-ha-vpc |
| ID | vpc-0aad3685fa17b8215 |
| CIDR | 10.0.0.0/16 |
| Region | us-east-1 |
| DNS Resolution | Enabled |
| DNS Hostnames | Enabled |

**Design decision:** /16 block chosen to allow future subnet expansion
across additional AZs without re-addressing. Provides 65,531 usable IPs.

---

## Subnets

| Name | Subnet ID | CIDR | AZ | Role |
|---|---|---|---|---|
| public-az-a | subnet-00518f1bf55a5795c | 10.0.10.0/24 | us-east-1a | ALB / IGW ingress |
| private-az-a | subnet-0fe7e46fb77a70663 | 10.0.20.0/24 | us-east-1a | PACS primary nodes |
| public-az-b | subnet-0ac11f1568f51d8ad | 10.0.30.0/24 | us-east-1b | ALB / IGW standby |
| private-az-b | subnet-07e6a3571d622b604 | 10.0.40.0/24 | us-east-1b | PACS standby nodes |

**Design decision:** /24 blocks give 251 usable IPs per subnet (256 minus
5 AWS reserved: network address, VPC router, DNS resolver, future use,
broadcast). Spaced at .10, .20, .30, .40 to leave room for additional
tiers without overlap.

---

## Internet Gateway
| Property | Value |
|---|---|
| Name | pacs-igw |
| ID | igw-07de71d45bf9aa47b |
| Attached VPC | pacs-ha-vpc |

---

## Route Tables

### pacs-rt-public (rtb-0c9e7aef3b9e8e9dd)
| Destination | Target | Purpose |
|---|---|---|
| 10.0.0.0/16 | local | VPC-internal traffic |
| 0.0.0.0/0 | igw-07de71d45bf9aa47b | Internet access for ALB |

Associated subnets: `public-az-a`, `public-az-b`

### pacs-rt-private (rtb-00e24f362a8be4b0a)
| Destination | Target | Purpose |
|---|---|---|
| 10.0.0.0/16 | local | VPC-internal only |
| 0.0.0.0/0 | pacs-nat-az-a | Outbound via NAT (deploy when needed) |

Associated subnets: `private-az-a`, `private-az-b`

**Design decision:** Private subnets have no direct internet route.
NAT Gateway deferred to avoid $32/month idle cost during development.

---

## NAT Gateway
Documented but not deployed. Will be created in `public-az-a` with
an Elastic IP when EC2 instances are active for live demo.

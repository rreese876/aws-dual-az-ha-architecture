# Architecture Decision Records

## ADR-001: /16 VPC CIDR
**Decision:** Use 10.0.0.0/16 for the VPC
**Reason:** Provides 65,531 usable IPs with room to add AZs, DB subnet 
tiers, and management subnets without re-addressing.
**Alternative considered:** /24 VPC — rejected, too small for multi-tier growth.

## ADR-002: Separate public/private route tables
**Decision:** Two route tables instead of using the main RT for everything
**Reason:** Private subnets must never have a direct internet route. 
Explicit association prevents accidental IGW exposure of PACS nodes.
**Alternative considered:** Single RT with conditional routes — rejected, 
too easy to misconfigure.

## ADR-003: NAT Gateway deferred
**Decision:** NAT Gateway documented but not deployed
**Reason:** $32/month baseline cost. Private EC2s need outbound access 
only during active sessions. Will deploy on-demand for live demos.
**Alternative considered:** Always-on NAT — rejected for cost during 
development phase.

## ADR-004: /24 subnet sizing
**Decision:** Each subnet is a /24 (251 usable IPs)
**Reason:** AWS reserves 5 IPs per subnet (network address, VPC router, 
DNS resolver, future use, broadcast). /24 gives comfortable room for 
all PACS node types per AZ.

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

## ADR-005: Direct Connect for on-prem hospital connectivity
**Decision:** Use AWS Direct Connect with VPN failover
**Reason:** Three on-prem use cases require dedicated connectivity:
  1. CT/MRI modalities sending DICOM over :104 — need consistent low latency
  2. Epic/Cerner HL7 feeds to cloud EIS — need reliable bandwidth
  3. Radiologist workstations retrieving images — latency-sensitive
**Alternative considered:** VPN only — rejected, insufficient bandwidth 
and latency guarantees for DICOM image transfer at scale.
**Failover:** Site-to-Site VPN configured as backup if Direct Connect fails.

## ADR-006: Colocation rack at Rackspace for Direct Connect termination
**Decision:** Physical network hardware hosted in Rackspace colo rack
**Reason:** AWS Direct Connect requires a physical cross connect between 
the customer router and the AWS DX router cage inside an 
AWS Direct Connect location. Rackspace provides the facility, 
rack space, and cross connect provisioning.

**Hardware in rack:**
- Customer edge router (BGP ASN 65000)
- Firewall/security appliance
- Layer 2 aggregation switch
- Cross connect to AWS DX router cage

**Two VIFs provisioned:**
- Private VIF (VLAN 100) → VGW → pacs-ha-vpc 
  (carries DICOM :104, HL7 :2575, viewer :443)
- Public VIF (VLAN 200) → S3 
  (DICOM archive writes never traverse public internet — HIPAA aligned)

**VPN failover:** Site-to-Site VPN configured as backup path 
if Direct Connect or colo hardware fails.

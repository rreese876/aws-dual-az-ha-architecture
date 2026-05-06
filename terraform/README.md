# Terraform Modules

IaC for this architecture. Modules planned:
- `vpc.tf` — VPC, subnets, IGW
- `route_tables.tf` — public/private RTs
- `security_groups.tf` — ALB, nodes, metadata sync SGs
- `ec2.tf` — PACS node instances
- `alb.tf` — Application Load Balancer
- `route53.tf` — Failover routing + health checks
- `s3.tf` — Archive bucket + lifecycle policy
- `iam.tf` — Instance roles and policies

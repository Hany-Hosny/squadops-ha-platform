# SquadOps HA Platform

Highly Available Production 3-Tier Web Architecture on AWS using Terraform (Multi-AZ, ASG, RDS Proxy, WAF, S3 & CloudWatch).

---

## Architecture Modules

* **Networking (`terraform/networking`):** Multi-AZ VPC, Public/Private Subnets, Internet Gateway, Redundant NAT Gateways, and Route Tables.
  * [Packet Tracer Network Design](docs/networking/packet-tracer-network-design.md)
* **Compute (`terraform/compute`):** Private EC2 Instances via Launch Templates, Nginx Web Tier, Application Load Balancer (ALB), and Auto Scaling Group (ASG).
* **Database & Storage (`terraform/database`):** Amazon RDS PostgreSQL (Multi-AZ Failover), RDS Proxy Connection Pooling, and Private S3 Bucket.
* **Security & Observability (`terraform/observability`):** AWS WAFv2 Web ACLs, CloudWatch Metrics/Logs/Alarms, SNS Notifications, and Route 53 DNS.

---

## Project Structure

```text
squadops-ha-platform/
├── docs/
│   └── networking/
├── terraform/
│   ├── networking/
│   ├── compute/
│   ├── database/
│   └── observability/
└── README.md

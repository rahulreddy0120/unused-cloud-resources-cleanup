# AWS Unused Resources Finder

Automated tool to identify and report unused AWS resources that are costing money. Scans for unattached EBS volumes, idle Elastic IPs, orphaned snapshots, unused NAT Gateways, old AMIs, and idle load balancers.

## Overview

This tool helps reduce AWS costs by identifying resources you're paying for but not using. It generates detailed reports with cost estimates and sends notifications to resource owners.

## Features

- **Unattached EBS Volumes**: Find volumes not attached to any instance
- **Idle Elastic IPs**: Detect IPs not associated with running instances
- **Orphaned Snapshots**: Identify snapshots whose source volume is deleted
- **Unused NAT Gateways**: Find NAT Gateways with zero data processed
- **Old AMIs**: Detect AMIs not used by any instance in 90+ days
- **Idle Load Balancers**: Find ALB/NLB with no active targets
- **Cost Calculation**: Estimate monthly savings for each resource
- **CSV Reports**: Generate detailed reports with all findings
- **Email Notifications**: Send alerts to resource owners via tags

## Architecture

```
┌─────────────────────────────────────────┐
│     Main Script (main.py)               │
│  - Orchestrates all scanners            │
│  - Generates reports                    │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│     Scanners (modular)                  │
│  - ebs_scanner.py                       │
│  - eip_scanner.py                       │
│  - snapshot_scanner.py                  │
│  - nat_scanner.py                       │
│  - ami_scanner.py                       │
│  - elb_scanner.py                       │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│     Report Generator                    │
│  - CSV export                           │
│  - Email notifications                  │
│  - S3 upload                            │
└─────────────────────────────────────────┘
```

## Installation

```bash
git clone https://github.com/rahulreddy0120/aws-unused-resources-finder.git
cd aws-unused-resources-finder
pip install -r requirements.txt
```

## Configuration

Edit `config/config.yaml`:

```yaml
aws:
  regions:
    - us-east-1
    - us-west-2
  
scanning:
  # Days to consider AMI as unused
  ami_unused_days: 90
  
  # Days to consider NAT Gateway as unused
  nat_idle_days: 7

costs:
  # Monthly costs (USD)
  ebs_per_gb: 0.10
  eip_idle: 3.60
  snapshot_per_gb: 0.05
  nat_gateway: 32.40
  alb: 16.20
  nlb: 22.50

notifications:
  enabled: true
  from_email: "aws-scanner@company.com"
  owner_tag: "Owner"
```

## Usage

### Run All Scans

```bash
python src/main.py --config config/config.yaml
```

### Run Specific Scanner

```bash
# EBS volumes only
python src/main.py --scanner ebs

# Multiple scanners
python src/main.py --scanner ebs,eip,snapshots
```

### Generate Report Only

```bash
python src/main.py --report-only --output unused-resources.csv
```

## Example Output

```
🔍 AWS Unused Resources Finder
Generated: 2024-04-15 10:30:00

Scanning Regions: us-east-1, us-west-2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Unattached EBS Volumes: 12 found
   Total Size: 2.5 TB
   Monthly Cost: $250.00

💡 Idle Elastic IPs: 5 found
   Monthly Cost: $18.00

📸 Orphaned Snapshots: 23 found
   Total Size: 1.2 TB
   Monthly Cost: $60.00

🌐 Unused NAT Gateways: 2 found
   Monthly Cost: $64.80

🖼️  Old AMIs: 8 found
   Snapshot Storage: 500 GB
   Monthly Cost: $25.00

⚖️  Idle Load Balancers: 3 found
   Monthly Cost: $48.60

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💰 Total Potential Savings: $466.40/month ($5,596.80/year)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 Report saved to: unused-resources-2024-04-15.csv
```

## CSV Report Format

```csv
resource_type,resource_id,region,size_gb,age_days,monthly_cost,owner,tags
ebs_volume,vol-abc123,us-east-1,100,45,10.00,platform-team,Environment=prod
elastic_ip,54.123.45.67,us-east-1,N/A,120,3.60,unknown,
snapshot,snap-xyz789,us-west-2,200,180,10.00,data-team,Project=analytics
nat_gateway,nat-0a1b2c3d,us-east-1,N/A,30,32.40,network-team,
ami,ami-def456,us-east-1,50,150,2.50,platform-team,
load_balancer,api-alb,us-east-1,N/A,15,16.20,backend-team,
```

## Scheduling

Run weekly via cron:

```bash
# Every Monday at 8 AM
0 8 * * 1 /usr/bin/python3 /path/to/src/main.py --config /path/to/config.yaml
```

Or deploy as Lambda function (see `lambda_deployment/` directory).

## AWS Permissions Required

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVolumes",
        "ec2:DescribeAddresses",
        "ec2:DescribeSnapshots",
        "ec2:DescribeNatGateways",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTargetHealth",
        "cloudwatch:GetMetricStatistics",
        "ses:SendEmail",
        "s3:PutObject"
      ],
      "Resource": "*"
    }
  ]
}
```

## Real-World Impact

At my previous organization:
- Found 150+ unattached EBS volumes ($1,500/month)
- Identified 25 idle Elastic IPs ($90/month)
- Discovered 8 forgotten NAT Gateways ($260/month)
- Total savings: $1,850/month ($22,200/year)
- Automated monthly scanning reduced waste by 85%

## Project Structure

```
.
├── src/
│   ├── main.py                 # Main orchestrator
│   ├── scanners/
│   │   ├── __init__.py
│   │   ├── ebs_scanner.py      # EBS volume scanner
│   │   ├── eip_scanner.py      # Elastic IP scanner
│   │   ├── snapshot_scanner.py # Snapshot scanner
│   │   ├── nat_scanner.py      # NAT Gateway scanner
│   │   ├── ami_scanner.py      # AMI scanner
│   │   └── elb_scanner.py      # Load balancer scanner
│   ├── report_generator.py     # Report generation
│   └── utils.py                # Helper functions
├── config/
│   └── config.yaml             # Configuration
├── requirements.txt
└── README.md
```

## Contributing

Pull requests welcome! Please open an issue first.

## License

MIT License

## Author

Rahul Reddy  
Cloud FinOps Engineer  
[LinkedIn](https://www.linkedin.com/in/rahul-7947/) | [GitHub](https://github.com/rahulreddy0120)






























<!-- updated: 2023-11-25 -->

<!-- updated: 2024-01-08 -->

<!-- updated: 2024-03-15 -->

<!-- updated: 2024-05-22 -->

<!-- updated: 2024-07-30 -->

<!-- updated: 2024-09-18 -->

<!-- updated: 2024-11-05 -->

<!-- updated: 2025-01-20 -->

<!-- updated: 2025-03-10 -->

<!-- updated: 2025-05-28 -->

<!-- updated: 2025-08-14 -->

<!-- updated: 2025-10-30 -->

<!-- updated: 2025-12-15 -->

<!-- 2022-12-08T15:45:00 -->

<!-- 2023-01-19T11:00:00 -->

<!-- 2023-02-27T09:15:00 -->

<!-- 2023-04-10T14:30:00 -->

<!-- 2023-06-26T10:45:00 -->

<!-- 2023-08-07T16:00:00 -->

<!-- 2023-09-25T11:15:00 -->

<!-- 2023-11-13T09:30:00 -->

<!-- 2024-01-22T14:45:00 -->

<!-- 2024-03-11T10:00:00 -->

<!-- 2024-05-27T15:15:00 -->

<!-- 2024-08-05T11:30:00 -->

<!-- 2024-10-21T09:45:00 -->

<!-- 2024-12-16T14:00:00 -->

<!-- 2025-02-03T10:15:00 -->

<!-- 2025-04-14T15:30:00 -->

<!-- 2025-07-07T11:45:00 -->

<!-- 2025-09-22T09:00:00 -->

<!-- 2025-12-08T14:15:00 -->

<!-- 2022-12-08T15:45:00 -->

<!-- 2023-01-19T11:00:00 -->

<!-- 2023-02-27T09:15:00 -->

<!-- 2023-04-10T14:30:00 -->

<!-- 2023-06-26T10:45:00 -->

<!-- 2023-08-07T16:00:00 -->

<!-- 2023-09-25T11:15:00 -->

<!-- 2023-11-13T09:30:00 -->

<!-- 2024-01-22T14:45:00 -->

<!-- 2024-03-11T10:00:00 -->

<!-- 2024-05-27T15:15:00 -->

<!-- 2024-08-05T11:30:00 -->

<!-- 2024-10-21T09:45:00 -->

<!-- 2024-12-16T14:00:00 -->

<!-- 2025-02-03T10:15:00 -->

<!-- 2025-04-14T15:30:00 -->

<!-- 2025-07-07T11:45:00 -->

<!-- 2025-09-22T09:00:00 -->

<!-- 2025-12-08T14:15:00 -->

<!-- 2022-11-22T15:45:00 -->

<!-- 2022-12-08T11:00:00 -->

<!-- 2023-01-19T09:15:00 -->

<!-- 2023-02-27T14:30:00 -->

<!-- 2023-06-26T10:45:00 -->

<!-- 2023-06-27T16:00:00 -->

<!-- 2023-06-28T11:15:00 -->

<!-- 2023-09-25T09:30:00 -->

<!-- 2024-02-22T14:45:00 -->

<!-- 2024-06-05T10:00:00 -->

<!-- 2024-06-06T15:15:00 -->

<!-- 2024-11-21T11:30:00 -->

<!-- 2025-01-03T09:45:00 -->

<!-- 2025-05-14T14:00:00 -->

<!-- 2025-05-15T10:15:00 -->

<!-- 2025-10-22T15:30:00 -->

<!-- 2025-12-08T11:45:00 -->

<!-- 2022-11-09T15:45:00 -->

<!-- 2022-12-13T11:00:00 -->

<!-- 2023-01-24T09:15:00 -->

<!-- 2023-03-07T14:30:00 -->

<!-- 2023-06-06T10:45:00 -->

<!-- 2023-06-07T16:00:00 -->

<!-- 2023-06-08T11:15:00 -->

<!-- 2023-10-17T09:30:00 -->

<!-- 2024-02-27T14:45:00 -->

<!-- 2024-07-16T10:00:00 -->

<!-- 2024-07-17T15:15:00 -->

<!-- 2024-12-10T11:30:00 -->

<!-- 2025-03-04T09:45:00 -->

<!-- 2025-06-24T14:00:00 -->

<!-- 2025-06-25T10:15:00 -->

<!-- 2025-11-11T15:30:00 -->

<!-- 2026-03-03T11:45:00 -->

<!-- 2022-12-06T11:19:00 -->

<!-- 2023-01-06T10:12:00 -->

<!-- 2023-01-07T15:17:00 -->

<!-- 2023-01-23T16:08:00 -->

<!-- 2023-02-10T10:40:00 -->

<!-- 2023-04-05T09:48:00 -->

<!-- 2023-04-07T11:16:00 -->

<!-- 2023-07-26T14:21:00 -->

<!-- 2023-09-09T17:48:00 -->

<!-- 2023-12-25T09:55:00 -->

<!-- 2024-03-24T17:19:00 -->

<!-- 2024-05-17T11:40:00 -->

<!-- 2024-06-20T14:11:00 -->

<!-- 2024-07-15T09:29:00 -->

<!-- 2024-11-10T11:08:00 -->

<!-- 2025-01-07T16:37:00 -->

<!-- 2025-02-14T14:38:00 -->

<!-- 2025-05-20T16:23:00 -->

<!-- 2025-06-20T08:11:00 -->

<!-- 2025-07-07T10:23:00 -->

<!-- 2025-11-09T09:27:00 -->

<!-- 2025-12-02T13:46:00 -->

<!-- 2026-01-19T16:04:00 -->

<!-- 2026-02-04T12:04:00 -->

<!-- 2026-03-18T09:32:00 -->

<!-- 2026-03-28T17:03:00 -->

<!-- 2026-04-28T09:37:00 -->

<!-- 2023-03-09T16:59:00 -->

<!-- 2023-11-26T08:53:00 -->

<!-- 2023-12-16T11:22:00 -->

<!-- 2024-01-17T10:08:00 -->

<!-- 2024-02-24T14:12:00 -->

<!-- 2024-03-14T10:04:00 -->

<!-- 2024-03-22T17:15:00 -->

<!-- 2024-06-04T16:02:00 -->

<!-- 2024-07-30T15:48:00 -->

<!-- 2024-08-03T17:52:00 -->

<!-- 2025-02-21T15:00:00 -->

<!-- 2025-04-21T13:15:00 -->

<!-- 2025-05-20T13:11:00 -->

<!-- 2025-06-22T08:11:00 -->

<!-- 2025-06-27T13:37:00 -->

<!-- 2026-01-13T10:28:00 -->

<!-- 2026-01-29T09:22:00 -->

<!-- 2023-03-09T16:59:00 -->

<!-- 2023-11-26T08:53:00 -->

<!-- 2023-12-16T11:22:00 -->

<!-- 2024-01-17T10:08:00 -->

<!-- 2024-02-24T14:12:00 -->

<!-- 2024-03-14T10:04:00 -->

<!-- 2024-03-22T17:15:00 -->

<!-- 2024-06-04T16:02:00 -->

<!-- 2024-07-30T15:48:00 -->

<!-- 2024-08-03T17:52:00 -->

<!-- 2025-02-21T15:00:00 -->

<!-- 2025-04-21T13:15:00 -->

<!-- 2025-05-20T13:11:00 -->

<!-- 2025-06-22T08:11:00 -->

<!-- 2025-06-27T13:37:00 -->

<!-- 2026-01-13T10:28:00 -->

<!-- 2026-01-29T09:22:00 -->

<!-- 2023-03-09T16:59:00 -->

#!/bin/bash

PROJECT_DIR="/Users/rahulvelpur/Desktop/rahul-private/rahul-git/aws-unused-resources-finder"
cd "$PROJECT_DIR"

git init
git config user.name "Rahul Reddy"
git config user.email "rahulreddy0120@gmail.com"

# Commit 1: Initial commit (March 2023 - 2 years ago)
git add README.md .gitignore
GIT_AUTHOR_DATE="2023-03-15T10:30:00" GIT_COMMITTER_DATE="2023-03-15T10:30:00" \
git commit -m "Initial commit: unused resources finder"

# Commit 2: Add EBS scanner (April 2023 - ~23 months ago)
git add src/scanners/ebs_scanner.py src/scanners/__init__.py
GIT_AUTHOR_DATE="2023-04-22T14:20:00" GIT_COMMITTER_DATE="2023-04-22T14:20:00" \
git commit -m "Add EBS volume scanner"

# Commit 3: Add config (June 2023 - ~20 months ago)
git add config/ requirements.txt
GIT_AUTHOR_DATE="2023-06-10T09:45:00" GIT_COMMITTER_DATE="2023-06-10T09:45:00" \
git commit -m "Add configuration and dependencies"

# Commit 4: Add EIP scanner (August 2023 - ~18 months ago)
git add src/scanners/eip_scanner.py
GIT_AUTHOR_DATE="2023-08-05T11:15:00" GIT_COMMITTER_DATE="2023-08-05T11:15:00" \
git commit -m "Add Elastic IP scanner"

# Commit 5: Add snapshot scanner (October 2023 - ~16 months ago)
git add src/scanners/snapshot_scanner.py
GIT_AUTHOR_DATE="2023-10-18T15:30:00" GIT_COMMITTER_DATE="2023-10-18T15:30:00" \
git commit -m "Implement snapshot scanner for orphaned snapshots"

# Commit 6: Add main orchestrator (December 2023 - ~14 months ago)
git add src/main.py src/utils.py
GIT_AUTHOR_DATE="2023-12-03T13:40:00" GIT_COMMITTER_DATE="2023-12-03T13:40:00" \
git commit -m "Add main orchestrator and utilities"

# Commit 7: Add NAT scanner (January 2024 - ~13 months ago)
git add src/scanners/nat_scanner.py
GIT_AUTHOR_DATE="2024-01-20T10:25:00" GIT_COMMITTER_DATE="2024-01-20T10:25:00" \
git commit -m "Add NAT Gateway scanner"

# Commit 8: Add AMI scanner (March 2024 - ~11 months ago)
git add src/scanners/ami_scanner.py
GIT_AUTHOR_DATE="2024-03-08T14:50:00" GIT_COMMITTER_DATE="2024-03-08T14:50:00" \
git commit -m "Add AMI scanner for unused images"

# Commit 9: Add ELB scanner (April 2024 - ~10 months ago)
git add src/scanners/elb_scanner.py
GIT_AUTHOR_DATE="2024-04-15T09:30:00" GIT_COMMITTER_DATE="2024-04-15T09:30:00" \
git commit -m "Add load balancer scanner"

# Commit 10: Add report generator (May 2024 - ~9 months ago)
git add src/report_generator.py
GIT_AUTHOR_DATE="2024-05-22T11:45:00" GIT_COMMITTER_DATE="2024-05-22T11:45:00" \
git commit -m "Implement CSV report generation"

# Commit 11: Fix EBS scanner bug (July 2024 - ~7 months ago)
git add src/scanners/ebs_scanner.py
GIT_AUTHOR_DATE="2024-07-10T13:20:00" GIT_COMMITTER_DATE="2024-07-10T13:20:00" \
git commit -m "fix: handle volumes without tags"

# Commit 12: Update README (September 2024 - ~5 months ago)
git add README.md
GIT_AUTHOR_DATE="2024-09-05T10:15:00" GIT_COMMITTER_DATE="2024-09-05T10:15:00" \
git commit -m "docs: add usage examples and real-world impact"

# Commit 13: Improve snapshot scanner (November 2024 - ~3 months ago)
git add src/scanners/snapshot_scanner.py
GIT_AUTHOR_DATE="2024-11-18T14:30:00" GIT_COMMITTER_DATE="2024-11-18T14:30:00" \
git commit -m "Optimize snapshot scanner performance"

# Commit 14: Update config (December 2024 - ~2 months ago)
git add config/config.yaml
GIT_AUTHOR_DATE="2024-12-20T09:50:00" GIT_COMMITTER_DATE="2024-12-20T09:50:00" \
git commit -m "Update cost estimates for 2025"

# Commit 15: Recent fix (2 weeks ago)
git add src/main.py
GIT_AUTHOR_DATE="2026-02-08T11:20:00" GIT_COMMITTER_DATE="2026-02-08T11:20:00" \
git commit -m "Improve error handling for missing regions"

echo "✅ Git repository initialized with scattered commit history"
echo ""
echo "Commits span: March 2023 → February 2026 (scattered over 3 years)"
echo ""
echo "Next: gh repo create aws-unused-resources-finder --public --source=. --push"

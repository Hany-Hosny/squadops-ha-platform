#!/bin/bash
dnf update -y
dnf install -y nginx amazon-cloudwatch-agent

# 1. Start and enable Nginx
systemctl enable --now nginx
echo "<h1>SquadOps HA Web Platform - App Tier</h1>" > /usr/share/nginx/html/index.html
echo "OK" > /usr/share/nginx/html/health

# 2. CloudWatch Agent Configuration
cat << 'EOF_CW' > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "/app/compute",
            "log_stream_name": "{instance_id}-nginx-access",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "/app/compute",
            "log_stream_name": "{instance_id}-nginx-error",
            "timezone": "UTC"
          }
        ]
      }
    }
  },
  "metrics": {
    "metrics_collected": {
      "mem": {
        "measurement": ["mem_used_percent"]
      },
      "disk": {
        "measurement": ["used_percent"],
        "resources": ["/"]
      }
    }
  }
}
EOF_CW

# 3. Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

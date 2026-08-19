# Dynamic AMI Lookup (Amazon Linux 2023)
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-lt-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.app_profile.name
  }

  vpc_security_group_ids = [var.app_security_group_id]

  user_data = base64encode(<<-USERDATA
              #!/bin/bash
              dnf update -y
              dnf install -y nginx amazon-cloudwatch-agent
              systemctl enable --now nginx
              echo "<h1>SquadOps HA Web Platform - App Tier</h1>" > /usr/share/nginx/html/index.html
              echo "OK" > /usr/share/nginx/html/health
              USERDATA
  )

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = "${var.project_name}-app-instance"
      Tier      = "App"
      ManagedBy = "Terraform"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name_prefix         = "${var.project_name}-app-asg-"
  vpc_zone_identifier = var.app_subnet_ids

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-asg-instance"
    propagate_at_launch = true
  }
}

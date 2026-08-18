provider "aws" {
  region = var.aws_region
}

locals {
  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
    Component = "networking"
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.tags, {
    Name = "${var.project_name}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, {
    Name = "${var.project_name}-igw"
  })
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true
  tags = merge(local.tags, {
    Name = "${var.project_name}-public-a"
    Tier = "public"
  })
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true
  tags = merge(local.tags, {
    Name = "${var.project_name}-public-b"
    Tier = "public"
  })
}

resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.app_subnet_a_cidr
  availability_zone = var.availability_zone_a
  tags = merge(local.tags, {
    Name = "${var.project_name}-app-a"
    Tier = "app"
  })
}

resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.app_subnet_b_cidr
  availability_zone = var.availability_zone_b
  tags = merge(local.tags, {
    Name = "${var.project_name}-app-b"
    Tier = "app"
  })
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.db_subnet_a_cidr
  availability_zone = var.availability_zone_a
  tags = merge(local.tags, {
    Name = "${var.project_name}-db-a"
    Tier = "db"
  })
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.db_subnet_b_cidr
  availability_zone = var.availability_zone_b
  tags = merge(local.tags, {
    Name = "${var.project_name}-db-b"
    Tier = "db"
  })
}

resource "aws_eip" "nat_a" {
  domain = "vpc"
  tags = merge(local.tags, {
    Name = "${var.project_name}-nat-a-eip"
  })
}

resource "aws_eip" "nat_b" {
  domain = "vpc"
  tags = merge(local.tags, {
    Name = "${var.project_name}-nat-b-eip"
  })
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id
  tags = merge(local.tags, {
    Name = "${var.project_name}-nat-a"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id
  tags = merge(local.tags, {
    Name = "${var.project_name}-nat-b"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, {
    Name = "${var.project_name}-public-rt"
    Tier = "public"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table" "app_a" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, {
    Name = "${var.project_name}-app-a-rt"
    Tier = "app"
  })
}

resource "aws_route" "app_a_default" {
  route_table_id         = aws_route_table.app_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

resource "aws_route_table" "app_b" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, {
    Name = "${var.project_name}-app-b-rt"
    Tier = "app"
  })
}

resource "aws_route" "app_b_default" {
  route_table_id         = aws_route_table.app_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, {
    Name = "${var.project_name}-db-rt"
    Tier = "db"
  })
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "app_a" {
  subnet_id      = aws_subnet.app_a.id
  route_table_id = aws_route_table.app_a.id
}

resource "aws_route_table_association" "app_b" {
  subnet_id      = aws_subnet.app_b.id
  route_table_id = aws_route_table.app_b.id
}

resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.db.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.db.id
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow public HTTP and HTTPS access to the load balancer."
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.project_name}-alb-sg"
  })
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Allow traffic only from the load balancer to the app layer."
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.project_name}-app-sg"
  })
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Allow PostgreSQL only from the application layer."
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "PostgreSQL from app"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.project_name}-db-sg"
  })
}


locals {
  # az_names = data.aws_availability_zones.azs.names
  az_name = ["${var.aws_region}a", "${var.aws_region}b"]
}

resource "aws_flow_log" "example" {
  log_destination      = aws_s3_bucket.flow_log.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.my_vpc.id
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "flow_log" {
  # unique bucket name
  #checkov:skip=CKV2_AWS_61:Skipping
  #checkov:skip=CKV2_AWS_6:Skipping
  #checkov:skip=CKV2_AWS_62:Skipping
  #checkov:skip=CKV_AWS_145:Skipping
  #checkov:skip=CKV_AWS_18:Skipping
  #checkov:skip=CKV_AWS_144:Skipping
  bucket = "flow-log-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "flow_log" {
  bucket = aws_s3_bucket.flow_log.id
  versioning_configuration {
    status = "Enabled"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  tags       = var.tags
}
# Create the public subnets
resource "aws_subnet" "my_public_subnets" {
  vpc_id            = aws_vpc.my_vpc.id
  for_each          = { for idx, az in local.az_name : idx => az }
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, each.key)
  availability_zone = each.value
  #checkov:skip=CKV_AWS_130:The public ip is allowed
  map_public_ip_on_launch = true
  tags = {
    Name = "my_public_subnet_${each.value}"
  }
}

# Create the private subnets
resource "aws_subnet" "my_private_subnets" {
  vpc_id                  = aws_vpc.my_vpc.id
  for_each                = { for idx, az in local.az_name : idx => az }
  cidr_block              = cidrsubnet(aws_vpc.my_vpc.cidr_block, 4, each.key + 1)
  availability_zone       = each.value
  map_public_ip_on_launch = false
  tags = {
    Name = "my_private_subnet_${each.value}"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}
# Create a public route table and route to the internet gateway
resource "aws_route_table" "my_public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}
# Create a private route table
resource "aws_route_table" "my_private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

# Associate the public route table with the public subnets
resource "aws_route_table_association" "my_public_subnet_association" {
  for_each       = aws_subnet.my_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.my_public_route_table.id
}
# Associate the private route table with the private subnets
resource "aws_route_table_association" "my_private_subnet_association" {
  for_each       = aws_subnet.my_private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.my_private_route_table.id
}

# Security Group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow inbound SSH traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow inbound SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #checkov:skip=CKV_AWS_24:For testing purpose, will be removed.
    #ts:skip=AC_AWS_0319:For testing purpose, will be removed.
    cidr_blocks = [var.your_ip_range]
  }
  egress {
    description = "By default, terraform will remove ALLOW ALL egress rule from the security group. Re-create it here."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = tls_private_key.ssh.public_key_openssh
  # public_key = file("~/.ssh/id_rsa.pub")
}

resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/my_key_pair.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.ssh.private_key_pem
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "my_instance" {
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.my_public_subnets[0].id
  availability_zone = "${var.aws_region}a"
  #checkov:skip=CKV2_AWS_41:Skipping
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = aws_key_pair.my_key_pair.key_name

  metadata_options {
    http_tokens = "required"
  }
  ebs_optimized = true
  monitoring    = true
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "my_instance"
  }
}

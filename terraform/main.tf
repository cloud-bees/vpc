module "my_vpc" {
  source     = "./modules/vpc"
  aws_region = "us-east-1"
  tags = {
    Name = "test-vpc-tag"
  }
  cidr_block    = "10.1.0.0/16"
  your_ip_range = "123.123.123.0/32"
}

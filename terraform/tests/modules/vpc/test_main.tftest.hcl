run "create_vpc" {
  command = apply

  variables {
    tags = {
      Name = "test-vpc-tag"
    }
    cidr_block = "10.1.0.0/16"
  }

  module {
    source = "./modules/vpc"
  }

  assert {
    condition     = output.my_vpc_id != null
    error_message = "VPC ID is null"
  }
  assert {
    condition     = output.my_vpc_cidr_block == var.cidr_block
    error_message = "VPC CIDR block does not match: ${output.my_vpc_cidr_block}"
  }
}



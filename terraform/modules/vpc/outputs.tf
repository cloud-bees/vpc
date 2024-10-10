output "my_vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "my_vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.my_vpc.cidr_block
}

output "tags" {
  description = "Tags of the VPC"
  value       = aws_vpc.my_vpc.tags_all
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for s in aws_subnet.my_public_subnets : s.id]
}
# ################################################################################
# # Security Group
# ################################################################################

# output "security_group_arn" {
#   description = "Amazon Resource Name (ARN) of the security group"
#   value       = try(aws_security_group.this[0].arn, null)
# }

# output "security_group_id" {
#   description = "ID of the security group"
#   value       = try(aws_security_group.this[0].id, null)
# }

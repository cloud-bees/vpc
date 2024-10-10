variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "The AWS region to use"
  type        = string
}

variable "your_ip_range" {
  description = "Your IP range to allow SSH access"
  type        = string
  default     = "123.123.123.0/24"
  validation {
    condition     = var.your_ip_range != "0.0.0.0/0"
    error_message = "Please do not use public IP range."
  }
}
# variable "security_group_ids" {
#   description = "Default security group IDs to associate with the VPC endpoints"
#   type        = list(string)
#   default     = []
# }


# variable "timeouts" {
#   description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
#   type        = map(string)
#   default     = {}
# }

# ################################################################################
# # Security Group
# ################################################################################

# variable "create_security_group" {
#   description = "Determines if a security group is created"
#   type        = bool
#   default     = false
# }

# variable "security_group_name" {
#   description = "Name to use on security group created. Conflicts with `security_group_name_prefix`"
#   type        = string
#   default     = null
# }

# variable "security_group_name_prefix" {
#   description = "Name prefix to use on security group created. Conflicts with `security_group_name`"
#   type        = string
#   default     = null
# }

# variable "security_group_description" {
#   description = "Description of the security group created"
#   type        = string
#   default     = null
# }

# variable "security_group_rules" {
#   description = "Security group rules to add to the security group created"
#   type        = any
#   default     = {}
# }

# variable "security_group_tags" {
#   description = "A map of additional tags to add to the security group created"
#   type        = map(string)
#   default     = {}
# }

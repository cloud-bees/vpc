# AWS VPC with Terraform

[![GitHub CI](https://github.com/cloud-bees/vpc/actions/workflows/main.yaml/badge.svg)](https://github.com/cloud-bees/vpc/actions/workflows/main.yaml)

This repository contains code to create an AWS VPC using Terraform. It includes detailed instructions for initializing, deploying, and managing the infrastructure.

## Get Started

### 1. Run Devcontainer

Open the project in a Devcontainer to ensure you have a consistent development environment.

### 2. Update Configuration

Before deploying the infrastructure, update your VPC settings:

- Modify the VPC name and IP range in `terraform/main.tf`.
- Run `aws configure` to set up AWS credentials and region.

### 3. Initialize Terraform

Navigate to the Terraform directory and initialize the project:

```sh
cd terraform && terraform init
```

### 4. Deploy Infrastructure

Generate a plan and apply it to deploy your infrastructure:

```sh
terraform plan -out=deploy.tfplan
terraform apply -auto-approve deploy.tfplan
```

### 5. SSH into EC2 Instance

After deployment, SSH into your EC2 instance:

```sh
ssh -i ~/.ssh/my_key_pair.pem ec2-user@<ec2-public-ip>
```

### 6. Destroy Infrastructure

When you’re done, you can destroy the infrastructure:

```sh
terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan
```

## Developer Guide

### 1. Initialize Terraform

Make sure to initialize the Terraform project before making changes:

```sh
cd terraform && terraform init
```

### 2. Format and Validate Configuration

Format and validate the Terraform code:

```sh
terraform fmt -check=true -recursive
terraform validate
```

**Note**: Skip formatting if you have Visual Studio Code’s format-on-save feature enabled.

### 3. Deploy Infrastructure

Create a plan and deploy the infrastructure:

```sh
terraform plan -out=deploy.tfplan
terraform apply -auto-approve deploy.tfplan
```

### 4. Destroy Infrastructure

To destroy the infrastructure, run:

```sh
terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan
```

### 5. Generate Documentation

Generate Markdown documentation for your Terraform modules using terraform-docs:

```sh
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) \
quay.io/terraform-docs/terraform-docs:0.19.0 markdown table \
/terraform-docs/terraform --recursive --output-file /terraform-docs/README.md
```

Additionally, create a graph visualization of your Terraform plan:

```sh
terraform graph -type=plan | dot -Tpng >graph.png
```

### 6. Test and Debug

To test and debug Terraform configurations, use the following commands:

```sh
export TF_LOG="trace"
export TF_LOG_PATH="tf.log"
terraform init -test-directory=tests/modules/vpc
terraform test -test-directory=tests/modules/vpc -var aws_region=$AWS_REGION
```

### 7. Lint Your Code

Before committing your changes, run the linter to ensure consistency:

```sh
docker run --rm \
  -e LOG_LEVEL=DEBUG \
  -e RUN_LOCAL=true \
  -e DEFAULT_BRANCH=main \
  -e SHELL=/bin/bash \
  -e SAVE_SUPER_LINTER_SUMMARY=true \
  -e SAVE_SUPER_LINTER_OUTPUT=true \
  -e IGNORE_GITIGNORED_FILES=true \
  -e FIX_JSON_PRETTIER=true \
  -e FIX_MARKDOWN_PRETTIER=true \
  -e FIX_YAML_PRETTIER=true \
  -e VALIDATE_NATURAL_LANGUAGE=false \
  -e CREATE_LOG_FILE=true \
  -v "$(pwd)":/tmp/lint \
  --platform linux/amd64 \
  --name super_linter \
  ghcr.io/super-linter/super-linter:v7.1.0
```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.8.3 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 5.30  |
| <a name="requirement_local"></a> [local](#requirement_local)             | >= 2.5.0 |
| <a name="requirement_tls"></a> [tls](#requirement_tls)                   | >= 4.0.0 |

## Providers

| Name                                                   | Version  |
| ------------------------------------------------------ | -------- |
| <a name="provider_aws"></a> [aws](#provider_aws)       | >= 5.30  |
| <a name="provider_local"></a> [local](#provider_local) | >= 2.5.0 |
| <a name="provider_tls"></a> [tls](#provider_tls)       | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                             | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group)                         | resource    |
| [aws_flow_log.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log)                                                     | resource    |
| [aws_instance.my_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                 | resource    |
| [aws_internet_gateway.my_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                      | resource    |
| [aws_key_pair.my_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)                                                 | resource    |
| [aws_route_table.my_private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                | resource    |
| [aws_route_table.my_public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                 | resource    |
| [aws_route_table_association.my_private_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_route_table_association.my_public_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)  | resource    |
| [aws_s3_bucket.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                  | resource    |
| [aws_s3_bucket_versioning.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)                            | resource    |
| [aws_security_group.allow_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                       | resource    |
| [aws_subnet.my_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                              | resource    |
| [aws_subnet.my_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                               | resource    |
| [aws_vpc.my_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                | resource    |
| [local_sensitive_file.pem_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file)                                    | resource    |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)                                                   | resource    |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                                                       | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                    | data source |

## Inputs

| Name                                                                     | Description                           | Type          | Default              | Required |
| ------------------------------------------------------------------------ | ------------------------------------- | ------------- | -------------------- | :------: |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)          | The AWS region to use                 | `string`      | n/a                  |   yes    |
| <a name="input_cidr_block"></a> [cidr_block](#input_cidr_block)          | The CIDR block for the VPC            | `string`      | `null`               |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                            | A map of tags to use on all resources | `map(string)` | `{}`                 |    no    |
| <a name="input_your_ip_range"></a> [your_ip_range](#input_your_ip_range) | Your IP range to allow SSH access     | `string`      | `"123.123.123.0/24"` |    no    |

## Outputs

| Name                                                                                   | Description               |
| -------------------------------------------------------------------------------------- | ------------------------- |
| <a name="output_my_vpc_cidr_block"></a> [my_vpc_cidr_block](#output_my_vpc_cidr_block) | CIDR block of the VPC     |
| <a name="output_my_vpc_id"></a> [my_vpc_id](#output_my_vpc_id)                         | ID of the VPC             |
| <a name="output_public_subnet_ids"></a> [public_subnet_ids](#output_public_subnet_ids) | IDs of the public subnets |
| <a name="output_tags"></a> [tags](#output_tags)                                        | Tags of the VPC           |

<!-- END_TF_DOCS -->

## License

This project is released under the [Mozilla Public License](/LICENSE) by [@Nguyen Tri Man](https://github.com/nguyentriman) ([@cloud-bees](https://github.com/cloud-bees))

© 2024 Nguyen Tri Man. All rights reserved.

#my-aws-credentials-variables
variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
}


#my-vpc-variables

variable "my_vpc_name" {
}

variable "my_vpc_cidr" {
}

variable "my_vpc_private_subnets" {
}

variable "my_vpc_public_subnets" {
}

variable "my_dns_hostnames_bool" {
}

variable "my_vpc_nat_gateway_bool" {
}


variable "my_tags" {
}


#my-eks-variables

variable "my_eks_version" {
}

variable "cluster_endpoint_private_bool" {
}

variable "cluster_endpoint_public_bool" {
}

variable "my_map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
}

variable "my_node_groups" {
}


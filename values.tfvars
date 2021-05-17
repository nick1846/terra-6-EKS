aws_region = "us-east-2"


#my-vpc-values

my_vpc_name             = "eks_vpc"
my_vpc_cidr             = "10.0.0.0/16"
my_vpc_private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
my_vpc_public_subnets   = ["10.0.100.0/24", "10.0.101.0/24"]
my_dns_hostnames_bool   = "true"
my_vpc_nat_gateway_bool = "true"
my_tags = {
  "kubernetes.io/cluster/my_cluster" = "shared"
}


#my-eks-values

my_eks_version                = "1.17"
cluster_endpoint_private_bool = "false"
cluster_endpoint_public_bool  = "true"

my_map_users = [
  {
    userarn  = "arn:aws:iam::021510583954:user/k8s-admin"
    username = "k8s-admin"
    groups   = ["system:masters"]
  },
]

my_node_groups = {

  private = {
    desired_capacity = 2
    max_capacity     = 2
    min_capacity     = 1
    instance_types   = ["t2.medium"]
  }
}



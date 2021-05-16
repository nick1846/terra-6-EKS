####################################
#my eks 
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.my_eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my_eks.cluster_id
}

locals {
  cluster_name = "my-cluster"
}


module "my_eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = local.cluster_name
  cluster_version                 = var.my_eks_version
  subnets                         = module.my_vpc.private_subnets
  vpc_id                          = module.my_vpc.vpc_id
  cluster_endpoint_private_access = var.cluster_endpoint_private_bool
  cluster_endpoint_public_access  = var.cluster_endpoint_public_bool
  map_users                       = var.my_map_users
  node_groups                     = var.my_node_groups
  enable_irsa                     = true
}

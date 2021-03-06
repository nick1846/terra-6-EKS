#IAM role for the AWS Load Balancer Controller

module "ingress_controller_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 3.0"

  create_role = true

  role_name = "ingress-controller-role"

  tags = {
    Role = "ingress-role-with-oidc"
  }

  provider_url = module.my_eks.cluster_oidc_issuer_url

  oidc_fully_qualified_subjects = ["system:serviceaccount:my-controllers-ns:ingress-controller-sa"]

  role_policy_arns           = [aws_iam_policy.ingress_controller_policy.arn, ]
  number_of_role_policy_arns = 1
}


resource "aws_iam_policy" "ingress_controller_policy" {
  name   = "ingress-controller-policy"
  policy = file("./aws_policies/ingress-controller-policy.json")
}


#IAM role for the ExternalDNS Controller

module "external_dns_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 3.0"

  create_role = true

  role_name = "external-dns-role"

  tags = {
    Role = "dns-role-with-oidc"
  }

  provider_url = module.my_eks.cluster_oidc_issuer_url

  oidc_fully_qualified_subjects = ["system:serviceaccount:my-controllers-ns:external-dns-sa"]

  role_policy_arns           = [aws_iam_policy.external_dns_policy.arn, ]
  number_of_role_policy_arns = 1
}


resource "aws_iam_policy" "external_dns_policy" {
  name   = "external-dns-policy"
  policy = file("./aws_policies/external-dns-policy.json")
}
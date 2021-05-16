#IAM role for the AWS Load Balancer Controller

module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 3.0"

  create_role = true

  role_name = "ingress-controller-role"

  tags = {
    Role = "role-with-oidc"
  }

  provider_url = module.my_eks.cluster_oidc_issuer_url

  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.sa_namespace}:${var.service_account}"]

  role_policy_arns           = [aws_iam_policy.ingress_controller_policy.arn, ]
  number_of_role_policy_arns = 1
}


resource "aws_iam_policy" "ingress_controller_policy" {
  name   = "ingress-controller-policy"
  policy = file("ingress-controller-policy.json")
}
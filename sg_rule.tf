#my security groups 

resource "aws_security_group_rule" "eks_ingress_localhost" {
  type        = "ingress"
  description = "Allow traffic from localhost"

  # Allow inbound traffic from your localhost external IP to the EKS. 
  #Replace 0.0.0.0/32 with your real IP. Use service like "ipv4.icanhazip.com"

  cidr_blocks       = ["0.0.0.0/32"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.my_eks.cluster_security_group_id
}







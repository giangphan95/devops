module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "rds-security-group-${var.env}"
  description = "Security group for rds instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.0.0.0/16"
    }
  ]
}

module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name          = "alb-security-group-${var.env}"
  description   = "Security group for alb"
  vpc_id        = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name         = "ec2-security-group-${var.env}"
  description  = "Security group for ec2 instances"
  vpc_id       = module.vpc.vpc_id

  ingress_cidr_blocks   = ["0.0.0.0/0"]
  ingress_rules         = ["http-80-tcp", "all-icmp", "ssh-tcp"]
  egress_rules          = ["all-all"]
}
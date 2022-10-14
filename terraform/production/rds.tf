module "security_group_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "rds-security-group-${var.env}"
  description = "Security group for RDS db instances"
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

# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/4.5.0

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "4.5.0"

  identifier          = "devops-db-${var.env}"
  engine              = "mysql"
  engine_version      = "8.0.28"
  instance_class      = "db.t3.small"
  allocated_storage   = 5
  skip_final_snapshot = true

  db_name  = "devops"
  username = "devops"
  port     = "3306"

  # DB security group
  vpc_security_group_ids = [module.security_group_rds.security_group_id]

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"
}
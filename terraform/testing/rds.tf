module "rds_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "4.5.0"

  identifier          = "${var.env}-mysql"
  engine              = "mysql"
  engine_version      = "8.0.28"
  instance_class      = "db.t3.small"
  allocated_storage   = 5
  skip_final_snapshot = true

  db_name  = "wp"
  username = "wp"
  port     = "3306"
  password = "P@ssw0rd"

  # DB security group
  vpc_security_group_ids = [module.rds_security_group.security_group_id]

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"
}
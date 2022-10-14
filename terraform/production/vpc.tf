module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "devops-vpc-production"
  cidr = "10.2.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets  = ["10.2.10.0/24", "10.2.20.0/24", "10.2.30.0/24"]

  tags = {
    Terraform = "true"
    Environment = "production"
  }
}
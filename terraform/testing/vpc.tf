module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "devops-vpc-testing"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]

  tags = {
    Terraform = "true"
    Environment = "testing"
  }
}
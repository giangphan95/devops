# tạo ssh keypair cho ec2 instance, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair

resource "aws_key_pair" "production" {
  key_name = "devops-ssh-${var.env}"

  # replace the below with your public key
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3YHGCDgcezzPWMx+tdUVPtugcfJ8f/lTj0FgHF1ccq0S0K3AjxtjnKAHQrnNQ2aua3fQJtbQ8kCb4z0ZbzAfmk4pf1WmTeMYm5UEC9Fl7tp1i8o9duRDhUWbRpP/C6itdt1bfgyDz9VZqa0L9nmBWVL8zdE3C6WiMg47AYAskFJUUIi2BuWrAF41s6hEHRR+fhlPC9daVSRS4cQFxB2QhtkOrtitN6VLLW3heYCUdikisgQvaqHfU5WFmtgWt4Wq/qt58jotchRTYGURQjY3w1M64uFTQwhtt+bm1sVZdj+hEffb28EJ4dFmpHBHNBX1VjEJJWiqVeoVW6nXJ7O4i9FuoU8fpZ43ohXPyV5yE1zpV11yyaYEXfkNoYlvrDtRFqtmPpvEAPjC6P+ESGRtZwpH780kTxzwTqe2wXJMMmBXm1TrGQ11l8gyTN8pbVDtgkwu+DlS6aMETtnkCTuiqv4VRmgJKWucGGvWn9+loSsfFRdouN6F+853vRDPWO+Fs9o1k78ubmrhAtEh7oAazU9IQwIWNgzC2X2yFp3j5tNLbeBkZLLJRJW0LTI6ayEIGxutCEd6FnbYFyx4AfKHluahEzmnUg5zsmyNMEkSFJcnC/yhPjxFFPK1lWbn08915Gm2LvrNToo7q3txWoLxubaylIDkuaS+wwU7Iu6HsCQ== giangphan@giangphan-lap"
}

# tạo ec2 instance

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "web-instance-${var.env}"

  ami                    = "ami-0eaf04122a1ae7b3b" # https://cloud-images.ubuntu.com/locator/ec2/
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.production.key_name
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}

# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/4.9.0

module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "web-security-group-${var.env}"
  description = "Security group for Web ec2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}
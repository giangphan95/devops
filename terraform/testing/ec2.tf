resource "aws_key_pair" "devops" {
  key_name = "devops-ssh"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3YHGCDgcezzPWMx+tdUVPtugcfJ8f/lTj0FgHF1ccq0S0K3AjxtjnKAHQrnNQ2aua3fQJtbQ8kCb4z0ZbzAfmk4pf1WmTeMYm5UEC9Fl7tp1i8o9duRDhUWbRpP/C6itdt1bfgyDz9VZqa0L9nmBWVL8zdE3C6WiMg47AYAskFJUUIi2BuWrAF41s6hEHRR+fhlPC9daVSRS4cQFxB2QhtkOrtitN6VLLW3heYCUdikisgQvaqHfU5WFmtgWt4Wq/qt58jotchRTYGURQjY3w1M64uFTQwhtt+bm1sVZdj+hEffb28EJ4dFmpHBHNBX1VjEJJWiqVeoVW6nXJ7O4i9FuoU8fpZ43ohXPyV5yE1zpV11yyaYEXfkNoYlvrDtRFqtmPpvEAPjC6P+ESGRtZwpH780kTxzwTqe2wXJMMmBXm1TrGQ11l8gyTN8pbVDtgkwu+DlS6aMETtnkCTuiqv4VRmgJKWucGGvWn9+loSsfFRdouN6F+853vRDPWO+Fs9o1k78ubmrhAtEh7oAazU9IQwIWNgzC2X2yFp3j5tNLbeBkZLLJRJW0LTI6ayEIGxutCEd6FnbYFyx4AfKHluahEzmnUg5zsmyNMEkSFJcnC/yhPjxFFPK1lWbn08915Gm2LvrNToo7q3txWoLxubaylIDkuaS+wwU7Iu6HsCQ== giangphan@giangphan-lap"
}

module "ec2-za" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["01"])

  name = "web-za-${var.env}-${each.key}"

  ami                    = "ami-0eaf04122a1ae7b3b"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.devops.key_name
  monitoring             = true
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}

module "ec2-zb" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["01"])

  name = "web-zb-${var.env}-${each.key}"

  ami                    = "ami-0eaf04122a1ae7b3b"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.devops.key_name
  monitoring             = true
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 1)

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
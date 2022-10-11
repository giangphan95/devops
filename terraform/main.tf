# khai báo provider, xác thực
provider "aws" {
  // access_key = "***"
  // secret_key = "***"
  region     = "ap-southeast-1" # Singapore region
}

# tạo ec2 instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "web" {

  ami           = "ami-0d058fe428540cd89"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id

  key_name               = aws_key_pair.dev.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "web-01"
  }
}

# tạo ssh keypair

resource "aws_key_pair" "dev" {
  key_name   = "dev-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3YHGCDgcezzPWMx+tdUVPtugcfJ8f/lTj0FgHF1ccq0S0K3AjxtjnKAHQrnNQ2aua3fQJtbQ8kCb4z0ZbzAfmk4pf1WmTeMYm5UEC9Fl7tp1i8o9duRDhUWbRpP/C6itdt1bfgyDz9VZqa0L9nmBWVL8zdE3C6WiMg47AYAskFJUUIi2BuWrAF41s6hEHRR+fhlPC9daVSRS4cQFxB2QhtkOrtitN6VLLW3heYCUdikisgQvaqHfU5WFmtgWt4Wq/qt58jotchRTYGURQjY3w1M64uFTQwhtt+bm1sVZdj+hEffb28EJ4dFmpHBHNBX1VjEJJWiqVeoVW6nXJ7O4i9FuoU8fpZ43ohXPyV5yE1zpV11yyaYEXfkNoYlvrDtRFqtmPpvEAPjC6P+ESGRtZwpH780kTxzwTqe2wXJMMmBXm1TrGQ11l8gyTN8pbVDtgkwu+DlS6aMETtnkCTuiqv4VRmgJKWucGGvWn9+loSsfFRdouN6F+853vRDPWO+Fs9o1k78ubmrhAtEh7oAazU9IQwIWNgzC2X2yFp3j5tNLbeBkZLLJRJW0LTI6ayEIGxutCEd6FnbYFyx4AfKHluahEzmnUg5zsmyNMEkSFJcnC/yhPjxFFPK1lWbn08915Gm2LvrNToo7q3txWoLxubaylIDkuaS+wwU7Iu6HsCQ== giangphan@giangphan-lap"
}

# tạo security group allow ssh

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from specify IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.232.243.111/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# in ra public ip của ec2 instance
output "ec2_instance_public_ips" {
  value = aws_instance.web.*.public_ip
}
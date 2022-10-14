module "s3_bucket" {
  source = "../modules/s3"

  bucket_name = "giangphan-devops-${var.env}"

  tags = {
    Env = "${var.env}"
  }
}
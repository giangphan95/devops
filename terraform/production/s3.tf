# gọi module s3 từ đường dẫn local và truyền các giá trị vào
module "s3_b" {
  source = "../modules/s3"

  bucket_name = "giangphan-devops-production"

  tags = {
    Env = "production"
  }
}
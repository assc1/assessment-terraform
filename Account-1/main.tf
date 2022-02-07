provider "aws" {
  region                  = "eu-west-1"
  profile                 = "default"
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "claude-terraform3"
  acl    = "private"
  versioning {
    enabled = true
  }
}
resource "aws_s3_bucket_object" "upload_state" {
  bucket       = "${aws_s3_bucket.s3_bucket.id}"
  acl          = "private"
  key          = "terraform-backend/terraform.tfstate"
  source       = "terraform.tfstate"
  content_type = "application/json"
  depends_on = [
    "aws_s3_bucket.s3_bucket",
  ]
}



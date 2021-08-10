resource "aws_s3_bucket" "s3_bucket" {
  bucket = "training-${var.training_suffix}"
  acl    = "public-read-write"
}
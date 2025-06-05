terraform {
  backend "s3" {
    bucket         = "<your-aws-bucket-name>" # Backend S3 Bucket name
    key            = "terraform.tfstate"
    region         = "<your-bucket-region-name>" # Region of Backend S3 Bucket
    encrypt        = true
  }
}
terraform {
  backend "s3" {
    bucket         = "3tier-app-backend"
    key            = "terraform/states/dev/3tier.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "3tier-lock"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "tf_remote_state_dev" {
  bucket = "3tier-app-backend"
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_dynamodb_table" "terraform_lock_dev" {
  name           = "3tier-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table Development"
  }
}
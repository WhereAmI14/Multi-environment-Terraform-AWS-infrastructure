terraform {
  backend "s3" {
    bucket         = "replace-with-your-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile   = true
    dynamodb_table = "replace-with-your-terraform-lock-table"
    encrypt        = true
  }
}

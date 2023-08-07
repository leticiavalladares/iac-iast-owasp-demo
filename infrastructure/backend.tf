terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-07082023"
    key            = "iast/owasp-app/terraform.tfstate"
    dynamodb_table = "dynamodb-lock"
  }
}
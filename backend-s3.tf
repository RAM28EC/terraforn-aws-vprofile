terraform {
  backend "s3" {
    bucket = "terra-state-dove12"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}
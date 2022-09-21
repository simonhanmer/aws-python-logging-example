provider "aws" {
    region = var.region
    default_tags {
        tags = {
            Project = "Lambda logging demo"
        }
    }
}

terraform {
    backend "s3" {
        key            = "lambda-logging.tfstate"
        dynamodb_table = "terraform-lock-lambda-logging"
        region         = "eu-west-2"
    }
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAXJJSMMSNKAJIWXH6"
  secret_key = "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"
}

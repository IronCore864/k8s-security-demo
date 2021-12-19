terraform {
  required_version = ">= 1.1.2"

  required_providers {
    aws = {
      version = ">= 3.70"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"

  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

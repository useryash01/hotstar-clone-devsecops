terraform {
  backend "s3" {
    bucket       = "hotstar-clone-terraform-state-634737373070"
    key          = "hotstar-eks/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }

  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

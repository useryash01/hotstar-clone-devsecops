terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ---------------------------------------------------------
# ECR KMS Key
# ---------------------------------------------------------

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecr_kms" {
  statement {
    sid    = "EnableIAMUserPermissions"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_kms_key" "ecr" {
  description             = "KMS key for Hotstar Clone ECR repository"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.ecr_kms.json

  tags = {
    Name      = "${var.repository_name}-ecr-kms"
    ManagedBy = "terraform"
  }
}

resource "aws_kms_alias" "ecr" {
  name          = "alias/${var.repository_name}-ecr"
  target_key_id = aws_kms_key.ecr.key_id
}

# ---------------------------------------------------------
# ECR Repository
# ---------------------------------------------------------

resource "aws_ecr_repository" "hotstar" {
  name                 = var.repository_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr.arn
  }

  tags = {
    Name = var.repository_name
  }
}

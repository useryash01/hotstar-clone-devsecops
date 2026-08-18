data "aws_caller_identity" "current" {}

resource "aws_iam_user" "jenkins_ecr" {
  name = "${var.project_name}-jenkins-ecr"

  tags = {
    Name      = "${var.project_name}-jenkins-ecr"
    Purpose   = "Jenkins ECR push"
    ManagedBy = "terraform"
  }
}

resource "aws_iam_user_policy" "jenkins_ecr" {
  name = "${var.project_name}-jenkins-ecr-policy"
  user = aws_iam_user.jenkins_ecr.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ECRAuthorization"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Sid    = "ECRPush"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.repository_name}"
      }
    ]
  })
}

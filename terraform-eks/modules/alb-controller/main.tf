# ---------------------------------------------------------
# AWS Load Balancer Controller IAM Policy
# ---------------------------------------------------------

resource "aws_iam_policy" "alb_controller" {
  name        = "${var.project_name}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = file("${path.module}/iam_policy.json")

  tags = {
    Name      = "${var.project_name}-alb-controller-policy"
    ManagedBy = "terraform"
  }
}

# ---------------------------------------------------------
# IRSA Trust Policy
# ---------------------------------------------------------

data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(
        var.oidc_issuer_url,
        "https://",
        ""
      )}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(
        var.oidc_issuer_url,
        "https://",
        ""
      )}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}

# ---------------------------------------------------------
# AWS Load Balancer Controller IAM Role
# ---------------------------------------------------------

resource "aws_iam_role" "alb_controller" {
  name = "${var.project_name}-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json

  tags = {
    Name      = "${var.project_name}-alb-controller-role"
    ManagedBy = "terraform"
  }
}

# ---------------------------------------------------------
# Attach ALB Controller Policy to Role
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

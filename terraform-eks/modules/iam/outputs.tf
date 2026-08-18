output "jenkins_ecr_user_name" {
  description = "IAM user used by Jenkins for ECR"
  value       = aws_iam_user.jenkins_ecr.name
}

output "jenkins_ecr_user_arn" {
  description = "ARN of the Jenkins ECR IAM user"
  value       = aws_iam_user.jenkins_ecr.arn
}

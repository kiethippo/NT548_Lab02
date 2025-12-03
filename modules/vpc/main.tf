resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"#"${var.project_tag}-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}

# CloudWatch Log Group cho VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = "/aws/vpc-flow-logs/${aws_vpc.this.id}"
  retention_in_days = 30
}

# IAM Role cho VPC Flow Logs
resource "aws_iam_role" "flow_log_role" {
  name = "${var.project_tag}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Policy cho Role
resource "aws_iam_role_policy" "flow_log_policy" {
  name = "${var.project_tag}-vpc-flow-logs-policy"
  role = aws_iam_role.flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc_flow" {
  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  log_group_name       = aws_cloudwatch_log_group.vpc_flow.name
  iam_role_arn         = aws_iam_role.flow_log_role.arn
  log_destination_type = "cloud-watch-logs"
}
# I followed https://terrateam.io/blog/aws-lambda-function-with-terraform

# Simple AWS Lambda Terraform Example
# requires 'handler.js' in the same directory
# to test: run `terraform plan`
# to deploy: run `terraform apply`
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }
  }
  backend "s3" {
    bucket = "bucket-for-terraform-state-ts-lambda"
    key    = "my_lambda/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "bucket-for-terraform-state-ts-lambda"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "ts_lambda_role" {
  name               = "ts_lambda-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_lambda_function" "ts_lambda" {
  filename      = "zips/lambda_function_${var.lambdasVersion}.zip"
  function_name = "ts_lambda"
  role          = aws_iam_role.ts_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  memory_size   = 1024
  timeout       = 300
}

#resource "aws_cloudwatch_log_group" "ts_lambda_loggroup" {
#  name              = "/aws/lambda/${aws_lambda_function.ts_lambda.function_name}"
#  retention_in_days = 3
#}

#data "aws_iam_policy_document" "ts_lambda_policy" {
#  statement {
#    actions = [
#      "logs:CreateLogGroup",
#      "logs:CreateLogStream",
#      "logs:PutLogEvents",
#      "logs:DeleteLogGroup"
#    ],
#    resources = [
#      aws_cloudwatch_log_group.ts_lambda_loggroup.arn,
#      "${aws_cloudwatch_log_group.ts_lambda_loggroup.arn}:*"
#    ]
#  }
#}

#resource "aws_iam_role_policy" "ts_lambda_role_policy" {
#  policy = data.aws_iam_policy_document.ts_lambda_policy.json
#  role   = aws_iam_role.ts_lambda_role
#  name   = "my-lambda-policy"
#}

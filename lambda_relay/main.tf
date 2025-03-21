resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    })
}

resource "aws_iam_policy" "vpc_access_policy" {
  name        = "vpc_access_policy"
  description = "Policy to allow Lambda function to access VPC resources"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.vpc_access_policy.arn
}

resource "aws_lambda_layer_version" "relay_dependencies" {
  filename         = "${path.module}/../../lambda/resources/dependencies.zip"
  layer_name       = "relay_dependencies"
  compatible_runtimes = ["python3.10"]
}

resource "aws_lambda_function" "relay_function" {
  function_name = "relay_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"
  filename = "${path.module}/../lambda/resources/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/resources/lambda_function.zip")
  layers = [aws_lambda_layer_version.relay_dependencies.arn]
  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = [var.subnet_id]
  }
}

resource "aws_lambda_function_url" "relay_function_url" {
  function_name = aws_lambda_function.relay_function.function_name
  authorization_type = "NONE"
}

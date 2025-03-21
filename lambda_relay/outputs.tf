output "lambda_function_arn" {
  value = aws_lambda_function.relay_function.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.relay_function.function_name
}

output "lambda_function_url" {
    value = aws_lambda_function_url.relay_function_url.function_url
}
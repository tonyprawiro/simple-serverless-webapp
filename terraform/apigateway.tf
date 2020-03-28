# API GATEWAY ACCOUNT 

resource "aws_api_gateway_account" "apigatewayaccount" {
  cloudwatch_role_arn = aws_iam_role.apigateway_cloudwatch_role.arn
}

# CLOUDWATCH ROLE

resource "aws_iam_role" "apigateway_cloudwatch_role" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.apigateway_cloudwatch_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# MAIN

resource "aws_api_gateway_rest_api" "simple_website_api" {
  name        = "simplewebsitebirthdayapi"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# /birthday [OPTIONS, GET]
resource "aws_api_gateway_resource" "api_resource_birthday" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  parent_id   = aws_api_gateway_rest_api.simple_website_api.root_resource_id
  path_part   = "birthday"
}

# /birthday/{username} [OPTIONS, PUT]
resource "aws_api_gateway_resource" "api_resource_birthday_username" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  parent_id   = aws_api_gateway_resource.api_resource_birthday.id
  path_part   = "{username}"
}


# Implementation of each resource in separate files (apigateway_birthday_username.tf)


# STAGE & DEPLOYMENT

resource "aws_api_gateway_deployment" "simple_website_deployment" {
  depends_on = [aws_api_gateway_integration.apimethod_birthday_username_options_request_integration]
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  stage_name  = "default"
  variables = {
    "deployed_at" = var.api_deployed_at
  }
}

resource "aws_api_gateway_stage" "api_stage_default" {
  stage_name    = "default"
  rest_api_id   = aws_api_gateway_rest_api.simple_website_api.id
  deployment_id = aws_api_gateway_deployment.simple_website_deployment.id
}

resource "aws_api_gateway_method_settings" "general_settings" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  stage_name  = "default"
  method_path = "*/*"
  settings {
    metrics_enabled        = true
    data_trace_enabled     = true
    logging_level          = "INFO"
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

# PERMISSION TO LAMBDA

resource "aws_lambda_permission" "allow_api_gateway_getbirthday" {
    function_name = aws_lambda_function.lambda_get_birthday.function_name
    statement_id = "AllowExecutionOfGetBirthdayFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.simple_website_api.id}/*/${aws_api_gateway_integration.apimethod_birthday_username_get_request_integration.http_method}${aws_api_gateway_resource.api_resource_birthday.path}/*"
}

resource "aws_lambda_permission" "allow_api_gateway_addbirthday" {
    function_name = aws_lambda_function.lambda_add_birthday.function_name
    statement_id = "AllowExecutionOfAddBirthdayFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.simple_website_api.id}/*/${aws_api_gateway_integration.apimethod_birthday_username_put_request_integration.http_method}${aws_api_gateway_resource.api_resource_birthday.path}/*"
}


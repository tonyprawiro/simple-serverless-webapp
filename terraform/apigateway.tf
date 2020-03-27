resource "aws_api_gateway_account" "apigatewayaccount" {
  cloudwatch_role_arn = aws_iam_role.apigateway_cloudwatch_role.arn
}

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

#

resource "aws_api_gateway_rest_api" "simple_website_api" {
  name        = "simplewebsitebirthdayapi"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api_resource_birthday" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  parent_id   = aws_api_gateway_rest_api.simple_website_api.root_resource_id
  path_part   = "birthday"
}

# OPTIONS

resource "aws_api_gateway_method" "apimethod_birthday_options" {
  rest_api_id   = aws_api_gateway_rest_api.simple_website_api.id
  resource_id   = aws_api_gateway_resource.api_resource_birthday.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apimethod_birthday_options_request_integration" {
  rest_api_id          = aws_api_gateway_rest_api.simple_website_api.id
  resource_id          = aws_api_gateway_resource.api_resource_birthday.id
  http_method          = aws_api_gateway_method.apimethod_birthday_options.http_method
  type                 = "MOCK"
  timeout_milliseconds = 29000
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
  passthrough_behavior    = "NEVER"
}

resource "aws_api_gateway_method_response" "apimethod_birthday_options_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday.id
  http_method = aws_api_gateway_method.apimethod_birthday_options.http_method
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "apimethod_birthday_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday.id
  http_method = aws_api_gateway_method.apimethod_birthday_options.http_method
  status_code = aws_api_gateway_method_response.apimethod_birthday_options_method_response_200.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# GET

resource "aws_api_gateway_method" "apimethod_birthday_get" {
  rest_api_id   = aws_api_gateway_rest_api.simple_website_api.id
  resource_id   = aws_api_gateway_resource.api_resource_birthday.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apimethod_birthday_get_request_integration" {
  rest_api_id             = aws_api_gateway_rest_api.simple_website_api.id
  resource_id             = aws_api_gateway_resource.api_resource_birthday.id
  http_method             = aws_api_gateway_method.apimethod_birthday_get.http_method
  integration_http_method = "POST" # Lambda can only be invoked using POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_get_birthday.invoke_arn
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
  passthrough_behavior    = "NEVER"
}

resource "aws_api_gateway_method_response" "apimethod_birthday_get_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday.id
  http_method = aws_api_gateway_method.apimethod_birthday_get.http_method
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "apimethod_birthday_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday.id
  http_method = aws_api_gateway_method.apimethod_birthday_get.http_method
  status_code = aws_api_gateway_method_response.apimethod_birthday_get_method_response_200.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# POST

resource "aws_api_gateway_method" "apimethod_birthday_post" {
  rest_api_id   = aws_api_gateway_rest_api.simple_website_api.id
  resource_id   = aws_api_gateway_resource.api_resource_birthday.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apimethod_birthday_post_request_integration" {
  rest_api_id             = aws_api_gateway_rest_api.simple_website_api.id
  resource_id             = aws_api_gateway_resource.api_resource_birthday.id
  http_method             = aws_api_gateway_method.apimethod_birthday_post.http_method
  integration_http_method = "POST" # Lambda can only be invoked using POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_add_birthday.invoke_arn
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
  passthrough_behavior    = "NEVER"
}

resource "aws_api_gateway_method_response" "apimethod_birthday_post_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday.id
  http_method = aws_api_gateway_method.apimethod_birthday_post.http_method
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "apimethod_birthday_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday.id
  http_method = aws_api_gateway_method.apimethod_birthday_post.http_method
  status_code = aws_api_gateway_method_response.apimethod_birthday_post_method_response_200.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}


# STAGE & DEPLOYMENT

resource "aws_api_gateway_deployment" "simple_website_deployment" {
  depends_on = [aws_api_gateway_integration.apimethod_birthday_options_request_integration]
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
    source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.simple_website_api.id}/*/${aws_api_gateway_integration.apimethod_birthday_get_request_integration.http_method}${aws_api_gateway_resource.api_resource_birthday.path}"
}

resource "aws_lambda_permission" "allow_api_gateway_addbirthday" {
    function_name = aws_lambda_function.lambda_add_birthday.function_name
    statement_id = "AllowExecutionOfAddBirthdayFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.simple_website_api.id}/*/${aws_api_gateway_integration.apimethod_birthday_post_request_integration.http_method}${aws_api_gateway_resource.api_resource_birthday.path}"
}


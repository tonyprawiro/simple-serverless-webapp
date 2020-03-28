# /birthday/{username} OPTIONS

resource "aws_api_gateway_method" "apimethod_birthday_username_options" {
  rest_api_id   = aws_api_gateway_rest_api.simple_website_api.id
  resource_id   = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apimethod_birthday_username_options_request_integration" {
  rest_api_id          = aws_api_gateway_rest_api.simple_website_api.id
  resource_id          = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method          = aws_api_gateway_method.apimethod_birthday_username_options.http_method
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

resource "aws_api_gateway_method_response" "apimethod_birthday_username_options_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method = aws_api_gateway_method.apimethod_birthday_username_options.http_method
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "apimethod_birthday_username_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method = aws_api_gateway_method.apimethod_birthday_username_options.http_method
  status_code = aws_api_gateway_method_response.apimethod_birthday_username_options_method_response_200.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# /birthday/{username} GET

resource "aws_api_gateway_method" "apimethod_birthday_username_get" {
  rest_api_id   = aws_api_gateway_rest_api.simple_website_api.id
  resource_id   = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apimethod_birthday_username_get_request_integration" {
  rest_api_id             = aws_api_gateway_rest_api.simple_website_api.id
  resource_id             = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method             = aws_api_gateway_method.apimethod_birthday_username_get.http_method
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

resource "aws_api_gateway_method_response" "apimethod_birthday_username_get_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method = aws_api_gateway_method.apimethod_birthday_username_get.http_method
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "apimethod_birthday_username_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method = aws_api_gateway_method.apimethod_birthday_username_get.http_method
  status_code = aws_api_gateway_method_response.apimethod_birthday_username_get_method_response_200.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# /birthday/{username} PUT

resource "aws_api_gateway_method" "apimethod_birthday_username_put" {
  rest_api_id   = aws_api_gateway_rest_api.simple_website_api.id
  resource_id   = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apimethod_birthday_username_put_request_integration" {
  rest_api_id             = aws_api_gateway_rest_api.simple_website_api.id
  resource_id             = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method             = aws_api_gateway_method.apimethod_birthday_username_put.http_method
  integration_http_method = "POST" # Lambda can only be invoked using POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_add_birthday.invoke_arn
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 204
      }
    )
  }
  passthrough_behavior    = "NEVER"
}

resource "aws_api_gateway_method_response" "apimethod_birthday_username_put_method_response_204" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method = aws_api_gateway_method.apimethod_birthday_username_put.http_method
  status_code = "204"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "apimethod_birthday_put_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_website_api.id
  resource_id = aws_api_gateway_resource.api_resource_birthday_username.id
  http_method = aws_api_gateway_method.apimethod_birthday_username_put.http_method
  status_code = aws_api_gateway_method_response.apimethod_birthday_username_put_method_response_204.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
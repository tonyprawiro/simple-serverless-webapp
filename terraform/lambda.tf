
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_dynamodb_permission" {
  name        = "lambda_dynamodb_permission"
  description = "Permission to access DynamoDB"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:PutItem"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.birthdays.arn}"
    },
    {
      "Action": [
        "dynamodb:GetItem"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.birthdays.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_basicexecution_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_role_ddbputitem_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_permission.arn
}


resource "aws_lambda_function" "lambda_add_birthday" {
  function_name    = "simple_serverless_website_add_birthday"
  s3_bucket        = var.lambda_repo
  s3_key           = var.lambda_code_addbirthday_filename
  role             = aws_iam_role.lambda_role.arn
  handler          = "addbirthday.lambda_handler"
  runtime          = "python3.8"
}

resource "aws_lambda_function" "lambda_get_birthday" {
  function_name    = "simple_serverless_website_get_birthday"
  s3_bucket        = var.lambda_repo
  s3_key           = var.lambda_code_getbirthday_filename
  role             = aws_iam_role.lambda_role.arn
  handler          = "getbirthday.lambda_handler"
  runtime          = "python3.8"
}

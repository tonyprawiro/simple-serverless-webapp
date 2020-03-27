variable "region" { type = string }
variable "account_id" { type = string }

variable "bucket_name" { type = string }

variable "api_deployed_at" { type = string }

variable "lambda_repo" { type = string }
variable "lambda_code_addbirthday_filename" { type = string }
variable "lambda_code_getbirthday_filename" { type = string }

variable "dynamodb_tablename" { type = string }
variable "dynamodb_billingmode" { type = string }
variable "dynamodb_read_cap" { type = number }
variable "dynamodb_write_cap" { type = number }

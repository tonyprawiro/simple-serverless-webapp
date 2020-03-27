resource "aws_dynamodb_table" "birthdays" {
  name           = var.dynamodb_tablename
  billing_mode   = var.dynamodb_billingmode
  read_capacity  = var.dynamodb_read_cap
  write_capacity = var.dynamodb_write_cap
  hash_key       = "username"

  attribute {
    name = "username"
    type = "S"
  }

}


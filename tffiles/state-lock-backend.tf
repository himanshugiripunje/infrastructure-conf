resource "aws_s3_bucket" "b4" {
  bucket = "bajli-${var.env}"
}
resource "aws_iam_user" "name" {
  name = "monu"
}

terraform {
  backend "s3" {
   bucket = "parass12"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    profile = "ram"
    dynamodb_table = "terraform-lock"
  }
}
resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
   name = "terraform-lock"
   hash_key = "LockID"
   read_capacity = 20
   write_capacity = 20
   attribute {
      name = "LockID"
      type = "S"
   }

}

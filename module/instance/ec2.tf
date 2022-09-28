data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  owners = ["amazon"]
}
# /////sg- group/////////////////
# data "aws_security_groups" "test" {
#   filter {
#     name   = "group-name"
#     values = ["*80,22*"]
#   }
# }
resource "aws_instance" "ec2" {
    ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  key_name = "public"
  tags = {
    type = "terraform-test-instance"
  }
}

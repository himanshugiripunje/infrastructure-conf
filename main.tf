# module "instance" {
#   source = "./module/instance"
#   instance_type = "t3.micro"
#   region = "us-east-2"
# }
# module "s3-bucket" {
#   source = "./module/bucket"
# }
resource "aws_security_group" "sg" {
  name = format("security-%s-%s", var.env, var.namespace)
  vpc_id = var.vpc_id
  
 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  }
}
# module "instance" {
#   source = "./module/instance"
#   instance_type = "t3.micro"
#   region = "us-east-2"
# }
# module "s3-bucket" {
#   source = "./module/bucket"
# }
# resource "aws_security_group" "sg" {
#   name = format("security-%s-%s", var.env, var.namespace)
#   vpc_id = var.vpc_id
#   dynamic "ingress" {
#   for_each = var.ingress
#   content {
#     description = ingress.value["description"]
#     from_port = ingress.value["from_port"]
#     to_port = ingress.value["to_port"]
#     protocol = ingress.value["protocol"]
#     cidr_blocks = ingress.value["cidr_blocks"]
#   }
#   }
# }
# resource "aws_security_group" "security" {
#   name        = "highsecurity"
#   vpc_id = var.vpc_id
#   for_each    = toset(var.port)
#   description = "bhjbckdb"
#   from_port   = each.value
#   to_port     = each.value
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }
resource "aws_security_group" "sg1" {
  name        = "hcnd"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each    = [22, 80, 8080]
    iterator    = port
    content {
    from_port   = port.value
    to_port     = port.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
}
# variable "s3" {
#   type = map(string)
#     default = {
#       "bucket_name" = "buck1.1"
#       "tags" = {
#         "name" = "mybucket"
#       }
#     }
# }
variable "env" {
  type    = string
  default = "dev"
}
variable "namespace" {
  type    = string
  default = "jam"
}
variable "vpc_id" {
  type    = string
  default = "vpc-00b95cf5c256be76c"
}
# variable "ingress" {
#   type = map(any)
#     default = {
#     "ssh" = {
#     description = "for ssh"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   },
#     "http" = {
#       description = "for apache"
#       from_port = 80
#       to_port = 80
#       protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     "apache" = {
#       description = "for apache tomcat"
#       from_port = 8080
#       to_port = 8080
#       protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

variable "port" {
  type    = list(any)
  default = ["22", "80", "8080"]
}
variable "description" {
  type    = list(any)
  default = ["ssh", "http", "tomiii"]
}


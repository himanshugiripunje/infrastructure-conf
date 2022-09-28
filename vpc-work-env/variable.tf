variable "cidr_block" {
  type = map(string)
  default = {
    "vpc"      = "10.0.0.0/16"
    "private1" = "10.0.8.0/21"
    "private2" = "10.0.16.0/21"
    "public1"  = "10.0.24.0/21"
    "public2"  = "10.0.32.0/21"
  }
}

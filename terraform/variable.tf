variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
}

variable "app_name" {
  type    = string
  default = "my-devops-demo"
}
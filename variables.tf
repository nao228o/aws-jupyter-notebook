variable "region" {
  type    = string
  default = "ap-northeast-1"
}


variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}


variable "instance_type" {
  type    = string
  default = "t2.micro"
}


variable "ami" {
  type    = string
  default = "ami-05506fa68391b4cb1"
}


variable "key_name" {
  type    = string
  default = "staging-key"
}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}


variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "env" {
  description = "環境名"
  type        = string
  default     = "staging"
}
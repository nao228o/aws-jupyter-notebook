variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "env" {
  description = "環境名"
  type        = string
  default     = "staging"
}

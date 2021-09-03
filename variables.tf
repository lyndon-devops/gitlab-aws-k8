variable "region" {
  type    = string
  default = "us-east-1"
}

variable "application_name" {
  type    = string
  default = "gitlab-demo"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
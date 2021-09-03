locals {
  common_tags = {
    Application = var.application_name
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "domain_root" {
  type    = string
  default = "headhuntr.io"
}

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

variable "eks_primary_instance_type" {
  default = "c5.xlarge"
}

variable "eks_secondary_instance_type" {
  default = "r5.xlarge"
}
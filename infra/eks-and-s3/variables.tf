variable "region" {
  description = "AWS region"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "training_suffix" {
  type = string
  description = "Suffix to avoid name collitions"
}
variable "region" {
  type = "string"
  description = "AWS region"
}

variable "profile" {
  type = "string"
  description = "AWS CLI configured profile to use"
}

variable "kms_name" {
  type = "string"
  description = "Name/Alias to assign to the KMS key"
}

variable "kms_description" {
  type = "string"
  description = "Description for the KMS key"
}

variable "owner" {
  type = "string"
  description = "Name of the department that owns this resource"
  default = "devops"
}

variable "environment" {
  type = "string"
  description = "development, staging or production environment"
  default = "staging"
}

## iam key pol; default
variable "key_policy" {
  description = "IAM policy to attach to the KMS key"
  type = "string"
  default = ""
}
# ---------------------------------------------------------------------------------------------------------------------
# AWS CMK KMS Terraform module
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
  profile = var.profile
}

locals {
  tags = {
    Name = var.kms_name
    Environment = lower(var.environment)
    Owner = lower(var.owner)
    Status = "active"
    ManagedBy = "terraform"
  }
}

resource "aws_kms_key" "kms_key" {
  description = var.kms_description
  key_usage = "ENCRYPT_DECRYPT"
  policy = "${var.key_policy}"
  deletion_window_in_days = "30"
  is_enabled = "true"
  enable_key_rotation = "true"
  tags = local.tags
}

resource "aws_kms_alias" "kms_alias" {
  name = "alias/${var.kms_name}"
  target_key_id = "${aws_kms_key.kms_key.key_id}"
}

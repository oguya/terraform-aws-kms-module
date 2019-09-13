output "kms_key_alias" {
  description = "Name of the KMS key"
  value = "${aws_kms_alias.kms_alias.name}"
}

output "kms_key_arn" {
  description = "ARN of the KMS key"
  value = "${aws_kms_key.kms_key.arn}"
}

output "kms_key_id" {
  value = "${aws_kms_key.kms_key.id}"
}

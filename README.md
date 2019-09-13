## Terraform AWS KMS Module

Terraform module for creating KMS Customer Managed Keys(CMK) on AWS.

### Usage

- CLI usage with default IAM key policy and TF variables in a vars. file:
    - clone this repo:

          $ git clone https://github.com/traveloka/terraform-aws-kms.git

    - create `example-vars-file.tfvars` vars file with the following content:

          region = "eu-west-1"
          profile = "default"
          kms_name = "xyz-app-kms-key"
          kms_description = "KMS key to encrypt and decrypt secret params. for XYZ staging service"

    - finally create KMS key:

          $ terraform apply -var-file=example-vars-file.tfvars

- Create KMS key with the default IAM key policy by importing module:

      module "kms-module" {
        source  = "github.com/oguya/terraform-aws-kms-module"
        region = "eu-west-1"
        profile = "default"
        kms_name = "zz-xyz-app-kms-key"
        kms_description = "KMS key to encrypt and decrypt XYZ staging service"
      }

- Create KMS key with a custom key policy containing key users/roles and admins:

      data "aws_caller_identity" "current" {}

      data "aws_iam_policy_doc" "key_policy" {
        statement {
          sid = "Enable IAM User Permissions"
          effect = "Allow"
          principals {
            type = "AWS"
            identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
          }
          actions = ["kms:*"]
          resources = ["*"]
        }
        statement {
          sid = "Allow access for Key Administrators"
          actions = [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource"
          ]
          resources = ["*"]
          effect = "Allow"
          principals {
            type = "AWS"
            identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/<AWS_USERNAME>"]
          }
        }
        statement {
          sid = "Allow use of the key"
          actions = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey",
          ]
          resources = ["*"]
          effect = "Allow"
          principals {
            type = "AWS"
            identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/<IAM_APP_INSTANCE_ROLE>"]
          }
        }
        statement {
          sid = "Allow attachment of persistent resources"
          actions = [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant*"
          ]
          resources = ["*"]
          effect = "Allow"
          principals {
            type = "AWS"
            identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/<IAM_APP_INSTANCE_ROLE>" ]
          }
          condition {
            test = "Bool"
            variable = "kms:GrantIsForAWSResource"
            values = [ "true" ]
          }
        }
      }

      module "kms-module" {
        source  = "modules/kms-module"
        region = "eu-west-1"
        profile = "default"
        kms_name = "zz-xyz-app-kms-key"
        kms_description = "KMS key to encrypt and decrypt XYZ staging service"
        environment = "staging"
        owner = "devops"
        key_policy = "${data.aws_iam_policy_doc.key_policy.json}"
      }

    > *NOTE*
    >
    > Replace `IAM_APP_INSTANCE_ROLE` & `AWS_USERNAME` with IAM instance role for your service and key admin username respectively

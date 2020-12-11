resource "aws_lambda_function" "lzards_backup_task" {
  function_name    = "${var.prefix}-LzardsBackup"
  filename         = "${path.module}/../../tasks/lzards-backup/dist/webpack/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../../tasks/lzards-backup/dist/webpack/lambda.zip")
  handler          = "index.handler"
  role             = var.lambda_processing_role_arn
  runtime          = "nodejs12.x"
  timeout          = 900
  memory_size      = 512

  layers = [var.cumulus_message_adapter_lambda_layer_version_arn]

  environment {
    variables = {
      CMR_ENVIRONMENT                  = var.cmr_environment
      stackName                        = var.prefix
      CUMULUS_MESSAGE_ADAPTER_DIR      = "/opt/"
      system_bucket                    = var.system_bucket
      launchpad_passphrase_secret_name = length(var.lzards_launchpad_passphrase) == 0 ? null : aws_secretsmanager_secret.lzards_launchpad_passphrase.name
      launchpad_certificate            = var.lzards_launchpad_certificate
      launchpad_api	                   = var.launchpad_api
      backup_role_arn                  = aws_iam_role.lambda_backup_role.arn
      lzards_api                       = var.lzards_api
      lzards_provider                  = var.lzards_provider
    }
  }

  dynamic "vpc_config" {
    for_each = length(var.lambda_subnet_ids) == 0 ? [] : [1]
    content {
      subnet_ids = var.lambda_subnet_ids
      security_group_ids = [
        aws_security_group.no_ingress_all_egress[0].id
      ]
    }
  }

  tags = var.tags
}

# Lambda backup role

data "aws_iam_policy_document" "lambda_backup_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [var.lambda_processing_role_arn]
    }

  }
}

resource "aws_iam_role_policy" "lambda_backup" {
  name   = "${var.prefix}_lambda_backup_policy"
  role   = aws_iam_role.lambda_backup_role.id
  policy = data.aws_iam_policy_document.lambda_backup_policy.json
}


resource "aws_iam_role" "lambda_backup_role" {
  name                 = "${var.prefix}-lambda-backups"
  assume_role_policy   = data.aws_iam_policy_document.lambda_backup_role_policy.json
  permissions_boundary = var.permissions_boundary_arn
  tags                 = var.tags
}

data "aws_iam_policy_document" "lambda_backup_policy" {
  statement {
    actions = [
      "s3:GetBucket*",
      "s3:ListBucket*",
    ]
    resources = [for b in local.all_non_internal_buckets : "arn:aws:s3:::${b}"]
  }
  statement {
    actions = [
      "s3:GetObject*"
    ]
    resources = [for b in local.all_non_internal_buckets : "arn:aws:s3:::${b}/*"]
  }
}

resource "aws_secretsmanager_secret" "lzards_launchpad_passphrase" {
  name_prefix = "${var.prefix}-lzards-launchpad-passphrase"
  description = "Launchpad passphrase for the lzards-backup task from the ${var.prefix} deployment"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "lzards_launchpad_passphrase" {
  count         = length(var.lzards_launchpad_passphrase) == 0 ? 0 : 1
  secret_id     = aws_secretsmanager_secret.lzards_launchpad_passphrase.id
  secret_string = var.launchpad_passphrase
}

data "aws_iam_policy_document" "lzards_processing_role_get_secrets" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [
      aws_secretsmanager_secret.lzards_launchpad_passphrase.arn,
    ]
  }
}

resource "aws_iam_role_policy" "lzards_processing_role_get_secrets" {
  name   = "${var.prefix}_lzards_processing_role_get_secrets_policy"
  role   = split("/", var.lambda_processing_role_arn)[1]
  policy = data.aws_iam_policy_document.lzards_processing_role_get_secrets.json
}

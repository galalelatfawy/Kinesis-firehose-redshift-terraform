# S3 bucket for 
resource "aws_s3_bucket" "bucket" {
  bucket = "jimdo-test-bkt"
  acl    = "private"
}

##################
# Kinesis Firehose Stream
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name        = "${var.app_name}_firehose_delivery_stream"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesis_stream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  //refer the more s3 configuration at https://docs.aws.amazon.com/firehose/latest/APIReference/API_ExtendedS3DestinationConfiguration.html
  extended_s3_configuration {
    role_arn        = aws_iam_role.firehose_role.arn
    bucket_arn      = aws_s3_bucket.bucket.arn
    buffer_size     = 1
    buffer_interval = "60"

  }
  redshift_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    cluster_jdbcurl    = "jdbc:redshift://${aws_redshift_cluster.redshift_cluster.endpoint}/${aws_redshift_cluster.redshift_cluster.database_name}"
    username           = "testuser"
    password           = "T3stPass"
    data_table_name    = "test-table"
    copy_options       = "delimiter '|'" # the default delimiter
    data_table_columns = "test-col"
    s3_backup_mode     = "Enabled"

    s3_backup_configuration {
      role_arn           = aws_iam_role.firehose_role.arn
      bucket_arn         = aws_s3_bucket.bucket.arn
      buffer_size        = 1
      buffer_interval    = "60"
      compression_format = "GZIP"
    }
  }
}

##################
# Kinesis Data Stream
resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.app_name
  shard_count      = var.shard_count
  retention_period = var.retention_period

  shard_level_metrics = var.shard_level_metrics

  tags = {
    owner = "${var.app_name}"
  }
}

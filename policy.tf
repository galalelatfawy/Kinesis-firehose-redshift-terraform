data "aws_caller_identity" "current" {}

resource "aws_iam_role" "firehose_role" {
  name = "${var.app_name}-firehose-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "read_policy" {
  name = "${var.app_name}-read-policy"

  //description = "Policy to allow reading from the ${var.stream_name} stream"
  role = aws_iam_role.firehose_role.id

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords"
         ],
         "Resource":[
            "arn:aws:kinesis:${var.region}:${data.aws_caller_identity.current.account_id}:stream/*"
         ]
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
         ],
         "Resource":[
            "${aws_s3_bucket.bucket.arn}"
         ]
      },
      {
         "Effect":"Allow",
         "Action":[
            "glue:GetTableVersions"
         ],
         "Resource":[
            "*"
         ]
      }
   ]
}
EOF
}
###########################
####################################
# IAM policy to grant full access control
resource "aws_iam_role_policy" "s3_full_access_policy" {
  name   = "redshift_s3_policy"
  role   = aws_iam_role.redshift_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}
####################################
# IAM Assume Role for Redshift

resource "aws_iam_role" "redshift_role" {
  name               = "redshift_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = "redshift-role"
  }
}

####################################
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.bucket
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "AWSLogDeliveryWrite20150319",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/AWSLogs/${var.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.account_id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs::${var.account_id}:*"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_name}",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.account_id}"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs::${var.account_id}:*"
                }
            }
        }
    ]
}
EOF
}

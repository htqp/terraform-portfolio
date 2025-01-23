provider "aws" {
  region = "eu-central-1"
}

# S3 Bucket
resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "nextjs-blog-bucket-htqp"
}

# Ownership control
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_control" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  rule {
    object_ownership = "BucketOwnerPrefferred"
  }
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "nextjs_public_access_block" {
  bucket                  = aws_s3_bucket.nextjs_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ACL
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.nextjs_bucket_ownership_control,
    aws_aws_s3_bucket_public_access_block.nextjs_public_access_block
  ]
  acl = "public-read"
}

# Bucket policy
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  policy = jsondecode(({
    version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.nextjs_bucket.arn}/*"
      }
    ]
  }))
}

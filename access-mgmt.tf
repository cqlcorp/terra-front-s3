resource "aws_iam_user" "s3_admin" {
    name = "${title(var.customer_name)}Admin"
    force_destroy = true   
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Cloudfront Origin Access Identity for ${title(var.customer_name)} s3 access"
}

//Policy for IAM 
data "aws_iam_policy_document" "s3_standard" {
    statement {
        sid = "1"

        actions = [
            "s3:ListBucket",
            "s3:GetBucketLocation"           
        ]        

        resources = [
            "arn:aws:s3:::${var.bucket_name}",
        ]
    }

    statement {
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"            
        ]

        resources = [
            "arn:aws:s3:::${var.bucket_name}/*",
        ]
    } 
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "1"
    effect = "Allow"
    actions   = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl",
    ]
    resources = [
        "arn:aws:s3:::${var.bucket_name}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }  
}

resource "aws_iam_policy" "s3_admin_policy" {
    name = "${title(var.customer_name)}S3AdminPolicy"
    policy = "${data.aws_iam_policy_document.s3_standard.json}"
}

# resource "aws_iam_role" "s3_admin_role" {
#     name = "${title(var.customer_name)}S3Admin"
#     assume_role_policy = "${data.aws_iam_policy_document.s3_standard.json}"
# }

resource "aws_iam_user_policy" "s3_user_policy" {
    name = "${title(var.customer_name)}S3UserPolicy"
    user = "${aws_iam_user.s3_admin.name}"
    policy = "${data.aws_iam_policy_document.s3_standard.json}"
}
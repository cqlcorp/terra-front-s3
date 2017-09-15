provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "aws_s3_bucket" "bucket" {
    bucket = "${var.bucket_name}"
    acl = "private"
    policy = "${data.aws_iam_policy_document.s3_bucket_policy.json}"

    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET,"POST"]
        allowed_origins = ["*"]
    }

    tags {
        Customer = "${var.customer_name}"        
    }
}


resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name= "${aws_s3_bucket.bucket.bucket_domain_name}"
        origin_id = "${title(var.customer_name)}S3Origin"     

        s3_origin_config {
            origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
        }   
    }

    enabled = true
    is_ipv6_enabled = true
    comment = "Cloudfront distribution for the S3 Bucket provisioned for ${title(var.customer_name)}"
    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "${title(var.customer_name)}S3Origin"

        forwarded_values {
            query_string = false            

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "allow-all"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
        compress = true
    }

    tags {
        Customer = "${var.customer_name}"
    }

    restrictions {
        geo_restriction {
            restriction_type = "blacklist"
            locations        = ["KP"]
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}

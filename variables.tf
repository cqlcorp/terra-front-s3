variable "region" {
    description = "The region this bucket will be deployed to or removed from"
    type = "string"
}

variable "access_key" {
    description = "The access key for your AWS account"
    type = "string"
}

variable "secret_key" {
    description = "The secret key for your AWS account"
    type = "string"
}

variable "bucket_name" {
    description = "The name of the bucket you would like to set up or destroy on S3"
    type = "string"
}

variable "customer_name" {
    description = "Customer that this bucket is being used for"
    type = "string"
}
locals {
  bucket_names = ["github-amitsaha-bucket"]
}

resource "aws_s3_bucket" "conf_bucket" {
  count = "${length(local.bucket_names)}"
  bucket = "${local.bucket_names[count.index]}"
}

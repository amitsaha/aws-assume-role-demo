resource "aws_iam_instance_profile" "iam_profile1" {
  name  = "test_profile1"
  role = "${aws_iam_role.role1.name}"
}

resource "aws_iam_role" "role1" {
  name = "test_profile1_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "assume_role2_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "${aws_iam_role.role2.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "role1_assume_role2" {
  name   = "AssumeRole2"
  role = "${aws_iam_role.role1.name}"
  policy = "${data.aws_iam_policy_document.assume_role2_policy.json}"
}
resource "aws_iam_instance_profile" "iam_profile2" {
  name  = "test_profile2"
  role = "${aws_iam_role.role2.name}"
}

resource "aws_iam_role" "role2" {
  name = "test_profile2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com",
               "AWS": "arn:aws::iam::${aws_caller_identity.current.account_id}:root"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "conf_bucket_access" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.conf_bucket.arn}",
    ]

  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.conf_bucket.arn}",
      "${aws_s3_bucket.conf_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "conf_bucket_access_policy" {
  name   = "AccessConfigurationBucket"
  role = "${aws_iam_role.role2.name}"
  policy = "${data.aws_iam_policy_document.conf_bucket_access.json}"
}

resource "aws_instance" "test1" {
  ami           = "ami-3248a350"
  instance_type = "t2.micro"

  key_name = "dev-key"
  iam_instance_profile = "${aws_iam_instance_profile.iam_profile1.arn}"
}

resource "aws_instance" "test2" {
  ami           = "ami-3248a350"
  instance_type = "t2.micro"

  key_name = "dev-key"
  iam_instance_profile = "${aws_iam_instance_profile.iam_profile2.arn}"
}


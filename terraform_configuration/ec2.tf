resource "aws_instance" "test1" {

  ami           = "ami-ff4ea59d"
  instance_type = "t2.micro"

  key_name = "dev-key"
  iam_instance_profile = "${aws_iam_instance_profile.iam_profile1.name}"
}

resource "aws_instance" "test2" {
  ami           = "ami-ff4ea59d"
  instance_type = "t2.micro"

  key_name = "dev-key"
  iam_instance_profile = "${aws_iam_instance_profile.iam_profile2.name}"
}

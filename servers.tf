provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "instance-01" {
  ami           = "ami-04d564b044eb0e5a0"
  instance_type = "t2.micro"
  key_name = "key-01"

  root_block_device {
    volume_type = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 16
    volume_type = "gp2"
    delete_on_termination = true
    encrypted = true
  }

  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  
 
  tags = {
    Name = "terraform-instance"
  }
 
}



resource "aws_iam_role" "ec2_firehose_access_role" {
  name               = "firehose-role-tf"
  assume_role_policy = "${file("role-policy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "firehose-access-policy"
  description = "A policy to allow full access to firehose"
  policy      = "${file("policy-firehose.json")}"
}

resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "policy-attachment"
  roles      = ["${aws_iam_role.ec2_firehose_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.ec2_firehose_access_role.name}"
}

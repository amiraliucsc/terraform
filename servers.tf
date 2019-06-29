provider "aws" {
  profile    = "default"
  region     = var.region
}


variable "region" {
  type    = string
}

variable "ami" {
type    = string
}

variable "instance_type" {
type    = string
}

variable "key_name" {
type    = string
}


variable "block_volume_type" {
type    = string
}


variable "ebs_volume_type" {
type    = string
}


variable "device_name" {
type    = string
}

variable "disk_size" {
type    = number
}

variable "security_groups" {
  type    = list(string)
}


resource "aws_instance" "instance-01" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name

  root_block_device {
    volume_type = var.block_volume_type
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = var.device_name
    volume_size = var.disk_size
    volume_type = var.ebs_volume_type
    delete_on_termination = true
    encrypted = true
  }
  vpc_security_group_ids = var.security_groups

  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"

  user_data = "${file("bootstrap.sh")}"

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

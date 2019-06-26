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

  
 
  tags = {
    Name = "terraform-instance"
  }
 
}

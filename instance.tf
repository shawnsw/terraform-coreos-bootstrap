# create key pair
resource "aws_key_pair" "coreos" {
  key_name   = "coreos-key"
  public_key = "${var.ssh_public_key}"
}

# create security group
resource "aws_security_group" "coreos" {
  name        = "coreos-sg"
  description = "Allow SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# create an instance
resource "aws_instance" "coreos" {
  ami           = "${data.aws_ami.coreos_stable_latest.image_id}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.coreos.key_name}"
  security_groups = ["${aws_security_group.coreos.name}"]

  # customise coreos
  user_data = "${data.ignition_config.coreos.rendered}"
  
  tags {
    Name = "coreos"
  }
}
resource "aws_instance" "private_isu" {
  ami                    = local.ami
  instance_type          = local.instance_type
  iam_instance_profile = aws_iam_instance_profile.admin.name
  subnet_id              = aws_subnet.public.id
  key_name = aws_key_pair.private_isu.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_http.id,
    aws_security_group.allow_ssh.id,
  ]
}

resource "aws_eip" "private_isu" {
  instance = aws_instance.private_isu.id
  vpc = true
}

resource "aws_instance" "benchmark" {
  ami                    = local.benchmark_ami
  instance_type          = local.benchmark_instance_type
  iam_instance_profile = aws_iam_instance_profile.admin.name
  subnet_id              = aws_subnet.public.id
  key_name = aws_key_pair.private_isu.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
  ]
}

resource "aws_security_group" "allow_http" {
  name   = "allow-http"
  vpc_id = aws_vpc.this.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name   = "allow-ssh"
  vpc_id = aws_vpc.this.id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "private_isu" {
  key_name   = "private_isu"
  public_key = file("/.ssh/id_rsa.private_isu.pub")
}

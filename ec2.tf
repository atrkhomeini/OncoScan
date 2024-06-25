#create instance
resource "aws_instance" "web" {
    ami ="ami-080660c9757080771"
    instance_type="t2.micro"
    security_groups =[aws_security_group.allow_tls.name]
    key_name = "tf-key"

    tags = {
        Name = "chest-cancerv4"}
  
}

# key pair
resource "aws_key_pair" "tf-key" {
  key_name = "tf-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa"{
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "TF-key" {
  content = tls_private_key.rsa.private_key_pem
  filename = "tf-key.pem"
}

#Security group
resource "aws_security_group" "allow_tls" {
  name        = "security group for chest-cancerv4"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0a578a14f972b5009"

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


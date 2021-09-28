data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["Default"]
  }
}

resource "aws_subnet" "example" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "172.31.48.0/20"
  map_public_ip_on_launch = true
}
data "template_file" "user_data" {
  template = "${file("install_jenkins.sh")}"
}

resource "aws_instance" "jenkins" {
  ami             = "ami-0443305dabd4be2bc"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.example.id
  security_groups = ["${aws_security_group.thiru-security-group.id}"]
  key_name        = "${aws_key_pair.petclinic.id}"
  user_data       = file("install_jenkins.sh")
  tags = {
    Name = "jenkins"
  }
}
output "jenkins_endpoint" {
  value = formatlist("/var/lib/jenkins/secrets/initialAdminPassword")
}
resource "aws_security_group" "thiru-security-group" {
  name        = "thiru-security-group"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    # SSH Port 22 allowed from any IP
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
      # SSH Port 80 allowed from any IP
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
      # SSH Port 80 allowed from any IP
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_key_pair" "petclinic" {
  key_name   = "petclinic-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDw4nMjzni41y5qlIWKGJD6VVmFDjDHfxcJ67ELx/y4TMACLHKMyXaDtIy4AElFrSsnZSFskRL+S5LJpg/x8fgFPXA3Y03qgxI23w4nGZE4tPuPKm3ryYwyoZbuJ48FHhONjxc7ZsxICkvmE5lpseIgzScIst03GXJmIAtE7glZoKw67FnkbnZnWacLXuRVb8wJeqpK3FO9cj9/4cbU6cxnGqEAI+5R1WiVdBw0mVknTPbNakiVQS+H742Lozbam1E422F6HLaymJhN8Kb7TgGKluntrDktRg5Odtkbnnsp4MEZHZzOIWn+vpM7MSrohCtbX5OK5a6TDOfIK6LN/phi+bmIm0ySRr7GyVMbAlyAKBJbbk7J5igEBmK7yY4NYUM54ozF/tExlDSMKi/Ai+bPSI4cUcV/kPp1MNpIlDvTcDI1xklfD2HNEogxoq/4Doc5wm+MWmqbN4ce/vUMrYkeq9vHJ9cZXbNOaLyy/J4Ddpu7m69j9HN0e8wRryKhDv8= girie@LAPTOP-JVC21MB8"
}
# Provider block
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("/Users/geraldoti/Documents/repos/darey/my-key.pub")
}


# Security group block
resource "aws_security_group" "application_sg" {
  name = "MY-SECURITY-GROUP"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "listenport"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

# EC2 instance
resource "aws_instance" "app_server" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.application_sg.id]
  key_name        = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  user_data       = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx

              # Create index.html with H1 tag in the default NGINX web directory
              echo "<h1>Hello From Ubuntu EC2 Instance!!!</h1>" | sudo tee /var/www/html/index.html

              # Update NGINX to listen on port 8080
              sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/g' /etc/nginx/sites-available/default

              # Restart NGINX to apply the changes
              sudo systemctl restart nginx
              EOF



  tags = {
    Name = var.instance_name
  }
}


# Create an AMI from the EC2 instance
resource "aws_ami_from_instance" "app_server_ami" {
  name               = "${var.instance_name}-ami"
  source_instance_id = aws_instance.app_server.id
  snapshot_without_reboot = true

  tags = {
    Name = "${var.instance_name}-ami"
  }
}


# Optional: Use the AMI to launch another instance

/* 

resource "aws_instance" "app_server_clone" {
  ami           = aws_ami_from_instance.app_server_ami.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.application_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name}-clone"
  }
}

*/

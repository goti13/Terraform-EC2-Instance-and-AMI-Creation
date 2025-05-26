# Terraform-EC2-Instance-and-AMI-Creation

Project Purpose:

The purpose of this project is to use Terraform to automate the creation of an EC2 instance on AWS and then create an Amazon Machine Image (AMI) from that instance.

Project Objectives:

1. Terraform Configuration:
- Learn how to write basic Terraform configuration files.
  
2. EC2 Instance Creation:
- Use Terraform to create an EC2 instance on AWS.
  
3. AMI Creation:
- Automate the creation of an AMl from the created EC2 instance.

Project Tasks:

Task 1: Terraform Configuration for EC2 Instance

- ﻿﻿﻿Create a new directory for your Terraform project (e.g., ' terraform-ec2-ami*).
- ﻿﻿﻿Inside the project directory, create a Terraform configuration file (e.g., 'main. tf*).
- ﻿﻿﻿Write Terraform code to create an EC2 instance. Specify instance type, key pair, security group, etc.
- ﻿﻿﻿Initialize the Terraform project using the command: 'terraform init'.
- ﻿﻿﻿Apply the Terraform configuration to create the EC2 instance using the command: ' terraform apply'.

```

# Provider block
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("${path.module}/my-key.pub")
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
  



  tags = {
    Name = var.instance_name
  }
}


```

![image](https://github.com/user-attachments/assets/95ace401-fa19-4dba-acf2-64997e440e3b)


![image](https://github.com/user-attachments/assets/78381483-f730-4ca3-88cc-760c880eed05)

![image](https://github.com/user-attachments/assets/27c5bb55-0696-45b1-9761-3a371071f5cd)

![image](https://github.com/user-attachments/assets/e830727d-36c7-4e92-89ad-2b3d807161bb)

![image](https://github.com/user-attachments/assets/48932f59-cabf-47f3-850e-c721c9f30f4d)

<img width="1326" alt="image" src="https://github.com/user-attachments/assets/b8d9aea8-b79a-4e63-a25d-b5761e78ee0e" />

<img width="1374" alt="image" src="https://github.com/user-attachments/assets/c175b802-8ec1-49b8-a7b0-27ecd3e9649a" />

<img width="1329" alt="image" src="https://github.com/user-attachments/assets/5c48421f-34af-468a-86a7-e370ec6264de" />




  
Task 2: AMI Creation

1. ﻿﻿﻿Extend your Terraform configuration to include the creation of an AMI.
2. ﻿﻿﻿Use provisioners in Terraform to execute commands on the EC2 instance after it's created. Install necessary packages or perform any setup required.
3. ﻿﻿﻿Configure Terraform to create an AMI from the provisioned EC2 instance.
4. ﻿﻿﻿Apply the updated Terraform configuration to create the AMl using the command: 'terraform apply'

```

# Provider block
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("${path.module}/my-key.pub")
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

```



![image](https://github.com/user-attachments/assets/7aa5fa52-1319-4461-ab39-4b78ef789586)


![image](https://github.com/user-attachments/assets/5d8b6def-ee9e-4d1e-a324-55f9e0998062)


![image](https://github.com/user-attachments/assets/8693a46e-d68c-45e2-bbb6-54a6ebcf613c)


<img width="1329" alt="image" src="https://github.com/user-attachments/assets/41d07876-f814-4e25-8a0a-cae23055f6f4" />


<img width="1367" alt="image" src="https://github.com/user-attachments/assets/5760c437-aab9-451c-923e-ab1199a36c6b" />


![image](https://github.com/user-attachments/assets/98c3e6af-7197-45c5-81ff-79fb16cce519)







Instructions:
1. ﻿﻿﻿Create a new directory for your Terraform project using a terminal ('mkdir terraform-ec2-ami*).
2. ﻿﻿﻿Change into the project directory ('cd terraform-ec2-ami').
3. ﻿﻿﻿Create a Terraform configuration file ('nano main.tf').
4. ﻿﻿﻿Copy and paste the sample Terraform configuration template into your file.

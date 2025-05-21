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
  
Task 2: AMI Creation

1. ﻿﻿﻿Extend your Terraform configuration to include the creation of an AMI.
2. ﻿﻿﻿Use provisioners in Terraform to execute commands on the EC2 instance after it's created. Install necessary packages or perform any setup required.
3. ﻿﻿﻿Configure Terraform to create an AMI from the provisioned EC2 instance.
4. ﻿﻿﻿Apply the updated Terraform configuration to create the AMl using the command: 'terraform apply'.
Instructions:
1. ﻿﻿﻿Create a new directory for your Terraform project using a terminal ('mkdir terraform-ec2-ami*).
2. ﻿﻿﻿Change into the project directory ('cd terraform-ec2-ami').
3. ﻿﻿﻿Create a Terraform configuration file ('nano main.tf').
4. ﻿﻿﻿Copy and paste the sample Terraform configuration template into your file.

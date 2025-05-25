variable "instance_type" {
  description = "AWS ec2 instance type"
  type = string
  default = "t2.micro"
}

variable "instance_name" {
  
  description = "Value of the name tag for the instance"
  type = string
  default = "my_terraform_instance"
}

variable "key_name" {
  description = "The name of the existing EC2 Key Pair"
  default     = "deployer-key" # Replace this with your real key pair name
}

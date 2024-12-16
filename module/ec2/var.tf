variable "ami_id"{
    description = "ami value" 
}

variable "instance_type" {
   description = "instances "
}

variable "subnet_id" {
    description = "subenetids"
  
}

variable "key_name" {
  description = "key pair"
}

variable "my_ip" {
  description = "Your IP address with CIDR block"
  default     = "0.0.0.0/0" # Replace this with your IP, e.g., "203.0.113.0/32" for specific access.
}

variable "vpc_id" {
  description = "The VPC ID where the instance is deployed"
}

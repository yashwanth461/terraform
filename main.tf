
module "vpc" {
  source = "./modules" # Path to the VPC module

  vpc_cidr           = "10.0.0.0/24"
  publicsubnet_cidr  = "10.0.0.0/25"
  privatesubnet_cidr = "10.0.0.128/25"
}


module "ec2" {
  source = "./module/ec2"
  ami_id ="ami-0aebec83a182ea7ea"
  instance_type="t2.micro"
  subnet_id= "subnet-0c105ed3f5b151fa0"
  key_name = "kube"
  vpc_id = "vpc-06b0e009e653d4bcd"
}




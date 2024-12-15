
module "vpc" {
  source = "./modules" # Path to the VPC module

  vpc_cidr           = "10.0.0.0/24"
  publicsubnet_cidr  = "10.0.0.0/25"
  privatesubnet_cidr = "10.0.0.128/25"
}






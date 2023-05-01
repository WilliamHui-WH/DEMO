variable "vpc_id" {
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "IDs of the public subnets"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "IDs of the private subnets"
}

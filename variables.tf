# creating region
variable "region" {
    default = "eu-west-2" 
    description = "AWS-region"
}

# creating vpc components
variable "aws_vpc-TSYS-VPC" {
    default     = "10.0.0.0/16"
    description = "Prod-rock-VPC-cidr_block"
}

# creating public subnet components
variable "aws_subnet-tsys-public-sub1" {
    default     = "10.0.1.0/24"
    description = "tsys-public-sub1"
}

variable "aws_subnet-tsys-public-sub2" {
    default     = "10.0.6.0/24"
    description = "tsys-public-sub1"
}

# creating private subnet components
variable "aws_subnet-tsys-private-sub1" {
    default     = "10.0.3.0/24"
    description = "tsys-private-sub1"
}

variable "aws_subnet-tsys-private-sub2" {
    default     = "10.0.4.0/24"
    description = "tsys-private-sub2"
}
# creating security group #
variable "aws_security_group-Tsys-sec-group" {
    default     = "Allow traffic from port 80 to port 22"
    description = "aws_security_group-Tsys-sec-group"
}
# Input Variables
variable "instance_type" {
  description = "EC2 Instance Type - Instance Sizing"
  type        = string
  default     = "t2.micro"
}

variable "REGION" {
  default = "us-west-2"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-west-2  = "ami-03d5c68bab01f3496"
    us-east-2  = "ami-00399ec92321828f5"
    ap-south-1 = "ami-0c1a7f89451184c8b"
  }
}

variable "USER" {
  default = "ubuntu"

}

variable "Private-key" {
  default = "cvengine"
}

variable "Public_key_path" {
  default = "cvengine.pub"
}

variable "MYIP" {
  default = "202.184.189.154/32"
}

/*variable "rmquser" {
  default = "rabbit"
}

variable "rmqpass" {
  default = "admin123"
}


variable "dbname" {
  default = "accounts"
}

variable "dbuser" {
  default = "admin"
}

variable "dbpass" {
  default = "admin123"
}

variable "instance_count" {
  default = "1"
}
*/

variable "vpc_name" {
  default = "dev-cvengine-vpc"
}

variable "zone1" {
  default = "us-west-2a"

}
variable "zone2" {
  default = "us-west-2b"

}
variable "zone3" {
  default = "us-west-2c"

}

variable "vpc-cidr" {

  default = "172.0.0.0/16"

}


variable "publicsubnet1" {

  default = "172.0.27.0/24"
}

variable "publicsubnet2" {

  default = "172.0.28.0/24"
}

variable "publicsubnet3" {

  default = "172.0.29.0/24"
}

variable "privatesubnet1" {

  default = "172.0.11.0/24"
}

variable "privatesubnet2" {

  default = "172.0.12.0/24"
}

variable "privatesubnet3" {

  default = "172.0.13.0/24"
}

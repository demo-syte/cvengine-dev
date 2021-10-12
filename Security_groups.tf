# Create Security Group - SSH Traffic
resource "aws_security_group" "cvengine-bastion-sg" {
  name        = "jumpbox-ssh-${terraform.workspace}"
  description = "Security Group for bastion host ec2 instances"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "cvengine-Bastion-sg"
    Owner       = "Roshan"
    Environment = "Dev"
  }
}

# Create Security Group - Web Traffic
resource "aws_security_group" "cvengine-backend-sg" {
  name        = "web-Traffic-${terraform.workspace}"
  description = "Security group for DB,active MQ,elastic cache"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /*ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  ingress {
    security_groups = [aws_security_group.cvengine-bastion-sg.id]
    description     = "Allow SSH access to Servers from Jumpbox"
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
  }

  ingress {
    from_port       = 80
    to_port         = 80
    description     = "Allow port 80 for ELB to access ec2 instances"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "cvengine-backend-sg"
    Owner       = "Roshan"
    Environment = "Dev"
  }
}
resource "aws_security_group_rule" "sec-allow_itself" {

  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cvengine-backend-sg.id
  source_security_group_id = aws_security_group.cvengine-backend-sg.id

}

# security Group for ELB LB

resource "aws_security_group" "elb-securitygroup" {
  vpc_id      = module.vpc.vpc_id
  name        = "elb-security Group"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "cvengine-elb-sg"
    Owner       = "Roshan"
    Environment = "Dev"
  }
}

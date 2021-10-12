resource "aws_instance" "cvengine-Bastion-1" {
  ami                    = lookup(var.AMIS, var.REGION)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.cvengine.key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.cvengine-bastion-sg.id]
  

  tags = {
    Name    = "cvengine-bastion"
    Project = "cvengine"
    Owner   = "Roshan"
  }
}
resource "aws_instance" "cvengine-Bastion-2" {
  ami                    = lookup(var.AMIS, var.REGION)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.cvengine.key_name
  subnet_id              = module.vpc.public_subnets[1]
  vpc_security_group_ids = [aws_security_group.cvengine-bastion-sg.id]
  

  tags = {
    Name    = "cvengine-bastion-2"
    Project = "cvengine"
    Owner   = "Roshan"
  }


}


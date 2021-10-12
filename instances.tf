# s3 Bucket resource

resource "aws_s3_bucket" "devcvengine-bucket" {
  bucket        = "dev-cvengine-bucket"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  #lifecycle {
    #prevent_destroy = true
  #}

  tags = {
    Name        = "Dev-CVProd-engine"
    Environment = "Dev"
    Owner       = "Roshan"
  }
}

#blocking public accessibility

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.devcvengine-bucket.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

# Dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "dev-cvengine-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}


# Create EC2 Instance - Ubuntu 20.0 LTS
resource "aws_instance" "ec2-web-1" {
  ami                    = lookup(var.AMIS, var.REGION)
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[0]
  key_name               = aws_key_pair.cvengine.key_name
  user_data              = file("apache-install.sh")
  vpc_security_group_ids = [aws_security_group.cvengine-backend-sg.id]
  tags = {

    "Name"    = "web-cvengine-1"
    "Project" = "Dev-cvengine"
    "Owner"   = "Roshan"
  }


}
resource "aws_instance" "ec2-web-2" {

  ami                    = var.AMIS[var.REGION]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.cvengine.key_name
  subnet_id              = module.vpc.private_subnets[1]
  user_data              = file("apache-install.sh")
  vpc_security_group_ids = [aws_security_group.cvengine-backend-sg.id]

  tags = {
    "Name"    = "web-cvengine-2"
    "Project" = "Dev-cvengine"
    "Owner"   = "Roshan"
  }

  /*provisioner "file" {
    source      = "tomcat.sh"
    destination = "/tmp/tomcat.sh"

  }

  provisioner "remote-exec" {

    inline = [
      "chmod u+x /tmp/tomcat.sh",
      "sudo /tmp/tomcat.sh"
    ]

  }
  connection {

    user        = var.USER
    private_key = file("cvengine")
    host        = self.public_ip
  }
*/
}

resource "aws_ebs_volume" "vol_dev-1" {
  availability_zone = var.zone1
  size              = 3
  tags = {

    Name = "extra-vol-1-dev"
  }
}

resource "aws_ebs_volume" "vol_dev-2" {
  availability_zone = var.zone2
  size              = 3
  tags = {

    Name = "extra-vol-2-dev"
  }
}

resource "aws_volume_attachment" "vol-devcvengine-attachment-1" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.vol_dev-1.id
  instance_id = aws_instance.ec2-web-1.id
}

resource "aws_volume_attachment" "vol-devcvengine-attachment-2" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.vol_dev-2.id
  instance_id = aws_instance.ec2-web-2.id
}


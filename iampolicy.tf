/*resource "aws_iam_role" "test_role" {
name = "test_role"
assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Action": "sts:AssumeRole",
"Principal": {
"Service": "ec2.amazonaws.com"
},
"Effect": "Allow",
"Sid": ""
}
]
}
EOF
tags = {
tag-key = "tag-value"
}
}


#Create EC2 Instance Profile
resource "aws_iam_instance_profile" "test_profile" {
name = "test_profile"
role = "${aws_iam_role.test_role.name}"
}


#Adding IAM Policies
#To give full access to S3 bucket
resource "aws_iam_role_policy" "test_policy" {
name = "test_policy"
role = "${aws_iam_role.test_role.id}"
policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Action": [
"S3:*"
],
"Effect": "Allow",
"Resource": "*"
}
]
}
EOF
}

/*resource "aws_instance" "role-test" {
ami = "ami-0bbe6b35405ecebdb"
instance_type = "t2.micro"
iam_instance_profile =
"${aws_iam_instance_profile.test_profile.name}"
key_name = "mytestpubkey"
}*/
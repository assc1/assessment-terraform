# Configuration related to IAM users

 resource "aws_iam_user" "ludes_ssm_user" {
   name          = "ludes-ssm-user"
   path          = "/"
   force_destroy = true

   tags = {
     "Name" = "ludes-ssm-user"
   }
 }

 # IAM Policy with assume role to EC2
 data "aws_iam_policy_document" "ec2_assume_role" {
   statement {
     actions = ["sts:AssumeRole"]

     principals {
       type        = "Service"
       identifiers = ["ec2.amazonaws.com"]
     }
   }
 }

 # Configure IAM role
 resource "aws_iam_role" "ludes_ec2_admin" {
   name                = "ludes-ec2-admin"
   path                = "/"
   assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role.json
 }

 # Configure IAM instance profile
 resource "aws_iam_instance_profile" "ludes_ec2_admin" {
   name = "ludes-ec2-admin"
   role = aws_iam_role.ludes_ec2_admin.name
 }

 # Configuration related to IAM policies

 resource "aws_iam_user_policy" "ludes_ssm_user" {
   name = "ludes-ssm-user"
   user = aws_iam_user.ludes_ssm_user.name

   policy = file("./json-policies/ludes-ssm-user.json")
 }

 resource "aws_iam_role_policy" "ludes_ec2_admin" {
   name = "ludes-ec2-admin"
   role = aws_iam_role.ludes_ec2_admin.id

   policy = file("./json-policies/ludes-ec2-admin.json")
 }

 
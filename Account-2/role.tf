data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2-session-s3-role" {
    name = "ec2-session-s3-role-combined"
    assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
    managed_policy_arns = [aws_iam_policy.policy_s3.arn, aws_iam_policy.policy_ec2.arn]
    }


resource "aws_iam_policy" "policy_s3" {
  name = "policy-618033"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1644200565295",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
})
}


resource "aws_iam_policy" "policy_ec2" {
  name = "policy-381966"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
)
}

resource "aws_iam_role_policy_attachment" "default" {
    role       = aws_iam_role.ec2-session-s3-role.name
    policy_arn = aws_iam_policy.policy_s3.arn
  }

resource "aws_iam_role_policy_attachment" "default1" {
    role       = aws_iam_role.ec2-session-s3-role.name
    policy_arn = aws_iam_policy.policy_ec2.arn
  }


resource "aws_iam_instance_profile" "s3_ec2_admin_profile" {
   name = "s3_admin_profile"
   role = aws_iam_role.ec2-session-s3-role.name
 }
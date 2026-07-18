resource "aws_iam_role" "george_ha_iam" {
  name = "george-ha-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy" "george_ha_iam_policy" {
  name = "george-ha-iam-policy"
  role = aws_iam_role.george_ha_iam.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
            "ec2:Describe*",
            "s3:GetObject",
            "s3:ListBucket"
            ]
            Effect   = "Allow"
            Resource = "*"
        },
        ]   
    })
        
}

resource "aws_iam_instance_profile" "george_ha_instance_profile" {
  name = "george-ha-instance-profile"
  role = aws_iam_role.george_ha_iam.name
}
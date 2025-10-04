provider "aws" {
  region = "us-east-1" # Change as needed  
  profile = "" # Change profile as needed
}

resource "aws_iam_role" "symetri-role" {
  name = "symetri-audit-scan-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::182399714842:user/backend_user"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "unique-external-id-value" # Replace with your actual external ID  
          }
        }
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "security_audit_policy" {
  role = aws_iam_role.symetri-role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "view_only_policy" {
  role = aws_iam_role.symetri-role.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_policy" "inventory_collect_policy" {
  name = "inventory_collect_policy"
  description = "Allows inventory collection operations"
  policy = file("${path.module}/inventory_collect_policy.json")
}

resource "aws_iam_policy" "inventory_mutate_policy" {
  name = "inventory_mutate_policy"
  description = "Allows inventory mutation operations"
  policy = file("${path.module}/inventory_mutate_policy.json")
}

resource "aws_iam_policy" "inventory_collect_policy_2" {
  name = "inventory_collect_policy_2"
  description = "Allows inventory collection operations"
  policy = file("${path.module}/inventory_collect_policy_2.json")
}

resource "aws_iam_role_policy_attachment" "attach_inventory_collect" {
  role = aws_iam_role.symetri-role.name
  policy_arn = aws_iam_policy.inventory_collect_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_inventory_mutate" {
  role = aws_iam_role.symetri-role.name
  policy_arn = aws_iam_policy.inventory_mutate_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_inventory_collect_2" {
  role = aws_iam_role.symetri-role.name
  policy_arn = aws_iam_policy.inventory_collect_policy_2.arn
} 

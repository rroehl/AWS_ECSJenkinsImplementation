resource "aws_iam_role" "RootRole" {
  name = "RootRole"
  path = "/"
  assume_role_policy =  data.aws_iam_policy_document.RootRole-policy-doc.json
}

# Roles, policy doc, and policy
data "aws_iam_policy_document" "RootRole-policy-doc" {
	version = "2012-10-17"
  	statement {
	    actions = ["sts:AssumeRole"]
	    effect =  "Allow"

	    principals {
	      type        = "Service"
	      identifiers = ["ec2.amazonaws.com"]
    	}
    }
}

resource "aws_alb" "web_alb" {
  name                       = "web-load-balancer"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.web_sg.id]
  enable_deletion_protection = true
  internal                   = false
  subnets                    = [aws_subnet.web_subnet_1.id, aws_subnet.web_subnet_2.id]


  access_logs {
    bucket  = aws_s3_bucket.tf_remote_state_dev.bucket
    prefix  = "alb_3tier"
    enabled = true
  }

}

resource "aws_lb_target_group" "web_alb_tg" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.three_tier_vpc.id
}


resource "aws_lb_target_group_attachment" "external-alb1" {
  target_group_arn = aws_lb_target_group.web_alb_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80

  depends_on = [
    aws_instance.web1,
  ]
}

# resource "aws_lb_target_group_attachment" "external-alb2" {
#   target_group_arn = aws_lb_target_group.web_alb_tg.arn
#   target_id        = aws_instance.web2.id
#   port             = 80

#   depends_on = [
#     aws_instance.web2,
#   ]
# }

resource "aws_lb_listener" "external-listener" {
  load_balancer_arn = aws_alb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
}


# Policy for access logs

resource "aws_s3_bucket_policy" "allow_access_from_alb" {
  bucket = aws_s3_bucket.tf_remote_state_dev.id
  policy = data.aws_iam_policy_document.allow_access_from_alb_doc.json
}

data "aws_iam_policy_document" "allow_access_from_alb_doc" {
  statement {
    actions = ["s3:PutObject"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::156460612806:root"]
    }

    resources = ["arn:aws:s3:::3tier-app-backend/alb_3tier/AWSLogs/708277680250/*"]
  }
  statement {
    actions = ["s3:PutObject"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control",
      ]
    }

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    resources = ["arn:aws:s3:::3tier-app-backend/alb_3tier/AWSLogs/708277680250/*"]
  }

  statement {
    actions = ["s3:GetBucketAcl"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    resources = ["arn:aws:s3:::3tier-app-backend"]
  }

  version = "2012-10-17"
}


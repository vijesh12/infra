# execution role - logs access, ecr pull image
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.environment}-backend-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_task_execution" {
  name        = "${var.environment}-backend-execution"
  path        = "/"
  description = "backend task execution policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "${aws_ecr_repository.backend.arn}"
    },
    {
      "Effect": "Allow",
      "Action": "ecr:GetAuthorizationToken",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": [
          "${aws_cloudwatch_log_group.backend.arn}:log-stream:*",
          "${aws_cloudwatch_log_group.backend.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "exec-attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}


# task role - empty for now
resource "aws_iam_role" "ecs_task" {
  name = "${var.environment}-backend-task"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# resource "aws_iam_policy" "ecs_task" {
#   name        = "${var.environment}-backend"
#   path        = "/"
#   description = "backend task policy"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "task-attach" {
#   role       = aws_iam_role.ecs_task.name
#   policy_arn = aws_iam_policy.ecs_task.arn
# }
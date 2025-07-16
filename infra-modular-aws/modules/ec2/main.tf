resource "aws_iam_role" "ec2_ssm" {
  count = var.enable_ssm ? 1 : 0

  name = "${var.name}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  }

resource "aws_iam_policy" "ec2_ssm_s3_policy" {
  count = var.enable_ssm ? 1 : 0
  name = "${var.name}-ec2-ssm-s3-policy"
  description = "Allows SSM access and full access to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
      Sid: "SSMSessionManagement",
      Effect: "Allow",
      Action: [
        "ssm:*",
        "ssmmessages:*",
        "ec2messages:*"
      ],
      Resource: "*"
    },
    {
      Sid: "FullS3Access"
      Effect: "Allow",
      Action: "s3:*",
      Resource: "*"
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_custom_policy" {
  count = var.enable_ssm ? 1 : 0
  role = aws_iam_role.ec2_ssm[0].name
  policy_arn = aws_iam_policy.ec2_ssm_s3_policy[0].arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.enable_ssm ? 1 : 0
  name = "${var.name}-instance-profile"
  role = aws_iam_role.ec2_ssm[0].name
}

resource "aws_security_group" "web_sg" {
  name = "${var.name}-sg"
  description = "Allow SSH and HTTP"
  vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    Name = "${var.name}-sg"
    }
}

resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data = var.user_data
  iam_instance_profile = var.enable_ssm ? aws_iam_instance_profile.ec2_profile[0].name : null

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  dynamic "ebs_block_device" {
    for_each = var.additional_ebs_volumes
    content {
      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      delete_on_termination = true
    }
  }
  tags = {
    Name = var.name
  }
}
resource "aws_launch_template" "george_ha_launchtemplate" {
  name_prefix   = "george-ha-lt-"
  image_id      = var.ami
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.george_ha_sg.id]
  }

     user_data = filebase64("userdata.sh")
     iam_instance_profile {
    name = aws_iam_instance_profile.george_ha_instance_profile.name
     }

}

resource "aws_autoscaling_group" "george_autoscaling_group" {
  name                = "george-ha-asg"
  max_size            = 6
  min_size            = 3
  desired_capacity    = 3
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.george_ha_launchtemplate.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "george-ha-asg"
    propagate_at_launch = true
  }
  target_group_arns = [aws_lb_target_group.george_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
 

}



resource "aws_autoscaling_attachment" "george_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.george_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.george_tg.arn # New argument
}


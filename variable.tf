variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
  default     = "vpc-0f8ffa69427e755ff"
}

variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-01edba92f9036f76e"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling group"
  type        = list(string)
  default     = ["subnet-04eff04788c28873e", "subnet-08a5324bee0d68c14", "subnet-09e89ecbfee521bc8"]
}

variable "route53_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
  default     = "Z1R8UBAEXAMPLE"
}

variable "route53_record_name" {
  description = "The name of the Route 53 record"
  type        = string
  default     = "george-ha.com"
}
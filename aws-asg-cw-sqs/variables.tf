variable "aws_region" {}
variable "aws_profile" {}
variable "custom_ami" {}
variable "custom_subnets" { default = [] }
variable "security_groups" {}
variable "iam_profile" {}
variable "instance_type" {}
variable "snapshot_id" {}
variable "assume_role_arn" {}
variable "role_arn" {}
variable "key_name" {}
variable "asg_max" {}
variable "asg_min" {}

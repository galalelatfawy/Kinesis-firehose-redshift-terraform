# Declare the AZs data source
variable "region" {
  description = "The AWS region we want this bucket to live in."
  default     = "us-west-2"
}
data "aws_availability_zones" "azs" {}

locals {
  web_ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      description = "Https port"
      protocol    = "tcp"
      cidr_blocks = var.vpc_cidr
    },
    {
      from_port   = 80
      to_port     = 80
      description = "http port"
      protocol    = "tcp"
      cidr_blocks = var.vpc_cidr
    }
  ]
  self_ingress_rules = [
    {
      from_port   = 0
      to_port     = 0
      description = "allow-all access"
      protocol    = "-1"
      self        = true
    }
  ]
  redshift_ingress_rules = [
    {
      from_port   = 5439
      to_port     = 5439
      description = "redshift port"
      protocol    = "-1"
      cidr_blocks = var.redshift_cidr
    }
  ]
}

variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "env_name" {
  type = string
}

variable "private_subs" {
  type = list(any)
}
variable "public_subs" {
  type = list(any)
}



variable "commontags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default = {
    account = "test-acc"
    SDLC    = "test"
  }
}
#############################
# Kinesis Variables

variable "app_name" {
  description = "The Kinesis App Name."
  default     = "teraform-kinesis"
}

variable "shard_count" {
  description = "The number of shards that the stream will use."
  default     = "1"
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream."
  default     = "24"
}

variable "shard_level_metrics" {
  type        = list(string)
  description = "A list of shard-level CloudWatch metrics which can be enabled for the stream."
  default = [
    "IncomingBytes",
    "OutgoingBytes"
  ]
}

#########################################
# RedShift Variables
variable "redshift_subs" {
  type = list(any)
}
variable "redshift_sg_name" {
  type = string
}
variable "redshift_cidr" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "rs_cluster_identifier" {}
variable "rs_database_name" {}
variable "rs_master_username" {}
variable "rs_master_pass" {}
variable "rs_nodetype" {}
variable "rs_cluster_type" {}
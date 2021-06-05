# Create A New VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
    env  = var.env_name
  }

}


# create 3 Private Subnets in created VPC
resource "aws_subnet" "private_subnets" {
  count             = length(data.aws_availability_zones.azs.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subs, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  tags = {
    Name = "pvt-sub-${element(data.aws_availability_zones.azs.names, count.index)}"
    env  = var.env_name
  }
}


# create 3 Public Subnets in created VPC
resource "aws_subnet" "public_subnets" {
  count             = length(data.aws_availability_zones.azs.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subs, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)

  tags = {
    Name = "pub-sub-${element(data.aws_availability_zones.azs.names, count.index)}"
    env  = var.env_name
  }
}



# Open access SG for generic access
resource "aws_security_group" "allow_all" {
  name   = "allow_all"
  vpc_id = aws_vpc.main.id
  dynamic "ingress" {
    for_each = local.web_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      description = ingress.value.description
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr_blocks]
    }
  }
  tags = merge(
    {
      "Name" = format("%s", "allow_all")
    },
    var.commontags,
  )

}

# # Create IGW
# resource "aws_internet_gateway" "default_vpc_gw" {
#   vpc_id = aws_vpc.main.id
# depends_on = [
#     "aws_vpc.main"
#   ]
# }

###################################

# create security group for redshift
resource "aws_security_group" "redshift" {
  name   = "redshfit_sg"
  vpc_id = aws_vpc.main.id
  dynamic "ingress" {
    for_each = local.web_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      description = ingress.value.description
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr_blocks]
    }
  }
  #   dynamic "ingress" {
  #   for_each = local.self_ingress_rules
  #   content {
  #     from_port   = ingress.value.from_port
  #     to_port     = ingress.value.to_port
  #     description = ingress.value.description
  #     protocol    = ingress.value.protocol
  #     self = ingress.value.self
  #   }
  # }
  tags = merge(
    {
      "Name" = format("%s", var.redshift_sg_name)
    },
    var.commontags,
  )

}
#############################
# RedShift Subnets

resource "aws_subnet" "redshift_subs" {
  count             = length(data.aws_availability_zones.azs.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.redshift_subs, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  tags = {
    Name  = "redshift-sub-${element(data.aws_availability_zones.azs.names, count.index)}"
    env   = var.env_name
    usage = "redshift"
  }
}
#############################
# Redshift SubnetGroup

# data "aws_subnet_ids" "subs_id" {
#     vpc_id = aws_vpc.main.id
#     filter {
#         name   = "tag:usage"
#         values = ["redshift"]
#     }
#     depends_on = [aws_subnet.redshift_subs]
# }

# data "aws_subnet" "subs" {
#   for_each = data.aws_subnet_ids.subs_id.ids
#   id       = each.value
# }

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name = "redshift-subnet-group"
  #   subnet_ids = [for s in data.aws_subnet.subs : s.cidr_block]
  subnet_ids = aws_subnet.redshift_subs.*.id
  tags = {
    environment = "dev"
    Name        = "redshift-subnet-group"
  }
}

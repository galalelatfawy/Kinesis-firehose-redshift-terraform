

##########################
# Redshift Cluster

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier        = var.rs_cluster_identifier
  database_name             = var.rs_database_name
  master_username           = var.rs_master_username
  master_password           = var.rs_master_pass
  node_type                 = var.rs_nodetype
  cluster_type              = var.rs_cluster_type
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.id
  publicly_accessible       = false
  encrypted                 = false
  skip_final_snapshot       = true
  iam_roles                 = [aws_iam_role.redshift_role.arn]
  depends_on = [
    aws_vpc.main,
    aws_security_group.redshift,
    aws_redshift_subnet_group.redshift_subnet_group,
    aws_iam_role.redshift_role
  ]
}
####################################

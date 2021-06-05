vpc_name     = "testing-vpc"
vpc_cidr     = "10.0.0.0/16"
env_name     = "testing"
private_subs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24", "10.0.105.0/24"]
public_subs  = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24", "10.0.204.0/24", "10.0.205.0/24"]

# commontags  =   { 
#     svc = testing
#     enabled = yes
#                 }
##############################
# RedShift
rs_cluster_identifier = "jimdo-cluster"
rs_database_name      = "jimdocluster"
rs_master_username    = "jimdo"
rs_master_pass        = "jimdoTest1"
rs_nodetype           = "dc2.large"
rs_cluster_type       = "single-node"
redshift_subs         = ["10.0.31.0/24", "10.0.32.0/24", "10.0.33.0/24", "10.0.34.0/24", "10.0.35.0/24"]
redshift_sg_name      = "redshift_sg"
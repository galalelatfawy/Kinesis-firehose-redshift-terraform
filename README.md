# Terraform - kinesis firehose to redshift

## Usage
this code used to created Data Pipeline to deliver input data to S3 bucket and firehose will pick it up and place it in redshift cluster
## Components
- S3 Bucket
- IAM Roles
- VPC
- Subnets (Public - Private - redshift)
    - didn't create IGW and public routing for cost savings :)
    - number of Subnets depends on the number of AZs in the region 
- Security Groups (Generic / redshift)
- Kinesis firehose 
- redshift cluster

## List of files
- kinesis.tf : contains all kinesis required resources like:
    - S3 bucket
    - IAM role
    - Kinesis 
- main.tf : contains basic setup like:
    - VPC 
    - subnets
    - SGs
- redshift.tf
    - variables
    - SGs
    - subnet
    - subnet group
    - IAM Policy / Role
    - redshift cluster

# notes:
``` 
- I didn't create the cluster in a separate AWS account , but the concept is to use IAM cross accounts assume roles 
- disables snapshots which can be used to re-import the data to the cluster 
```

# Deployment Steps:
```
terraform init
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve

```
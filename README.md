# Terraform - kinesis firehose to redshift

## Usage
this Terraform code used to created Data Pipeline including 
- Kineses Data stream
- Kineses Firehose
- Redshift Cluster
- S3 Bucket
- IAM Roles/Policies
- VPC
- Subnets (Public - Private - redshift)
    - didn't create IGW and public routing for cost savings :)
    - number of Subnets depends on the number of AZs in the region 
- Security Groups (Generic / redshift)


# notes:
``` 
- I didn't create the cluster in a separate AWS account , but the concept is to use IAM cross accounts assume roles 
- I have disabled snapshots which can be used to re-import the data to the cluster 
- Public Accessability is Disabled
- Didn't create the Schema for Redshift and test sending data to the Kineses Data stream
```

# Deployment Steps:
```
terraform init
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve

```
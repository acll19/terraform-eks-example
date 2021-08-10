## Prerequisites
The Terraform CLI (1.0.4) installed.
The AWS CLI installed.
An AWS account.
Your AWS credentials. You can create a new Access Key on this page. https://console.aws.amazon.com/iam/home?#/security_credentials

## Steps:
    1. Create a policy
        Select JSON and past this https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
    2. Create new user named terraform
    Permission:
        Select attach existing policy
            AmazonS3FullAccess
            The Terraform EKS Policy previously created
    3. Configure your aws cli with the new user's credentials by running `aws configure`

## Commands
    terraform init
    terraform validate
    terraform apply -var-file=variables.tfvars
    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
    kubectl get nodes -owide
    kubectl get pod -n application
    kubectl describe configmap app-config -n application
    kubectl describe secret -n application aws-s3-user-creds
    kubectl port-forward <pod-name> 3000:3000 -n application

## Sources
https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
https://learn.hashicorp.com/tutorials/terraform/eks
https://github.com/hashicorp/learn-terraform-provision-eks-cluster
https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
https://github.com/hashicorp/terraform-provider-kubernetes
https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace

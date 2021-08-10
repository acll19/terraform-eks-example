To follow this tutorial you will need:

    The Terraform CLI (1.0.4) installed.
    The AWS CLI installed.
    An AWS account.
    Your AWS credentials. You can create a new Access Key on this page. https://console.aws.amazon.com/iam/home?#/security_credentials

Steps:
    1. Create a policy
        Select JSON and past this https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
    2. Create new user named terraform
    Permission:
        Select attach existing policy
            AmazonS3FullAccess
            The Terraform EKS Policy previously created
    3. Configure your aws cli with the new user's credentials by running `aws configure`

    
    ```
    terraform init
    terraform validate
    terraform apply -var-file=variables.tfvars
    kubectl get nodes -owide
    kubectl get pod -n application
    kubectl describe configmap app-config -n application
    kubectl describe secret -n application aws-s3-user-creds
    ```

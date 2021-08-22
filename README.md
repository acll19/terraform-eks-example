# Terraform EKS Example

This repo will help you provision an EKS cluster with basic configuration with Terraform. It will also create a S3 bucket. Besides that you will find an ExpreseJS "Hello World" application that reads your name from a URL query parameter and creates a file that contains your name and stores it in the S3 bucket.

## Prerequisites

* The Terraform CLI (v1.0.4) installed.
* The AWS CLI (v2.2.27) installed.
* An AWS account*.

(*) Keep in mind that creating the resources described in this repo may infer in charges from AWS

## How to run

### Set up AWS

#### Create a new IAM policy

1. Go to IAM page in the AWS Console
2. Then Access management > [Policies](https://console.aws.amazon.com/iamv2/home?#/policies)
3. Click on Create Policy
4. Give it a name
5. Select JSON and paste the JSON in [terraform-user-policy.json](./terraform-user-policy.json)*

(*) Minimum permissions needed for your IAM user or IAM role to create an EKS cluster. Taken from the terraform-aws-modules [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md)

#### Create a new IAM user for Terraform

1. Go to IAM page in the AWS Console
2. Then Access management > [Users](https://console.aws.amazon.com/iam/home#/users)
3. Click on Add users
4. Provide a name
5. In the permissions step select the following:
    * `AmazonS3FullAccess`
    * The Terraform EKS Policy previously created

#### Create a new Access key for the Terraform's user

Now that you have a new user, you need to attach an access key to that user. These are the credentials you are going to use to configure your aws cli.

1. Go to IAM page in the AWS Console
2. Then Access management > [Users](https://console.aws.amazon.com/iam/home#/users)
3. Select the previously created user, then,
4. Select the [Security credentials](https://console.aws.amazon.com/iam/home#/users/terraform?section=security_credentials) tab
5. Finally click on Create access key

#### Configure your AWS cli

Configure your aws cli with the new user's credentials by running `aws configure`

### Create the EKS cluster and S3 bucket with Terraform

1. Go inside the `infra` folder
2. Create a folder named `tf_user`
3. Inside the `tf_user` folder create a text file named `credentials` and past your Access key details. It should look like this:

    ```Javascript
    [default] // Replace this with the AWS profile you are using
    aws_access_key_id = <your_aws_access_key_id>
    aws_secret_access_key = <your_aws_secret_access_key>
    ```

4. Go inside the `eks-and-s3` folder
5. Run `terraform init`
6. Run `terraform validate`
7. If everything is fine run `terraform apply -var-file=variables.tfvars`
8. Run `kubectl get nodes -owide` to see the cluster node.

Terraform will start creating all the resources needed to spin up an EKS cluster plus a S3 bucket. This may take around 10 minutes.

### Configure kubectl

Now that you have an EKS cluster you can configure your `kubectl` cli to connect to it from your terminal. To do so, you can use the `eks` command as follows `aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`. This also references the output variables created by terraform in the previous step.

### Create the K8S resources the application needs

For the Hello World application to run properly we need to create some configuration data first: a kubernetes secret to store the AWS user credentials for the application to write in AWS S3 and a kubernetes config map to store the bucket name the application will be writing to (keep in mind that the name needs to be globally unique)

#### Create a new user for application

Before we do that we need to create a new user for the application, so we can grant it access to S3 only.

1. Go to IAM page in the AWS Console
2. Then Access management > [Users](https://console.aws.amazon.com/iam/home#/users)
3. Click on Add users
4. Provide a name
5. In the permissions step select `AmazonS3FullAccess`

#### Create a new Access key for the application's user

Now that you have a new user, you need to attach an access key to that user. These are the credentials you are going to store in the K8S secret.

1. Go to IAM page in the AWS Console
2. Then Access management > [Users](https://console.aws.amazon.com/iam/home#/users)
3. Select the previously created user, then,
4. Select the [Security credentials](https://console.aws.amazon.com/iam/home#/users/terraform?section=security_credentials) tab
5. Finally click on Create access key

#### The variables-template.tfvars

To provision these K8S resources we need to provide variables to the `terraform apply` command. Similarly to how it was done for creating the EKS cluster.
The [variables-template.tfvars](./infra/k8s/variables-template.tfvars) file has a needed variables. So all you need to do is provide the right values.

```Javascript
aws_app_access_key     = "<ACCESS_KEY>" // Access key for the application's user
aws_app_access_token   = "<SECRET_ACCESS_KEY>"// Access key secret for the application's user
k8s_cluster_name       = "<CLUSTER_NAME>" // EKS cluster name
aws_profile            = "<PROFILE>" // AWS profile you are using
region                 = "<REGION>" // The AWS region you are using
```

Then change the name of the file to `variables.tfvars`

These variable are used to configure the AWS Terraform provider in [providers.tf](./infra/k8s/providers.tf)

#### Run Terraform apply

Now that you have everything set up, the next thing to do is use Terraform to apply your resource declaration

1. Go inside the `k8s` folder
2. Run `terraform init`
3. Run `terraform validate`
4. If everything is fine run `terraform apply -var-file=variables.tfvars`

### The application

This repo provides a simple Hello World ExpressJS application that reads an input from a URL query string and saves it in a text file in an AWS bucket. It reads the AWS credentials from environment variables.

You can find the application code inside the `app` folder. [app.js](./app/app.js) contains the NodeJS code. [deployment.yaml](./app/deployment.yaml) contains the K8S manifest to create a deployment in the EKS cluster to manage the application and [Dockerfile](./app/Dockerfile) will help you build a Docker image for your application

#### Build the image

1. Go inside the `app` folder
2. Run `docker build . -t <your-docker-hub-username>/s3-express-app`

The intention here is to publish the image in your Docker Hub account, but you can use any Docker registry you like. Also, the name of the image could be anything you like.

#### Push your docker image

1. Run `docker login` if you haven't already, then,
2. run the following command:
`docker push <your-docker-hub-username>/s3-express-app`

#### Deploy your application

1. Open the [deployment.yaml](./app/deployment.yaml) file and replace the image name with the name you used to build you image
2. Run `kubectl apply -f ./deployment.yaml`
3. Run `kubectl get pod -n application`. You should see a K8S pod running.

#### Test the application

1. Run `kubectl port-forward <pod-name> 3000:3000 -n application`
2. Open [localhost:3000](http://localhost:3000?name=EKS-Terraform-Example) in your browser
3. Go to the [AWS S3](https://s3.console.aws.amazon.com/s3/home) page in the AWS Console to see the results. (Remember to provide a `?name` query string)

## Useful Commands

```Shell
terraform init
terraform validate
terraform apply -var-file=variables.tfvars
kubectl get nodes -owide
kubectl get pod -n application
kubectl describe configmap app-config -n application
kubectl describe secret -n application aws-s3-user-creds
kubectl port-forward <pod-name> 3000:3000 -n application
```

## Sources

* https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started
* https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
* https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
* https://learn.hashicorp.com/tutorials/terraform/eks
* https://github.com/hashicorp/learn-terraform-provision-eks-cluster
* https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
* https://github.com/hashicorp/terraform-provider-kubernetes
* https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace
* https://www.terraform.io/docs/language/data-sources/index.html

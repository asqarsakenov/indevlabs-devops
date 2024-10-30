How to deploy istio-httpd application 
to existing Minikube cluster using Terraform

1)	All steps are done in Terminal. You can use multiple windows.
2)	Make sure your Minikube instance is running and configured. You can check the current context by execution the following command: 

$ kubectl config current-context

3)	Make sure your machine already has Terraform pre-installed. To check this, execute:

$ terraform version 

INFO: The output shows the current version of the terraform. In case you face an error, you have to install Terraform using the official documentation.

4)	Go to the directory where the ‘01-helm-istio.tf ‘script is located. For example:

$ cd path-to-tf-script-folder

5)	Execute the following command to download the necessary providers:

$ terraform init

6)	Run the following command to review the Terraform plan:

$ terraform plan

7)	Apply the Terraform configuration and deploy all resources:

$ terraform apply
INFO: Input yes and press Enter to proceed

8)	In a separate terminal window, you have to start Minikube tunnel to access the Ingress IP

$ minikube tunnel 

INFO: Terminal will request a sudo permission, cause httpd-apache requires privileged ports (80/443) to be exposed. You have to input your password.

9)	Run the following command to get the IP address (EXTERNAL-IP) for the Istio Ingress Gateway:

$ kubectl get svc -n istio-ingress istio-ingress


10)	Go to the Minikube shell and check if the httpd server is accessible using EXTERNAL-IP

$ minikube ssh
$ curl http://localhost
$ curl -k https://localhost

INFO: Both curl command’s outputs (without brackets): 
“<html><body><h1>It works!</h1></body></html>”

11)	To destroy the deployed resources, execute:
$ terraform destroy
INFO: Input yes and press Enter to proceed




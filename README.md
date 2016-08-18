
Pre requirements :

#1) Terraform ( https://www.terraform.io/ )

After downloading Terraform, unzip the package into a directory where Terraform will be installed. The directory will contain a set of binary programs, such as terraform, terraform-provider-aws, etc. The final step is to make sure the directory you installed Terraform to is on the PATH

Example for Linux/Mac - Type the following into your terminal:

PATH=/usr/local/terraform/bin:/home/youruser-name/terraform:$PATH

Verification:

After installing Terraform, verify the installation worked by opening a new terminal session and checking that terraform is available.


#2) Ansible ( https://www.ansible.com/ )

Ubuntu instalation :

The best way to get Ansible for Ubuntu is to add the project's PPA (personal package archive) to your system. We can add the Ansible PPA by typing the following command:

sudo apt-add-repository ppa:ansible/ansible
Press ENTER to accept the PPA addition.

Next, we need to refresh our system's package index so that it is aware of the packages available in the PPA. Afterwards, we can install the software:

sudo apt-get update
sudo apt-get install ansible


#3) AWS account & SSH key

If you don't have an AWS account, create one now. For the getting started guide, we'll only be using resources which qualify under the AWS free-tier, meaning it will be free. If you already have an AWS account, you may be charged some amount of money, but it shouldn't be more than a few pounds.

Feel free to create new ssh-key that you're going to use to connect with AWS resources.

ssh-keygen -t rsa -C "ansible" -P '' -f ~/.ssh/ansible


#Before we begin:

Please take a note of you're AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY

Please update your variables files : terraform.tfvars, variables.tf 

#Lets spin up your environment first:

terraform apply -var-file terraform.tfvars
if you want to just check your config file, please run "terraform plan"

terraform plan -var-file terraform.tfvars 

# Time to run our Ansible playbook

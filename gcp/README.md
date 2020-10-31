# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in GCP with a low-cost instance using Terraform, Ansible, and Docker.

![Diagram](../diagram.png)

# Requirements
- A Google cloud account
- Follow Step-by-Step (compatible with Windows and Ubuntu)

# Step-by-Step for Windows Users
Windows Users install WSL (Windows Subsystem Linux)
```
#############################
## Windows Subsystem Linux ##
#############################
# Launch elevated Powershell prompt (right click -> Run as Administrator)
 
# Enable Windows Subsystem Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
 
# Reboot
shutdown /r /t 5
 
# Launch a regular Powershell prompt
 
# Download the Ubuntu 1804 package from Microsoft
curl.exe -L -o ubuntu-1804.appx https://aka.ms/wsl-ubuntu-1804
 
# Rename the package
Rename-Item ubuntu-1804.appx ubuntu-1804.zip
 
# Expand the zip
Expand-Archive ubuntu-1804.zip ubuntu-1804
 
# Change to the zip directory
cd ubuntu-1804
 
# Execute the ubuntu 1804 installer
.\ubuntu1804.exe
 
# Create a username and password when prompted
```

Install Terraform, Git, and create an SSH key pair
```
#############################
##  Terraform + Git + SSH  ##
#############################
# Add terraform's apt key (enter previously created password at prompt)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
 
# Add terraform's apt repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
 
# Install terraform and git
sudo apt-get update && sudo apt-get -y install terraform git
 
# Clone the cloudblock project
git clone https://github.com/chadgeary/cloudblock

# Create SSH key pair (RETURN for defaults)
ssh-keygen
```

Install the GCP CLI and authenticate
```
# Add the google cloud sdk repository
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Install prerequisite packages
sudo apt-get -y install apt-transport-https ca-certificates gnupg

# Add the google cloud package key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install the google cloud sdk package
sudo apt-get update && sudo apt-get -y install google-cloud-sdk

# Authenticate
gcloud init

# Note the billing ID for the vars file
gcloud beta billing accounts list | grep True

# Note the gcp user for the vars file
gcloud auth list
```

Customize the deployment - See variables section below
```
# Change to the project's aws directory in powershell
cd ~/cloudblock/gcp/

# Open File Explorer in a separate window
# Navigate to gcp project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudblock\gcp

# Edit the gcp.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's gcp directory
cd ~/cloudblock/gcp/

# Initialize terraform and apply the terraform state
terraform init
terraform apply -var-file="gcp.tfvars"

# Note the outputs from terraform after the apply completes

# Wait for the virtual machine to become ready (Ansible will setup the services for us)
```

# Variables
Edit the vars file (gcp.tfvars) to customize the deployment, especially:

```
# ph_password
# password to access the pihole webui

# mgmt_cidr
# an IP range granted webUI and SSH access. Also permitted PiHole DNS if dns_novpn = 1. 
# deploying from home? This should be your public IP address with a /32 suffix. 

# ssh_key
# a public SSH key for SSH access to the instance via user `ubuntu`.

# gcp_billing_account
# The billing ID for the google cloud account

# gcp_user
# The GCP user
```

# Post-Deployment
- See terraform output for VPN Client configuration link and the Pihole WebUI address.

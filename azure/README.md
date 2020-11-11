##### IN PROGRESS #####

# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in Azure using Terraform with Ansible+Docker.

![Diagram](../diagram.png)

# Requirements
- An Azure account
- Follow Step-by-Step (compatible with Windows and Ubuntu)

# Step-by-Step 
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

Install the Azure cli and authenticate
```
#############################
##          Azure          ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# Install the azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Authenticate (for WSL users, login to the browser popup!)
az login
```

Customize the deployment - See variables section below
```
# Change to the project's azure directory in powershell
cd ~/cloudblock/azure/

# Open File Explorer in a separate window
# Navigate to azure project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudblock\azure

# Edit the az.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's azure directory in powershell
cd ~/cloudblock/azure/

# Initialize terraform and apply the terraform state
terraform init
terraform apply -var-file="az.tfvars"

# Note the outputs from terraform after the apply completes

# Wait for the virtual machine to become ready (Ansible will setup the services for us)

```

Want to watch Ansible setup the virtual machine? SSH to the cloud instance - see the terraform output.
```
# Connect to the virtual machine via ssh
ssh ubuntu@<some ip address terraform told us about>

# Tail the cloudblock log file
tail -F /var/log/cloudblock.log
```

# Variables
Edit the vars file (az.tfvars) to customize the deployment, especially:

```
# ph_password
# password to access the pihole webui

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
# cat ~/.ssh/id_rsa.pub

# mgmt_cidr
# an IP range granted webUI, EC2 SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix. 
```

# Deploy
```
# Clone and change to directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/azure/

# Initialize terraform
terraform init

# Apply terraform
terraform apply -var-file="az.tfvars"
```

# Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.
- Using an ISP with DHCP and unable to reach the PiHole webUI from home? Connect to the Wireguard VPN and browse to Pihole VPN IP in the terraform output.

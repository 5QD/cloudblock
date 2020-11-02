## COMMON ##
gcp_region = "us-east1"
gcp_zone = "b"
gcp_machine_type = "f1-micro"
gcp_billing_account = "X1X1X1-ABABAB-123456"
gcp_user = "me@example.com"
ph_prefix = "pihole"
ph_password = "changeme"
ssh_key = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr = "1.2.3.4/32"

# The number of wireguard peer configurations to generate / store - 1 per device
wireguard_peers = 20

# Pick a DoH provider, one of: adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended
doh_provider = "opendns"

## UNCOMMON ##
project_url = "https://github.com/chadgeary/cloudblock"
dns_novpn = 1
vpn_cidr = "0.0.0.0/0"
gcp_project_services = ["serviceusage.googleapis.com","cloudkms.googleapis.com","storage-api.googleapis.com","secretmanager.googleapis.com"]
gcp_image_project = "ubuntu-os-cloud"
gcp_image_name = "ubuntu-1804-bionic-v20200923"
ssh_user = "ubuntu"
gcp_cidr = "10.10.12.0/24"
gcp_instanceip = "10.10.12.5"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
wireguard_network = "172.19.0.0"

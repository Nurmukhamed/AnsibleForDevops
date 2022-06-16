# Main difference
| # | Name | Jeff Geerling | Nurmukhamed Artykaly |
|---|------|---------------|----------------------|
| 1 | Virtualization | Virtualbox | libvirt KVM |
| 2 | Orchestration tool | Vagrant | Terraform + libvirt plugin |
| 3 | Network | Static | Dynamic |
| 4 | Inventory | Static | Dynamic |
| 5 | folder sync | sharing local folder | coping files to vm |

# Small instruction before start using examples.

Examples tested at Ubuntu 20.04.

## Prepare

### libvirt

**[Install libvirt](https://www.tecmint.com/install-kvm-on-ubuntu/)**

```
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
```

Ensure that libvirt systemd service started and running.

```
sudo systemctl status libvirtd

```

Ensure that kernel modules kvm are loaded.

```
lsmod | grep -i kv
```

### Docker

**[Install Docker](https://docs.docker.com/engine/install/ubuntu/)**


Remove old version of docker

```
sudo apt-get remove docker docker-engine docker.io containerd runc
```

Set up the repository. Update the apt package index and install packages to allow apt to use a repository over HTTPS:

```
sudo apt-get update 
sudo apt-get install ca-certificates curl gnupg lsb-release
```

Add Docker’s official GPG key:
```
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Use the following command to set up the repository:
```
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker Engine. Update the apt package index, and install the latest version of Docker Engine, containerd, and Docker Compose, or go to the next step to install a specific version:
```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### Add user to docker,kvm,libvirt groups

```
sudo usermod -aG docker,kvm,libvirt $(id -u -n)

```

### Terraform

**[Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)**

```
sudo apt update && sudo apt install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install terraform
```

### Downloading required QCOW2 images 

Links are actual for Kazakhstan. You may use links that close to your region.

```
cd iso
wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2
wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
wget https://cloud-images.ubuntu.com/releases/hirsute/release/ubuntu-21.04-server-cloudimg-amd64-disk-kvm.img
wget https://cloud-images.ubuntu.com/releases/hirsute/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img
```

### Use ssh public keys

Please change file **config.auto.tfvars** to use your ssh private and public keys

For example: 

* using RSA key
```
pub_key = "~/.ssh/id_rsa.pub"
pvt_key = "~/.ssh/id_rsa"
```
* using other keys
```
pub_key = "~/ansiblefordevops.pub"
pvt_key = "~/ansiblefordevops"
```

# How to run examples

```
terraform init
terraform plan
terraform apply
ansible-playbook ...
terraform destroy
```
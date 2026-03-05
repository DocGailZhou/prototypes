# Set up Local Device and AIO Platform

This doc is a streamlined guide to implement the functions built by this repo [GitHub - BillmanH/learn-iot: Working Example of Azure IoT Operations · GitHub](https://github.com/billmanh/learn-iot).

### Step 1 Create Linux VM and Set up AIO Config 

From your Laptop, create VM using this PowerShell script [link](https://github.com/DocGailZhou/prototypes/blob/main/design_with_ai/infra/setup_azure_vm.ps1). The script will create a file azure_vm_ssh.md. Follow the instructions in azure_vm_ssh.md to connect to your Linux virtual machine. 

```
# From your Linux machine, Clone the repo: 
git clone https://github.com/BillmanH/learn-iot.git
cd learn-iot

# Install useful tools (Optional)
sudo apt update
sudo apt install -y emacs
sudo apt install -y jq

```



```
# From your Linux machine, Edit the aio_config.json, look for the field has EDIT_ in it. 
cd config
cp quikstart_config.template aio_config.json

# edit aio_config using vi (or emacs -nw) aio_config.json 
#
# Edit the aio_config.json, replace with your own values - used in the Linux VM creation process. 
{
  "config_type": "quickstart",
  "azure": {
    "subscription_id": "EDIT_with_Your_own_subscription_id",
    "subscription_name": "EDIT_with_Your_own_subscription_name",
    "resource_group": "EDIT_wiht_the_RG_You_Used_to_Create_the_Linux_Machine",
    "location": "eastus",
    "cluster_name": "iot-ops-cluster",
    "storage_account_name": "EDIT_THIS_to_be_Unique_iotopsgazhostorageiotaiogz2026",
    "key_vault_name": "EDIT_to_name_Your_KV",
    "enable_arc_on_install": true,
    "deploy_iot_operations": true
  },
  "deployment": {
    "skip_system_update": false,
    "deployment_mode": "test"
  },
  "optional_tools": {
    "k9s": true,
    "mqtt-viewer": true,
    "ssh": false
  }

```

### Step 2 Execute Scripts in Linux VM 

```
# 1. From your Linux machine, run installer.sh
cd arc_build_linux
bash installer.sh

# 2. After step 1 is secessully run:
pwsh ./arc_enable.ps1
```



### Step 3 Azure Configuration (from Windows Machine) 

```
# 1. Clone the same repo to Windows Machine

git clone https://github.com/BillmanH/learn-iot.git
cd learn-iot/config

# 2. get the content of aio_config.json cluster_info.json and copy them into config folder of your windows
# You can use below command in Linux manauly:
cat aio_config.json
cat cluster_info.json

# 3. Run below scripts in your Windows Machine:
cd external_configuration

# First, grant yourself the required Azure permissions
# This uses your current signed-in Azure identity by default
.\grant_entra_id_roles.ps1

# 4. Deploy Azure IoT Operations (this can take some time)
.\External-Configurator.ps1


```


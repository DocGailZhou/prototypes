# Azure VM SSH Connection Information

## 🔗 SSH Connection Commands:

### Option 1 - Azure CLI SSH (Recommended):
```
az ssh vm --resource-group gz_iot_aio_dev_rg --name gz_local_linux --local-user azureuser
```

### Option 2 - Direct SSH:
```
ssh azureuser@20.127.11.153
```

## Connection Details:
- **📍 Public IP Address:** 20.127.11.153
- **👤 Username:** azureuser
- **🔑 SSH Key Location:** ~/.ssh/id_rsa
- **🗂️ Resource Group:** gz_iot_aio_dev_rg
- **🖥️ VM Name:** gz_local_linux

---
*Generated on 2026-03-04 23:46:38*

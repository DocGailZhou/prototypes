# Azure VM SSH Connection Information

## 🔗 SSH Connection Commands:

### Option 1 - Azure CLI SSH (Recommended):
`
az ssh vm --resource-group gzt_iot_aio_dev_rg --name local_linux --local-user azureuser
`

### Option 2 - Direct SSH:
`
ssh azureuser@20.115.122.123
`

## Connection Details:
- **📍 Public IP Address:** 20.115.122.123
- **👤 Username:** azureuser
- **🔑 SSH Key Location:** ~/.ssh/id_rsa
- **🗂️ Resource Group:** gzt_iot_aio_dev_rg
- **🖥️ VM Name:** local_linux

---
*Generated on 2026-03-04 23:50:42*

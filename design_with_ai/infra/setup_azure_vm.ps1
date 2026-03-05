#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Automated Azure VM Setup Script - Streamlined Workflow
.DESCRIPTION
    This script automatically creates an Azure VM with the complete setup workflow:
    1. Gets user configuration
    2. Creates resource group
    3. Creates VM
    4. Opens port 80
    5. Shows SSH connection commands
    6. Shows VM status
    7. Offers cleanup option

.EXAMPLE
    # Step 1: Login to Azure
    az login

    # Step 2: Run the script (in Git Bash or WSL terminal)
    chmod +x setup_azure_vm.sh 
    .\setup_azure_vm.ps1

.NOTES
    Requires Azure CLI to be installed and user to be logged in with 'az login'
#>

# =======================================================================
# QUICK START INSTRUCTIONS FOR BEGINNERS:
# =======================================================================
# Step 1: Login to Azure
# az login
#
# Step 2: Run the script  
# .\setup_azure_vm.ps1
# =======================================================================

# Color functions for better UI
function Write-Success { param($Message) Write-Host $Message -ForegroundColor Green }
function Write-Error { param($Message) Write-Host $Message -ForegroundColor Red }
function Write-Warning { param($Message) Write-Host $Message -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host $Message -ForegroundColor Cyan }
function Write-Header { param($Message) Write-Host "`n$('='*60)" -ForegroundColor Magenta; Write-Host $Message -ForegroundColor Magenta; Write-Host $('='*60) -ForegroundColor Magenta }

# Global variables (will be set by user input)
$ResourceGroupName = ""
$VMName = ""
$Location = ""
$VMSize = "Standard_D4s_v3"
$AdminUsername = "azureuser"
$VMImage = "Ubuntu2204"

function Get-UserConfiguration {
    Write-Header "Azure VM Automated Setup - Configuration"
    Write-Info "Please provide the following information for your VM setup:"
    Write-Host ""
    
    # Resource Group Name
    $defaultRG = "iot_aio_dev_rg"
    $inputRG = Read-Host "Resource Group Name [default: $defaultRG]"
    $script:ResourceGroupName = if ($inputRG) { $inputRG } else { $defaultRG }
    
    # Location
    $defaultLocation = "eastus"
    Write-Info "Common locations: eastus, westus2, centralus, westeurope, eastasia"
    $inputLocation = Read-Host "Location [default: $defaultLocation]"
    $script:Location = if ($inputLocation) { $inputLocation } else { $defaultLocation }
    
    # VM Name
    $defaultVM = "local_linux"
    $inputVM = Read-Host "VM Name [default: $defaultVM]"
    $script:VMName = if ($inputVM) { $inputVM } else { $defaultVM }
    
    Write-Host ""
    Write-Success "✓ Configuration set successfully!"
    Write-Host "Resource Group: " -NoNewline; Write-Info $ResourceGroupName
    Write-Host "Location:       " -NoNewline; Write-Info $Location  
    Write-Host "VM Name:        " -NoNewline; Write-Info $VMName
    Write-Host "VM Size:        " -NoNewline; Write-Info "$VMSize (4 vCPUs, 16GB RAM, ~`$0.19/hr)"
    Write-Host ""
}

function Create-ResourceGroup {
    Write-Header "Step 1: Creating Resource Group"
    Write-Info "Creating resource group '$ResourceGroupName' in '$Location'..."
    
    $result = az group create --name $ResourceGroupName --location $Location --output table
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✓ Resource group created successfully!"
        return $true
    }
    else {
        Write-Error "✗ Failed to create resource group"
        return $false
    }
}

function Create-VM {
    Write-Header "Step 2: Creating Virtual Machine"
    Write-Info "Creating VM '$VMName' with specifications:"
    Write-Host "  - Image: $VMImage"
    Write-Host "  - Size: $VMSize (4 vCPUs, 16GB RAM)"
    Write-Host "  - Admin User: $AdminUsername"
    Write-Host "  - SSH Keys: Auto-generated"
    Write-Host ""
    Write-Warning "This will take 3-5 minutes. VM costs approximately `$0.19/hour."
    Write-Host ""
    Write-Info "Creating VM... Please wait..."
    
    $result = az vm create --resource-group $ResourceGroupName --name $VMName --image $VMImage --size $VMSize --admin-username $AdminUsername --generate-ssh-keys --output table
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✓ Virtual machine created successfully!"
        Write-Info "SSH keys have been generated and saved to ~/.ssh/"
        return $true
    }
    else {
        Write-Error "✗ Failed to create virtual machine"
        return $false
    }
}

function Wait-ForVMReady {
    Write-Header "Step 4: Waiting for VM to be Ready"
    Write-Info "Checking VM status and waiting for it to be fully ready..."
    
    $attempts = 0
    $maxAttempts = 20
    
    do {
        $attempts++
        Write-Host "." -NoNewline -ForegroundColor Yellow
        
        $vmStatus = az vm get-instance-view --resource-group $ResourceGroupName --name $VMName --query "instanceView.statuses[1].displayStatus" -o tsv 2>$null
        
        if ($vmStatus -eq "VM running") {
            Write-Host ""
            Write-Success "✓ VM is running and ready!"
            return $true
        }
        
        if ($attempts -ge $maxAttempts) {
            Write-Host ""
            Write-Warning "⏰ Timeout waiting for VM to be ready. Current status: $vmStatus"
            return $false
        }
        
        Start-Sleep -Seconds 10
    } while ($true)
}

function Open-Port80 {
    Write-Header "Step 5: Opening Port 80 (Optional)"
    Write-Info "Port 80 allows HTTP web traffic from the internet to your VM."
    Write-Host ""
    
    $openPort = Read-Host "Would you like to open port 80? (Y/n)"
    
    if ($openPort -eq "n" -or $openPort -eq "N") {
        Write-Info "⏭️  Skipping port 80 - VM will only be accessible via SSH"
        return $true
    }
    else {
        Write-Info "Opening port 80 for web traffic..."
        $result = az vm open-port --resource-group $ResourceGroupName --name $VMName --port 80 --output table --only-show-errors
        if ($LASTEXITCODE -eq 0) {
            Write-Success "✓ Port 80 opened successfully!"
            return $true
        }
        else {
            Write-Error "✗ Failed to open port 80"
            return $false
        }
    }
}

function Show-ConnectionInfo {
    Write-Header "Step 6: SSH Connection Information"
    
    # Get public IP
    Write-Info "Retrieving VM connection details..."
    $publicIp = az vm show --resource-group $ResourceGroupName --name $VMName --show-details --query "publicIps" -o tsv 2>$null
    
    if ($publicIp) {
        Write-Success "✓ VM is ready for connection!"
        Write-Host ""
        Write-Info "🔗 SSH Connection Commands:"
        Write-Host ""
        Write-Host "Option 1 - Azure CLI SSH (Recommended):" -ForegroundColor Yellow
        Write-Host "  az ssh vm --resource-group $ResourceGroupName --name $VMName --local-user $AdminUsername" -ForegroundColor White
        Write-Host ""
        Write-Host "Option 2 - Direct SSH:" -ForegroundColor Yellow  
        Write-Host "  ssh $AdminUsername@$publicIp" -ForegroundColor White
        Write-Host ""
        Write-Info "📍 Public IP Address: $publicIp"
        Write-Info "👤 Username: $AdminUsername"
        Write-Info "🔑 SSH Key Location: ~/.ssh/id_rsa"
        
        # Create SSH info markdown file
        $sshInfoFile = "azure_vm_ssh_info.md"
        
        # Remove existing file if it exists
        if (Test-Path $sshInfoFile) {
            Remove-Item $sshInfoFile -Force
        }
        
        $sshContent = @"
# Azure VM SSH Connection Information

## 🔗 SSH Connection Commands:

### Option 1 - Azure CLI SSH (Recommended):
```
az ssh vm --resource-group $ResourceGroupName --name $VMName --local-user $AdminUsername
```

### Option 2 - Direct SSH:
```
ssh $AdminUsername@$publicIp
```

## Connection Details:
- **📍 Public IP Address:** $publicIp
- **👤 Username:** $AdminUsername
- **🔑 SSH Key Location:** ~/.ssh/id_rsa
- **🗂️ Resource Group:** $ResourceGroupName
- **🖥️ VM Name:** $VMName

---
*Generated on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')*
"@
        
        Set-Content -Path $sshInfoFile -Value $sshContent -Encoding UTF8
        Write-Host ""
        Write-Success "✓ SSH connection info saved to: $sshInfoFile"
    }
    else {
        Write-Warning "Could not retrieve public IP address"
    }
}

function Show-VMStatus {
    Write-Header "Step 7: VM Status Summary"
    
    Write-Info "Retrieving complete VM information..."
    $vmStatus = az vm get-instance-view --resource-group $ResourceGroupName --name $VMName --query "instanceView.statuses[1].displayStatus" -o tsv 2>$null
    
    if ($vmStatus) {
        Write-Success "✓ VM Status: $vmStatus"
        
        Write-Host ""
        Write-Info "📊 VM Details:"
        az vm show --resource-group $ResourceGroupName --name $VMName --show-details --output table
    }
    else {
        Write-Warning "Could not retrieve VM status"
    }
}

function Offer-Cleanup {
    Write-Header "Cleanup"
    Write-Host ""
    Write-Warning "💰 Your VM is running and incurring charges (~`$0.19/hour)"
    Write-Host ""
    Write-Host "Your VM is ready to use! You can SSH into it using the commands shown above." -ForegroundColor Green
    Write-Host ""
    Write-Host "🗑️  CLEANUP OPTIONS:" -ForegroundColor Yellow
    Write-Host "Do you want to DELETE everything we just created?" -ForegroundColor Yellow
    Write-Host "(This includes: VM, resource group, and ALL associated resources)" -ForegroundColor Yellow
    Write-Host ""
    
    do {
        $cleanup = Read-Host "Delete all resources? Type 'y' for YES or 'n' for NO"
        $cleanup = $cleanup.ToLower().Trim()
        
        if ($cleanup -eq "y" -or $cleanup -eq "yes") {
            Write-Host ""
            Write-Error "⚠️  This will DELETE everything we just created:"
            Write-Host "   • Resource Group: $ResourceGroupName" -ForegroundColor Red
            Write-Host "   • Virtual Machine: $VMName" -ForegroundColor Red  
            Write-Host "   • All associated resources (disk, network, public IP, etc.)" -ForegroundColor Red
            Write-Warning "This action CANNOT be undone!"
            Write-Host ""
            
            $confirm = Read-Host "Type 'DELETE' to confirm (case sensitive, or anything else to cancel)"
            if ($confirm -eq "DELETE") {
                Write-Info "Deleting resource group '$ResourceGroupName' and all resources..."
                az group delete --name $ResourceGroupName --yes --no-wait
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "✓ Deletion initiated successfully!"
                    Write-Info "Resources are being deleted in the background."
                }
                else {
                    Write-Error "✗ Failed to initiate deletion"
                }
            }
            else {
                Write-Info "Deletion cancelled. VM continues running."
            }
            break
        }
        elseif ($cleanup -eq "n" -or $cleanup -eq "no") {
            Write-Success "✓ VM will continue running. Happy coding! 🚀"
            break
        }
        else {
            Write-Warning "Please type 'y' for YES or 'n' for NO"
        }
    } while ($true)
}

# Main script execution
function Main {
    Write-Success "🚀 Starting Azure VM Automated Setup"
    Write-Info "Assuming you've already run 'az login'..."
    Write-Host ""
    
    # Step 1: Get configuration
    Get-UserConfiguration
    
    # Step 2: Create resource group
    if (-not (Create-ResourceGroup)) { 
        Write-Error "Failed to create resource group. Exiting."
        return 
    }
    
    # Step 3: Create VM  
    if (-not (Create-VM)) { 
        Write-Error "Failed to create VM. Exiting."
        return 
    }
    
    # Step 4: Wait for VM to be ready
    if (-not (Wait-ForVMReady)) {
        Write-Warning "VM may not be fully ready, but continuing..."
    }
    
    # Step 5: Open port 80
    Open-Port80 | Out-Null  # Don't stop if this fails
    
    # Step 6: Show connection info
    Show-ConnectionInfo
    
    # Step 7: Show VM status  
    Show-VMStatus
    
    # Step 8: Offer cleanup and exit
    Offer-Cleanup
    
    Write-Host ""
    Write-Success "🎉 Setup complete! Thank you for using Azure VM Quick Setup!"
}

# Run the script
Main

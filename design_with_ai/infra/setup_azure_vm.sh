#!/bin/bash

# =======================================================================
# Automated Azure VM Setup Script - Streamlined Workflow (Bash Version)
# =======================================================================
# This script automatically creates an Azure VM with the complete setup workflow:
# 1. Gets user configuration
# 2. Creates resource group
# 3. Creates VM
# 4. Waits for VM to be ready
# 5. Opens port 80 (optional)
# 6. Shows SSH connection commands
# 7. Shows VM status
# 8. Offers cleanup option
#
# PREREQUISITES:
# 1. Install Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
# 2. Run 'az login' BEFORE executing this script
# 3. Optionally set your subscription: az account set --subscription "your-subscription-id"
#
# EXAMPLE:
# # Step 1: Login to Azure
# az login
#
# # Step 2: Run the script  
# ./setup_azure_vm.sh
#
# NOTES:
# Requires Azure CLI to be installed and user to be logged in with 'az login'
# =======================================================================

# =======================================================================
# QUICK START INSTRUCTIONS FOR BEGINNERS:
# =======================================================================
# Step 1: Login to Azure
# az login
#
# Step 2: Make script executable and run it
# chmod +x setup_azure_vm.sh
# ./setup_azure_vm.sh
# =======================================================================

# Color functions for better UI
print_success() { echo -e "\033[32m$1\033[0m"; }
print_error() { echo -e "\033[31m$1\033[0m"; }
print_warning() { echo -e "\033[33m$1\033[0m"; }
print_info() { echo -e "\033[36m$1\033[0m"; }
print_header() { 
    echo ""
    echo -e "\033[35m============================================================\033[0m"
    echo -e "\033[35m$1\033[0m"
    echo -e "\033[35m============================================================\033[0m"
}

# Global variables (will be set by user input)
RESOURCE_GROUP_NAME=""
VM_NAME=""
LOCATION=""
VM_SIZE="Standard_D4s_v3"
ADMIN_USERNAME="azureuser"
VM_IMAGE="Ubuntu2204"

get_user_configuration() {
    print_header "Azure VM Automated Setup - Configuration"
    print_info "Please provide the following information for your VM setup:"
    echo ""
    
    # Resource Group Name
    default_rg="iot_aio_dev_rg"
    read -p "Resource Group Name [default: $default_rg]: " input_rg
    RESOURCE_GROUP_NAME=${input_rg:-$default_rg}
    
    # Location
    default_location="eastus"
    print_info "Common locations: eastus, westus2, centralus, westeurope, eastasia"
    read -p "Location [default: $default_location]: " input_location
    LOCATION=${input_location:-$default_location}
    
    # VM Name
    default_vm="local_linux"
    read -p "VM Name [default: $default_vm]: " input_vm
    VM_NAME=${input_vm:-$default_vm}
    
    echo ""
    print_success "✓ Configuration set successfully!"
    echo -n "Resource Group: "; print_info "$RESOURCE_GROUP_NAME"
    echo -n "Location:       "; print_info "$LOCATION"
    echo -n "VM Name:        "; print_info "$VM_NAME" 
    echo -n "VM Size:        "; print_info "$VM_SIZE (4 vCPUs, 16GB RAM, ~\$0.19/hr)"
    echo ""
}

create_resource_group() {
    print_header "Step 1: Creating Resource Group"
    print_info "Creating resource group '$RESOURCE_GROUP_NAME' in '$LOCATION'..."
    
    if az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" --output table > /dev/null; then
        print_success "✓ Resource group created successfully!"
        return 0
    else
        print_error "✗ Failed to create resource group"
        return 1
    fi
}

create_vm() {
    print_header "Step 2: Creating Virtual Machine"
    print_info "Creating VM '$VM_NAME' with specifications:"
    echo "  - Image: $VM_IMAGE"
    echo "  - Size: $VM_SIZE (4 vCPUs, 16GB RAM)"
    echo "  - Admin User: $ADMIN_USERNAME"
    echo "  - SSH Keys: Auto-generated"
    echo ""
    print_warning "This will take 3-5 minutes. VM costs approximately \$0.19/hour."
    echo ""
    print_info "Creating VM... Please wait..."
    
    if az vm create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$VM_NAME" \
        --image "$VM_IMAGE" \
        --size "$VM_SIZE" \
        --admin-username "$ADMIN_USERNAME" \
        --generate-ssh-keys \
        --output table > /dev/null; then
        print_success "✓ Virtual machine created successfully!"
        print_info "SSH keys have been generated and saved to ~/.ssh/"
        return 0
    else
        print_error "✗ Failed to create virtual machine"
        return 1
    fi
}

wait_for_vm_ready() {
    print_header "Step 4: Waiting for VM to be Ready"
    print_info "Checking VM status and waiting for it to be fully ready..."
    
    local attempts=0
    local max_attempts=20
    
    while [ $attempts -lt $max_attempts ]; do
        ((attempts++))
        echo -n "." 
        
        local vm_status=$(az vm get-instance-view \
            --resource-group "$RESOURCE_GROUP_NAME" \
            --name "$VM_NAME" \
            --query "instanceView.statuses[1].displayStatus" \
            -o tsv 2>/dev/null)
        
        if [ "$vm_status" = "VM running" ]; then
            echo ""
            print_success "✓ VM is running and ready!"
            return 0
        fi
        
        if [ $attempts -ge $max_attempts ]; then
            echo ""
            print_warning "⏰ Timeout waiting for VM to be ready. Current status: $vm_status"
            return 1
        fi
        
        sleep 10
    done
}

open_port80() {
    print_header "Step 5: Opening Port 80 (Optional)"
    print_info "Port 80 allows HTTP web traffic from the internet to your VM."
    echo ""
    
    read -p "Would you like to open port 80? (Y/n): " open_port
    
    if [ "$open_port" = "n" ] || [ "$open_port" = "N" ]; then
        print_info "⏭️  Skipping port 80 - VM will only be accessible via SSH"
        return 0
    else
        print_info "Opening port 80 for web traffic..."
        if az vm open-port \
            --resource-group "$RESOURCE_GROUP_NAME" \
            --name "$VM_NAME" \
            --port 80 \
            --output table \
            --only-show-errors > /dev/null; then
            print_success "✓ Port 80 opened successfully!"
            return 0
        else
            print_error "✗ Failed to open port 80"
            return 1
        fi
    fi
}

show_connection_info() {
    print_header "Step 6: SSH Connection Information"
    
    # Get public IP
    print_info "Retrieving VM connection details..."
    local public_ip=$(az vm show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$VM_NAME" \
        --show-details \
        --query "publicIps" \
        -o tsv 2>/dev/null)
    
    if [ -n "$public_ip" ]; then
        print_success "✓ VM is ready for connection!"
        echo ""
        print_info "🔗 SSH Connection Commands:"
        echo ""
        echo -e "\033[33mOption 1 - Azure CLI SSH (Recommended):\033[0m"
        echo -e "\033[37m  az ssh vm --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME --local-user $ADMIN_USERNAME\033[0m"
        echo ""
        echo -e "\033[33mOption 2 - Direct SSH:\033[0m"
        echo -e "\033[37m  ssh $ADMIN_USERNAME@$public_ip\033[0m"
        echo ""
        print_info "📍 Public IP Address: $public_ip"
        print_info "👤 Username: $ADMIN_USERNAME"
        print_info "🔑 SSH Key Location: ~/.ssh/id_rsa"
        
        # Create SSH info markdown file
        local ssh_info_file="azure_vm_ssh_info.md"
        
        # Remove existing file if it exists
        [ -f "$ssh_info_file" ] && rm -f "$ssh_info_file"
        
        cat > "$ssh_info_file" << EOF
# Azure VM SSH Connection Information

## 🔗 SSH Connection Commands:

### Option 1 - Azure CLI SSH (Recommended):
\`\`\`
az ssh vm --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME --local-user $ADMIN_USERNAME
\`\`\`

### Option 2 - Direct SSH:
\`\`\`
ssh $ADMIN_USERNAME@$public_ip
\`\`\`

## Connection Details:
- **📍 Public IP Address:** $public_ip
- **👤 Username:** $ADMIN_USERNAME
- **🔑 SSH Key Location:** ~/.ssh/id_rsa
- **🗂️ Resource Group:** $RESOURCE_GROUP_NAME
- **🖥️ VM Name:** $VM_NAME

---
*Generated on $(date '+%Y-%m-%d %H:%M:%S')*
EOF
        
        echo ""
        print_success "✓ SSH connection info saved to: $ssh_info_file"
    else
        print_warning "Could not retrieve public IP address"
    fi
}

show_vm_status() {
    print_header "Step 7: VM Status Summary"
    
    print_info "Retrieving complete VM information..."
    local vm_status=$(az vm get-instance-view \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$VM_NAME" \
        --query "instanceView.statuses[1].displayStatus" \
        -o tsv 2>/dev/null)
    
    if [ -n "$vm_status" ]; then
        print_success "✓ VM Status: $vm_status"
        
        echo ""
        print_info "📊 VM Details:"
        az vm show \
            --resource-group "$RESOURCE_GROUP_NAME" \
            --name "$VM_NAME" \
            --show-details \
            --output table
    else
        print_warning "Could not retrieve VM status"
    fi
}

offer_cleanup() {
    print_header "Cleanup"
    echo ""
    print_warning "💰 Your VM is running and incurring charges (~\$0.19/hour)"
    echo ""
    echo -e "\033[32mYour VM is ready to use! You can SSH into it using the commands shown above.\033[0m"
    echo ""
    echo -e "\033[33m🗑️  CLEANUP OPTIONS:\033[0m"
    echo -e "\033[33mDo you want to DELETE everything we just created?\033[0m"
    echo -e "\033[33m(This includes: VM, resource group, and ALL associated resources)\033[0m"
    echo ""
    
    while true; do
        read -p "Delete all resources? Type 'y' for YES or 'n' for NO: " cleanup
        cleanup=$(echo "$cleanup" | tr '[:upper:]' '[:lower:]' | xargs)
        
        if [ "$cleanup" = "y" ] || [ "$cleanup" = "yes" ]; then
            echo ""
            print_error "⚠️  This will DELETE everything we just created:"
            echo -e "\033[31m   • Resource Group: $RESOURCE_GROUP_NAME\033[0m"
            echo -e "\033[31m   • Virtual Machine: $VM_NAME\033[0m"
            echo -e "\033[31m   • All associated resources (disk, network, public IP, etc.)\033[0m"
            print_warning "This action CANNOT be undone!"
            echo ""
            
            read -p "Type 'DELETE' to confirm (case sensitive, or anything else to cancel): " confirm
            if [ "$confirm" = "DELETE" ]; then
                print_info "Deleting resource group '$RESOURCE_GROUP_NAME' and all resources..."
                if az group delete --name "$RESOURCE_GROUP_NAME" --yes --no-wait > /dev/null; then
                    print_success "✓ Deletion initiated successfully!"
                    print_info "Resources are being deleted in the background."
                else
                    print_error "✗ Failed to initiate deletion"
                fi
            else
                print_info "Deletion cancelled. VM continues running."
            fi
            break
        elif [ "$cleanup" = "n" ] || [ "$cleanup" = "no" ]; then
            print_success "✓ VM will continue running. Happy coding! 🚀"
            break
        else
            print_warning "Please type 'y' for YES or 'n' for NO"
        fi
    done
}

# Main script execution
main() {
    print_success "🚀 Starting Azure VM Automated Setup"
    print_info "Assuming you've already run 'az login'..."
    echo ""
    
    # Step 1: Get configuration
    get_user_configuration
    
    # Step 2: Create resource group
    if ! create_resource_group; then
        print_error "Failed to create resource group. Exiting."
        return 1
    fi
    
    # Step 3: Create VM  
    if ! create_vm; then
        print_error "Failed to create VM. Exiting."
        return 1
    fi
    
    # Step 4: Wait for VM to be ready
    if ! wait_for_vm_ready; then
        print_warning "VM may not be fully ready, but continuing..."
    fi
    
    # Step 5: Open port 80
    open_port80 > /dev/null  # Don't stop if this fails
    
    # Step 6: Show connection info
    show_connection_info
    
    # Step 7: Show VM status  
    show_vm_status
    
    # Step 8: Offer cleanup and exit
    offer_cleanup
    
    echo ""
    print_success "🎉 Setup complete! Thank you for using Azure VM Quick Setup!"
}

# Run the script
main "$@"
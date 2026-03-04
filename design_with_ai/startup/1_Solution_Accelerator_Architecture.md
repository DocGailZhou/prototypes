# Solution Accelerator Architecture - Azure IoT Operations with Historian Simulation

**Simplified Azure-Only Architecture for Solution Accelerator Deployment**

This document outlines a **simplified, Azure-only architecture** that enables **single-command deployment** (`azd up`) of the complete IoT Operations solution with historian data simulation. Based on the [learn-iot repository](https://github.com/BillmanH/learn-iot), it has been adapted for **solution accelerator** use cases.

## 🎯 **Design Principles**

1. **✅ Azure-Only Deployment** - No local or physical edge devices required
2. **🚀 Single Command Setup** - Complete deployment via `azd up` 
3. **🏭 Edge Simulation in Azure VM** - Azure VM simulates edge environment with K3s
4. **📊 Historian Data Focus** - Real historian data simulation and storage
5. **☁️ Cloud-Native Dataflows** - All pipelines managed through Azure services
6. **🏗️ Solution Accelerator Ready** - Packaged for enterprise deployment

---

## 🏗️ **Draft Architecture**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         Microsoft Fabric (Cloud Analytics)                      │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────────────────────┐ │
│  │  Event Streams  │  │  Real-Time Intel │  │     KQL Dashboards              │ │
│  │  (Kafka)        │◀─│  (Analytics)     │◀─│     (Visualization)            │ │
│  └─────────────────┘  └──────────────────┘  └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────────┘
                                     ▲
                             📡 Kafka Protocol / Event Hub Compatible
                                     │
┌─────────────────────────────────────────────────────────────────────────────────┐
│                      Azure IoT Operations (ARC-Connected AVM)                   │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────────────────────┐ │
│  │   MQTT Broker   │  │   Dataflow Ops   │  │     Key Vault Sync              │ │
│  │   (aio-broker)  │─▶│   (K8s Resources)│─▶│     (Secrets Mgmt)             │ │
│  └─────────────────┘  └──────────────────┘  └─────────────────────────────────┘ │
│                     Deployed via Azure CLI + ARM Templates                      │
└─────────────────────────────────────────────────────────────────────────────────┘
                                     ▲
                               🔌 Arc Connection
                                     │
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    Azure VM - Edge Simulation Environment                       │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────────────────────┐ │
│  │   K3s Cluster   │  │   Historian DB   │  │     Factory Simulators          │ │
│  │   (Lightweight  │─▶│   (PostgreSQL)   │◀─│     (MQTT Publishers)          │ │
│  │   Kubernetes)   │  │                  │  │                                 │ │
│  └─────────────────┘  └──────────────────┘  └─────────────────────────────────┘ │
│         │                      │                             │                  │
│    ☸️ Container        🗃️ Historian API            🏭 edgemqttsim              │
│     Orchestration       (FastAPI :8080)            (CNC, 3DPrint, etc)          │
└─────────────────────────────────────────────────────────────────────────────────┘
                                     ▲
                              ⚙️ Bicep Deployment
                                     │
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           Azure Infrastructure                                  │ 
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────────────────────┐ │
│  │  Resource Group │─▶│  Virtual Network │─▶│  Storage & Security            │ │
│  │  (Deployment)   │  │  (Connectivity)  │  │  (Key Vault, ACR, etc)          │ │
│  └─────────────────┘  └──────────────────┘  └─────────────────────────────────┘ │
│                            azd up deploys everything                            │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🚀 **Solution Accelerator Deployment Flow**

### **Phase 1: Infrastructure Provisioning** (`azd up`)

```bash
# Single command deploys everything
azd up
```

**What gets deployed**:

1. **Azure VM with K3s** - Edge simulation environment
2. **Supporting Resources** - Key Vault, ACR, Storage, Networking  
3. **Cloud-init Setup** - Automatic K3s installation and configuration
4. **Arc Enablement** - VM automatically connects to Azure Arc

### **Phase 2: AIO Installation** (Automated)

**Triggered automatically post-VM deployment**:
```powershell
# Runs automatically via VM extension or cloud-init
.\infra\scripts\external_configuration\External-Configurator.ps1 -ConfigFile aio_config.json
```

**What gets configured**:
1. **Azure IoT Operations** - MQTT broker, dataflow engine
2. **Historian Service** - PostgreSQL + FastAPI deployed to K3s
3. **Factory Simulators** - MQTT data generators
4. **Dataflow Pipelines** - MQTT → processing → destinations

### **Phase 3: Fabric Integration** (Optional)

**Manual configuration for Fabric connectivity**:
```powershell
# Deploy Fabric endpoint
.\infra\scripts\Deploy-FabricEndpoint.ps1 -ConfigFile fabric_config.json

# Apply dataflows  
kubectl apply -f src/operations/fabric-realtime-dataflow.yaml
```


# Technology Stack Overview - Azure IoT Operations with Historian Simulation

This document provides a comprehensive overview of all technology stacks used in the Azure IoT Operations (AIO) Solution Accelerator with Historian Simulation. Each technology includes its purpose, key features, and links to official Microsoft Learn documentation.

## 📋 **Table of Contents**

- [Core Azure Infrastructure](#core-azure-infrastructure)
- [Azure IoT and Edge Services](#azure-iot-and-edge-services)
- [Container Platform and Orchestration](#container-platform-and-orchestration)
- [Data and Analytics Platform](#data-and-analytics-platform)
- [Development and Deployment Tools](#development-and-deployment-tools)
- [Communication and Messaging](#communication-and-messaging)
- [Monitoring and Observability](#monitoring-and-observability)
- [Security and Identity](#security-and-identity)

---

## 🏗️ **Core Azure Infrastructure**

### **Azure Virtual Machines**
**Purpose**: Host the edge simulation environment with K3s Kubernetes cluster
- **Role**: Primary compute platform simulating an industrial edge environment
- **Configuration**: Ubuntu 24.04 LTS with cloud-init for automated setup
- **Features**: Arc-enabled, auto-scaling, managed identities
- **📚 Learn More**: [Azure Virtual Machines Documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/)
- **🎯 Quick Start**: [Create a Linux VM in Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal)

### **Azure Virtual Network**
**Purpose**: Provides secure network isolation and connectivity for all Azure resources
- **Role**: Network backbone with subnets, NSGs, and public IP management
- **Features**: Network security groups, subnet isolation, private endpoints
- **📚 Learn More**: [Azure Virtual Network Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/)
- **🎯 Best Practices**: [Virtual Network Security](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-security-overview)

### **Azure Storage Account**
**Purpose**: Provides blob storage for schema registry and configuration data
- **Role**: Centralized storage for AIO configuration and message schemas
- **Features**: Hierarchical namespace, lifecycle management, access control
- **📚 Learn More**: [Azure Storage Documentation](https://learn.microsoft.com/en-us/azure/storage/)
- **🎯 Schema Registry**: [Azure Storage for IoT](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-overview)

---

## 🌐 **Azure IoT and Edge Services**

### **Azure IoT Operations**
**Purpose**: Unified data plane for industrial IoT scenarios with MQTT broker and dataflow capabilities
- **Role**: Core IoT platform providing MQTT messaging, dataflows, and device management
- **Key Components**: MQTT broker, dataflow processors, device registry, asset management
- **Deployment**: Kubernetes-based deployment on Arc-enabled clusters
- **📚 Learn More**: [Azure IoT Operations Documentation](https://learn.microsoft.com/en-us/azure/iot-operations/)
- **🎯 Getting Started**: [Deploy Azure IoT Operations](https://learn.microsoft.com/en-us/azure/iot-operations/get-started/quickstart-deploy)

### **Azure Arc**
**Purpose**: Extends Azure management and governance to edge Kubernetes clusters
- **Role**: Connects on-premises/edge K3s cluster to Azure for unified management
- **Key Features**: Policy enforcement, configuration management, monitoring integration
- **Benefits**: Centralized governance, Azure-native tooling, GitOps workflows
- **📚 Learn More**: [Azure Arc Documentation](https://learn.microsoft.com/en-us/azure/azure-arc/)
- **🎯 Arc-enabled Kubernetes**: [Azure Arc-enabled Kubernetes](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/overview)

### **Azure Device Registry**
**Purpose**: Centralized registry for managing IoT assets and their metadata
- **Role**: Asset lifecycle management, device twins, telemetry routing configuration
- **Integration**: Works with Azure IoT Operations for comprehensive device management
- **📚 Learn More**: [Azure Device Registry](https://learn.microsoft.com/en-us/azure/iot-operations/manage-devices-assets/overview-manage-assets)

---

## ☸️ **Container Platform and Orchestration**

### **Kubernetes (K3s)**
**Purpose**: Lightweight Kubernetes distribution for edge computing scenarios
- **Role**: Container orchestration platform hosting all edge applications  
- **Why K3s**: Reduced memory footprint, simplified deployment, edge-optimized
- **Hosted Services**: Historian database, factory simulators, MQTT broker, dataflow processors
- **📚 Learn More**: [Kubernetes Documentation](https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads)
- **🎯 K3s Specific**: [K3s Official Documentation](https://k3s.io/)

### **Azure Container Registry (ACR)**
**Purpose**: Private container registry for custom application images
- **Role**: Stores historian, simulator, and custom application container images
- **Features**: Integrated security scanning, geo-replication, webhook support
- **Integration**: Seamlessly integrated with Kubernetes deployments
- **📚 Learn More**: [Azure Container Registry Documentation](https://learn.microsoft.com/en-us/azure/container-registry/)
- **🎯 Best Practices**: [ACR Best Practices](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-best-practices)

### **Docker Containers**
**Purpose**: Application containerization for consistent deployment across environments
- **Role**: Packages historian service, factory simulators, and custom applications
- **Benefits**: Environment consistency, resource isolation, simplified deployment
- **📚 Learn More**: [Containers on Azure](https://learn.microsoft.com/en-us/azure/container-instances/)

### **Helm**
**Purpose**: Kubernetes package manager for application deployment and management
- **Role**: Manages complex Kubernetes deployments with templating and versioning
- **Usage**: Deploying Azure IoT Operations, historian service, and monitoring stack
- **📚 Learn More**: [Helm Documentation](https://learn.microsoft.com/en-us/azure/aks/kubernetes-helm)

---

## 📊 **Data and Analytics Platform**

### **Microsoft Fabric**
**Purpose**: Unified analytics platform for real-time and batch data processing
- **Role**: Cloud analytics destination for historian data with KQL capabilities
- **Key Components**: Event Streams, Real-Time Intelligence, KQL Database, Power BI integration
- **Data Flow**: Receives processed data from AIO dataflow pipelines
- **📚 Learn More**: [Microsoft Fabric Documentation](https://learn.microsoft.com/en-us/fabric/)
- **🎯 Real-Time Intelligence**: [Fabric Real-Time Intelligence](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/)

### **PostgreSQL**
**Purpose**: Relational database for historian data storage and time-series analysis
- **Role**: Primary data store for factory telemetry, equipment status, and historical analytics
- **Deployment**: Containerized on the K3s cluster with persistent volumes
- **Features**: JSON support, time-series extensions, full-text search
- **📚 Learn More**: [PostgreSQL on Azure](https://learn.microsoft.com/en-us/azure/postgresql/)
- **🎯 Flexible Server**: [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/)

### **Event Streams (Kafka)**
**Purpose**: Kafka-compatible streaming platform for real-time data ingestion
- **Role**: Ingests streaming data from AIO dataflows into Microsoft Fabric
- **Protocol**: Kafka-compatible APIs for seamless integration
- **Benefits**: High throughput, fault tolerance, horizontal scaling
- **📚 Learn More**: [Azure Event Hubs for Apache Kafka](https://learn.microsoft.com/en-us/azure/event-hubs/azure-event-hubs-kafka-overview)

### **KQL (Kusto Query Language)**
**Purpose**: Query language for time-series analysis and real-time analytics
- **Role**: Enables complex analytics on streaming and historical data in Fabric
- **Capabilities**: Time-series functions, geospatial queries, machine learning integration
- **📚 Learn More**: [KQL Documentation](https://learn.microsoft.com/en-us/kusto/query/)
- **🎯 Time Series**: [Time Series Analysis with KQL](https://learn.microsoft.com/en-us/kusto/query/samples?pivots=azuredataexplorer#time-series)

---

## 🛠️ **Development and Deployment Tools**

### **Azure Developer CLI (azd)**
**Purpose**: Simplified Azure application development and deployment tool
- **Role**: Single-command deployment (`azd up`) for complete solution stack
- **Benefits**: Infrastructure as Code integration, environment management, CI/CD workflows
- **Configuration**: `azure.yaml` defines complete deployment topology
- **📚 Learn More**: [Azure Developer CLI Documentation](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/)
- **🎯 Getting Started**: [Install and configure azd](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)

### **Azure CLI**
**Purpose**: Command-line interface for Azure resource management and automation
- **Role**: Infrastructure provisioning, resource configuration, deployment automation
- **Usage**: Deployed within scripts for Arc enablement and AIO configuration
- **📚 Learn More**: [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)
- **🎯 Installation**: [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

### **Bicep**
**Purpose**: Domain-specific language (DSL) for Azure Resource Manager deployments
- **Role**: Infrastructure as Code for Azure resources with type safety and intellisense
- **Benefits**: Simplified ARM template syntax, modularity, comprehensive resource support
- **Usage**: Defines all Azure infrastructure including VM, networking, storage, monitoring
- **📚 Learn More**: [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- **🎯 Tutorial**: [Bicep Tutorial](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep)

### **PowerShell**
**Purpose**: Cross-platform automation and configuration management
- **Role**: Deployment orchestration, AIO configuration, Fabric integration setup
- **Key Scripts**: External-Configurator.ps1, Deploy-FabricEndpoint.ps1, testing utilities
- **📚 Learn More**: [PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)
- **🎯 Azure PowerShell**: [Azure PowerShell Module](https://learn.microsoft.com/en-us/powershell/azure/)

---

## 📡 **Communication and Messaging**

### **MQTT Protocol**
**Purpose**: Lightweight publish-subscribe messaging protocol for IoT scenarios
- **Role**: Primary communication protocol between factory simulators and MQTT broker
- **Features**: Quality of Service levels, retained messages, session persistence
- **Implementation**: Eclipse Mosquitto broker within Azure IoT Operations
- **📚 Learn More**: [MQTT with Azure IoT](https://learn.microsoft.com/en-us/azure/iot-hub/iot-hub-mqtt-support)
- **🎯 Protocol Details**: [MQTT 3.1.1 Specification](https://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html)

### **REST APIs**
**Purpose**: HTTP-based APIs for historian data access and system management
- **Role**: Provides RESTful interface for historian data query and factory system status
- **Implementation**: FastAPI framework with automatic OpenAPI documentation
- **Endpoints**: Historical data query, real-time metrics, system health checks
- **📚 Learn More**: [RESTful APIs on Azure](https://learn.microsoft.com/en-us/azure/architecture/best-practices/api-design)

### **FastAPI**
**Purpose**: Modern, high-performance web framework for building APIs with Python
- **Role**: Powers the historian REST API with automatic validation and documentation
- **Features**: Automatic OpenAPI schema, async support, dependency injection
- **Benefits**: High performance, developer productivity, built-in validation
- **📚 Learn More**: [Web APIs with Python](https://learn.microsoft.com/en-us/azure/app-service/quickstart-python)
- **🎯 FastAPI Docs**: [FastAPI Official Documentation](https://fastapi.tiangolo.com/)

---

## 📈 **Monitoring and Observability**

### **Azure Monitor**
**Purpose**: Comprehensive monitoring solution for Azure resources and applications
- **Role**: Centralized monitoring, alerting, and diagnostics for entire solution stack
- **Components**: Metrics, logs, alerts, workbooks, application insights integration
- **Coverage**: Infrastructure metrics, application performance, custom telemetry
- **📚 Learn More**: [Azure Monitor Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/)
- **🎯 Getting Started**: [Azure Monitor Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)

### **Application Insights**
**Purpose**: Application Performance Management (APM) for historian and simulator applications
- **Role**: Tracks application performance, failures, dependencies, and user flows
- **Features**: Automatic dependency detection, live metrics, failure analysis
- **Integration**: SDK-based integration with FastAPI historian service
- **📚 Learn More**: [Application Insights Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- **🎯 Python Apps**: [Application Insights for Python](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opencensus-python)

### **Log Analytics Workspace**
**Purpose**: Centralized log collection and analysis platform
- **Role**: Aggregates logs from Kubernetes, applications, and Azure resources
- **Query Language**: KQL for log analysis and custom dashboards
- **Sources**: K3s cluster logs, application logs, Azure resource logs
- **📚 Learn More**: [Log Analytics Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/)
- **🎯 KQL Queries**: [KQL Tutorial](https://learn.microsoft.com/en-us/kusto/query/tutorials/learn-common-operators)

---

## 🔐 **Security and Identity**

### **Azure Key Vault**
**Purpose**: Secure storage and management of secrets, keys, and certificates
- **Role**: Stores connection strings, API keys, certificates for AIO and Fabric integration
- **Features**: Hardware security modules (HSM), access policies, audit logging
- **Integration**: Kubernetes Secret Store CSI driver for secret injection
- **📚 Learn More**: [Azure Key Vault Documentation](https://learn.microsoft.com/en-us/azure/key-vault/)
- **🎯 Best Practices**: [Key Vault Security](https://learn.microsoft.com/en-us/azure/key-vault/general/security-features)

### **Managed Identity**
**Purpose**: Azure identity service for secure authentication without stored credentials
- **Role**: Enables secure access to Azure resources from VM and Kubernetes applications
- **Types**: System-assigned and user-assigned identities for different scenarios
- **Benefits**: Eliminates credential management, automatic rotation, fine-grained access control
- **📚 Learn More**: [Managed Identity Documentation](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/)
- **🎯 Best Practices**: [Managed Identity Best Practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identities-best-practice-recommendations)

### **Microsoft Entra ID (Azure AD)**
**Purpose**: Cloud-based identity and access management service
- **Role**: Provides authentication and authorization for Azure resources and applications
- **Features**: Role-based access control (RBAC), conditional access, multi-factor authentication
- **Integration**: Secures access to Azure resources, Arc clusters, and Fabric workspaces
- **📚 Learn More**: [Microsoft Entra ID Documentation](https://learn.microsoft.com/en-us/entra/identity/)
- **🎯 RBAC**: [Azure Role-Based Access Control](https://learn.microsoft.com/en-us/azure/role-based-access-control/)

---

## 🎯 **Technology Integration Architecture**

### **Data Flow Technology Stack**
```
Factory Simulators (Python/MQTT) 
    ↓
MQTT Broker (Azure IoT Operations/Mosquitto)
    ↓  
Historian API (FastAPI/PostgreSQL)
    ↓
Dataflow Processors (Azure IoT Operations/K8s)
    ↓
Event Streams (Kafka/Microsoft Fabric)
    ↓
Analytics (KQL/Power BI)
```

### **Deployment Technology Stack**
```
Infrastructure (Bicep/Azure CLI)
    ↓
Virtual Machine (Ubuntu/cloud-init)
    ↓
Container Platform (K3s/Docker)
    ↓
Applications (Helm/Kubernetes)
    ↓
Monitoring (Azure Monitor/Application Insights)
```

### **Security Technology Stack**
```
Identity (Microsoft Entra ID/Managed Identity)
    ↓
Secrets (Azure Key Vault/CSI Driver)
    ↓
Network (Virtual Network/NSGs)
    ↓
Access Control (RBAC/Conditional Access)
```

---

## 📋 **Quick Reference Links**

### **Essential Getting Started Resources**
- [Azure IoT Operations Quickstart](https://learn.microsoft.com/en-us/azure/iot-operations/get-started/)
- [Azure Developer CLI Installation](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
- [Microsoft Fabric Getting Started](https://learn.microsoft.com/en-us/fabric/get-started/)
- [Azure Arc-enabled Kubernetes](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/quickstart-connect-cluster)

### **Advanced Topics**
- [Bicep Language Reference](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions)
- [KQL Query Reference](https://learn.microsoft.com/en-us/kusto/query/kql-quick-reference)
- [Kubernetes Best Practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)
- [Azure Monitor Best Practices](https://learn.microsoft.com/en-us/azure/azure-monitor/best-practices)


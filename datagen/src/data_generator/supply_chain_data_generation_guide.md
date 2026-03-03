# Supply Chain Data Generation Guide

**Enterprise Supply Chain & Inventory Management with Analytics Dashboard**

Generates comprehensive supply chain data with sales integration and professional 4-chart analytics visualization.

## 🎯 What It Does

- **📦 Supplier Management** → 5 suppliers with procurement events  
- **📊 Inventory Intelligence** → Sales-driven inventory levels and purchase orders
- **� Demand Forecasting** → 3-month forward-looking demand predictions with confidence scoring
- **📈 Analytics Dashboard** → Professional 4-chart PNG with forecast vs reality visualization

**Output**: 9 CSV files + analytics dashboard (supply_chain_data.png) + summary report

**Optional**: Use `--copydata` to copy all generated data to `../../infra/data/` for infrastructure deployment.

## Input Data

- **suppliers.json**: 5 suppliers with lead times and relationships
- **Product_Samples_Combined.csv**: Product catalog for supplier mappings  
- **Sales Data**: Analyzes existing transactions for demand intelligence

## 🚀 Quick Start

```bash
# Recommended: Complete with analytics dashboard
python main_generate_supplychain.py --graph --copydata -s 2025-12-01 -e 2026-03-31 --num-orders 50 --num-transactions 800

# Default: Generate 1 year of data (today back 1 year)  
python main_generate_supplychain.py --graph

# Development testing
python main_generate_supplychain.py --graph --num-orders 10 --num-transactions 50
```

**Default**: When no dates are specified, automatically generates 1 year of data (from 1 year ago to today's execution date).  
**Note**: Use `--copydata` flag to copy generated data to `../../infra/data/` for infrastructure deployment.

## ⚙️ Default Behavior

**When no dates are specified**, the program automatically uses smart defaults:

| Setting | Default Value | Description |
|---------|---------------|-------------|
| **Start Date** | **1 year ago** | Automatically calculated from today's date |
| **End Date** | **Today** (`2026-03-03`) | Automatically uses current date |
| **Timeline** | **365 days** | Complete business year coverage |
| **Transactions** | **Auto-scaled** | Analyzes 56,457+ sales records and scales to 6,375 transactions |

**Simple Command**: `python main_generate_supplychain.py --graph`
**Result**: Complete supply chain dataset spanning full business timeline with realistic patterns

## 📋 Command Options

| Option | Description | Values | Impact |
|--------|------------|--------|--------|
| `--graph` | Generate analytics dashboard | Always use | Creates 4-chart PNG |
| `--copydata` | Copy files to infra/data directory | Optional | Organizes files in infra/data/suppliers/ and infra/data/inventory/ + suppliers.json config |
| `--num-orders` | Purchase orders to generate | 10-15 (test), 25-35 (demo), 50+ (production) | Each order = 2-5 line items |
| `--num-transactions` | Inventory transactions | 50-100 (small), 150-300 (demo), 800+ (full) | Stock movements for analytics |
| `-s/--start-date` | Start date (YYYY-MM-DD) | `2025-01-01` | Timeline beginning |
| `-e/--end-date` | End date (YYYY-MM-DD) | `2026-03-02` | Timeline end |

## 📁 Output Files

```
output/
├── suppliers/     # Suppliers, ProductSuppliers, SupplyChainEvents  
├── inventory/     # Inventory, PurchaseOrders, PurchaseOrderItems, InventoryTransactions, DemandForecast
├── supply_chain_data.png           # Analytics dashboard
└── sample_supplychain_data_summary.md   # Business report
```

**With --copydata option**:
```
infra/data/
├── suppliers/     # Organized supplier files + suppliers.json config
├── inventory/     # Organized inventory files including demand forecasts
└── sample_supplychain_data_summary.md   # Business report
```

## 🏭 Suppliers

| Supplier | Type | Lead Time | Reliability |
|----------|------|-----------|-------------|
| Contoso Outdoor/Kitchen/Alpine | Primary | 7-14 days | 90-95% |
| Worldwide Importers | Backup | 21 days | 88% |
| Fabrikam Supply Co | Backup | 28 days | 85% |

## 📊 Data Output

**Supplier Management** (3 CSV files + config): Suppliers, ProductSuppliers, SupplyChainEvents + suppliers.json
**Inventory Management** (5 files): Inventory, PurchaseOrders, PurchaseOrderItems, InventoryTransactions, DemandForecast  
**Analytics**: 4-chart dashboard featuring:
- **🔮 Demand Forecast vs Recent Sales Reality** - Shows 3-month transition from actual sales to predicted demand
- **🏭 Warehouse Capacity Utilization** - Real-time capacity monitoring with risk zones  
- **📊 Inventory Health Status** - Actionable stock level insights by category
- **🎯 Supplier Performance Matrix** - Reliability vs risk analysis for procurement decisions

## 🎯 Use Cases

- **Supply Chain Analytics**: Supplier performance, inventory optimization, lead time analysis
- **Demand Forecasting**: 3-month forward-looking predictions with seasonal patterns and confidence scoring
- **Business Intelligence**: Cost analysis, predictive analytics, supplier risk management
- **Data Engineering**: Fabric lakehouse testing, ETL development, system integration with forecasting models

## 🎯 Best Practices

1. Always use `--graph` for analytics dashboard
2. Start with small datasets before scaling up  
3. Review dashboard for realistic metrics (≥80% supplier reliability)
4. Use generated PNG for presentations




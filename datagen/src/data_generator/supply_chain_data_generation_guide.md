# Supply Chain Data Generator

Generates supplier management and inventory data with analytics dashboard.

## Quick Start

```bash
# Full example with analytics
python main_generate_supplychain.py --graph --copydata -s 2025-12-01 -e 2026-03-31 --num-orders 50 --num-transactions 800

# Default: 1 year of data with dashboard
python main_generate_supplychain.py --graph

# Testing with smaller dataset
python main_generate_supplychain.py --graph --num-orders 10 --num-transactions 50
```

## Options

| Option | Description |
|--------|-------------|
| `--graph` | Generate 4-chart analytics dashboard |
| `--copydata` | Copy files to infra/data/ |
| `--num-orders` | Number of purchase orders (default scales to data) |
| `--num-transactions` | Number of inventory transactions (default scales to data) |
| `-s`, `--start-date` | Start date (YYYY-MM-DD) |
| `-e`, `--end-date` | End date (YYYY-MM-DD) |

## Output Files

**Generated Files:**
- **Suppliers**: Suppliers, ProductSuppliers, SupplyChainEvents (3 files)
- **Inventory**: Inventory, PurchaseOrders, PurchaseOrderItems, InventoryTransactions, DemandForecast (5 files)
- **Analytics**: supply_chain_data.png (4-chart dashboard)
- **Summary**: sample_supplychain_data_summary.md

**Locations:**
- Local: `output/suppliers/` and `output/inventory/`
- Infrastructure: `../../infra/data/suppliers/` and `../../infra/data/inventory/` (with `--copydata`)

## Features

**Analytics Dashboard (--graph):**
- Demand forecast vs actual sales
- Warehouse capacity utilization
- Inventory health by category  
- Supplier performance analysis

**Data Characteristics:**
- 5 suppliers with realistic lead times
- Sales-driven inventory levels
- 3-month demand forecasting
- Professional business intelligence charts

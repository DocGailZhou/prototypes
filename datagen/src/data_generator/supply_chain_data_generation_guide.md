# Supply Chain Data Generation Guide

Generates intelligent supplier management and inventory data with auto-scaling based on sales patterns. 

## 🚀 Interactive PowerShell Workflow (Recommended)

**Simplest Method - Complete Business Dataset:**
```powershell
.\datagen.ps1
```

**What it does:**
- Interactive prompts with smart defaults (2025-01-01 to 2026-03-31)
- First generates sales data for all domains (Camping, Kitchen, Ski)
- Then auto-scales and generates supply chain data based on sales volume
- Creates comprehensive analytics dashboard (4-chart visualization)
- Copies all data to infra directories
- Complete end-to-end business simulation

**Interactive Options:**
- **Default dates**: 15-month period (full 2025 + Q1 2026)
- **Business growth**: Enabled by default (for realistic sales patterns)
- **Analytics graphs**: Enabled by default (revenue + supply chain dashboards)
- **Copy data**: Enabled by default (to infra/data directories)

## 📊 Python Command Line (Advanced)

### Quick Examples

```bash
# Auto-scale (recommended): Analyzes existing sales data
python main_generate_supplychain.py --auto-scale --graph --copydata --no-display

# Custom date range with auto-scaling
python main_generate_supplychain.py -s 2025-01-01 -e 2026-03-31 --auto-scale --graph --copydata --no-display

# Manual parameters (if no sales data exists)
python main_generate_supplychain.py --num-orders 125 --num-transactions 2000 --graph --copydata --no-display

# Testing with smaller dataset
python main_generate_supplychain.py --auto-scale --num-orders 10 --num-transactions 50 --no-display
```

### Command Line Options

| Option | Description |
|--------|-------------|
| `--auto-scale` | **Auto-calculate parameters based on existing sales data (recommended)** |
| `-s`, `--start-date` | Start date (YYYY-MM-DD, default: 2025-01-01) |
| `-e`, `--end-date` | End date (YYYY-MM-DD, default: 2026-03-31) |
| `--graph` | Generate 4-chart analytics dashboard |
| `--no-display` | Save graphs without GUI windows (for automation) |
| `--copydata` | Copy generated files to infra/data/ directory |
| `--num-orders` | Number of purchase orders (default: 30, overridden by auto-scale) |
| `--num-transactions` | Number of inventory transactions (default: 500, overridden by auto-scale) |
| `--inventory-only` | Generate only inventory data (requires existing supplier data) |
| `--num-events` | Number of supply chain events (default: 15) |

## 🧠 Auto-Scaling Intelligence

### How Auto-Scale Works

**Sales Data Analysis Process:**
1. Scans `output/[camping|kitchen|ski]/sales/` directories for OrderLine CSV files
2. Loads and filters sales data by the specified date range
3. Counts total sales line items and orders across all product categories
4. Analyzes product-level sales velocity and demand patterns

**Parameter Calculation Logic:**

**Purchase Order Scaling:**
- Uses realistic ratio of ~1 purchase order per 400-500 sales line items
- Business logic: Most companies consolidate orders for efficiency
- Applies minimum of 20 orders and maximum of 200 orders
- Example: 50,504 line items ÷ 450 = 112 purchase orders

**Inventory Transaction Scaling:**
- Calculates 2-3x sales volume (receipts, adjustments, transfers, issues)
- Business logic: Multiple inventory movements per sale (receipt → putaway → pick → ship)
- Applies daily transaction caps (15 per day maximum) for realistic volume
- Uses date range duration for proper temporal distribution
- Example: 50,504 × 2.7 = 136,361 but capped at 455 days × 15 = 6,825 transactions

**Inventory Level Intelligence:**
- Each product's stock levels based on actual sales velocity from historical data
- Safety stock calculated as 2-4 weeks of average monthly sales per product
- Reorder points determined by supplier lead times plus safety stock
- Current stock levels vary realistically around reorder points
- Some products intentionally set to low-stock scenarios for realism

### Example Auto-Scale Results
```
📈 Sales Analysis: 50,504 line items from 18,669 orders (Camping, Kitchen, Ski)
📊 Calculated Parameters:
   • Purchase Orders: 112 (was default 30)
   • Inventory Transactions: 6,825 (was default 500) 
   • Daily Transaction Rate: ~15 transactions/day
   • Coverage: 455 days of business activity
✅ Using auto-calculated parameters for realistic business simulation
```

## 📁 Generated Files & Structure

### Output Directory Structure
```
output/
├── suppliers/
│   ├── Suppliers.csv
│   ├── ProductSuppliers.csv
│   └── SupplyChainEvents.csv
├── inventory/
│   ├── Inventory.csv
│   ├── PurchaseOrders.csv
│   ├── PurchaseOrderItems.csv
│   ├── InventoryTransactions.csv
│   └── DemandForecast.csv
├── sample_supplychain_data_summary.md
└── supply_chain_analytics_dashboard.png (with --graph)
```

### Infrastructure Copy (with --copydata)
```
../../infra/data/
├── suppliers/ (mirrors output structure)
└── inventory/ (mirrors output structure)
```

### File Contents

**Supplier Files:**
- **Suppliers.csv**: Supplier master data (SupplierID, Name, ContactInfo, LeadTime, etc.)
- **ProductSuppliers.csv**: Product-supplier relationships (ProductID, SupplierID, IsBackup, etc.)
- **SupplyChainEvents.csv**: Risk events and disruptions (EventID, EventType, ImpactLevel, etc.)

**Inventory Files:**
- **Inventory.csv**: Current stock levels (ProductID, CurrentStock, ReorderPoint, SafetyStock, etc.)
- **PurchaseOrders.csv**: Purchase order headers (OrderID, SupplierID, OrderDate, Status, etc.)
- **PurchaseOrderItems.csv**: Purchase order line items (ItemID, OrderID, ProductID, Quantity, etc.)
- **InventoryTransactions.csv**: Stock movements (TransactionID, ProductID, Type, Quantity, Date, etc.)
- **DemandForecast.csv**: 3-month demand predictions (ProductID, ForecastDate, ForecastQuantity, etc.)

## 📊 Analytics Dashboard (--graph)

### Four-Chart Business Intelligence Dashboard

**Chart 1: Demand Forecast vs Recent Sales Reality**
- Compares 3-month demand forecasts with actual sales patterns
- Shows forecasting accuracy and seasonal trends
- Helps identify planning gaps and opportunities

**Chart 2: Warehouse Capacity Utilization**  
- Current inventory levels vs. maximum capacity
- High utilization (>70%) and critical capacity (>90%) indicators
- Helps identify storage constraints and expansion needs

**Chart 3: Inventory Health Status**
- Stock levels by product category (Camping, Kitchen, Ski)
- Safety stock vs. current stock analysis
- Low stock and overstock identification

**Chart 4: Supplier Performance Matrix**
- Risk score vs. reliability analysis
- Primary vs. backup supplier visualization
- Performance-based supplier selection insights

### Professional Output
- High-resolution PNG (150 DPI)
- Date-specific filenames: `supply_chain_analytics_dashboard.png`
- Clean, font-compatible charts (no emoji dependencies)
- Business-ready visualization for reports and presentations

## 🔗 Integration Workflow

### Standalone Supply Chain Generation
```bash
# Generate only supply chain data (requires existing sales data)
python main_generate_supplychain.py --auto-scale --graph --copydata --no-display
```

### Complete Business Dataset (Sales + Supply Chain)
```powershell
# Interactive orchestration (recommended)
.\datagen.ps1

# Manual two-phase generation:
python main_generate_sales.py -s 2025-01-01 -e 2026-03-31 --enable-growth --copydata --graph --no-display
python main_generate_supplychain.py -s 2025-01-01 -e 2026-03-31 --auto-scale --copydata --graph --no-display
```

### Integration Benefits
1. **Sales Data Drives Inventory**: Stock levels reflect actual product demand
2. **Procurement Matches Volume**: Purchase orders scaled to business activity
3. **Realistic Relationships**: Supplier-product connections based on sales patterns
4. **Temporal Consistency**: All supply chain activities within sales date range
5. **Business Logic**: Inventory movements align with customer demand

## 🎯 Use Cases

### Supply Chain Analytics
- Inventory optimization modeling
- Supplier performance analysis
- Demand forecasting validation
- Risk management simulation

### Business Intelligence
- Power BI supply chain dashboards  
- Tableau inventory visualizations
- SQL-based procurement reporting
- Data warehouse supply chain modules

### Application Development
- ERP system inventory modules
- Supply chain management applications
- Procurement workflow systems
- Warehouse management system testing

### Education & Training
- Supply chain management courses
- Inventory control workshops
- Business analytics training
- SQL learning with realistic datasets

## 🧮 Business Logic & Realism

### Supplier Management
- **5 realistic suppliers** with varied lead times and capabilities
- **Primary + Backup relationships** for supply chain resilience  
- **Geographic distribution** affecting lead times and costs
- **Reliability scoring** based on performance history

### Inventory Intelligence
- **Sales-velocity driven stock levels** (not random numbers)
- **Safety stock calculations** using sales patterns and lead times
- **Reorder point optimization** based on demand variability
- **ABC classification** with appropriate stock policies

### Procurement Patterns
- **Economic order quantities** based on demand and costs
- **Supplier lead times** affecting order timing
- **Seasonal ordering** patterns aligned with sales forecasts
- **Emergency purchases** for stock-out scenarios

### Transaction Realism
- **Receipt transactions** when purchase orders arrive
- **Putaway activities** moving stock to locations
- **Picking transactions** for sales fulfillment
- **Adjustment transactions** for cycle counts and corrections
- **Transfer movements** between locations

## 🛠️ Technical Requirements

**Dependencies:**
```bash
pip install pandas numpy matplotlib
```

**System Requirements:**
- Python 3.7+
- PowerShell 5.0+ (for interactive workflow)
- 200MB+ free disk space (for large datasets)
- Windows/Linux/macOS compatible

## 📈 Performance & Scalability

### Dataset Sizes (15-month period with auto-scale)
- **Small Sales Volume** (1K orders): ~20 POs, ~500 transactions
- **Medium Sales Volume** (10K orders): ~50 POs, ~2K transactions  
- **Large Sales Volume** (50K orders): ~112 POs, ~7K transactions
- **Enterprise Sales Volume** (100K+ orders): ~200 POs, ~15K transactions

### Generation Speed
- Small datasets: <30 seconds
- Medium datasets: 1-2 minutes
- Large datasets: 3-5 minutes
- Analytics graphs: +10-15 seconds

## 📋 Summary & Reporting

Every supply chain generation creates comprehensive documentation:
- **Parameter Analysis**: Auto-scale calculations and rationale
- **Volume Statistics**: Orders, transactions, and inventory counts
- **Supplier Summary**: Lead times, relationships, and performance
- **Inventory Health**: Stock levels, reorder points, and forecasts
- **Integration Status**: Sales data connectivity and date alignment
- **File Manifest**: All generated files with sizes and locations

The summary report provides complete audit trail for business simulation accuracy and helps validate the realism of generated supply chain data.

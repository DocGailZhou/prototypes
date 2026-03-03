# Sales and Finance Data Generation Guide

A comprehensive utility for generating realistic sales and finance data across three business domains with automated infrastructure data deployment. The main purpose is to generate sales data. Finance data is generated based on actual sales data. 

## 🎯 What It Does

Generates realistic eCommerce data for three business domains:
- **🏕️ Camping Products** → Outdoor gear and equipment
- **🍳 Kitchen Products** → Home appliances and kitchenware  
- **⛷️ Ski Equipment** → Winter sports gear and accessories

Each domain produces **6 CSV files**: Orders, OrderLines, OrderPayments (Sales) + Invoices, Payments, Accounts (Finance).

**Optional**: Use `--copydata` to copy all generated data to `../../infra/data/` for infrastructure deployment.

## 🚀 Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Recommended: Full featured example
python main_generate_sales.py -s 2025-01-01 -e 2026-03-31 --enable-growth --copydata --graph

# Default: Generate 1 year of data (today back 1 year)
python main_generate_sales.py

# Single domain only
python main_generate_sales.py --camping-only
```

**Default**: When no dates are specified, automatically generates 1 year of data (from 1 year ago to today's execution date).  
**Note**: Use `--copydata` flag to copy generated data to `../../infra/data/` for infrastructure deployment.





## 📋 Command Options

### **Main Orchestrator (`main_generate_sales.py`)**
| Option | Description | Example |
|--------|------------|---------|
| `-s`, `--start-date` | Start date (YYYY-MM-DD) | `-s 2025-01-01` |
| `-e`, `--end-date` | End date (YYYY-MM-DD) | `-e 2025-12-31` |
| `--enable-growth` | Enable business growth patterns | |
| `--graph` | Generate revenue trend graph | |
| `--copydata` | Copy files to infra/data directory with organized structure | |
| `--camping-only` | Generate only camping orders | |
| `--kitchen-only` | Generate only kitchen orders | |
| `--ski-only` | Generate only ski orders | |

### **Individual Generators**
Run individual domain generators for specific customization:
```bash
python generate_camping_orders.py -s 2025-01-01 -e 2025-12-31
python generate_kitchen_orders.py -s 2025-01-01 -e 2025-12-31  
python generate_ski_orders.py -s 2025-01-01 -e 2025-12-31
```

### **Domain Utilities**
```bash
# Generate ProductCategory files from Product data
python utils/create_category_from_product.py

# Consolidate all Product and ProductCategory files
python utils/consolidate_product_domain_input.py
```

## 📁 Output Structure

### **Local Output (src/data_simulator/output/)**
```
output/
├── camping/                      # 🏕️ Camping Products
│   ├── sales/                    # Order_Samples_Camping.csv, OrderLine_Samples_Camping.csv, OrderPayment_Camping.csv
│   └── finance/                  # Invoice_Samples_Camping.csv, Payment_Samples_Camping.csv, Account_Samples_Camping.csv
├── kitchen/                      # 🍳 Kitchen Products  
│   ├── sales/                    # Order_Samples_Kitchen.csv, OrderLine_Samples_Kitchen.csv, OrderPayment_Kitchen.csv
│   └── finance/                  # Invoice_Samples_Kitchen.csv, Payment_Samples_Kitchen.csv, Account_Samples_Kitchen.csv
├── ski/                          # ⛷️ Ski Equipment
│   ├── sales/                    # Order_Samples_Ski.csv, OrderLine_Samples_Ski.csv, OrderPayment_Ski.csv
│   └── finance/                  # Invoice_Samples_Ski.csv, Payment_Samples_Ski.csv, Account_Samples_Ski.csv
└── sample_sales_data_summary.md  # 📊 Comprehensive data generation summary with statistics
```

### **Infrastructure Data Copy (../../infra/data/) - Optional**
**Use --copydata flag to organize files for infrastructure:**
- **Product data** → `infra/data/product/` (all product and category files)
- **Customer data** → `infra/data/customer/` (all customer and location files)  
- **Sales/Finance data** → `infra/data/camping|kitchen|ski/` (preserving folder structure)
- **Reference data** → `infra/data/shared/` (all input files for backward compatibility)
- **Summary report** → `infra/data/sample_sales_data_summary.md` (comprehensive generation statistics)

### **Input Files**
```
input/
├── Product_Samples_Combined.csv          # All products consolidated
├── ProductCategory_Samples_Combined.csv  # All categories consolidated
├── Product_Samples_Camping.csv           # Individual domain files
├── Product_Samples_Kitchen.csv
├── Product_Samples_Ski.csv
├── ProductCategory_Samples_Camping.csv
├── ProductCategory_Samples_Kitchen.csv
├── ProductCategory_Samples_Ski.csv
├── Customer_Samples.csv                  # Customer master data (513 customers)
├── CustomerAccount_Samples.csv           # Customer account information
├── CustomerRelationshipType_Samples.csv  # Customer tier definitions
├── CustomerTradeName_Samples.csv         # Customer trade names
└── Location_Samples.csv                  # Customer location data
```

## 💰 Data Characteristics

### **Realistic Business Patterns**
- **Seasonal trends**: Tents in spring, ski gear in winter, kitchen appliances during holidays
- **Customer hierarchy**: Two-level system (CustomerTypeId > CustomerRelationshipTypeId)
- **Schema compliance**: 100% Microsoft Fabric Delta Lake compatible
- **Platform independence**: Domain-focused, not tied to specific cloud platforms

### **Customer Segment Hierarchy**

| Category | Tier Structure | Order Frequency (Camping/Kitchen/Ski) | Description |
|----------|---------------|----------------|-------------|
| **Individual** | Standard > Premium > VIP | 1-8 / 2-6 / 1-8 orders | Consumer progression (Kitchen boosted) |
| **Business** | SMB > Premier > Partner | 2-15 / 6-30 / 2-15 orders | Partner tier highest (Kitchen boosted) |
| **Government** | Federal > State > Local | 0-4 / 2-8 / 0-4 orders | Specialized procurement (Kitchen boosted) |

### **Average Order Values**
- **Camping**: ~$1,023 (moderate outdoor gear)
- **Kitchen**: ~$560 (boosted appliances, 2-4 products per order with 2x revenue multiplier)  
- **Ski**: ~$1,608 (premium equipment - highest value)

### **Customer Hierarchy Implementation**
The system uses a **two-level hierarchy** matching the database schema:
- `CustomerTypeId`: Individual | Business | Government  
- `CustomerRelationshipTypeId`: Specific tier within each type
- This structure allows easy addition of new customer types or relationship tiers

## � Business Growth Patterns

**NEW**: Enhanced with realistic business growth simulation when using `--enable-growth` flag.

### **Three-Phase Growth Simulation**

| Phase | Timeline | Pattern | Multiplier Range | Description |
|-------|----------|---------|------------------|-------------|
| **Phase 1** | 0-33% | Initial Growth | 1.0 → 1.2 (+20%) | Startup momentum, market entry |
| **Phase 2** | 33-67% | Market Decline | 1.2 → 0.9 (-25%) | Competition, market saturation |
| **Phase 3** | 67-100% | Accelerated Growth | 0.9 → 1.4 (+56%) | Innovation, market expansion |

### **Market Events & Seasonal Patterns**

| Event | Timing | Frequency Boost | Size Boost | Impact |
|-------|--------|----------------|------------|--------|
| **Black Friday Weekend** | Last Fri-Mon in Nov | 4.0× | 1.4× | Major shopping event |
| **Christmas Shopping** | Dec 1-25 | 1.2×-2.0× | 1.2× | Progressive weekly increases |
| **Memorial Day** | Last Mon in May | 1.5× | 1.3× | Outdoor season start |
| **Back-to-School** | Aug 15-31 | 1.3× | 1.2× | Kitchen equipment boost |
| **New Year Resolutions** | Jan 2-15 | 1.4× | 1.1× | Fitness/outdoor goals |
| **Post-Holiday Lull** | Jan 16-31 | 0.7× | 0.9× | Reduced activity |

### **Customer Tier Amplification**

**Higher tiers are more responsive** to growth and decline patterns:

| Customer Type | Tiers | Growth Amplifier | Notes |
|---------------|-------|-----------------|-------|
| **Individual** | Standard/Premium/VIP | 1.0×/1.3×/1.6× | Consumer progression |
| **Business** | SMB/Premier/Partner | 1.2×/1.5×/1.6× | Partner tier highest |
| **Government** | Federal/State/Local | 0.8×/0.7×/0.6× | Less responsive |

### **Growth Analytics**

**Camping and Kitchen generators** (both enhanced) provide detailed growth tracking:
- Phase progression monitoring
- Market event impact analysis  
- Customer tier response patterns
- Order frequency and size adjustments

**Ski generator**: Standard patterns (growth enhancement baseline for comparison)

## 🎯 Key Features

### **Revenue Trend Visualization**
**NEW**: Generate interactive revenue trend graphs with `--graph` flag:
- **Monthly aggregation**: Clear trends without daily noise for multi-year analysis
- **Dual-panel graphs**: Individual domain trends + combined total revenue  
- **Business growth indicators**: Camping & Kitchen* show 3-phase growth pattern analysis
- **Visual distinction**: Solid lines (growth-enabled) vs dashed lines (standard)
- **Trend analysis**: Quadratic trend line and phase-by-phase statistics
- **High-resolution export**: PNG graphs saved to output folder
- **Requirements**: matplotlib, pandas, and numpy

### **Automated Infrastructure Deployment (--copydata)**
- **Product files**: Copied to `infra/data/product/` (9 product & category files)
- **Customer files**: Copied to `infra/data/customer/` (5 customer & location files)
- **Sales/Finance data**: Organized in `infra/data/camping|kitchen|ski/sales|finance/`
- **Reference data**: Backward compatible copying to `infra/data/shared/` (all input files)
- **Summary documentation**: Comprehensive report in `infra/data/sample_sales_data_summary.md`
- **Overwrite protection**: Existing files are automatically overwritten

**Complete Infrastructure Structure:**
```
infra/data/
├── product/          # Product_Samples_*.csv, ProductCategory_Samples_*.csv (9 files)
├── customer/         # Customer*.csv, Location_Samples.csv (5 files)
├── camping/
│   ├── sales/        # Order, OrderLine, OrderPayment CSV files
│   └── finance/      # Invoice, Payment, Account CSV files
├── kitchen/
│   ├── sales/        # Order, OrderLine, OrderPayment CSV files  
│   └── finance/      # Invoice, Payment, Account CSV files
├── ski/
│   ├── sales/        # Order, OrderLine, OrderPayment CSV files
│   └── finance/      # Invoice, Payment, Account CSV files
├── shared/           # All input files (backward compatibility)
└── sample_sales_data_summary.md  # Generation statistics & analytics
```

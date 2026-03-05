# Sales & Finance Data Generator

Generates realistic sales and finance data for three business domains: Camping 🏕️, Kitchen 🍳, and Ski ⛷️.

## Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Full example with all features
python main_generate_sales.py -s 2025-01-01 -e 2026-03-31 --enable-growth --copydata --graph

# Default: 1 year of data
python main_generate_sales.py

# Single domain
python main_generate_sales.py --camping-only
```

## Options

| Option | Description |
|--------|-------------|
| `-s`, `--start-date` | Start date (YYYY-MM-DD) |
| `-e`, `--end-date` | End date (YYYY-MM-DD) |
| `--camping-only` | Generate only camping data |
| `--kitchen-only` | Generate only kitchen data |
| `--ski-only` | Generate only ski data |
| `--enable-growth` | Add business growth patterns |
| `--graph` | Generate revenue chart |
| `--copydata` | Copy files to infra/data/ |

## Output Files

**Generated for each domain (camping, kitchen, ski):**
- **Sales**: Orders, OrderLines, OrderPayments
- **Finance**: Invoices, Payments, Accounts

**Locations:**
- Local: `output/[domain]/sales/` and `output/[domain]/finance/`
- Infrastructure: `../../infra/data/[domain]/` (with `--copydata`)

**Summary:** `sample_sales_data_summary.md` with statistics

## Features

**Business Growth (--enable-growth):**
- Three-phase growth simulation
- Seasonal events (Black Friday, Christmas, etc.)
- Customer tier responses

**Revenue Visualization (--graph):**
- Monthly revenue trends
- Growth pattern analysis
- Saves PNG chart to output folder

**Data Characteristics:**
- Average order values: Camping ~$1,000, Kitchen ~$560, Ski ~$1,600
- Customer types: Individual, Business, Government with tier progression  
- Seasonal patterns and realistic business cycles

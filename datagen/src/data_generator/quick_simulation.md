```bash
# program location
cd datagen\src\data_generator
# Complete Business Data Simulation

# Sales and Finance Data (15 months: full 2025 + Q1 2026)
python main_generate_sales.py -s 2025-01-01 -e 2026-03-31 --enable-growth --copydata --graph
python main_generate_sales.py -s 2025-01-01 -e 2026-03-31 --enable-growth --copydata

# Supply Chain Data 
python main_generate_supplychain.py -s 2025-01-01 -e 2026-03-31 --num-orders 50 --num-transactions 800 --graph --copydata
# Supply Chain Data
python main_generate_supplychain.py -s 2025-01-01 -e 2026-03-31 --num-orders 50 --num-transactions 800
```






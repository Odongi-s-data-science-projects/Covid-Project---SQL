**Zepto E-commerce Data Analysis (SQL)**

A comprehensive SQL-based analysis of product inventory and sales data from an e-commerce platform (Zepto) to derive key business insights on pricing, inventory management, and customer value.


**Description**

This repository contains a single SQL script (Project.sql) that demonstrates a complete data analysis pipeline. It covers table creation, data exploration, cleaning steps, and a series of complex queries designed to answer specific business questions related to product performance, pricing strategy, and warehouse/delivery planning.


**Key Insights & Features**
1. Database Setup: Defines the Zepto table schema for product data.
2. Data Cleaning: Identifies and corrects data inconsistencies (e.g., handling zero MRP values and converting monetary units).
3. Pricing Strategy: Identifies the top 10 products with the highest discount percentage.
4. Inventory Management: Flags high-value, out-of-stock products that require immediate restocking.
5. Revenue & Discount Analysis: Calculates estimated revenue per category and identifies categories with the highest average discounts.
6. Logistics & Planning: Segments products by weight category (Low, Medium, Bulk) and calculates total inventory weight per category for warehouse optimization.


**Getting Started**

This project was built on PostgreSQL.

**Execution**
1. Set up your database: Ensure you have a database connection established.
2. Execute the SQL script: Run the Project.sql file in your preferred SQL client.

The script will:
1. Create the Zepto table.
2. Attempt to run data exploration queries (may require data to be loaded first).
3. Perform data cleaning (e.g., deleting rows where mrp = 0).
4. Execute all 8 Business Insight Queries.


**Business Insights from Zepto E-commerce Data**
1. Top 10 Best-Value Products (by Discount) ; Identify products being heavily promoted or offering the best bargains to customers.
2. High MRP, Out-of-Stock Products ;  Helps the company know products that are being bought frequently, enabling them to restock and prevent loss in revenue.
3. Estimated Revenue for Each Category ; Provides a baseline for category performance and contribution to overall sales.
4. High MRP, Low Discount Products ; Identify premium products that maintain high price points even after applying discounts.
5. Top 5 Categories by Average Discount ; Useful for marketing teams to understand where most price cuts happen and how they can optimize them accordingly.
6. Price per Gram for Products (100g+) ; Compares the effective cost efficiency of products based on weight, which is useful for identifying the best value for money on bulkier items.
7. Product Weight Categorization ; Good for delivery planning and optimizing shipping costs based on the physical size/weight of items.
8. Total Inventory Weight Per Category ; Great for warehouse planning, inventory space allocation, and understanding logistics demands.


**Script Structure**

The Project.sql file is logically organized into three main phases:
1. Schema and Data Setup: DROP TABLE and CREATE TABLE statements.
2. Data Exploration & Cleaning: Initial SELECT COUNT(*), LIMIT 10, NULL checks, deletion of erroneous data (mrp = 0), and a critical UPDATE to convert paise to rupees.
3. Business Insights: The 8 detailed analytical queries focusing on pricing, revenue, and logistics.

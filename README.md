# Unit-Economics-Audit-Channel-Profitability-Analysis
Built an Unit Economics Audit analyzing 6 acquisition channels (2020-2026), identified ₹977K annual loss, designed reallocation model for break-even in 6 months.

## Business Problem
Modern businesses invest heavily across multiple marketing channels to acquire customers. However, high acquisition volume does not necessarily translate into profitable growth.

The organization lacked visibility into:
* Which acquisition channels generate profitable customers?
* Are marketing dollars being spent efficiently?
* Is customer lifetime value sufficient to justify acquisition costs?
* Which channels should receive more budget and which should be reduced?
* Is the current acquisition strategy sustainable in the long term?

Without these insights, management risks allocating budget toward loss-making channels while overlooking profitable opportunities.

This project was developed to perform a **Unit Economics Audit**, transforming raw transactional and marketing data into executive-level insights that support strategic decision-making.
---

# Project Objectives

This project aims to:

✔ Validate and prepare raw business data for analytics

✔ Build a structured analytical database using SQL Server

✔ Design a Star Schema optimized for reporting

✔ Evaluate acquisition channel performance using unit economics

✔ Measure Customer Lifetime Value (CLV), Customer Acquisition Cost (CAC), ROI and LTV:CAC ratio

✔ Identify profitable and loss-making marketing channels

✔ Develop an executive dashboard for business stakeholders

✔ Recommend actionable strategies to improve marketing profitability

---

# Key Business Questions

## Data Validation

1. How many records are present in the Orders table?
2. Are there any duplicate Order IDs?
3. Does the calculated order total match the recorded total amount?
4. How much marketing spend has been incurred across each acquisition channel?

---

## Exploratory Data Analysis (EDA)

1. What is the overall customer portfolio value?
2. What is the Customer Lifetime Value (CLV) of each customer?
3. What are the customer lifespan, Average Order Value (AOV), and purchase frequency?
4. How many delivered orders have been placed, and what is the total revenue?
5. How does customer value vary across membership tiers?
6. How do marketing channels perform in terms of impressions, clicks, CTR, and CPC?

---

# End-to-End Workflow

```
Business Problem 
↓
Raw Dataset
↓

Excel
• Formatting
• Validation

↓

SQL Server
• Database Creation
• Fact Tables
• Dimension Tables

↓

SQL Analysis
• Data Validation
• Data Exploration
• Exploratory Data Analysis

↓

Power BI
• Import Mode
• Data Modeling
• Star Schema
• DAX Measures

↓

Interactive Dashboard

↓

Executive Summary

↓

Business Recommendations

```
---

````markdown
# SQL Scripts

This folder contains all SQL scripts used throughout the project, from database creation to exploratory data analysis.

---

## 📄 01_Database_Creation.sql

### Purpose
Creates the project database and all required fact and dimension tables.

### Key Components
- Database Creation
- Dimension Tables
  - `dim_customers`
  - `dim_product`
- Fact Tables
  - `fact_orders`
  - `fact_marketing_spending`

```sql
-- Create Database
CREATE DATABASE DB_Acquisition_Health_Audit;
USE DB_Acquisition_Health_Audit;

-- Create Dimension Tables
CREATE TABLE dim_customers (
    customer_id VARCHAR(50),
    country VARCHAR(50),
    age INT,
    gender VARCHAR(20),
    membership_tier VARCHAR(20),
    registration_date DATE,
    total_orders INT,
    total_spend_usd DECIMAL(12,2),
    avg_order_value_usd DECIMAL(10,2),
    days_since_last_purchase INT,
    preferred_category VARCHAR(100),
    preferred_device VARCHAR(50),
    preferred_payment_method VARCHAR(50),
    acquisition_channel VARCHAR(50),
    reviews_given INT,
    avg_review_score DECIMAL(3,2),
    returns_made INT,
    wishlist_items INT,
    newsletter_subscribed INT,
    churned INT
);

CREATE TABLE dim_product (
    category VARCHAR(100),
    product_name VARCHAR(150),
    total_orders INT,
    total_revenue_usd DECIMAL(15,2),
    avg_price DECIMAL(10,2),
    avg_rating DECIMAL(3,2),
    return_rate DECIMAL(5,2),
    avg_discount_pct DECIMAL(5,2),
    avg_delivery_days DECIMAL(5,2)
);

CREATE TABLE fact_marketing_spending (
    date DATE,
    year INT,
    month INT,
    quarter VARCHAR(5),
    acquisition_channel VARCHAR(50),
    impressions INT,
    clicks INT,
    marketing_spend_usd DECIMAL(12,2)
);

CREATE TABLE fact_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_date DATE,
    year INT,
    month INT,
    quarter VARCHAR(5),
    day_of_week VARCHAR(20),
    product_name VARCHAR(150),
    category VARCHAR(100),
    unit_price_usd DECIMAL(10,2),
    quantity INT,
    subtotal_usd DECIMAL(10,2),
    discount_pct INT,
    discount_amount_usd DECIMAL(10,2),
    shipping_fee_usd DECIMAL(10,2),
    tax_pct INT,
    tax_amount_usd DECIMAL(10,2),
    total_amount_usd DECIMAL(10,2),
    payment_method VARCHAR(50),
    device_used VARCHAR(50),
    delivery_days INT,
    delivery_date DATE,
    order_status VARCHAR(50),
    returned INT,
    customer_rating INT,
    session_duration_minutes DECIMAL(10,2),
    pages_viewed_before_purchase INT,
    is_repeat_customer INT
);
```

---

## 📄 02_Data_Validation.sql

### Purpose
Ensures data integrity before performing analysis.

### Validation Checks
1. Total records in Orders table
2. Duplicate Order IDs
3. Revenue calculation validation
4. Marketing spend by acquisition channel

```sql
-- 1. Count Total Rows
SELECT COUNT(*) AS Total_Rows
FROM fact_orders;

-- 2. Duplicate Order IDs
SELECT
    order_id,
    COUNT(*) AS Total_Count
FROM fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 3. Revenue Validation
SELECT
    order_id,
    subtotal_usd,
    discount_amount_usd,
    tax_amount_usd,
    shipping_fee_usd,
    total_amount_usd,
    (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd) AS Calculated_Total,
    CASE
        WHEN total_amount_usd =
             (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd)
        THEN 'Match'
        ELSE 'Mismatch'
    END AS Validation_Status
FROM fact_orders
WHERE total_amount_usd <>
      (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd);

-- 4. Marketing Spend
SELECT
    acquisition_channel,
    SUM(marketing_spend_usd) AS Total_Spend
FROM fact_marketing_spending
GROUP BY acquisition_channel
ORDER BY acquisition_channel;
```

---

## 📄 03_Data_Exploration.sql

### Purpose
Explores customer behavior and overall business performance.

### Analysis Performed
- Customer Portfolio
- Customer Lifetime Value (CLV)
- Customer Lifespan
- Average Order Value (AOV)
- Purchase Frequency
- Delivered Orders & Revenue

```sql
-- Overall Customer Portfolio
SELECT
    COUNT(customer_id) AS Total_Customers,
    FORMAT(SUM(total_amount_usd),'C','en-US') AS Portfolio_Value,
    FORMAT(AVG(total_amount_usd),'C','en-US') AS Average_LTV,
    FORMAT(MIN(total_amount_usd),'C','en-US') AS Minimum_Spend,
    FORMAT(MAX(total_amount_usd),'C','en-US') AS Maximum_Spend
FROM fact_orders;

-- Historical CLV
SELECT
    customer_id,
    SUM(total_amount_usd) AS Historical_CLV
FROM fact_orders
WHERE order_status='Delivered'
GROUP BY customer_id;

-- Customer Metrics
SELECT
    customer_id,
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS Lifespan_Days,
    SUM(total_amount_usd)/COUNT(*) AS Average_Order_Value,
    COUNT(*)*1.0 /
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS Purchase_Frequency
FROM fact_orders
WHERE order_status='Delivered'
GROUP BY customer_id;

-- Delivered Revenue
SELECT
    COUNT(*) AS Delivered_Orders,
    SUM(total_amount_usd) AS Total_Revenue
FROM fact_orders
WHERE order_status='Delivered';
```

---

## 📄 04_Exploratory_Data_Analysis.sql

### Purpose
Analyzes customer segments and marketing channel performance.

### Analysis Performed
- Membership Tier Performance
- Marketing Channel Performance
- Click Through Rate (CTR)
- Cost Per Click (CPC)

```sql
-- Membership Tier Analysis
SELECT
    c.membership_tier,
    COUNT(DISTINCT o.customer_id) AS Total_Customers,
    ROUND(
        SUM(o.total_amount_usd) /
        COUNT(DISTINCT o.customer_id),
        2
    ) AS Average_Lifetime_Spend
FROM fact_orders o
LEFT JOIN dim_customers c
ON o.customer_id = c.customer_id
WHERE order_status='Delivered'
GROUP BY c.membership_tier
ORDER BY Total_Customers;

-- Marketing Performance
SELECT
    acquisition_channel,
    SUM(impressions) AS Total_Impressions,
    SUM(clicks) AS Total_Clicks,
    ROUND(
        (SUM(clicks) * 100.0) /
        NULLIF(SUM(impressions),0),
        2
    ) AS CTR_Percentage,
    ROUND(
        SUM(marketing_spend_usd) /
        NULLIF(SUM(clicks),0),
        2
    ) AS CPC_USD
FROM fact_marketing_spending
WHERE acquisition_channel IN (
    'Email Campaign',
    'Paid Ad',
    'Social Media'
)
GROUP BY acquisition_channel;
```
````

## Executive Summary

Purpose

Provide senior management with an overview of acquisition profitability, unit economics and recommended business actions.

![image alt](https://github.com/Yamankumar445/Unit-Economics-Audit-CAC-LTV-Channel-Performance-Budget-Optimization/blob/5fbb95b1e454dc1556a95c6604ac66ea75b9d63f/Executive%20Summary.png)

---

## Acquisition Dashboard

Purpose

Analyze acquisition performance across channels, customers and marketing efficiency using interactive KPIs and visualizations.

![image alt](https://github.com/Yamankumar445/Unit-Economics-Audit-CAC-LTV-Channel-Performance-Budget-Optimization/blob/5fbb95b1e454dc1556a95c6604ac66ea75b9d63f/Dashboard.png)

---

# Business Recommendations

## Recommended Actions

### Stop

Pause Paid Advertising due to significant financial losses and poor return on investment.

### Reduce

Decrease Social Media marketing spend and reallocate budget toward higher-performing channels.

### Invest

Increase investment in Email Marketing and Organic Search, which demonstrate stronger profitability and healthier unit economics.

### Expected Outcome

Improve marketing efficiency, increase the LTV:CAC ratio, and move toward sustainable customer acquisition.

---

# Repository Files

Here's what I'd include.

📂 Customer-Acquisition-Health-Audit

│

├── README.md ⭐

├── Business Problem and Project Objective PDF

├── Project Workflow.png

├── Dataset

│      Raw Dataset.xlsx

├── SQL

│      01_Project_SQL_Script.sql│

├── Power BI

│      Dashboard.pbix

├── Dashboard Images

│      Executive Summary.png

│      Dashboard.png

├── Data Model

│      Star Schema.png

├── Business Insights and recommendation.pdf

👤 Author
**Yaman Kumar**  
Data Analyst | Building hands-on projects in SQL, Power BI & Excel

📂 **GitHub Portfolio:** [github.com/yourusername](https://github.com/Yamankumar445)  
💼 **LinkedIn:** [linkedin.com/in/yourusername](www.linkedin.com/in/yaman-kumar-dhakrey-7a4b67260)

📄 License
This project is open-source and available under the MIT License.

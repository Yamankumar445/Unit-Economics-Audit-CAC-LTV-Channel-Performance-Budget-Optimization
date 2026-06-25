# Unit-Economics-Audit-Channel-Profitability-Analysis
Built a Unit Economics Audit analyzing 6 acquisition channels (2020-2026), identified ₹977K annual loss, designed reallocation model for break-even in 6 months.

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

# SQL Section
SQL


## 📄 01_Database_Creation.sql

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

-- Create Fact Tables
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

## 📄 03_Data_Validation.sql

=========================================================
  Data Validation
=========================================================

-- 1. Count all rows in Orders table

SELECT COUNT(*) AS Total_rows
FROM fact_orders;


-- 2. Check duplicate Order IDs

SELECT
    order_id,
    COUNT(*) AS Total_count
FROM fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 3. Validate calculated revenue against total_amount_usd

SELECT
    order_id,
    subtotal_usd,
    discount_amount_usd,
    tax_amount_usd,
    shipping_fee_usd,
    total_amount_usd,
    (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd) AS Revenue_match,
    CASE
        WHEN (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd)
             = total_amount_usd
        THEN 'Match'
        ELSE 'Unmatch'
    END AS Validation_status
FROM fact_orders
WHERE total_amount_usd <>
      (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd);


-- 4. Calculate total marketing spend by acquisition channel

SELECT
    acquisition_channel,
    SUM(marketing_spend_usd) AS Total_spend
FROM fact_marketing_spending
GROUP BY acquisition_channel
ORDER BY acquisition_channel;

## 📄 04_Data_Exploration.sql

=========================================================
  Data Exploration
=========================================================

-- 1. Overall customer portfolio metrics

SELECT
    COUNT(customer_id) AS total_customers,
    FORMAT(SUM(total_amount_usd),'C','en-US') AS overall_portfolio_ltv,
    FORMAT(AVG(total_amount_usd),'C','en-US') AS average_ltv_per_customer,
    FORMAT(MIN(total_amount_usd),'C','en-US') AS min_customer_spend,
    FORMAT(MAX(total_amount_usd),'C','en-US') AS max_customer_spend
FROM fact_orders;

-- 2. Historical Customer Lifetime Value (CLV)

SELECT
    customer_id,
    SUM(total_amount_usd) AS historical_clv
FROM fact_orders
WHERE order_status='Delivered'
GROUP BY customer_id;

-- 3. Customer lifespan, AOV and purchase frequency

SELECT
    customer_id,
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS lifespan_days,
    SUM(total_amount_usd)/COUNT(*) AS AOV,
    COUNT(*)*1.0/
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS purchase_frequency
FROM fact_orders
WHERE order_status='Delivered'
GROUP BY customer_id;

-- 4. Total delivered orders and revenue

SELECT
    COUNT(*) AS Total_orders,
    SUM(total_amount_usd) AS Total_revenue
FROM fact_orders
WHERE order_status='Delivered';


## 📄 05_Exploratory_Data_Analysis.sql

=========================================================
  Exploratory Data Analysis
=========================================================

-- 1. Membership Tier Analysis

SELECT
    c.membership_tier,
    COUNT(DISTINCT o.customer_id) AS Total_customers,
    ROUND(
        SUM(o.total_amount_usd) /
        COUNT(DISTINCT o.customer_id),
        2
    ) AS AverageLifetimeSpend
FROM fact_orders o
LEFT JOIN dim_customers c
ON o.customer_id=c.customer_id
WHERE order_status='Delivered'
GROUP BY c.membership_tier
ORDER BY Total_customers;


-- 2. Marketing Channel Performance

SELECT
    acquisition_channel,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(
        (SUM(clicks)*100.0)/
        NULLIF(SUM(impressions),0),
        2
    ) AS ctr_percentage,
    ROUND(
        SUM(marketing_spend_usd)/
        NULLIF(SUM(clicks),0),
        2
    ) AS cpc_usd
FROM fact_marketing_spending
WHERE acquisition_channel IN
(
'Email Campaign',
'Paid Ad',
'Social Media'
)
GROUP BY acquisition_channel;


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

├── Business Problem.pdf

├── Project Objectives.pdf

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
Yaman Kumar
Data Analyst | Building hands-on projects in SQL, Power BI & Excel
📂 GitHub Portfolio • 💼 LinkedIn

📄 License
This project is open-source and available under the MIT License.

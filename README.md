# UUnit-Economics-Audit-Channel-Profitability-Analysis
Built a Unit Economics Audit analyzing 6 acquisition channels (2020-2025), identified ₹977K annual loss, designed reallocation model for break-even in 6 months.

## Business Problem
Modern businesses invest heavily across multiple marketing channels to acquire customers. However, high acquisition volume does not necessarily translate into profitable growth.

The organization lacked visibility into:
* Which acquisition channels generate profitable customers?
* Are marketing dollars being spent efficiently?
* Is customer lifetime value sufficient to justify acquisition costs?
* Which channels should receive more budget and which should be reduced?
* Is the current acquisition strategy sustainable in the long term?

Without these insights, management risks allocating budget toward loss-making channels while overlooking profitable opportunities.

This project was developed to perform a complete **Unit Economics Audit**, transforming raw transactional and marketing data into executive-level insights that support strategic decision-making.
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
<img width="1881" height="836" alt="ChatGPT Image Jun 25, 2026, 10_44_56 AM" src="https://github.com/user-attachments/assets/3f2a6911-3c4a-4de4-b976-48bd8b410dbf" />

```

This should be a PNG in the README.

---

# SQL Section

Don't upload one SQL file.

Organize it like this.

```
SQL

│

├── 01_Database_Creation.sql

├── 02_Table_Creation.sql

├── 03_Data_Validation.sql

├── 04_Data_Exploration.sql

└── 05_Exploratory_Data_Analysis.sql
```

Recruiters love organized repositories.

---

# Data Validation

Your validation queries fit perfectly here.

Examples:

```
✔ Row Count Validation

✔ Duplicate Order Detection

✔ Revenue Calculation Validation

✔ Marketing Spend Validation
```

---

# Data Exploration

Use queries such as:

```
Overall Revenue

Customer Lifetime Value

Purchase Frequency

Average Order Value

Marketing Spend

CTR

CPC

Membership Tier Analysis
```

---

# Dashboard Story

Instead of saying

Dashboard 1

Dashboard 2

Write

## Executive Summary

Purpose

Provide senior management with an overview of acquisition profitability, unit economics and recommended business actions.

---

## Acquisition Dashboard

Purpose

Analyze acquisition performance across channels, customers and marketing efficiency using interactive KPIs and visualizations.

---

# Business Recommendations

This is one of the strongest parts of your project because it's based on your analysis.

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

```
📂 Customer-Acquisition-Health-Audit

│

├── README.md ⭐

├── Business Problem.pdf

├── Project Objectives.pdf

├── Project Workflow.png

├── Dataset

│      Raw Dataset.xlsx

│      Data Dictionary.xlsx

│

├── Excel

│      Data Cleaning.xlsx

│      Data Validation.xlsx

│

├── SQL

│      01 Database.sql

│      02 Tables.sql

│      03 Data Validation.sql

│      04 Data Exploration.sql

│      05 EDA.sql

│

├── Power BI

│      Dashboard.pbix

│      DAX Measures.md

│

├── Dashboard Images

│      Executive Summary.png

│      Dashboard.png

│

├── Data Model

│      Star Schema.png

│

├── Business Insights.pdf

└── Recommendations.pdf
```

---

## My recommendation

Given the quality of your work, **don't settle for a basic GitHub README**. Build it like a professional analytics case study. A recruiter should feel they're reading documentation from an analyst at a consulting firm rather than a student portfolio.

If we do it properly, this can become one of the strongest projects in your portfolio. I recommend creating **five polished documents** alongside the README:

1. **Business Problem.pdf**
2. **Project Objectives.pdf**
3. **Business Questions.pdf**
4. **Business Insights & Recommendations.pdf**
5. **Technical Documentation.pdf** (covering Excel → SQL → Data Model → Power BI → DAX)

Together with your screenshots, SQL scripts, PBIX file, and README, this presents a complete end-to-end analytics project.

use DB_Acquisition_Health_Audit

/*================================Data Validation====================================*/ 

--1.	Count all rows in Orders table 
select count(*) as Total_rows from fact_orders
 

--2.Checking duplicates in Order table 

select 
order_id,
count(*) as Total_count 
from fact_orders
group by order_id 
having count(*) > 1

---Validate whether the calculated total revenue matches total_amount_usd.
--Flag any rows where they do not match.

select 
order_id,
subtotal_usd,
discount_amount_usd,
tax_amount_usd,
shipping_fee_usd,
total_amount_usd,
(subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd ) as Revenue_match,
case 
	when (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd ) = total_amount_usd then 'match'
		else 'unmatch'
	end as Validation_status
from fact_orders
where total_amount_usd != (subtotal_usd - discount_amount_usd + tax_amount_usd + shipping_fee_usd )

--Calculate the total marketing spend from fact_marketing_spending.

select 
acquisition_channel as Channel,
sum( marketing_spend_usd) as Total_spend
from fact_marketing_spending
group by acquisition_channel
order by acquisition_channel asc


USE DB_Acquisition_Health_Audit;
GO

SELECT 
    COUNT(customer_id) AS total_customers,
    FORMAT(SUM(total_amount_usd), 'C', 'en-US') AS overall_portfolio_ltv,
    FORMAT(AVG(total_amount_usd), 'C', 'en-US') AS average_ltv_per_customer,
    FORMAT(MIN(total_amount_usd), 'C', 'en-US') AS min_customer_spend,
    FORMAT(MAX(total_amount_usd), 'C', 'en-US') AS max_customer_spend
FROM fact_orders;

--Calculate the overall Customer Lifetime Value (LTV) from the customers table.  

select 
customer_id,
sum( total_amount_usd) as historical_clv
from fact_orders
where order_status = 'Delivered'
group by customer_id


SELECT
    customer_id,
    DATEDIFF(
        DAY,
        MIN(order_date),
        MAX(order_date)
    ) AS lifespan_days,
    (sum(total_amount_usd) / count (*)) as AOV,
    (count (*) / DATEDIFF(
        DAY,
        MIN(order_date),
        MAX(order_date)
                         ) ) as purchase_frequency
FROM fact_orders
WHERE order_status = 'Delivered'
GROUP BY customer_id;

/*You need to calculate 4 things:

Total Orders
Total Revenue
Marketing Spend
RoAS = Total Revenue / Marketing Spend */


select 
count(*) as Total_orders,
sum( total_amount_usd) as Total_revenue
from fact_orders
where order_status = 'Delivered'

/*You need to calculate:

Total number of customers
Average lifetime spend (AVG(total_spend_usd))

All of these should be calculated for each membership_tier.*/


select 
c.membership_tier,
COUNT(distinct(o.customer_id)) as Total_customers,
round((sum(o.total_amount_usd) / COUNT(distinct(o.customer_id))),2) as Averagelifetimespend
from fact_orders as o
left join dim_customers as c 
on o.customer_id = c.customer_id
where order_status = 'Delivered'
group by c.membership_tier
order by Total_customers

/* 1 question with 4 things to calculate
1. Clicks
2. Impressions
3. CTR (%) = Clicks / Impressions × 100
4. CPC = Spend / Clicks
All of these should be calculated **for each marketing channel.
*/

SELECT 
    acquisition_channel,
    -- CTR (%) = (Total Clicks / Total Impressions) * 100
    ROUND((SUM(clicks) * 100.0) / NULLIF(SUM(impressions), 0), 2) AS ctr_percentage,
    
    -- CPC = Total Spend / Total Clicks
    ROUND(SUM(marketing_spend_usd) / NULLIF(SUM(clicks), 0), 2) AS cpc_usd
FROM fact_marketing_spending
where acquisition_channel in ('Email Campaign','Paid Ad','Social Media')
GROUP BY acquisition_channel;


SELECT 
    acquisition_channel,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    
    -- Exact CTR (%)
    ROUND((SUM(clicks) * 100.0) / NULLIF(SUM(impressions), 0), 2) AS ctr_percentage,
    
    -- Exact CPC
    ROUND(SUM(marketing_spend_usd) / NULLIF(SUM(clicks), 0), 2) AS cpc_usd
FROM fact_marketing_spending
where acquisition_channel in ('Email Campaign','Paid Ad','Social Media')
GROUP BY acquisition_channel;












select *
from fact_marketing_spending

select * from dim_customers
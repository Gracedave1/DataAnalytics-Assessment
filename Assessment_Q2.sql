-- Assessment_Q2.sql
-- TASK: Analyze and categorize customers based on their average monthly transaction activity

/*
TASK OVERVIEW:
This query will evaluates customer engagement by:
1. Calculating the number of successful transactions and the number of active months 
   (months with at least one transaction) over the past 12 months.
2. Categorizing each customer into frequency category based on their average transactions per month.
3. Summarizing how many customers fall into each frequency category and the average frequency.

Categories:
- High Frequency: ≥ 10 transactions/month
- Medium Frequency: ≥ 3 and < 10 transactions/month
- Low Frequency: < 3 transactions/month
*/

-- SQL SCRIPT IMPLEMENTATION:
-- Step 1: Preparing monthly activity statistics per customer using a CTE (Common Table Expression) to simplify calculations.
WITH monthly_activity_stats AS (
    SELECT 
        s.owner_id,
        
        -- Total successful transactions in the past 12 months
        COUNT(s.id) AS total_transactions,
        
        -- Count of distinct months with at least one transaction
        COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) AS active_months
    FROM savings_savingsaccount AS s
    WHERE 
        s.transaction_status = 'success'
        AND s.transaction_date >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
    GROUP BY s.owner_id
    HAVING active_months > 0
)

-- Step 2: Categorizing customers by average monthly transaction frequency
SELECT 
    -- Assign a frequency category based on transaction rate per month
    CASE 
        WHEN total_transactions / active_months >= 10 THEN 'High Frequency'
        WHEN total_transactions / active_months >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,

    -- Count of customers in each frequency category
    COUNT(owner_id) AS customer_count,

    -- Average monthly transaction frequency per category
    ROUND(AVG(total_transactions / active_months), 1) AS avg_transactions_per_month

FROM monthly_activity_stats

GROUP BY frequency_category

-- Ensure custom ordering of frequency category
ORDER BY CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    ELSE 3
END;

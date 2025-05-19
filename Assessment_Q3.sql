-- Assessment_Q3.sql
-- TASK: Identify inactive active plans: no successful transactions in the past year

/*
TASK OVERVIEW:
This query flags active (non-deleted) savings or investment plans that have been inactive,
meaning they haven't recorded any *successful* transaction in the last 365 days.

For each inactive plan, it provides:
- Plan ID
- Owner ID
- Plan type (Savings / Investment / Other)
- Date of last successful transaction (if any)
- Number of days since last transaction
*/

-- SQL SCRIPT : 
    SELECT 
    p.id AS plan_id,
    p.owner_id,

    -- Classify plan type based on flags
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    -- Latest successful transaction date (can be NULL if none)
    MAX(s.transaction_date) AS last_transaction_date,

    -- Number of days since the last transaction (NULL-safe)
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactive_days

FROM plans_plan AS p

-- Join only successful transactions (left join to preserve plans without any)
LEFT JOIN savings_savingsaccount AS s 
    ON p.id = s.plan_id 
    AND s.transaction_status = 'success'

WHERE 
    p.is_deleted = 0    -- Exclude soft-deleted plans
    AND p.status_id = 1 -- Include only active plans

GROUP BY 
    p.id, p.owner_id, p.is_regular_savings, p.is_a_fund

-- Filter to plans with no transactions or inactive for over 365 days
HAVING 
    last_transaction_date IS NULL 
    OR inactive_days > 365

ORDER BY 
    inactive_days DESC;

-- Assessment_Q4.sql
-- TASK: Estimate Customer Lifetime Value (CLV) based on account tenure and transaction volume

/*
TASK OVERVIEW: 
Customer Lifetime Value (CLV) is estimated using:
- Total number of successful transactions
- Customer account age (in months)
- Assumed platform profit: 0.1% of each transaction

Assumption: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
   i.e  CLV = (Avg Monthly Transactions × 12) × Avg Profit per Transaction
*/

-- SQL SCRIPT IMPLEMENTATION
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Account age in months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,

    -- Count of all successful transactions
    COUNT(s.id) AS total_transactions,

    -- Estimated CLV (rounded to 2 decimal places)
    ROUND(
        (
            COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 1) -- avg monthly txns
        ) * 12 * 
        (SUM(s.confirmed_amount) / 100 * 0.001), 2 -- transaction value × 0.1% profit
    ) AS estimated_clv

FROM users_customuser AS u

-- Join to only successful savings transactions with positive amounts
LEFT JOIN savings_savingsaccount AS s 
    ON u.id = s.owner_id 
    AND s.transaction_status = 'success'

 -- Only include active users and exclude deleted accounts
WHERE 
    u.is_active = 1            
    AND u.is_account_deleted = 0  

GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined

-- Ensure valid tenure and actual transactions
HAVING 
    tenure_months > 0
    AND total_transactions > 0

ORDER BY 
    estimated_clv DESC;

-- Assessment_Q4.sql
-- TASK: Estimate Customer Lifetime Value (CLV) based on historical activity

/*
TASK OVERVIEW: 
Customer Lifetime Value (CLV) is estimated using:
- Total number of successful transactions
- Customer account age (in months)
- Assumed platform profit: 0.1% of each transaction

Formula:
    CLV = (Avg Monthly Transactions × 12) × Avg Profit per Transaction
*/

SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,

    -- Account age in months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS account_tenure_months,

    -- Count of all successful transactions
    COUNT(s.id) AS total_successful_transactions,

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

WHERE 
    u.is_active = 1            -- Only include active users
    AND u.is_account_deleted = 0  -- Exclude deleted accounts

GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined

-- Ensure valid tenure and actual transactions
HAVING 
    account_tenure_months > 0
    AND total_successful_transactions > 0

ORDER BY 
    estimated_clv DESC;

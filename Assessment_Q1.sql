-- Assessment_Q1.sql
-- TASK: Retrieve customers with at least one funded savings plan and one funded investment plan
-- Sort their result by total deposits

/*
TASK OVERVIEW: 
This query returns a list of users who have:
1. At least one regular savings plan (is_regular_savings = 1)
2. At least one investment fund (is_a_fund = 1)
3. Confirmed deposit transactions (transaction_status = 'success')

The expected output will includes:
- User ID
- Full name
- Count of funded savings plans
- Count of funded investment plans
- Total deposits (converted from kobo to Naira)
*/

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,

    -- This block of code will count distinct savings plans where is_regular_savings = 1
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 THEN p.id 
    END) AS savings_plan_count,

    -- This will count distinct investment plans where is_a_fund = 1
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 THEN p.id 
    END) AS investment_plan_count,

    -- A total Sum of confirmed deposits only for successful transactions
    COALESCE(SUM(CASE 
        WHEN s.transaction_status = 'success' THEN s.confirmed_amount 
        ELSE 0 
    END), 0) / 100 AS total_confirmed_deposits

FROM users_customuser AS u

-- Joining user to their plans
INNER JOIN plans_plan AS p 
    ON u.id = p.owner_id

-- Joining plans to their corresponding savings account transactions
LEFT JOIN savings_savingsaccount AS s 
    ON p.id = s.plan_id

WHERE 
    p.is_deleted = 0       -- delete inactive plans
    AND p.status_id = 1     -- Include only active plans

GROUP BY 
    u.id, u.first_name, u.last_name

HAVING 
    savings_plan_count > 0 
    AND investment_plan_count > 0

ORDER BY 
    total_confirmed_deposits DESC;

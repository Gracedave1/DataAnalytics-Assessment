-- Assessment_Q1.sql
-- TASK: Retrieve customers with at least one funded savings plan and one funded investment plan
-- Sort their result by total deposits 

/*
TASK OVERVIEW: 
This query will returns a list of users who have:
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


-- SQL SCRIPT IMPLEMENTATION:
-- Select the user's unique ID and Concatenate first and last names
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Count distinct savings plans where is_regular_savings = 1 (i.e the user has a savings-type plan) 
    -- and rename as savings_count
    COUNT(CASE WHEN p.is_regular_savings = 1 THEN 1 END) AS savings_count,

    -- Count the number of funded investment plans where is_a_fund = 1 (i.e the user has an investment-type plan)
    -- Sum up all confirmed deposits made by the user, divide by 100 to convert from kobo to Naira rounded to 2 decimal
    COUNT(CASE WHEN p.is_a_fund = 1 THEN 1 END) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100.0, 2) AS total_deposits
FROM savings_savingsaccount s

    -- Joining the plans table to link each savings account to its plan & users table to retrieve user information
JOIN plans_plan p ON s.plan_id = p.id
JOIN users_customuser u ON s.owner_id = u.id
    
    -- filtering out only savings records that have confirmed deposits (inflow) & group results by user
WHERE s.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name 

    -- Filter to include only users with at least one savings and one investment plan. 
    -- Sort by total deposits in descending order
HAVING 
    COUNT(CASE WHEN p.is_regular_savings = 1 THEN 1 END) > 0 AND
    COUNT(CASE WHEN p.is_a_fund = 1 THEN 1 END) > 0
ORDER BY total_deposits DESC;

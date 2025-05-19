# DataAnalytics-Assessment

## 🧾 Introduction

This repository contains my solutions to a **SQL Proficiency Assessment** completed using **MySQL**. Each question is based on real-world business scenarios designed to test practical SQL skills.

For every task, I clearly outline:
- What the problem is,  
- The challenges I faced,  
- And the SQL approach I used to address it

The goal is to demonstrate my ability to write efficient, accurate queries while thinking critically about data in a business context.

---

## ❓ Question Summaries

### 1. 🏦 High-Value Customers with Multiple Products

**Problem:**  
Find users who have **both savings and investment plans**, and calculate and sort the **total amount** they’ve deposited.

**Challenges:**  
- Avoid **double-counting** plans when users had multiple types.  
- Include users who had **no transaction records** yet.  
- Dealing with **amounts stored in kobo**, not naira.

**Approach Taken:**  
- Applied `DISTINCT` and conditional aggregation to ensure accuracy by using `COUNT(DISTINCT CASE WHEN ...)` to separately count savings and investment products.
- Performed a `LEFT JOIN` so users without transactions were still included.  
- Aggregated `confirmed_amount` and converted from **kobo to naira**.  
- Filtered only **active** and **non-deleted** plans with **successful transactions**.

---

### 2. 📈 Transaction Frequency Analysis - Grouping Customers by Transaction Frequency

**Problem:**  
Group users into **Low**, **Medium**, or **High** frequency based on their **average monthly transaction activity** over the last 12 months.

**Challenges:**  
- The need to **avoid dividing by zero** when users had no transactions.  
- Original logic was hard to follow with many subqueries.  
- Some users had **multiple transactions in the same month**.

**Approach Taken:**  
- Created a **CTE** (Common Table Expression) to simplify calculations.  
- Used `GREATEST(..., 1)` to ensure no division by zero.  
- Aggregated monthly transactions and calculated an average.  
- Used **thresholds** to assign users to frequency bands.

---

### 3. ⏸️ Detecting Inactive Accounts

**Problem:**  
Find active savings or investment accounts that haven’t had **any successful transaction in the last 365 days**.

**Challenges:**  
- Initially missed accounts with **zero transactions**.  
- Needed to follow the rule: account must be **active** and **not deleted**.  
- Had to compare **last transaction date** to today’s date.

**Approach Taken:**  
- Used a `LEFT JOIN` to include accounts with no transactions.  
- Calculated the **last transaction date** using `MAX(...)`.  
- Used `DATEDIFF` to check if it's been more than **365 days**.  
- Used `HAVING` to catch both **old transactions** and **nulls** (no transactions at all).

---

### 4. 💰 Estimating Customer Lifetime Value (CLV)

**Problem:**  
Estimate the **lifetime value** of each customer based on how long they’ve had an account and how much they’ve deposited.

**Challenges:**  
- Had to calculate **account age** in months.  
- Some users had **no transactions**, causing `NULL` errors.  
- Needed to **avoid divide-by-zero** for very new accounts.

**Approach Taken:**  
- Measured tenure using `TIMESTAMPDIFF` (in months).  
- Summed total transactions and amounts using `COALESCE` to handle nulls.  
- Applied a custom CLV formula:  
  `(Transactions ÷ Months) × 12 × (0.001 × Total Amount)`  
- Used `GREATEST(..., 1)` to prevent division by zero.

---

## ✨ Conclusion

Each solution in this assessment started with a business problem and ended with a clear, efficient SQL query. I prioritized **clarity**, **accuracy**, and **performance**, while also addressing any data quirks or edge cases I encountered.

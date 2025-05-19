# DataAnalytics-Assessment

## 🧾 Introduction

This repository contains a series of SQL-based analytical queries that demonstrate real-world problem-solving using **MySQL**. Each solution reflects practical expertise in joining, filtering, aggregating, and analyzing structured data to uncover business insights.

---

## ❓ Problem Summaries & Solutions

<details>
<summary><strong>1. 🏦 Identifying High-Value Customers with Diverse Financial Products</strong></summary>

**🔍 Objective**  
Identify users who own both savings and investment products, and evaluate their total deposits.

**🛠️ Strategy**
- Used `COUNT(DISTINCT CASE WHEN ...)` for separate counts of savings vs. investment plans.
- Aggregated `confirmed_amount` (converted from kobo to naira).
- Filtered to include only active, non-deleted plans with successful transactions.
- Applied `LEFT JOIN` to capture plans with or without transaction records.

**⚠️ Challenges Addressed**
- Switched from simple count to conditional aggregation for accuracy.
- Prevented overcounting by using `DISTINCT` on plan IDs.
- Ensured currency consistency with unit conversion logic.

</details>

---

<details>
<summary><strong>2. 📈 Transaction Frequency Banding</strong></summary>

**🔍 Objective**  
Group customers into tiers (Low, Medium, High) based on average monthly transaction activity over the past year.

**🛠️ Strategy**
- Used a CTE to calculate total successful transactions and active months per user.
- Limited to the **last 12 months** for recency.
- Computed average monthly transactions and applied thresholds for frequency tiers.
- Grouped by month using `DATE_FORMAT` for year-month accuracy.

**⚠️ Challenges Addressed**
- Replaced subqueries with a cleaner CTE structure.
- Introduced `GREATEST(..., 1)` to avoid divide-by-zero for new users.
- Accounted for multiple transactions within the same month.

</details>

---

<details>
<summary><strong>3. ⏸️ Detecting Inactive Accounts</strong></summary>

**🔍 Objective**  
Highlight active savings or investment accounts with no transaction in the past 365 days.

**🛠️ Strategy**
- Filtered for active (`status_id = 1`) and undeleted plans.
- Used `LEFT JOIN` to connect plans with successful transactions.
- Calculated last transaction date using `MAX(...)` and days since last activity via `DATEDIFF`.
- Applied `HAVING` to detect accounts with NULL or old transactions.

**⚠️ Challenges Addressed**
- Initially excluded accounts with no transactions—corrected with `HAVING last_transaction_date IS NULL`.
- Ensured alignment with business rules for “active accounts”.

</details>

---

<details>
<summary><strong>4. 💰 Estimating Customer Lifetime Value (CLV)</strong></summary>

**🔍 Objective**  
Estimate long-term customer value based on tenure and financial contributions.

**🛠️ Strategy**
- Measured account age in months using `TIMESTAMPDIFF`.
- Counted successful transactions and summed confirmed amounts.
- Applied this CLV formula:  
  `(Transactions / Tenure Months) × 12 × (0.1% of Total Amount)`
- Rounded and formatted for presentation.

**⚠️ Challenges Addressed**
- Fixed early syntax issues with date functions.
- Used `GREATEST(..., 1)` to avoid division errors.
- Handled null transaction values using `COALESCE`.

</details>

---

## ⚙️ Technical Highlights

### ✅ Performance Optimization
- Proper use of `INNER JOIN` and `LEFT JOIN` with ON clauses.
- Index-friendly filtering on fields like `transaction_status`.
- Reduced data scope where applicable (e.g., using 12-month windows).

### ✅ Data Quality Assurance
- Safeguarded calculations with `GREATEST` and `COALESCE`.
- Ensured accurate plan counting using `DISTINCT` and conditional logic.
- Validated logic against domain-specific business rules.

---

## ✨ Conclusion

This assessment reflects the ability to translate business questions into efficient SQL solutions. From customer segmentation to CLV modeling, each query was designed with performance, clarity, and impact in mind.

---

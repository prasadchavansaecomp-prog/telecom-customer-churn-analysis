-- =========================================
-- CUSTOMER CHURN ANALYSIS
-- Database: PostgreSQL
-- =========================================

-------------------------------------------------------------------------------------------
-- QUES1-> What is the overall churn rate?
SELECT COUNT(*) AS Total_Customers, 
		SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customers ,
		ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_percentage
FROM churn;
-- Insight:
-- Overall churn rate is ~26.5%, meaning approximately 1 in 4 customers leave the company.
-- This indicates a significant retention issue.

------------------------------------------------------------------------------------------
-- Ques2-> Which contract type has the highest churn rate?
-- Objective: Identify high-risk contract segments
SELECT contract, COUNT(*) AS Total_Cust_Per_contract  ,
		SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customer_per_contract,
		ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/ COUNT(*), 2) 
			AS churn_PERCENTAGE_per_contract
			
FROM churn
GROUP BY contract
-- Insight:
-- Month-to-month contracts show the highest churn rate,
-- indicating customers without long-term commitment are more likely to leave.

-------------------------------------------------------------------------------------------
-- Ques3-> Do customers with higher MonthlyCharges churn more?
SELECT churn, ROUND(AVG(monthlycharges),2) AS avg_monthly_charges
FROM churn
GROUP BY churn
-- Insight:
-- Churned customers have higher average MonthlyCharges,
-- suggesting pricing or perceived value may influence churn.

-------------------------------------------------------------------------------------------
-- Ques 4-> Does Tenure Affect Churn?
SELECT churn, ROUND(AVG(tenure),2) AS avg_tenure
FROM churn
GROUP BY churn
-- Insight:
-- Customers who churn have significantly lower average tenure,
-- indicating that early-stage customer retention is a critical issue.

-------------------------------------------------------------------------------------------
--Q5: Does Internet Service Type Affect Churn?

SELECT internetservice, count(*) AS total_customers, 
						SUM(CASE WHEN churn = 'Yes' Then 1 ELSE 0 END) AS total_churn,
						ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' Then 1 ELSE 0 END)/ COUNT(*), 2) AS percentage
FROM churn
GROUP BY internetservice
-- Insight:
-- Fiber optic customers show extremely high churn (~41.89%),
-- significantly higher than DSL and non-internet users.
-- This suggests potential pricing, service quality, or value perception issues
-- among premium internet customers.

-------------------------------------------------------------------------------------------
-- Q6: Which Internet Service and Contract combination has the highest churn rate?
-- Objective: Identify the most vulnerable customer segment based on service type and contract structure.
SELECT internetservice, contract, COUNT(*) AS Total_customers, 
	   SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS total_churn_customers,
	   ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / count(*) , 2) as Percentage_of_churned
FROM churn
GROUP BY internetservice, contract
-- Segment-Level Insights

-- Month-to-month customers exhibit significantly higher churn across all service types.
-- Fiber optic month-to-month customers represent the highest churn risk segment.
-- Two-year contracts demonstrate strong retention effectiveness.
-- Nearly 60% of churn-related revenue loss originates from Fiber optic month-to-month customers.

-------------------------------------------------------------------------------------------
-- Q7: What is the total revenue lost due to churned customers?
-- Objective: Quantify the financial impact of customer churn.


SELECT  ROUND(
    SUM(NULLIF(TRIM(totalcharges),'')::NUMERIC) ,
    2
) AS TOTAL_CHARGES, 
		COUNT(*) AS total_churn_count

FROM churn
WHERE churn  = 'Yes'
-- Insight:
-- A total of 1,869 customers have churned, contributing approximately 2.86 million in revenue.
-- This highlights significant financial impact due to customer attrition.

-------------------------------------------------------------------------------------------
--Q8: Revenue from Highest-Risk Segment

SELECT ROUND(SUM(NULLIF(TRIM(totalcharges),'')::NUMERIC),2) AS total_charges
FROM churn
WHERE internetservice = 'Fiber optic' AND contract = 'Month-to-month' AND churn = 'Yes'
-- Insight:
-- Fiber optic customers on month-to-month contracts account for approximately
-- 1.73 million in lost revenue, representing nearly 60% of total churn revenue.
-- This segment is the primary financial risk driver.
-------------------------------------------------------------------------------------------



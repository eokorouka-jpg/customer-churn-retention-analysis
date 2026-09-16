-- =========================================================
-- CUSTOMER CHURN & RETENTION ANALYSIS
-- MySQL Portfolio Project
-- =========================================================
--
-- Dataset: IBM Telco Customer Churn
-- Customers: 7,043
--
-- Objective:
-- Analyse customer churn patterns and identify customer
-- characteristics associated with higher churn.
-- =========================================================

USE customer_churn_project;
    
CREATE TABLE telco_customer_churn (
    customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges VARCHAR(30),
    Churn VARCHAR(5)
);

-- =============================================
-- STEP 1: DATA PREPARATION
-- =============================================
--
-- The source CSV was imported into MySQL Workbench
-- as the table: telco_customer_churn.
-- TotalCharges was initially imported as VARCHAR because
-- 11 records contained blank values.

SELECT COUNT(*) AS total_rows
FROM telco_customer_churn;

SELECT * 
FROM telco_customer_churn 
LIMIT 10;

-- clean TotalCharges properly,
-- First, check how many blank values are still there:
SELECT COUNT(*) AS blank_totalcharges
FROM telco_customer_churn
WHERE TRIM(TotalCharges) = '';

-- Then convert those blank strings to NULL:
UPDATE telco_customer_churn
SET TotalCharges = NULL
WHERE TRIM(TotalCharges) = '';

-- Now change TotalCharges from text to a numeric column:
ALTER TABLE telco_customer_churn
MODIFY TotalCharges DECIMAL(10,2);

-- Finally, verify the result:
SELECT
    COUNT(*) AS total_rows,
    SUM(TotalCharges IS NULL) AS null_totalcharges
FROM telco_customer_churn;

-- ==================================================
-- Step 2: DATA QUALITY CHECKS
-- ==================================================

-- 2.1 Check total number of customers
SELECT COUNT(*) AS total_customers
FROM telco_customer_churn;

-- 2.2 Check duplicate Customer IDs
-- Each customerID should represent one customer.
SELECT
    customerID,
    COUNT(*) AS occurrences
FROM telco_customer_churn
GROUP BY customerID
HAVING COUNT(*) > 1;

-- 2.3 Check NULL values
-- We already expect 11 NULLs in TotalCharges. Let's verify the important fields:
SELECT
    SUM(customerID IS NULL) AS customerID_nulls,
    SUM(tenure IS NULL) AS tenure_nulls,
    SUM(MonthlyCharges IS NULL) AS monthlycharges_nulls,
    SUM(TotalCharges IS NULL) AS totalcharges_nulls,
    SUM(Churn IS NULL) AS churn_nulls
FROM telco_customer_churn;

-- 2.4 Check the Churn categories
SELECT
    Churn,
    COUNT(*) AS customers
FROM telco_customer_churn
GROUP BY Churn;

-- =======================================================================
-- Step 3 — BASELINE CHURN ANALYSIS
-- Business Question:
-- What percentage of customers have churned?
-- =======================================================================
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,
    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn;

-- Business Insight:
-- Of the 7,043 customers in the dataset, 1,869 customers churned
-- and 5,174 were retained, resulting in an overall churn rate of 26.54%.
-- This means approximately one in four customers in the dataset left the company.

-- =============================================
-- STEP 4: CONTRACT TYPE & CHURN
-- Business Question:
-- How does customer churn vary by contract type?
-- =============================================
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,
    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- Business Insight:
-- Month-to-month customers have the highest churn rate at 42.71%,
-- compared with 11.27% for one-year contracts and 
-- 2.83% for two-year contracts.
--
-- This indicates that churn is substantially more concentrated among
-- month-to-month customers, making them an important segment for
-- further retention analysis.
--
-- This relationship is associative and does not demonstrate that
-- contract type directly causes customer churn.

-- =============================================
-- STEP 5: CUSTOMER TENURE & CHURN
-- Business Question:
-- How does churn vary across customer tenure groups?
-- =============================================
SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 months'
        ELSE 'Other'
    END AS tenure_group,
    
    COUNT(*) AS total_customers,
    
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    
    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telco_customer_churn

GROUP BY
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 months'
        ELSE 'Other'
    END

ORDER BY
    MIN(tenure);
    
-- Business Insight:
-- Customer churn is highest during the first 12 months, at 47.44%.
-- The churn rate declines as customer tenure increases, falling to
-- 28.71% for customers with 13-24 months of tenure, 20.39% for
-- customers with 25-48 months, and 9.51% for customers with
-- 49-72 months of tenure.
--
-- This suggests that the early customer lifecycle is an important
-- period for retention efforts.

-- =============================================
-- STEP 6: INTERNET SERVICE & CHURN
-- Business Question:
-- How does churn vary across internet service types?
-- =============================================

SELECT
    InternetService,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telco_customer_churn

GROUP BY InternetService

ORDER BY churn_rate_pct DESC;

-- Business Insight:
-- Fiber optic customers have the highest churn rate at 41.89%,
-- compared with 18.96% for DSL customers and 7.40% for customers
-- without internet service.
--
-- This identifies fiber optic customers as an important segment
-- for further investigation and potential retention efforts.
--
-- The results show an association between internet service type
-- and churn but do not establish that fiber optic service itself
-- causes customers to leave.

-- =============================================
-- STEP 7: MONTHLY CHARGES & CHURN
-- Business Question:
-- How do monthly charges differ between churned
-- and retained customers?
-- =============================================
SELECT
    Churn,
    COUNT(*) AS total_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(MIN(MonthlyCharges), 2) AS min_monthly_charge,
    ROUND(MAX(MonthlyCharges), 2) AS max_monthly_charge
FROM telco_customer_churn
GROUP BY Churn
ORDER BY avg_monthly_charge DESC;

-- calculate the difference directly
SELECT
    ROUND(
        AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END)
        -
        AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),
        2
    ) AS avg_charge_difference
FROM telco_customer_churn;

-- Business Insight:
-- Customers who churned had higher monthly charges, averaging $74.44,
-- compared with $61.27 among customers who remained with the company.
--
-- This represents an average difference of approximately $13.17.
--
-- The result suggests that higher monthly charges are associated with
-- customer churn. However, this does not prove that higher charges
-- directly cause customers to leave.

-- =============================================
-- STEP 8: TECH SUPPORT & CHURN
-- Business Question:
-- How does churn vary based on tech support status?
-- =============================================
SELECT
    TechSupport,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telco_customer_churn

GROUP BY TechSupport

ORDER BY churn_rate_pct DESC;

-- Compare customers with and without tech support,
-- excluding customers without internet service.
SELECT
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn
WHERE TechSupport IN ('Yes', 'No')
GROUP BY TechSupport
ORDER BY churn_rate_pct DESC;

-- Business Insight:
-- Among customers using internet services, customers without tech
-- support have a substantially higher churn rate at 41.64%,
-- compared with 15.17% among customers with tech support.
--
-- Customers classified as "No internet service" have a churn rate
-- of 7.40%, but this group is structurally different because these
-- customers do not use internet service and therefore would not
-- require internet-related technical support.
--
-- The results suggest that access to tech support is associated
-- with stronger customer retention. However, this relationship
-- does not establish that tech support directly causes lower churn.

-- =============================================
-- STEP 9: PAYMENT METHOD & CHURN
-- Business Question:
-- How does customer churn vary across payment methods?
-- =============================================
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct,

    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge

FROM telco_customer_churn

GROUP BY PaymentMethod

ORDER BY churn_rate_pct DESC;

-- Business Insight:
-- Customers paying by electronic check have the highest churn rate
-- at 45.29%, compared with 19.11% for mailed checks, 16.71% for
-- automatic bank transfers and 15.24% for automatic credit-card
-- payments.
--
-- Electronic-check customers also have relatively high average
-- monthly charges of $76.26.
--
-- This identifies electronic-check customers as an important segment
-- for further investigation. However, payment method should not be
-- assumed to cause churn because other characteristics such as
-- contract type, tenure and service usage may contribute to the
-- higher churn observed within this group.

-- =============================================
-- STEP 10: CONTRACT TYPE + TECH SUPPORT
-- Business Question:
-- How does churn vary when contract type and
-- tech support status are analysed together?
-- =============================================
SELECT
    Contract,
    TechSupport,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telco_customer_churn

GROUP BY
    Contract,
    TechSupport

ORDER BY churn_rate_pct DESC;

-- Business Insight:
-- Month-to-month customers without tech support represent a
-- particularly high-risk customer segment.
--
-- Of the 2,680 customers in this group, 1,350 churned,
-- resulting in a churn rate of 50.37%.
--
-- Month-to-month customers with tech support also experienced
-- relatively high churn at 30.70%, although this was considerably
-- lower than the 50.37% observed among month-to-month customers
-- without tech support.
--
-- Churn was substantially lower among customers on one-year and
-- two-year contracts, regardless of tech-support status.
--
-- These findings identify month-to-month customers without tech
-- support as an important segment for targeted retention analysis.
-- However, these relationships are associative and do not prove
-- that changing contract type or adding tech support would
-- directly prevent customer churn.

-- =============================================
-- STEP 11: CUSTOMER RISK SEGMENTATION
-- Business Question:
-- Can multiple churn-associated characteristics
-- be combined to identify higher-risk customers?
-- =============================================

-- Month-to-month contract
-- Tenure of 12 months or less
-- Fiber optic internet service
-- No tech support
-- Electronic check payment method

SELECT
    (
        CASE WHEN Contract = 'Month-to-month' THEN 1 ELSE 0 END
        +
        CASE WHEN tenure <= 12 THEN 1 ELSE 0 END
        +
        CASE WHEN InternetService = 'Fiber optic' THEN 1 ELSE 0 END
        +
        CASE WHEN TechSupport = 'No' THEN 1 ELSE 0 END
        +
        CASE WHEN PaymentMethod = 'Electronic check' THEN 1 ELSE 0 END
    ) AS risk_score,

    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telco_customer_churn

GROUP BY risk_score

ORDER BY risk_score;

-- Business Insight:
-- Customer churn increases substantially as customers accumulate
-- more of the identified churn-associated characteristics.
--
-- Customers with a risk score of 0 have an observed churn rate
-- of only 2.53%, while customers with all five risk characteristics
-- have an observed churn rate of 72.33%.
--
-- This suggests that combining multiple customer characteristics
-- provides a clearer way to identify high-risk customer segments
-- than analysing individual factors in isolation.
--
-- Important Limitation:
-- This is an exploratory rule-based segmentation method rather
-- than a predictive machine-learning model.
--
-- The risk characteristics were selected and evaluated using the
-- same dataset, so the 72.33% churn rate at risk score 5 should
-- not be interpreted as predictive accuracy for new customers.


-- =============================================
-- STEP 12: FINAL BUSINESS INSIGHTS & RECOMMENDATIONS
-- =============================================


-- FINAL BUSINESS INSIGHTS
-- -----------------------

-- 1. Overall Customer Churn
-- Of the 7,043 customers analysed, 1,869 churned, resulting in an
-- overall churn rate of 26.54%. This means approximately one in four
-- customers in the dataset left the company.


-- 2. Contract Type
-- Month-to-month customers have the highest churn rate at 42.71%,
-- compared with 11.27% for one-year contracts and 2.83% for
-- two-year contracts.
--
-- This identifies month-to-month customers as an important segment
-- for retention efforts.


-- 3. Customer Tenure
-- Customers within their first 12 months have the highest tenure-based
-- churn rate at 47.44%.
--
-- Churn decreases as tenure increases, falling to 28.71% for customers
-- with 13-24 months of tenure, 20.39% for customers with 25-48 months,
-- and 9.51% for customers with 49-72 months of tenure.
--
-- This suggests that the early customer lifecycle is an important
-- period for retention efforts.


-- 4. Internet Service
-- Fiber optic customers have the highest churn rate at 41.89%,
-- compared with 18.96% for DSL customers and 7.40% for customers
-- without internet service.
--
-- Fiber optic customers therefore represent an important segment
-- for further investigation.


-- 5. Monthly Charges
-- Customers who churned had an average monthly charge of $74.44,
-- compared with $61.27 among customers who remained.
--
-- The difference of approximately $13.17 suggests that higher monthly
-- charges are associated with churn, although this does not establish
-- that higher charges directly cause customers to leave.


-- 6. Technical Support
-- Among internet customers, customers without tech support have a
-- churn rate of 41.64%, compared with 15.17% among customers with
-- tech support.
--
-- This suggests that access to technical support is associated with
-- stronger customer retention.


-- 7. Payment Method
-- Electronic-check customers have the highest churn rate among payment
-- methods at 45.29%, compared with 19.11% for mailed checks, 16.71%
-- for automatic bank transfers and 15.24% for automatic credit-card
-- payments.
--
-- This identifies electronic-check customers as another segment that
-- should be investigated further.


-- 8. High-Risk Customer Segment
-- Month-to-month customers without tech support represent a particularly
-- important high-risk segment.
--
-- Of the 2,680 customers in this group, 1,350 churned, resulting in a
-- churn rate of 50.37%.


-- 9. Customer Risk Segmentation
-- The exploratory risk score showed a clear increase in churn as
-- customers accumulated more churn-associated characteristics.
--
-- Customers with a risk score of 0 had an observed churn rate of 2.53%,
-- compared with 72.33% among customers with all five identified
-- risk characteristics.
--
-- This demonstrates the value of combining multiple characteristics
-- when identifying high-risk customer segments.



-- BUSINESS RECOMMENDATIONS
-- ------------------------

-- 1. Prioritise New and Month-to-Month Customers
-- The company could strengthen onboarding, proactive service check-ins
-- and targeted retention initiatives during the first 12 months.
-- Suitable incentives for longer-term contracts could also be tested
-- among month-to-month customers.


-- 2. Investigate the Fiber Optic Customer Experience
-- The company should investigate pricing, service reliability,
-- customer complaints and perceived value among fiber optic customers
-- to better understand why this segment experiences higher churn.


-- 3. Test Tech-Support Retention Initiatives
-- The company could test initiatives that improve awareness,
-- accessibility or adoption of tech support among eligible high-risk
-- customers and measure whether customer retention improves.


-- 4. Investigate Electronic-Check Customers
-- Further analysis should determine whether tenure, contract type,
-- monthly charges or service selection help explain the high churn
-- observed among electronic-check customers.
--
-- Where appropriate, customers could also be offered convenient
-- automatic payment alternatives.


-- 5. Prioritise Customers With Multiple Risk Characteristics
-- Customers displaying several churn-associated characteristics could
-- be prioritised for targeted retention campaigns and further analysis.
--
-- The exploratory risk score should be validated on unseen data before
-- being used as a predictive or operational decision-making tool.


-- IMPORTANT ANALYTICAL LIMITATION
-- -------------------------------
-- The relationships identified in this analysis are associations and
-- should not be interpreted as proof of causation.
--
-- The customer risk score is an exploratory rule-based segmentation
-- method rather than a predictive machine-learning model.
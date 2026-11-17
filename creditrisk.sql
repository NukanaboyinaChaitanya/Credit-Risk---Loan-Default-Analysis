
/*
PROJECT: CREDIT RISK & LOAN DEFAULT ANALYSIS
DATASET: Default of Credit Card Clients (UCI)
RECORDS: 30,000
TOOL: SQL SERVER MANAGEMENT STUDIO

BUSINESS OBJECTIVE:
Analyse customer repayment behaviour and identify
patterns associated with credit-card payment defaults.
*/


-- =====================================================
-- QUERY 1: OVERALL CUSTOMER DEFAULT RATE
-- Business Question: What percentage of customers default?
-- =====================================================

SELECT
    COUNT(*) AS Total_Customers,

    SUM(CAST(default_payment_next_month AS INT))
        AS Default_Customers,

    COUNT(*) - SUM(CAST(default_payment_next_month AS INT))
        AS Non_Default_Customers,

    CAST(
        AVG(CAST(default_payment_next_month AS FLOAT)) * 100
        AS DECIMAL(5,2)
    ) AS Default_Rate

FROM dbo.credit_risk_full;


-- =====================================================
-- QUERY 2: DEFAULT RATE BY REPAYMENT STATUS
-- Business Question: Do repayment delays relate to default?
-- =====================================================

SELECT
    PAY_0 AS Repayment_Status,

    COUNT(*) AS Total_Customers,

    SUM(CAST(default_payment_next_month AS INT))
        AS Default_Customers,

    CAST(
        AVG(CAST(default_payment_next_month AS FLOAT)) * 100
        AS DECIMAL(5,2)
    ) AS Default_Rate

FROM dbo.credit_risk_full

GROUP BY PAY_0
ORDER BY PAY_0;


-- =====================================================
-- QUERY 3: DEFAULT RATE BY CREDIT LIMIT GROUP
-- Business Question: How does credit limit relate to defaults?
-- =====================================================

SELECT
    CASE
        WHEN LIMIT_BAL <= 50000 THEN 'Low Credit Limit'
        WHEN LIMIT_BAL <= 150000 THEN 'Medium Credit Limit'
        WHEN LIMIT_BAL <= 300000 THEN 'High Credit Limit'
        ELSE 'Very High Credit Limit'
    END AS Credit_Limit_Group,

    COUNT(*) AS Total_Customers,

    SUM(CAST(default_payment_next_month AS INT))
        AS Default_Customers,

    CAST(
        AVG(CAST(default_payment_next_month AS FLOAT)) * 100
        AS DECIMAL(5,2)
    ) AS Default_Rate

FROM dbo.credit_risk_full

GROUP BY
    CASE
        WHEN LIMIT_BAL <= 50000 THEN 'Low Credit Limit'
        WHEN LIMIT_BAL <= 150000 THEN 'Medium Credit Limit'
        WHEN LIMIT_BAL <= 300000 THEN 'High Credit Limit'
        ELSE 'Very High Credit Limit'
    END

ORDER BY Default_Rate DESC;


-- =====================================================
-- QUERY 4: DEFAULT RATE BY AGE GROUP
-- Business Question: Which age groups have higher default rates?
-- =====================================================

SELECT
    CASE
        WHEN AGE BETWEEN 21 AND 30 THEN '21-30'
        WHEN AGE BETWEEN 31 AND 40 THEN '31-40'
        WHEN AGE BETWEEN 41 AND 50 THEN '41-50'
        WHEN AGE BETWEEN 51 AND 60 THEN '51-60'
        ELSE '61-79'
    END AS Age_Group,

    COUNT(*) AS Total_Customers,

    SUM(CAST(default_payment_next_month AS INT))
        AS Default_Customers,

    CAST(
        AVG(CAST(default_payment_next_month AS FLOAT)) * 100
        AS DECIMAL(5,2)
    ) AS Default_Rate

FROM dbo.credit_risk_full

GROUP BY
    CASE
        WHEN AGE BETWEEN 21 AND 30 THEN '21-30'
        WHEN AGE BETWEEN 31 AND 40 THEN '31-40'
        WHEN AGE BETWEEN 41 AND 50 THEN '41-50'
        WHEN AGE BETWEEN 51 AND 60 THEN '51-60'
        ELSE '61-79'
    END

ORDER BY MIN(AGE);


-- =====================================================
-- QUERY 5: DEFAULT RATE BY EDUCATION CATEGORY
-- Business Question: How do default rates vary by education?
-- =====================================================

SELECT
    EDUCATION,

    COUNT(*) AS Total_Customers,

    SUM(CAST(default_payment_next_month AS INT))
        AS Default_Customers,

    CAST(
        AVG(CAST(default_payment_next_month AS FLOAT)) * 100
        AS DECIMAL(5,2)
    ) AS Default_Rate

FROM dbo.credit_risk_full

GROUP BY EDUCATION
ORDER BY EDUCATION;


-- =====================================================
-- QUERY 6: DEFAULT RATE BY MARRIAGE CATEGORY
-- Business Question: How do default rates vary by marriage category?
-- =====================================================

SELECT
    MARRIAGE,

    COUNT(*) AS Total_Customers,

    SUM(CAST(default_payment_next_month AS INT))
        AS Default_Customers,

    CAST(
        AVG(CAST(default_payment_next_month AS FLOAT)) * 100
        AS DECIMAL(5,2)
    ) AS Default_Rate

FROM dbo.credit_risk_full

GROUP BY MARRIAGE
ORDER BY MARRIAGE;


-- =====================================================
-- QUERY 7: AVERAGE BILL AMOUNT BY DEFAULT STATUS
-- Business Question: How do billing patterns differ?
-- =====================================================

SELECT
    default_payment_next_month,

    CAST(AVG(CAST(BILL_AMT1 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Bill_September,

    CAST(AVG(CAST(BILL_AMT2 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Bill_August,

    CAST(AVG(CAST(BILL_AMT3 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Bill_July,

    CAST(AVG(CAST(BILL_AMT4 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Bill_June,

    CAST(AVG(CAST(BILL_AMT5 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Bill_May,

    CAST(AVG(CAST(BILL_AMT6 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Bill_April

FROM dbo.credit_risk_full

GROUP BY default_payment_next_month
ORDER BY default_payment_next_month;


-- =====================================================
-- QUERY 8: AVERAGE PAYMENT AMOUNT BY DEFAULT STATUS
-- Business Question: Do defaulting customers make smaller payments?
-- =====================================================

SELECT
    default_payment_next_month,

    CAST(AVG(CAST(PAY_AMT1 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Payment_September,

    CAST(AVG(CAST(PAY_AMT2 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Payment_August,

    CAST(AVG(CAST(PAY_AMT3 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Payment_July,

    CAST(AVG(CAST(PAY_AMT4 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Payment_June,

    CAST(AVG(CAST(PAY_AMT5 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Payment_May,

    CAST(AVG(CAST(PAY_AMT6 AS FLOAT)) AS DECIMAL(12,2))
        AS Avg_Payment_April

FROM dbo.credit_risk_full

GROUP BY default_payment_next_month
ORDER BY default_payment_next_month;


-- =====================================================
-- QUERY 9: PAYMENT-TO-CREDIT LIMIT RATIO
-- Business Question: How much do customers pay relative
-- to their available credit limit?
-- =====================================================

SELECT
    default_payment_next_month,

    COUNT(*) AS Total_Customers,

    CAST(
        AVG(
            (
                CAST(PAY_AMT1 AS FLOAT) +
                PAY_AMT2 +
                PAY_AMT3 +
                PAY_AMT4 +
                PAY_AMT5 +
                PAY_AMT6
            ) / NULLIF(LIMIT_BAL, 0)
        ) * 100
        AS DECIMAL(10,2)
    ) AS Avg_Payment_To_Credit_Ratio

FROM dbo.credit_risk_full

GROUP BY default_payment_next_month
ORDER BY default_payment_next_month;


-- =====================================================
-- QUERY 10: REPAYMENT DELAY FREQUENCY ANALYSIS
-- Business Question: Do repeated repayment delays relate
-- to higher default rates?
-- =====================================================

WITH Customer_Delays AS
(
    SELECT
        ID,
        default_payment_next_month,

        CASE WHEN PAY_0 > 0 THEN 1 ELSE 0 END +
        CASE WHEN PAY_2 > 0 THEN 1 ELSE 0 END +
        CASE WHEN PAY_3 > 0 THEN 1 ELSE 0 END +
        CASE WHEN PAY_4 > 0 THEN 1 ELSE 0 END +
        CASE WHEN PAY_5 > 0 THEN 1 ELSE 0 END +
        CASE WHEN PAY_6 > 0 THEN 1 ELSE 0 END
        AS Delayed_Months

    FROM dbo.credit_risk_full
)

SELECT
    CASE
        WHEN Delayed_Months = 0 THEN 'No Delays'
        WHEN Delayed_Months BETWEEN 1 AND 2
            THEN '1-2 Delayed Months'
        ELSE '3+ Delayed Months'
    END AS Repayment_Category,

    COUNT(*) AS Total_Customers,

    SUM(CAST(default_payment_next_month AS INT))
        AS Default_Customers,

    CAST(
        AVG(CAST(default_payment_next_month AS FLOAT)) * 100
        AS DECIMAL(5,2)
    ) AS Default_Rate

FROM Customer_Delays

GROUP BY
    CASE
        WHEN Delayed_Months = 0 THEN 'No Delays'
        WHEN Delayed_Months BETWEEN 1 AND 2
            THEN '1-2 Delayed Months'
        ELSE '3+ Delayed Months'
    END

ORDER BY MIN(Delayed_Months);


/*
END OF CREDIT RISK SQL ANALYSIS

All queries use dbo.credit_risk_full.
The final dataset contains 30,000 customer records.

Note:
These analyses identify historical associations,
not causal relationships or approved lending decisions.
*/

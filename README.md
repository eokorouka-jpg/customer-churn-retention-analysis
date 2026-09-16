# Customer Churn & Retention Analysis

## Project Overview

Customer churn is an important business challenge for subscription-based companies because retaining existing customers can be critical to maintaining recurring revenue and long-term growth.

This project analyses the IBM Telco Customer Churn dataset containing **7,043 customers** to identify customer characteristics associated with churn and highlight segments that may benefit from targeted retention strategies.

The analysis was completed across **Python, MySQL, and Power BI**, demonstrating an end-to-end data analytics workflow from data cleaning and exploratory analysis to SQL-based business analysis and interactive dashboard development.

### Business Questions

The project investigates the following questions:

- What is the overall customer churn rate?
- How does churn vary by contract type and customer tenure?
- Is internet service type associated with different churn rates?
- How does tech support relate to customer churn?
- Which payment methods are associated with higher churn?
- Do churned customers have different monthly charges from retained customers?
- Which combinations of customer characteristics are associated with particularly high churn?
- Can customers be grouped into exploratory risk segments based on multiple churn-related characteristics?

## Tools & Technologies

- **Python** — Data cleaning, exploratory data analysis, churn analysis, customer risk segmentation, and visualisation using Pandas and Matplotlib.
- **MySQL** — Data quality checks, aggregation, customer segmentation, and SQL-based analysis of churn patterns.
- **Power BI** — Interactive dashboard development, KPI reporting, DAX measures, customer segmentation, and visualisation of key churn drivers.
- **Jupyter Notebook** — Development and documentation of the Python analysis.
- **MySQL Workbench** — SQL database management and query development.
- **GitHub** — Project documentation and portfolio presentation.

## Project Workflow

The project followed an end-to-end analytics workflow:

1. **Data Preparation** — Imported the customer churn dataset and reviewed its structure, data types, missing values, and duplicates.
2. **Data Cleaning** — Converted `TotalCharges` to a numeric field while retaining 11 new customers whose original values were blank.
3. **Exploratory Data Analysis** — Examined customer characteristics and overall churn patterns.
4. **Churn Driver Analysis** — Analysed churn across contract type, tenure, internet service, tech support, payment method, and monthly charges.
5. **Customer Risk Segmentation** — Created an exploratory rule-based risk score using multiple characteristics associated with churn in the dataset.
6. **SQL Analysis** — Reproduced and extended the business analysis in MySQL using aggregation, conditional logic, and customer segmentation.
7. **Power BI Dashboard** — Developed a two-page interactive dashboard covering executive KPIs, churn drivers, and customer risk.
8. **Business Recommendations** — Translated the analytical findings into retention-focused areas for further investigation and testing.

## Key Findings

### 1. Overall Customer Churn

- The dataset contains **7,043 customers**.
- **1,869 customers churned**, while **5,174 customers were retained**.
- The overall customer churn rate was **26.54%**.

### 2. Contract Type

Contract type showed a strong association with customer churn:

- **Month-to-month:** 42.71%
- **One-year contract:** 11.27%
- **Two-year contract:** 2.83%

Customers on month-to-month contracts had substantially higher churn than customers on longer-term contracts.

### 3. Customer Tenure

Churn was highest among customers earlier in their relationship with the company:

- **0–12 months:** 47.44%
- **13–24 months:** 28.71%
- **25–48 months:** 20.39%
- **49–72 months:** 9.51%

This pattern suggests that the early customer lifecycle is an important area for retention analysis and intervention testing.

### 4. Internet Service

Churn varied considerably across internet service types:

- **Fiber optic:** 41.89%
- **DSL:** 18.96%
- **No internet service:** 7.40%

Fiber-optic customers had the highest observed churn rate, indicating that their pricing, service experience, and other characteristics warrant further investigation.

### 5. Tech Support

Customers without tech support experienced considerably higher churn:

- **No tech support:** 41.64%
- **Tech support:** 15.17%
- **No internet service:** 7.40%

Among month-to-month customers without tech support, churn reached **50.37%**.

### 6. Payment Method

Electronic check customers recorded the highest churn rate among payment methods:

- **Electronic check:** 45.29%
- **Mailed check:** 19.11%
- **Bank transfer (automatic):** 16.71%
- **Credit card (automatic):** 15.24%

### 7. Monthly Charges

Churned customers also had higher average monthly charges:

- **Churned customers:** $74.44
- **Retained customers:** $61.27
- **Difference:** $13.17

These results show an association between higher monthly charges and churn, although the analysis does not establish that higher charges directly cause customers to leave.

### 8. Exploratory Customer Risk Segmentation

A rule-based risk score was created using five characteristics associated with higher churn in the dataset:

- Month-to-month contract
- Tenure of 12 months or less
- Fiber-optic internet service
- No tech support
- Electronic check payment

Observed churn increased as the number of risk characteristics increased:

| Risk Score | Churn Rate |
|---:|---:|
| 0 | 2.53% |
| 1 | 7.34% |
| 2 | 18.99% |
| 3 | 35.46% |
| 4 | 56.42% |
| 5 | 72.33% |

Customers with scores of **4–5** were classified as the exploratory **High Risk** segment. This group contained **1,656 customers** and had an observed churn rate of **62.08%**.

> **Note:** The risk score is an exploratory rule-based segmentation developed from patterns observed in this dataset. It is not a predictive machine-learning model and would require validation on unseen data before being used for prediction.

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


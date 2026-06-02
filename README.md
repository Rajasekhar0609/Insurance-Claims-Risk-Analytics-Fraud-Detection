# 🛡️ Insurance Claims Fraud Detection & Analytics

## 📌 Project Overview

This project simulates a real-world insurance company environment and develops an end-to-end **Insurance Claims Fraud Detection & Analytics** solution using **SQL, Python, Exploratory Data Analysis (EDA), Feature Engineering, and Power BI**.

The objective is to identify fraudulent claims, analyze operational performance, generate business insights, and prepare data for predictive analytics and machine learning.

---

## 🎯 Business Problem

Insurance companies face several challenges, including:

- Fraudulent claims
- Delayed claim settlements
- High customer complaint volumes
- Low policy renewal rates
- Provider billing inflation
- High-risk customers and agents
- Regional fraud concentration

This project addresses these challenges using data-driven analytics and business intelligence.

---

## 🛠️ Tech Stack

### Database & Querying
- MySQL
- SQL

### Data Analysis
- Python
- Pandas
- NumPy

### Visualization
- Matplotlib
- Seaborn
- Power BI

### Development Environment
- Jupyter Notebook

---

## 📂 Project Workflow

### 1️⃣ Database Design

Designed a normalized insurance database consisting of:

- Branches
- Agents
- Providers
- Customers
- Policies
- Claims
- Payments
- Claim Investigations
- Renewals
- Complaints

### 2️⃣ Data Cleaning

Performed:

- Missing value treatment
- Duplicate removal
- Data validation
- Data standardization
- Data quality checks

### 3️⃣ Exploratory Data Analysis (EDA)

Conducted analysis on:

- Claim trends
- Fraud patterns
- Provider behavior
- Agent performance
- Customer risk
- Settlement delays
- Regional claim distribution

### 4️⃣ Feature Engineering

Created fraud detection features including:

| Feature | Description |
|----------|------------|
| Claim Month | Month of claim submission |
| Claim Day Name | Day of claim submission |
| Policy Age at Claim | Policy age before claim |
| Claim-to-Coverage Ratio | Claim amount vs coverage |
| High Value Claim Flag | Identifies unusually large claims |
| Early Claim Flag | Claims raised shortly after policy issuance |
| Duplicate Claim Flag | Detects repeated claims |
| Frequent Claim Customer Flag | Flags repeat claim customers |
| Provider Risk Flag | High-risk providers |
| Agent Risk Flag | High-risk agents |
| Settlement Delay Flag | Delayed claim settlements |
| Customer Risk Score | Customer risk profiling |
| Claim Risk Score | Fraud risk scoring |

---

## 📊 Power BI Dashboard

The project includes a multi-page Power BI dashboard for insurance claims analytics.

### Executive Overview
- Total Claims
- Total Policies
- Fraud Rate
- Claim Approval Rate
- Total Payouts

### Claims Operations Dashboard
- Pending Claims
- Settlement Delays
- Approval/Rejection Trends
- Claims Processing Efficiency

### Fraud & Risk Analytics
- Fraud Trends
- High-Risk Providers
- Suspicious Regions
- Fraud Distribution

### Customer Risk Analytics
- High-Risk Customers
- Repeat Claim Customers
- Income Analysis
- Age Group Analysis

### Agent & Provider Analytics
- Agent Performance
- Provider Billing Analysis
- Branch Exposure Monitoring
- Regional Risk Analysis

### Renewal & Complaint Analytics
- Complaint Trends
- Renewal Rates
- Delayed Settlements
- Strategic Recommendations

---

## 📈 Key Business Insights

- Fraudulent claims generally have higher claim amounts.
- Certain providers show suspicious billing behavior.
- High-risk regions contribute significantly to fraud cases.
- Settlement delays increase customer complaints.
- Repeat claim customers require closer monitoring.
- Customer claim history influences renewal behavior.

---

## 📁 Repository Structure

```bash
Insurance-Fraud-Detection/
│
├── Data/
│   ├── claims_cleaned.csv
│   ├── customers_cleaned.csv
│   ├── policies_cleaned.csv
│   ├── providers_cleaned.csv
│   ├── agents_cleaned.csv
│   ├── branches_cleaned.csv
│   ├── payments_cleaned.csv
│   ├── claim_investigations_cleaned.csv
│   └── policy_renewals_cleaned.csv
│
├── Feature_Engineered_Data/
│   ├── insurance_claims_feature_engineered.csv
│   ├── insurance_claims_feature_engineered_v3.csv
│   └── insurance_claims_feature_engineered_v4.csv
│
├── Notebooks/
│   ├── Insurance_Fraud_EDA.ipynb
│   ├── Feature_Engineering.ipynb
│   └── Final_python_likith.ipynb
│
├── PowerBI/
│   └── dashboard.pbix
│
├── Documentation/
│   ├── Insurance Fraud Detection Project Documentation.docx
│   └── Business Problems and Solutions.docx
│
└── README.md
```

---

## 🚀 Skills Demonstrated

- SQL
- MySQL
- Python
- Pandas
- NumPy
- Data Cleaning
- Data Validation
- Exploratory Data Analysis (EDA)
- Feature Engineering
- Data Visualization
- Power BI
- DAX
- Dashboard Development
- KPI Reporting
- Business Intelligence
- Fraud Analytics
- Risk Scoring
- Business Problem Solving

---

## 🔮 Future Enhancements

- Machine Learning Fraud Prediction Models
- Real-Time Fraud Detection System
- Automated Risk Scoring Engine
- Advanced Predictive Analytics
- Model Deployment using Flask/FastAPI
- Interactive Web Dashboard

---

## 📷 Dashboard Preview

Add screenshots of your Power BI dashboard here.

Example:

![Dashboard Overview](images/dashboard_overview.png)

---

## 👨‍💻 Author

**Rakhi Puligoti**

**Data Analyst | Power BI | SQL | Python | Advanced Excel | Business Intelligence**

📧 Email: your-email@example.com

💼 LinkedIn: https://www.linkedin.com/in/your-profile

💻 GitHub: https://github.com/your-username

---

⭐ If you found this project useful, please give it a star!

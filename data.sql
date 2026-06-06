-- ============================================================

use securelife_insurance;
-- SecureLife Insurance Corporation
-- Data Generation Script
-- Generates: Branches(500), Agents(10k), Providers(5k),
--            Customers(100k), Policies(250k), Claims(150k),
--            Investigations(35k), Payments(120k),
--            Renewals(100k), Complaints(60k)
-- Run this AFTER Tables.sql
-- ============================================================

-- ============================================================
-- STEP 1 : BRANCHES (500 rows)
-- ============================================================
-- Seed table for cities / states / regions
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_cities (
    city VARCHAR(50), state VARCHAR(50), region VARCHAR(30)
);
INSERT INTO tmp_cities VALUES
  ('Hyderabad','Telangana','South'),('Bengaluru','Karnataka','South'),
  ('Chennai','Tamil Nadu','South'),('Kochi','Kerala','South'),
  ('Mumbai','Maharashtra','West'),('Pune','Maharashtra','West'),
  ('Ahmedabad','Gujarat','West'),('Surat','Gujarat','West'),
  ('Delhi','Delhi','North'),('Noida','Uttar Pradesh','North'),
  ('Gurugram','Haryana','North'),('Jaipur','Rajasthan','North'),
  ('Kolkata','West Bengal','East'),('Bhubaneswar','Odisha','East'),
  ('Patna','Bihar','East'),('Ranchi','Jharkhand','East'),
  ('Bhopal','Madhya Pradesh','Central'),('Nagpur','Maharashtra','Central'),
  ('Lucknow','Uttar Pradesh','North'),('Chandigarh','Punjab','North');

INSERT INTO Branches (branch_id, branch_name, city, state, region,
                      branch_manager, opening_date, branch_type,
                      claim_processing_capacity)
WITH RECURSIVE seq AS (
    SELECT 501 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 1000
),
city_seq AS (
    SELECT city, state, region,
           ROW_NUMBER() OVER (ORDER BY city) AS rn
    FROM tmp_cities
)
SELECT
    s.n AS branch_id,
    CONCAT(c.city, ' Branch-', (s.n - 500))        AS branch_name,
    c.city, c.state, c.region,
    -- intentionally NULL for ~3% records
    CASE WHEN RAND() < 0.03 THEN NULL
         ELSE CONCAT('Manager_', s.n) END           AS branch_manager,
    -- opening dates 2010-2023, ~1% future dates (quality issue)
    CASE WHEN RAND() < 0.01 THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD('2010-01-01', INTERVAL FLOOR(RAND()*4748) DAY) END AS opening_date,
    ELT(FLOOR(1 + RAND()*4), 'Metro','Urban','Semi-Urban','Rural') AS branch_type,
    -- capacity 200-1000, ~1% extreme outliers
    CASE WHEN RAND() < 0.01 THEN FLOOR(5000 + RAND()*10000)
         ELSE FLOOR(200 + RAND()*800) END           AS claim_processing_capacity
FROM seq s
JOIN city_seq c ON c.rn = (((s.n - 501) % 20) + 1);

select * from branches;
select * from agents;
SET SESSION cte_max_recursion_depth = 200000;
-- ============================================================
-- STEP 2 : AGENTS (10,000 rows)
-- ============================================================
INSERT INTO Agents (agent_id, agent_name, branch_id, city,
                    agent_experience_years, agent_status,
                    policies_sold, commission_amount, agent_risk_category)
WITH RECURSIVE seq AS (
    SELECT 7001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 17000
)
SELECT
    s.n,
    CASE WHEN RAND() < 0.02 THEN NULL
         ELSE CONCAT(ELT(FLOOR(1+RAND()*10),'Rahul','Priya','Amit','Neha',
             'Ravi','Sneha','Arjun','Pooja','Vikram','Anita'),
             ' ', ELT(FLOOR(1+RAND()*10),'Sharma','Verma','Reddy','Patel',
             'Singh','Kumar','Gupta','Nair','Iyer','Das'),
             '_',s.n)
    END                                                           AS agent_name,
    501 + FLOOR(RAND() * 500)                                     AS branch_id,
    ELT(FLOOR(1+RAND()*20),'Hyderabad','Mumbai','Delhi','Bengaluru','Chennai',
        'Pune','Ahmedabad','Kolkata','Jaipur','Lucknow','Surat','Noida',
        'Gurugram','Chandigarh','Kochi','Bhopal','Nagpur','Patna',
        'Ranchi','Bhubaneswar')                                   AS city,
    -- experience 1-30, ~1% outlier like 50
    CASE WHEN RAND() < 0.01 THEN 50
         ELSE FLOOR(1 + RAND()*29) END                            AS agent_experience_years,
    -- mixed casing quality issue in ~2%
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*3),'active','INACTIVE','suspended')
         ELSE ELT(FLOOR(1+RAND()*3),'Active','Inactive','Suspended') END AS agent_status,
    -- policies_sold 10-1000, 1% extreme
    CASE WHEN RAND() < 0.01 THEN FLOOR(5000 + RAND()*5000)
         ELSE FLOOR(10 + RAND()*990) END                          AS policies_sold,
    -- commission, 1% negative
    CASE WHEN RAND() < 0.01 THEN -(FLOOR(RAND()*50000))
         ELSE ROUND(10000 + RAND()*490000, 2) END                 AS commission_amount,
    CASE WHEN RAND() < 0.03 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*3),'Low','Medium','High') END    AS agent_risk_category
FROM seq s;
select * from providers;
-- ============================================================
-- STEP 3 : PROVIDERS (5,000 rows)
-- ============================================================
INSERT INTO Providers (provider_id, provider_name, provider_type,
                       city, state, network_status,
                       average_claim_amount, provider_risk_level,
                       claim_inflation_flag)
WITH RECURSIVE seq AS (
    SELECT 3001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 8001
)
SELECT
    s.n,
    -- ~1% duplicate names (quality issue)
    CASE WHEN RAND() < 0.01 THEN 'CityCare Hospital'
         ELSE CONCAT(ELT(FLOOR(1+RAND()*8),'City','Metro','National','Regional',
             'Prime','Apex','Sunrise','Global'),
             ' ',
             ELT(FLOOR(1+RAND()*4),'Hospital','Garage','Surveyor','Clinic'),
             '_', s.n)
    END                                                           AS provider_name,
    ELT(FLOOR(1+RAND()*3),'Hospital','Garage','Surveyor')         AS provider_type,
    ELT(FLOOR(1+RAND()*10),'Hyderabad','Mumbai','Delhi','Bengaluru','Chennai',
        'Pune','Kolkata','Jaipur','Ahmedabad','Lucknow')           AS city,
    ELT(FLOOR(1+RAND()*10),'Telangana','Maharashtra','Delhi','Karnataka',
        'Tamil Nadu','Maharashtra','West Bengal','Rajasthan',
        'Gujarat','Uttar Pradesh')                                 AS state,
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*2),'in-network','OUT OF NETWORK')
         ELSE ELT(FLOOR(1+RAND()*2),'In-Network','Out-of-Network') END AS network_status,
    -- avg claim: 20k-500k; 2% are inflated outliers
    CASE WHEN RAND() < 0.02 THEN ROUND(500000 + RAND()*1000000, 2)
         ELSE ROUND(20000 + RAND()*480000, 2) END                 AS average_claim_amount,
    CASE WHEN RAND() < 0.04 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*3),'Low','Medium','High') END    AS provider_risk_level,
    -- 15% of providers have inflation flag = 1
    CASE WHEN RAND() < 0.15 THEN 1 ELSE 0 END                    AS claim_inflation_flag
FROM seq s;

select * from Providers;
-- ============================================================
-- STEP 4 : CUSTOMERS (100,000 rows)
-- ============================================================
INSERT INTO Customers (customer_id, customer_name, gender, age,
                       city, state, occupation, annual_income,
                       customer_since, customer_risk_category)
WITH RECURSIVE seq AS (
    SELECT 100001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 200001
)
SELECT
    s.n,
    CASE WHEN RAND() < 0.02 THEN NULL
         ELSE CONCAT(ELT(FLOOR(1+RAND()*15),'Amit','Priya','Rahul','Neha',
             'Suresh','Anita','Vijay','Kavitha','Ravi','Deepa',
             'Arun','Meena','Kiran','Pooja','Ramesh'),
             ' ',
             ELT(FLOOR(1+RAND()*15),'Sharma','Reddy','Patel','Singh','Kumar',
             'Verma','Nair','Iyer','Das','Gupta','Rao','Mishra',
             'Joshi','Chopra','Menon'))
    END                                                           AS customer_name,
    -- inconsistent gender values (quality issue ~3%)
    CASE WHEN RAND() < 0.01 THEN 'M'
         WHEN RAND() < 0.01 THEN 'FEMALE'
         WHEN RAND() < 0.01 THEN 'male'
         ELSE ELT(FLOOR(1+RAND()*3),'Male','Female','Other') END  AS gender,
    -- 1% invalid age outliers
    CASE WHEN RAND() < 0.005 THEN 10
         WHEN RAND() < 0.005 THEN 110
         ELSE FLOOR(18 + RAND()*62) END                           AS age,
    ELT(FLOOR(1+RAND()*20),'Hyderabad','Mumbai','Delhi','Bengaluru','Chennai',
        'Pune','Ahmedabad','Kolkata','Jaipur','Lucknow','Surat','Noida',
        'Gurugram','Chandigarh','Kochi','Bhopal','Nagpur','Patna',
        'Ranchi','Bhubaneswar')                                   AS city,
    ELT(FLOOR(1+RAND()*10),'Telangana','Maharashtra','Delhi','Karnataka',
        'Tamil Nadu','Gujarat','West Bengal','Rajasthan',
        'Uttar Pradesh','Kerala')                                  AS state,
    ELT(FLOOR(1+RAND()*3),'Salaried','Self-Employed','Business')  AS occupation,
    -- income: 2% missing, 1% outliers
    CASE WHEN RAND() < 0.02 THEN NULL
         WHEN RAND() < 0.01 THEN ROUND(RAND()*100, 2)            -- near zero
         WHEN RAND() < 0.005 THEN ROUND(50000000 + RAND()*50000000, 2)  -- extreme high
         ELSE ROUND(200000 + RAND()*2800000, 2) END               AS annual_income,
    -- 1% future dates (quality issue)
    CASE WHEN RAND() < 0.01 THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD('2018-01-01', INTERVAL FLOOR(RAND()*2191) DAY) END AS customer_since,
    CASE WHEN RAND() < 0.03 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*3),'Low','Medium','High') END    AS customer_risk_category
FROM seq s;
select * from customers;
SET SESSION cte_max_recursion_depth = 500000;
-- ============================================================
-- STEP 5 : POLICIES (250,000 rows)
-- ============================================================
INSERT INTO Policies (policy_id, customer_id, policy_type,
                      policy_start_date, policy_end_date,
                      premium_amount, coverage_amount,
                      policy_status, agent_id, branch_id)
WITH RECURSIVE seq AS (
    SELECT 5000001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 5250001
)
SELECT
    s.n,
    100001 + FLOOR(RAND() * 100000)                               AS customer_id,
    -- mixed casing in ~2%
    CASE WHEN RAND() < 0.01 THEN 'health'
         WHEN RAND() < 0.01 THEN 'MOTOR'
         ELSE ELT(FLOOR(1+RAND()*5),'Health','Motor','Life','Travel','Property') END AS policy_type,
    -- start dates 2020-2025; 1% future
    CASE WHEN RAND() < 0.01 THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*1825) DAY) END AS policy_start_date,
    -- end date = start + 1 year; 1% end before start (quality issue)
    CASE WHEN RAND() < 0.01
         THEN DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*730) DAY)
         ELSE DATE_ADD(DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*1825) DAY),
                       INTERVAL 365 DAY) END                      AS policy_end_date,
    -- premium 5k-100k; 1% negative
    CASE WHEN RAND() < 0.01 THEN ROUND(-(RAND()*5000), 2)
         ELSE ROUND(5000 + RAND()*95000, 2) END                   AS premium_amount,
    -- coverage 100k-5M; 1% extreme outlier
    CASE WHEN RAND() < 0.01 THEN ROUND(50000000 + RAND()*50000000, 2)
         ELSE ROUND(100000 + RAND()*4900000, 2) END               AS coverage_amount,
    ELT(FLOOR(1+RAND()*4),'Active','Lapsed','Expired','Cancelled') AS policy_status,
    7001 + FLOOR(RAND() * 10000)                                  AS agent_id,
    501  + FLOOR(RAND() * 500)                                    AS branch_id
FROM seq s;
select * from policies;
-- ============================================================
-- STEP 6 : CLAIMS (150,000 rows)
-- ============================================================
INSERT INTO Claims (claim_id, policy_id, customer_id, claim_type,
                    claim_amount, claim_submission_date, incident_date,
                    claim_status, fraud_flag, settlement_days, provider_id)
WITH RECURSIVE seq AS (
    SELECT 9000001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 9150001
)
SELECT
    s.n,
    5000001 + FLOOR(RAND() * 250000)                              AS policy_id,
    -- 2% missing customer_id (quality issue) - stored as 0
    CASE WHEN RAND() < 0.02 THEN NULL
         ELSE 100001 + FLOOR(RAND() * 100000) END                 AS customer_id,
    -- mixed casing ~2%
    CASE WHEN RAND() < 0.01 THEN 'hospitalization'
         WHEN RAND() < 0.01 THEN 'ACCIDENT'
         ELSE ELT(FLOOR(1+RAND()*5),'Hospitalization','Accident',
                  'Theft','Damage','Death') END                   AS claim_type,
    -- claim amount by risk tier; 2% extreme outliers; 1% negative
    CASE WHEN RAND() < 0.01 THEN ROUND(-(RAND()*10000),2)
         WHEN RAND() < 0.02 THEN ROUND(2000000 + RAND()*3000000, 2)
         ELSE ROUND(10000 + RAND()*490000, 2) END                 AS claim_amount,
    -- submission date 2021-2025; 1% future
    CASE WHEN RAND() < 0.01 THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY) END AS claim_submission_date,
    -- incident before submission; 2% AFTER submission (quality issue)
    CASE WHEN RAND() < 0.02
         THEN DATE_ADD(DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY),
                       INTERVAL FLOOR(RAND()*30) DAY)
         ELSE DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY) END AS incident_date,
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*4),'approved','PENDING','rejected','investigating')
         ELSE ELT(FLOOR(1+RAND()*4),'Approved','Pending','Rejected','Investigating') END AS claim_status,
    -- Fraud flag: rule-based + 3% missing NULL
    CASE WHEN RAND() < 0.03 THEN NULL
         WHEN RAND() < 0.12 THEN 1   -- ~12% flagged fraudulent
         ELSE 0 END                                               AS fraud_flag,
    -- settlement days 1-90; 2% > 45 (delay); 1% negative
    CASE WHEN RAND() < 0.01 THEN -(FLOOR(RAND()*10))
         WHEN RAND() < 0.02 THEN FLOOR(45 + RAND()*120)
         ELSE FLOOR(1 + RAND()*44) END                           AS settlement_days,
    3001 + FLOOR(RAND() * 5000)                                   AS provider_id
FROM seq s;
select * from claims;
-- ============================================================
-- INJECT DUPLICATE CLAIMS (~0.7% = ~1050 rows)
-- ============================================================
SET SESSION cte_max_recursion_depth = 60000;

INSERT INTO Claims (claim_id, policy_id, customer_id, claim_type,
                    claim_amount, claim_submission_date, incident_date,
                    claim_status, fraud_flag, settlement_days, provider_id)
SELECT
    claim_id + 900000,   -- shifted ID to avoid PK conflict
    policy_id, customer_id, claim_type,
    claim_amount,
    claim_submission_date, incident_date,
    'Pending', 1,        -- mark as pending and fraud
    settlement_days, provider_id
FROM Claims
WHERE RAND() < 0.007
LIMIT 1050;

-- ============================================================
-- STEP 7 : CLAIM INVESTIGATIONS (35,000 rows)
-- ============================================================
INSERT INTO Claim_Investigations (investigation_id, claim_id,
    investigation_start_date, investigation_end_date,
    investigator_name, risk_score, investigation_result,
    evidence_count, remarks)
WITH RECURSIVE seq AS (
    SELECT 8100001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 8135001
),
sampled_claims AS (
    SELECT claim_id, ROW_NUMBER() OVER (ORDER BY RAND()) AS rn
    FROM Claims
    WHERE fraud_flag = 1 OR claim_amount > 300000
    LIMIT 35000
)
SELECT
    seq.n,
    sc.claim_id,
    DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY)        AS investigation_start_date,
    -- 1% end before start (quality issue)
    CASE WHEN RAND() < 0.01
         THEN DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD(DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY),
                       INTERVAL FLOOR(5 + RAND()*20) DAY) END      AS investigation_end_date,
    CASE WHEN RAND() < 0.04 THEN NULL
         ELSE CONCAT(ELT(FLOOR(1+RAND()*8),'Neha','Rajesh','Anita','Suresh',
              'Meera','Vikram','Kavya','Siddharth'),
              ' ', ELT(FLOOR(1+RAND()*6),'Reddy','Sharma','Patel',
              'Nair','Verma','Singh')) END                          AS investigator_name,
    -- risk score 0-100; 1% outlier like 150
    CASE WHEN RAND() < 0.01 THEN FLOOR(100 + RAND()*100)
         ELSE FLOOR(RAND()*101) END                                AS risk_score,
    CASE WHEN RAND() < 0.04 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*3),'Fraud','Not Fraud','Inconclusive') END AS investigation_result,
    -- 1% negative evidence count (quality issue)
    CASE WHEN RAND() < 0.01 THEN -(FLOOR(RAND()*5))
         ELSE FLOOR(RAND()*10) END                                 AS evidence_count,
    CASE WHEN RAND() < 0.05 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*5),
              'Duplicate medical bill detected',
              'Provider inflated claim amount',
              'Policy taken recently before claim',
              'Customer has multiple claims this year',
              'Third party verification pending') END               AS remarks
FROM seq
JOIN sampled_claims sc ON sc.rn = (seq.n - 8100000);

-- ============================================================
-- STEP 8 : PAYMENTS (120,000 rows)
-- ============================================================
INSERT INTO Payments (payment_id, policy_id, claim_id,
                      payment_type, payment_amount, payment_date,
                      payment_method, payment_status, transaction_reference)
WITH RECURSIVE seq AS (
    SELECT 7200001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 7320001
)
SELECT
    s.n,
    5000001 + FLOOR(RAND() * 250000)                              AS policy_id,
    -- ~35% are premium payments (no claim_id)
    CASE WHEN RAND() < 0.35 THEN NULL
         ELSE 9000001 + FLOOR(RAND() * 150000) END                AS claim_id,
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*3),'premium','CLAIM SETTLEMENT','refund')
         ELSE ELT(FLOOR(1+RAND()*3),'Premium','Claim Settlement','Refund') END AS payment_type,
    -- 1% negative; 2% extreme
    CASE WHEN RAND() < 0.01 THEN ROUND(-(RAND()*10000),2)
         WHEN RAND() < 0.02 THEN ROUND(1000000 + RAND()*4000000, 2)
         ELSE ROUND(5000 + RAND()*495000, 2) END                  AS payment_amount,
    -- 1% future dates
    CASE WHEN RAND() < 0.01 THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY) END AS payment_date,
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*4),'upi','CARD','bank transfer','cheque')
         ELSE ELT(FLOOR(1+RAND()*4),'UPI','Card','Bank Transfer','Cheque') END AS payment_method,
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*4),'success','FAILED','pending','reversed')
         ELSE ELT(FLOOR(1+RAND()*4),'Success','Failed','Pending','Reversed') END AS payment_status,
    -- 3% missing transaction reference
    CASE WHEN RAND() < 0.03 THEN NULL
         ELSE CONCAT('TXN_', UPPER(CONV(FLOOR(RAND()*1000000000),10,36))) END AS transaction_reference
FROM seq s;
select * from payments;
-- ============================================================
-- INJECT DUPLICATE PAYMENTS (~0.6%)
-- ============================================================
INSERT INTO Payments (payment_id, policy_id, claim_id, payment_type,
                      payment_amount, payment_date, payment_method,
                      payment_status, transaction_reference)
SELECT
    payment_id + 200000,
    policy_id, claim_id, payment_type,
    payment_amount, payment_date, payment_method,
    payment_status, transaction_reference
FROM Payments
WHERE RAND() < 0.006
LIMIT 720;

-- ============================================================
-- STEP 9 : POLICY_RENEWALS (100,000 rows)
-- ============================================================
INSERT INTO Policy_Renewals (renewal_id, policy_id, customer_id,
    renewal_due_date, renewal_date, renewal_status,
    renewal_premium, discount_offered, lapse_reason)
WITH RECURSIVE seq AS (
    SELECT 6100001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 6200001
)
SELECT
    s.n,
    5000001 + FLOOR(RAND() * 250000)                              AS policy_id,
    CASE WHEN RAND() < 0.02 THEN NULL
         ELSE 100001 + FLOOR(RAND() * 100000) END                 AS customer_id,
    DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY)       AS renewal_due_date,
    -- 2% invalid: renewal before policy start or after grace
    CASE WHEN RAND() < 0.02
         THEN DATE_ADD('2019-01-01', INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD(DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY),
                       INTERVAL FLOOR(-30 + RAND()*60) DAY) END   AS renewal_date,
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*3),'renewed','LAPSED','pending')
         ELSE ELT(FLOOR(1+RAND()*3),'Renewed','Lapsed','Pending') END AS renewal_status,
    -- 1% negative premium
    CASE WHEN RAND() < 0.01 THEN ROUND(-(RAND()*5000),2)
         ELSE ROUND(5000 + RAND()*95000, 2) END                   AS renewal_premium,
    -- discount_offered, 0.5% > premium (quality issue)
    CASE WHEN RAND() < 0.005 THEN ROUND(100000 + RAND()*50000, 2)
         ELSE ROUND(RAND()*10000, 2) END                          AS discount_offered,
    CASE WHEN RAND() < 0.05 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*5),
              'High Premium','Competitor Offer','No Response',
              'Claim Dissatisfaction','Financial Constraint') END  AS lapse_reason
FROM seq s;
select * from policy_renewals;
-- ============================================================
-- STEP 10 : CUSTOMER_COMPLAINTS (60,000 rows)
-- ============================================================
INSERT INTO Customer_Complaints (complaint_id, customer_id, policy_id,
    claim_id, complaint_category, complaint_date,
    resolution_status, resolution_time_days, customer_sentiment)
WITH RECURSIVE seq AS (
    SELECT 9300001 AS n UNION ALL SELECT n+1 FROM seq WHERE n < 9360001
)
SELECT
    s.n,
    CASE WHEN RAND() < 0.02 THEN NULL
         ELSE 100001 + FLOOR(RAND() * 100000) END                 AS customer_id,
    CASE WHEN RAND() < 0.03 THEN NULL
         ELSE 5000001 + FLOOR(RAND() * 250000) END                AS policy_id,
    CASE WHEN RAND() < 0.40 THEN NULL
         ELSE 9000001 + FLOOR(RAND() * 150000) END                AS claim_id,
    CASE WHEN RAND() < 0.03 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*5),
              'Settlement Delay','Rejected Claim','Agent Issue',
              'Premium Dispute','Policy Terms Mismatch') END       AS complaint_category,
    -- 1% future dates
    CASE WHEN RAND() < 0.01 THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)
         ELSE DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND()*1461) DAY) END AS complaint_date,
    CASE WHEN RAND() < 0.02 THEN ELT(FLOOR(1+RAND()*3),'open','RESOLVED','escalated')
         ELSE ELT(FLOOR(1+RAND()*3),'Open','Resolved','Escalated') END AS resolution_status,
    -- 1% negative; 2% extreme
    CASE WHEN RAND() < 0.01 THEN -(FLOOR(RAND()*5))
         WHEN RAND() < 0.02 THEN FLOOR(90 + RAND()*200)
         ELSE FLOOR(1 + RAND()*60) END                            AS resolution_time_days,
    CASE WHEN RAND() < 0.04 THEN NULL
         ELSE ELT(FLOOR(1+RAND()*3),'Positive','Neutral','Negative') END AS customer_sentiment
FROM seq s;
select * from customer_complaints;
-- ============================================================
-- INJECT DUPLICATE COMPLAINTS (~0.6%)
-- ============================================================
INSERT INTO Customer_Complaints (complaint_id, customer_id, policy_id,
    claim_id, complaint_category, complaint_date,
    resolution_status, resolution_time_days, customer_sentiment)
SELECT
    complaint_id + 100000,
    customer_id, policy_id, claim_id, complaint_category,
    complaint_date, resolution_status, resolution_time_days, customer_sentiment
FROM Customer_Complaints
WHERE RAND() < 0.006
LIMIT 360;

SELECT 'Data generation complete!' AS status;


select * from customers_cleaned
where customer_id=null;

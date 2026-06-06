-- ============================================================
-- SecureLife Insurance Corporation
-- Database Schema - All Tables
-- ============================================================

CREATE DATABASE IF NOT EXISTS securelife_insurance;
USE securelife_insurance;

-- ============================================================
-- TABLE 1: BRANCHES
-- ============================================================
CREATE TABLE Branches (
    branch_id       INT PRIMARY KEY,
    branch_name     VARCHAR(100) NOT NULL,
    city            VARCHAR(50),
    state           VARCHAR(50),
    region          VARCHAR(30),           -- North/South/East/West/Central
    branch_manager  VARCHAR(100),
    opening_date    DATE,
    branch_type     VARCHAR(30),           -- Metro/Urban/Semi-Urban/Rural
    claim_processing_capacity INT
);

-- ============================================================
-- TABLE 2: AGENTS
-- ============================================================
CREATE TABLE Agents (
    agent_id                INT PRIMARY KEY,
    agent_name              VARCHAR(100),
    branch_id               INT,
    city                    VARCHAR(50),
    agent_experience_years  INT,
    agent_status            VARCHAR(30),   -- Active/Inactive/Suspended
    policies_sold           INT,
    commission_amount       DECIMAL(12,2),
    agent_risk_category     VARCHAR(20),   -- Low/Medium/High
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- ============================================================
-- TABLE 3: PROVIDERS
-- ============================================================
CREATE TABLE Providers (
    provider_id             INT PRIMARY KEY,
    provider_name           VARCHAR(150),
    provider_type           VARCHAR(40),   -- Hospital/Garage/Surveyor
    city                    VARCHAR(50),
    state                   VARCHAR(50),
    network_status          VARCHAR(30),   -- In-Network/Out-of-Network
    average_claim_amount    DECIMAL(14,2),
    provider_risk_level     VARCHAR(20),   -- Low/Medium/High
    claim_inflation_flag    BIT DEFAULT 0
);

-- ============================================================
-- TABLE 4: CUSTOMERS
-- ============================================================
CREATE TABLE Customers (
    customer_id             INT PRIMARY KEY,
    customer_name           VARCHAR(100),
    gender                  VARCHAR(20),
    age                     INT,
    city                    VARCHAR(50),
    state                   VARCHAR(50),
    occupation              VARCHAR(60),
    annual_income           DECIMAL(14,2),
    customer_since          DATE,
    customer_risk_category  VARCHAR(20)    -- Low/Medium/High
);

-- ============================================================
-- TABLE 5: POLICIES
-- ============================================================
CREATE TABLE Policies (
    policy_id           BIGINT PRIMARY KEY,
    customer_id         INT,
    policy_type         VARCHAR(50),       -- Health/Motor/Life/Travel/Property
    policy_start_date   DATE,
    policy_end_date     DATE,
    premium_amount      DECIMAL(12,2),
    coverage_amount     DECIMAL(14,2),
    policy_status       VARCHAR(30),       -- Active/Lapsed/Expired/Cancelled
    agent_id            INT,
    branch_id           INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (agent_id)    REFERENCES Agents(agent_id),
    FOREIGN KEY (branch_id)   REFERENCES Branches(branch_id)
);

-- ============================================================
-- TABLE 6: CLAIMS
-- ============================================================
CREATE TABLE Claims (
    claim_id                BIGINT PRIMARY KEY,
    policy_id               BIGINT,
    customer_id             INT,
    claim_type              VARCHAR(60),   -- Hospitalization/Accident/Theft/Damage/Death
    claim_amount            DECIMAL(14,2),
    claim_submission_date   DATE,
    incident_date           DATE,
    claim_status            VARCHAR(30),   -- Approved/Pending/Rejected/Investigating
    fraud_flag              BIT DEFAULT 0,
    settlement_days         INT,
    provider_id             INT,
    FOREIGN KEY (policy_id)   REFERENCES Policies(policy_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

-- ============================================================
-- TABLE 7: CLAIM_INVESTIGATIONS
-- ============================================================
CREATE TABLE Claim_Investigations (
    investigation_id        BIGINT PRIMARY KEY,
    claim_id                BIGINT,
    investigation_start_date DATE,
    investigation_end_date   DATE,
    investigator_name       VARCHAR(100),
    risk_score              INT,           -- 0-100
    investigation_result    VARCHAR(30),   -- Fraud/Not Fraud/Inconclusive
    evidence_count          INT,
    remarks                 VARCHAR(300),
    FOREIGN KEY (claim_id) REFERENCES Claims(claim_id)
);

-- ============================================================
-- TABLE 8: PAYMENTS
-- ============================================================
CREATE TABLE Payments (
    payment_id              BIGINT PRIMARY KEY,
    policy_id               BIGINT,
    claim_id                BIGINT,        -- NULL for premium payments
    payment_type            VARCHAR(40),   -- Premium/Claim Settlement/Refund
    payment_amount          DECIMAL(14,2),
    payment_date            DATE,
    payment_method          VARCHAR(30),   -- UPI/Card/Bank Transfer/Cheque
    payment_status          VARCHAR(30),   -- Success/Failed/Pending/Reversed
    transaction_reference   VARCHAR(80),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id),
    FOREIGN KEY (claim_id)  REFERENCES Claims(claim_id)
);

-- ============================================================
-- TABLE 9: POLICY_RENEWALS
-- ============================================================
CREATE TABLE Policy_Renewals (
    renewal_id          BIGINT PRIMARY KEY,
    policy_id           BIGINT,
    customer_id         INT,
    renewal_due_date    DATE,
    renewal_date        DATE,
    renewal_status      VARCHAR(30),       -- Renewed/Lapsed/Pending
    renewal_premium     DECIMAL(12,2),
    discount_offered    DECIMAL(10,2),
    lapse_reason        VARCHAR(100),
    FOREIGN KEY (policy_id)   REFERENCES Policies(policy_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- TABLE 10: CUSTOMER_COMPLAINTS
-- ============================================================
CREATE TABLE Customer_Complaints (
    complaint_id            BIGINT PRIMARY KEY,
    customer_id             INT,
    policy_id               BIGINT,
    claim_id                BIGINT,        -- NULL if not claim-related
    complaint_category      VARCHAR(80),
    complaint_date          DATE,
    resolution_status       VARCHAR(30),   -- Open/Resolved/Escalated
    resolution_time_days    INT,
    customer_sentiment      VARCHAR(30),   -- Positive/Neutral/Negative
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (policy_id)   REFERENCES Policies(policy_id),
    FOREIGN KEY (claim_id)    REFERENCES Claims(claim_id)
);

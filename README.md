# 🚀 Salesforce Sales Cloud POC — Lead Intelligence & Deal Health System

## 📌 Overview

This project demonstrates an end-to-end Sales Cloud solution focused on **lead qualification, automated routing, and opportunity health monitoring**.

The goal is to help sales teams:
- Prioritize high-value leads
- Automate lead assignment
- Identify at-risk deals early
- Improve pipeline visibility

Salesforce Sales Cloud provides tools for **lead management, opportunity tracking, and analytics**, enabling teams to manage the full sales lifecycle efficiently :contentReference[oaicite:0]{index=0}.

---

## 🧩 Key Features

### 🔹 1. Lead Scoring (Apex)
- Custom scoring logic based on:
  - Company Size
  - Industry
  - Budget
  - Job Title
  - Email Domain
- Automatically calculates:
  - `Lead_Score__c`
  - Lead Rating → **Hot / Warm / Cold**

Lead scoring helps rank prospects based on their likelihood to convert, allowing teams to focus on high-value opportunities :contentReference[oaicite:1]{index=1}.

---

### 🔹 2. Auto Qualification & Routing
- Leads are automatically classified:
  - Hot → High priority
  - Warm → Medium priority
  - Cold → Low priority

- Automated routing:
  - Hot leads → Senior Sales Rep
  - Warm leads → Sales Queue
  - Cold leads → Nurture pipeline

- Follow-up task automation for high-value leads

---

### 🔹 3. Lead Conversion
- Converts Lead → Account, Contact, Opportunity
- Transitions process from **lead qualification → deal management**

---

### 🔹 4. Opportunity Health Monitoring
- Implemented using:
  - Scheduled Apex
  - `OpportunityHealthService`

- Evaluates:
  - Last Activity Date
  - Stage change duration
  - Close date proximity

- Assigns:
  - `Risk_Status__c` → **Healthy / Watch / At Risk**

This ensures continuous monitoring of pipeline health.

---

### 🔹 5. Sales Analytics

Reports and dashboards provide:

- 📊 Pipeline Health Distribution
- 📊 Pipeline by Stage
- 📊 At-Risk Opportunities

Sales Cloud reporting enables teams to track performance and make data-driven decisions using pipeline insights :contentReference[oaicite:2]{index=2}.

---

## 🏗️ Architecture Flow

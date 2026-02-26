# E-commerce SQL Analytics Portfolio (BigQuery)

This repository contains SQL projects based on an e-commerce dataset (BigQuery).  
The focus is on product analytics, CRM/email analytics, performance optimization, and revenue analysis.

The projects demonstrate dataset design for BI tools, query optimization, aggregation logic, and analytical thinking.

---

## Projects

### 1. Email Engagement Dataset

A full SQL dataset built for CRM and email engagement analysis.

The query combines account metrics and email activity metrics in shared dimensions:
- date
- country
- send_interval
- is_verified
- is_unsubscribed

Includes:
- account creation metrics
- email metrics (sent / open / visit)
- country-level totals
- country ranking (TOP-10)
- preparation for Looker Studio

Technical highlights:
- Multiple CTEs
- UNION ALL for handling different date logic
- Window functions (DENSE_RANK)
- COUNT(DISTINCT)
- Multi-level aggregation

Path:
`projects/01_email_engagement_dataset/`

---

### 2. Email Metrics Query Optimization

Query performance optimization case in BigQuery.

The original query contained nested subqueries and unnecessary data reshuffling.  
The optimized version simplified joins and removed redundant logic.

Execution improvements:
- Slot time reduced from ~7.6 sec to ~1 sec
- Execution time reduced from 3 sec to under 1 sec
- Shuffle output reduced from 57.57 MB to 354 B

Demonstrates:
- Execution plan analysis
- Query simplification
- Performance tuning
- SAFE_DIVIDE usage
- Clean JOIN structure

Path:
`projects/02_email_metrics_query_optimization/`

---

### 3. Revenue by Continent with Device Split and Sessions

Revenue analysis dataset grouped by continent.

Includes:
- Total revenue
- Revenue split by device (mobile vs desktop)
- Revenue share percentage
- Unique account count
- Verified account count
- Session count

Business questions supported:
- Which regions generate the highest revenue?
- How does mobile vs desktop revenue distribution vary?
- How does revenue correlate with verified accounts and sessions?

Technical highlights:
- CTE structure
- Conditional aggregation (CASE WHEN)
- COUNT(DISTINCT)
- Window functions (SUM OVER)
- SAFE_DIVIDE and ROUND

Path:
`projects/03_revenue_by_continent_device_sessions/`

---

## Tech Stack

- SQL (BigQuery)
- Data aggregation and transformation
- Window functions
- Query optimization
- Dataset preparation for BI tools (Looker Studio)

---

## Skills Demonstrated

- Analytical dataset design
- Handling multi-table joins
- Preventing metric duplication
- Window function usage
- Query performance optimization
- Business-oriented metric interpretation

## Planned Extensions

The repository will be extended with additional analytical case studies:

- A/B Test KPI Dataset (control vs test comparison, conversion rate, AOV, segmentation by device/country/channel)
- Cohort Retention Analysis (weekly and monthly retention tracking)
- RFM Segmentation (Recency / Frequency / Monetary scoring and customer grouping)

These projects will further demonstrate experimental analysis, behavioral segmentation, and lifecycle analytics.

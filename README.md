# E-commerce Email Engagement Analysis (SQL | BigQuery)

Цей репозиторій містить SQL-проєкти з аналізу e-commerce даних.
Фокус — продуктова аналітика, email-активність та сегментація користувачів.

## Projects

### Email Engagement Dataset (BigQuery)
Повний SQL-запит для створення датасету з:
- метриками створення акаунтів
- email-активністю (send/open/visit)
- ранжуванням країн
- TOP-10 сегментацією

Tech:
- CTE
- UNION ALL
- Window Functions (DENSE_RANK)
- Aggregations
- COUNT(DISTINCT)

Code:
`projects/01_email_engagement_dataset/query.sql`

---

## Tech Stack
- SQL (BigQuery)
- Looker Studio
- Product / CRM analytics

---

## Skills demonstrated
- Dataset design for BI tools
- Working with multiple event tables
- Avoiding date logic conflicts via UNION
- Window functions for ranking
- Multi-level aggregation

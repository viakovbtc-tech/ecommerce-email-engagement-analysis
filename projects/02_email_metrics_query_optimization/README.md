# Email Metrics Query Optimization (BigQuery)

## Goal
Оптимізувати запит, що рахує email-метрики в розрізі операційних систем, та порівняти Execution Details до і після змін.

Метрики:
- sent_msg
- open_msg
- visit_msg
- open_rate
- click_rate
- CTOR

Фільтр: тільки активні підписники (`is_unsubscribed = 0`)

---

## Problem in Original Query

Початковий запит:
- Містив вкладені підзапити з `SELECT *`
- Створював проміжні великі таблиці
- Використовував зайві JOIN-и
- Ускладнював execution plan

Це призводило до:
- Більшого обсягу оброблених даних
- Довшого execution time
- Вищого slot consumption

---

## Optimization Approach

Було зроблено:

- Видалено вкладені `SELECT *`
- Використано прямі JOIN-и між таблицями
- Спрощено структуру запиту
- Додано `SAFE_DIVIDE()` для уникнення ділення на 0
- Додано `ROUND(..., 2)` для коректного форматування метрик

---

## Before / After (Execution Details)

### Before Optimization
- Bytes processed: 59.75 MB
- Slot time: 7599
- Execution time: 3 sec
- Shuffled bytes: 57.57 MB


### After Optimization
- Bytes processed: 59.75 MB
- Slot time: 1482
- Execution time: 0 sec
- Shuffled bytes: 354

---

## Impact

Although bytes processed remained the same (same source tables),
query performance significantly improved:

- Slot time reduced from 7599 to 1482
- Execution time reduced from 3 sec to near-instant
- Shuffled bytes reduced from 57.57 MB to 354 B

The main performance gain came from removing nested subqueries
and eliminating unnecessary data reshuffling.

---

## Tech Skills Demonstrated
- Query optimization
- Execution plan analysis
- BigQuery performance tuning
- Join simplification
- SAFE_DIVIDE usage

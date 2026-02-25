# Email Engagement Dataset (BigQuery)

## Goal
Зібрати єдиний набір даних для аналізу:
- динаміки створення акаунтів,
- активності користувачів за email-подіями (send/open/visit),
- порівняння та сегментації за країною та атрибутами акаунта.

Набір даних підходить для візуалізації в Looker Studio.

## Dimensions (grouping fields)
- **date** — для акаунтів: дата сесії/прив’язки акаунта; для емейлів: дата відправки
- **country**
- **send_interval**
- **is_verified**
- **is_unsubscribed**

## Metrics
### Base metrics
- **account_cnt** — кількість створених (унікальних) акаунтів
- **sent_msg** — кількість надісланих листів
- **open_msg** — кількість відкритих листів
- **visit_msg** — кількість переходів з листів

### Country totals & ranks (all-time)
- **total_country_account_cnt** — загальна кількість акаунтів по країні
- **total_country_sent_cnt** — загальна кількість надісланих листів по країні
- **rank_total_country_account_cnt** — рейтинг країн за акаунтами (DENSE_RANK)
- **rank_total_country_sent_cnt** — рейтинг країн за надісланими (DENSE_RANK)

> У фіналі залишаються лише країни з **TOP-10** за акаунтами або за відправками.

## Data sources (tables)
- `DA.session`
- `DA.session_params`
- `DA.account_session`
- `DA.account`
- `DA.email_sent`
- `DA.email_open`
- `DA.email_visit`

## Approach (query structure)
Запит побудований через CTE:
1. **accounts_info** — агрегація акаунтів за вимірами (date/country/send_interval/is_verified/is_unsubscribed)
2. **message_info** — агрегація email-метрик за тими ж вимірами (date = дата відправки)
3. **account_msg** — об’єднання потоків через `UNION ALL`, щоб уникнути конфлікту логіки поля `date`
4. **aggregation** — згортання після UNION до одного рядка на комбінацію вимірів
5. **country_total** — тотали по країні за весь період
6. **ranked_info** — ранги країн через window functions (`DENSE_RANK()`)

Фінальний SELECT підтягує country totals + ranks та фільтрує TOP-10.

## How to use
Виконай `query.sql` у BigQuery та підключи результат до Looker Studio.

## Tech highlights
- CTE
- `UNION ALL` для різних логік date (accounts vs emails)
- window functions: `DENSE_RANK()`
- агрегації `COUNT(DISTINCT ...)`, `SUM(...)`

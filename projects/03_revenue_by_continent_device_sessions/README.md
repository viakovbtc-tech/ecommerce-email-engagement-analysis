# Revenue by Continent with Device Split and Sessions (BigQuery)

## Goal
Побудувати зведений набір даних для аналізу виручки (revenue) за континентами з розподілом за типом пристрою та базовими метриками активності (акаунти та сесії).

## Output columns
- **continent**
- **revenue**
- **revenue_from_mobile**
- **revenue_from_desktop**
- **revenue_share_pct** — частка revenue від загального revenue (%)
- **account_count** — кількість унікальних акаунтів
- **verified_account** — кількість унікальних verified акаунтів
- **session_count** — кількість унікальних сесій

## Data sources (tables)
- `DA.order` — замовлення (прив’язані до сесій)
- `DA.product` — довідник товарів з цінами
- `DA.session_params` — атрибути сесій (continent, device, тощо)
- `DA.account_session` — зв’язок акаунтів і сесій
- `DA.account` — атрибути акаунтів (is_verified)

## Approach
Запит складається з 3 CTE:
1. **revenue_usd** — рахує revenue по континенту та робить split за device (mobile/desktop)
2. **account_metrics** — рахує унікальні акаунти та verified акаунти по континенту (`COUNT(DISTINCT ...)`)
3. **session_count** — рахує кількість унікальних сесій по континенту

У фінальному SELECT:
- об’єднуємо всі метрики по continent
- рахуємо **revenue_share_pct** через window function `SUM(...) OVER ()`
- використовуємо `SAFE_DIVIDE` (без ділення на 0) та `ROUND(..., 2)` для форматування

## Business Questions this dataset can answer
- Які континенти приносять найбільшу виручку?
- Яка частка mobile vs desktop revenue у різних регіонах?
- Де найвища концентрація verified користувачів?
- Як виручка співвідноситься з обсягом сесій та кількістю акаунтів?

## Tech highlights
- CTE
- Conditional aggregation (CASE WHEN)
- Window functions (`SUM(...) OVER ()`)
- Safe calculations (`SAFE_DIVIDE`, `ROUND`)
- Deduplication with `COUNT(DISTINCT ...)`

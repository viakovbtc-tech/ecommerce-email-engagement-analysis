-- =====================================================================
-- 1) accounts_info: агрегуємо щоденні метрики по акаунтах і сесіях
--    - рахуємо унікальні акаунти
-- =====================================================================


WITH accounts_info as (


SELECT
    s.date as date,                                            -- дата сесії
    sp.country as country,                                     -- країна користувача
    ac.send_interval as send_interval,                         -- інтервал відправки (налаштування акаунта)
    ac.is_verified AS is_verified,                             -- прапорець верифікації (0 або 1)
    ac.is_unsubscribed AS is_unsubscribed,                     -- прапорець відписки (0 або 1)
    COUNT(DISTINCT acs.account_id)    as account_cnt           -- кількість унікальних акаунтів у цей день
FROM `DA.session_params` sp
JOIN `DA.session` s
ON sp.ga_session_id = s.ga_session_id
JOIN `DA.account_session` acs
ON s.ga_session_id = acs.ga_session_id
JOIN `DA.account` ac
ON acs.account_id = ac.id
GROUP BY 1, 2, 3, 4, 5
),


-- =====================================================================
-- 2) message_info: агрегуємо щоденні метрики по емейл-подіях
--    - рахуємо унікальні повідомлення: надіслані / відкриті / з візитом
--    - дата = дата сесії + зсув у днях (es.sent_date)
-- =====================================================================


message_info as (
SELECT
    DATE_ADD(s.date, INTERVAL es.sent_date DAY) as date,       -- дата відправки листа
    sp.country as country,                                     -- країна користувача
    ac.send_interval AS send_interval,                         -- інтервал відправки (налаштування акаунта)
    ac.is_verified AS is_verified,                             -- статус верифікації (0/1)
    ac.is_unsubscribed AS is_unsubscribed,                     -- статус підписки (0/1)
    COUNT(DISTINCT es.id_message) as sent_msg,                 -- к-сть унікальних надісланих
    COUNT(DISTINCT eo.id_message) as open_msg,                 -- к-сть унікальних відкриттів
    COUNT(DISTINCT ev.id_message) as visit_msg                 -- к-сть унікальних візитів
FROM `DA.email_sent` es
LEFT JOIN `DA.email_open` eo
ON es.id_message = eo.id_message
LEFT JOIN `DA.email_visit` ev
ON es.id_message = ev.id_message
JOIN `DA.account_session` acs
ON es.id_account = acs.account_id
JOIN `DA.account` ac
ON ac.id  = acs.account_id
JOIN `DA.session` s
ON acs.ga_session_id = s.ga_session_id
JOIN  `DA.session_params` sp
ON s.ga_session_id = sp.ga_session_id
GROUP BY 1, 2, 3, 4, 5
),
-- =====================================================================
-- 3) account_msg: зводимо акаунтні й емейл-метрики в один потік
--    Завдяки однаковим вимірам (date, country, send_interval, is_verified, is_unsubscribed)
--    UNION ALL: далі можна сумувати/агрегувати по країні/даті
-- =====================================================================
account_msg as (
SELECT
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed,
    account_cnt,
    0 as sent_msg,
    0 as open_msg,
    0 as visit_msg
FROM accounts_info
UNION ALL
SELECT
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed,
    0 as account_cnt,
    sent_msg,
    open_msg,
    visit_msg
FROM message_info
),

-- =====================================================================
-- 4) aggregation: згортаємо ПІСЛЯ UNION до одного рядка на комбінацію вимірів
-- =====================================================================
aggregation AS (
  SELECT
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed,
    SUM(account_cnt) AS account_cnt,
    SUM(sent_msg)    AS sent_msg,
    SUM(open_msg)    AS open_msg,
    SUM(visit_msg)   AS visit_msg
  FROM account_msg
  GROUP BY 1,2,3,4,5
),

-- =====================================================================
-- 5) country_total: тотали по країні за весь період
--    - сумарна к-сть надісланих листів і акаунтів по країні
-- =====================================================================
country_total AS (
SELECT
    country,
    SUM(sent_msg) AS total_country_sent_cnt,            -- сумарно надісланих по країні
    SUM(account_cnt) AS total_country_account_cnt       -- сумарно акаунтів по країні
FROM account_msg
GROUP BY country
),
-- =====================================================================
-- 6) ranked_info: ранжуємо країни за двома метриками
--    - ранг за кількістю акаунтів (DESC)
--    - ранг за кількістю надісланих (DESC)
-- =====================================================================
ranked_info AS (
SELECT
    country,
    total_country_sent_cnt,
    total_country_account_cnt,
    DENSE_RANK() OVER (ORDER BY total_country_account_cnt DESC)
      AS rank_total_country_account_cnt,                        -- місце країни за акаунтами
    DENSE_RANK() OVER (ORDER BY total_country_sent_cnt DESC)
      AS rank_total_country_sent_cnt                            -- місце країни за відправками
FROM country_total
)
-- 7) Фінальна вибірка:
--    - підтягуємо ранги/тотали для кожної країни
--    - фільтр: беремо лише країни з топ-10 за відправками або акаунтами
--    - сортування: по даті, потім за total_country_account_cnt спадаючим
-- =====================================================================
SELECT
  agg.date,
  agg.country,
  agg.send_interval,
  agg.is_verified,
  agg.is_unsubscribed,
  agg.account_cnt,
  agg.sent_msg,
  agg.open_msg,
  agg.visit_msg,
  r.total_country_account_cnt,
  r.total_country_sent_cnt,
  r.rank_total_country_account_cnt,
  r.rank_total_country_sent_cnt
FROM aggregation AS agg
LEFT JOIN ranked_info AS r
  ON agg.country = r.country
WHERE r.rank_total_country_sent_cnt   <= 10
   OR r.rank_total_country_account_cnt <= 10
ORDER BY agg.date, r.total_country_account_cnt DESC;

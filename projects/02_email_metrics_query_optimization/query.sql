-- Email Metrics Query Optimization (BigQuery)
-- Goal: calculate email metrics by operating system with a simpler, faster query.
-- Metrics: sent/open/visit + open rate, click rate, CTOR
-- Filter: only subscribed users (is_unsubscribed = 0)

SELECT
  sp.operating_system,
  COUNT(DISTINCT es.id_message) AS sent_msg,
  COUNT(DISTINCT eo.id_message) AS open_msg,
  COUNT(DISTINCT ev.id_message) AS visit_msg,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT eo.id_message), COUNT(DISTINCT es.id_message)) * 100, 2) AS open_rate,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT ev.id_message), COUNT(DISTINCT es.id_message)) * 100, 2) AS click_rate,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT ev.id_message), COUNT(DISTINCT eo.id_message)) * 100, 2) AS ctor
FROM `DA.session_params` sp
JOIN `DA.account_session` acs
  ON sp.ga_session_id = acs.ga_session_id
JOIN `DA.account` ac
  ON acs.account_id = ac.id
JOIN `DA.email_sent` es
  ON ac.id = es.id_account
LEFT JOIN `DA.email_open` eo
  ON es.id_message = eo.id_message
LEFT JOIN `DA.email_visit` ev
  ON es.id_message = ev.id_message
WHERE ac.is_unsubscribed = 0
GROUP BY sp.operating_system
ORDER BY sent_msg DESC;

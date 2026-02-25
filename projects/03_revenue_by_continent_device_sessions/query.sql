-- Revenue by Continent with Device Split and Account Metrics
-- BigQuery version
-- Goal: analyze revenue distribution, device contribution, account metrics and sessions by continent

WITH revenue_usd AS (
  SELECT
    sp.continent,
    SUM(p.price) AS revenue,
    SUM(CASE WHEN sp.device = 'mobile' THEN p.price ELSE 0 END) AS revenue_from_mobile,
    SUM(CASE WHEN sp.device = 'desktop' THEN p.price ELSE 0 END) AS revenue_from_desktop
  FROM `DA.order` o
  JOIN `DA.product` p
    ON o.item_id = p.item_id
  JOIN `DA.session_params` sp
    ON o.ga_session_id = sp.ga_session_id
  GROUP BY sp.continent
),

account_metrics AS (
  SELECT
    sp.continent,
    COUNT(DISTINCT ac.id) AS account_count,
    COUNT(DISTINCT CASE WHEN ac.is_verified = 1 THEN ac.id END) AS verified_account
  FROM `DA.session_params` sp
  JOIN `DA.account_session` acs
    ON sp.ga_session_id = acs.ga_session_id
  JOIN `DA.account` ac
    ON acs.account_id = ac.id
  GROUP BY sp.continent
),

session_count AS (
  SELECT
    continent,
    COUNT(DISTINCT ga_session_id) AS session_count
  FROM `DA.session_params`
  GROUP BY continent
)

SELECT
  am.continent,
  r.revenue,
  r.revenue_from_mobile,
  r.revenue_from_desktop,
  ROUND(SAFE_DIVIDE(r.revenue, SUM(r.revenue) OVER ()) * 100, 2) AS revenue_share_pct,
  am.account_count,
  am.verified_account,
  sc.session_count
FROM account_metrics am
LEFT JOIN revenue_usd r
  ON am.continent = r.continent
LEFT JOIN session_count sc
  ON am.continent = sc.continent
ORDER BY r.revenue DESC;

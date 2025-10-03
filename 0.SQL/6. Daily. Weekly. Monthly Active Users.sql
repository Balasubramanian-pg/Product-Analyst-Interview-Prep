-- =====================================================
-- 6. Daily/Weekly/Monthly Active Users (DAU/WAU/MAU)
-- =====================================================
-- DAU
SELECT 
  DATE(event_timestamp) AS date,
  COUNT(DISTINCT user_id) AS dau
FROM events
WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY date
ORDER BY date;

-- WAU (rolling 7-day window)
SELECT 
  DATE(event_timestamp) AS date,
  COUNT(DISTINCT user_id) OVER (
    ORDER BY DATE(event_timestamp)
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS wau
FROM events
WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 37 DAY)
GROUP BY date
ORDER BY date;

-- MAU (rolling 30-day window)
SELECT 
  DATE(event_timestamp) AS date,
  COUNT(DISTINCT user_id) OVER (
    ORDER BY DATE(event_timestamp)
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ) AS mau
FROM events
WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY)
GROUP BY date
ORDER BY date;

-- Combined DAU/WAU/MAU with engagement ratios
WITH daily_users AS (
  SELECT 
    DATE(event_timestamp) AS date,
    user_id
  FROM events
  WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY)
  GROUP BY date, user_id
)
SELECT 
  date,
  COUNT(DISTINCT user_id) AS dau,
  COUNT(DISTINCT user_id) OVER (
    ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS wau,
  COUNT(DISTINCT user_id) OVER (
    ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ) AS mau,
  COUNT(DISTINCT user_id) * 100.0 / NULLIF(COUNT(DISTINCT user_id) OVER (
    ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 0) AS dau_wau_ratio,
  COUNT(DISTINCT user_id) * 100.0 / NULLIF(COUNT(DISTINCT user_id) OVER (
    ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ), 0) AS dau_mau_ratio
FROM daily_users
GROUP BY date
ORDER BY date;

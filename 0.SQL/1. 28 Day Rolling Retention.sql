-- =====================================================
-- 1. 28-Day Rolling Retention
-- =====================================================
-- Calculates what % of users return on each day after signup
WITH user_first_activity AS (
  SELECT 
    user_id,
    MIN(DATE(event_timestamp)) AS cohort_date
  FROM events
  GROUP BY user_id
),
user_activity_days AS (
  SELECT DISTINCT
    e.user_id,
    DATE(e.event_timestamp) AS activity_date,
    u.cohort_date
  FROM events e
  JOIN user_first_activity u ON e.user_id = u.user_id
)
SELECT 
  cohort_date,
  DATE_DIFF(activity_date, cohort_date, DAY) AS days_since_signup,
  COUNT(DISTINCT user_id) AS retained_users,
  COUNT(DISTINCT user_id) * 100.0 / FIRST_VALUE(COUNT(DISTINCT user_id)) 
    OVER (PARTITION BY cohort_date ORDER BY DATE_DIFF(activity_date, cohort_date, DAY)) AS retention_pct
FROM user_activity_days
WHERE DATE_DIFF(activity_date, cohort_date, DAY) BETWEEN 0 AND 28
GROUP BY cohort_date, days_since_signup
ORDER BY cohort_date, days_since_signup;


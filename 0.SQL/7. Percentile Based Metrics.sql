-- =====================================================
-- 7. Percentile-Based Metrics (p50, p90, p95 Session Duration)
-- =====================================================
WITH session_durations AS (
  SELECT 
    session_id,
    user_id,
    MIN(event_timestamp) AS session_start,
    MAX(event_timestamp) AS session_end,
    TIMESTAMP_DIFF(MAX(event_timestamp), MIN(event_timestamp), SECOND) / 60.0 AS duration_minutes
  FROM events
  WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY session_id, user_id
  HAVING TIMESTAMP_DIFF(MAX(event_timestamp), MIN(event_timestamp), SECOND) > 0
)
SELECT 
  COUNT(*) AS total_sessions,
  ROUND(AVG(duration_minutes), 2) AS avg_duration_min,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.5) OVER(), 2) AS p50_median_min,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.75) OVER(), 2) AS p75_min,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.90) OVER(), 2) AS p90_min,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.95) OVER(), 2) AS p95_min,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.99) OVER(), 2) AS p99_min
FROM session_durations
LIMIT 1;

-- Percentiles by user segment
WITH session_durations AS (
  SELECT 
    e.session_id,
    e.user_id,
    u.subscription_type,
    TIMESTAMP_DIFF(MAX(e.event_timestamp), MIN(e.event_timestamp), SECOND) / 60.0 AS duration_minutes
  FROM events e
  JOIN users u ON e.user_id = u.user_id
  WHERE DATE(e.event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY e.session_id, e.user_id, u.subscription_type
  HAVING TIMESTAMP_DIFF(MAX(e.event_timestamp), MIN(e.event_timestamp), SECOND) > 0
)
SELECT 
  subscription_type,
  COUNT(*) AS sessions,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.5) OVER(PARTITION BY subscription_type), 2) AS p50_median_min,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.90) OVER(PARTITION BY subscription_type), 2) AS p90_min,
  ROUND(PERCENTILE_CONT(duration_minutes, 0.95) OVER(PARTITION BY subscription_type), 2) AS p95_min
FROM session_durations
GROUP BY subscription_type
LIMIT 100;

-- =====================================================
-- 2. Top 3 Features Predicting Conversion to Paid
-- =====================================================
-- Uses feature usage within first 7 days to predict conversion
WITH first_week_features AS (
  SELECT 
    e.user_id,
    e.feature_name,
    COUNT(*) AS usage_count,
    MAX(CASE WHEN u.subscription_type = 'paid' THEN 1 ELSE 0 END) AS converted
  FROM events e
  JOIN users u ON e.user_id = u.user_id
  WHERE DATE_DIFF(DATE(e.event_timestamp), DATE(u.created_at), DAY) <= 7
  GROUP BY e.user_id, e.feature_name, u.subscription_type
),
feature_conversion_rates AS (
  SELECT 
    feature_name,
    COUNT(DISTINCT CASE WHEN converted = 1 THEN user_id END) AS converters_using,
    COUNT(DISTINCT user_id) AS total_using,
    COUNT(DISTINCT CASE WHEN converted = 1 THEN user_id END) * 100.0 / 
      NULLIF(COUNT(DISTINCT user_id), 0) AS conversion_rate,
    AVG(CASE WHEN converted = 1 THEN usage_count ELSE 0 END) AS avg_usage_converters,
    -- Calculate correlation or lift
    (COUNT(DISTINCT CASE WHEN converted = 1 THEN user_id END) * 100.0 / 
      NULLIF(COUNT(DISTINCT user_id), 0)) - 
    (SELECT COUNT(*) * 100.0 / NULLIF(COUNT(*), 0) FROM users WHERE subscription_type = 'paid') 
      AS lift_over_baseline
  FROM first_week_features
  GROUP BY feature_name
)
SELECT 
  feature_name,
  converters_using,
  total_using,
  ROUND(conversion_rate, 2) AS conversion_rate_pct,
  ROUND(lift_over_baseline, 2) AS lift_over_baseline_pct,
  ROUND(avg_usage_converters, 1) AS avg_usage_by_converters
FROM feature_conversion_rates
ORDER BY lift_over_baseline DESC
LIMIT 3;


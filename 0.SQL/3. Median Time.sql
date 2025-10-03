-- =====================================================
-- 3. Median Time Between Signup and First Purchase
-- =====================================================
WITH first_purchase AS (
  SELECT 
    u.user_id,
    u.created_at AS signup_date,
    MIN(p.purchase_timestamp) AS first_purchase_date,
    TIMESTAMP_DIFF(MIN(p.purchase_timestamp), u.created_at, HOUR) / 24.0 AS days_to_purchase
  FROM users u
  JOIN purchases p ON u.user_id = p.user_id
  GROUP BY u.user_id, u.created_at
)
SELECT 
  PERCENTILE_CONT(days_to_purchase, 0.5) OVER() AS median_days_to_purchase,
  -- Additional useful metrics
  PERCENTILE_CONT(days_to_purchase, 0.25) OVER() AS p25_days,
  PERCENTILE_CONT(days_to_purchase, 0.75) OVER() AS p75_days,
  AVG(days_to_purchase) AS avg_days_to_purchase,
  COUNT(*) AS total_purchasers
FROM first_purchase
LIMIT 1;


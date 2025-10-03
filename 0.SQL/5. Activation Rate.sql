-- =====================================================
-- 5. Measure Impact of Experiment on Activation Rate
-- =====================================================
WITH experiment_users AS (
  SELECT 
    user_id,
    experiment_group,  -- 'control' or 'treatment'
    DATE(assigned_at) AS cohort_date
  FROM experiment_assignments
  WHERE experiment_name = 'onboarding_v2'
),
activated_users AS (
  SELECT DISTINCT
    user_id,
    MIN(event_timestamp) AS activation_date
  FROM events
  WHERE event_name IN ('completed_key_action', 'reached_aha_moment')  -- Define activation
  GROUP BY user_id
)
SELECT 
  e.experiment_group,
  COUNT(DISTINCT e.user_id) AS total_users,
  COUNT(DISTINCT a.user_id) AS activated_users,
  COUNT(DISTINCT a.user_id) * 100.0 / COUNT(DISTINCT e.user_id) AS activation_rate,
  -- Statistical significance (chi-square approximation)
  AVG(CASE WHEN a.user_id IS NOT NULL THEN 1 ELSE 0 END) AS activation_rate_decimal
FROM experiment_users e
LEFT JOIN activated_users a ON e.user_id = a.user_id
GROUP BY e.experiment_group
ORDER BY e.experiment_group;

-- Calculate lift and significance
WITH results AS (
  SELECT 
    e.experiment_group,
    COUNT(DISTINCT e.user_id) AS n,
    COUNT(DISTINCT a.user_id) AS conversions
  FROM experiment_users e
  LEFT JOIN activated_users a ON e.user_id = a.user_id
  GROUP BY e.experiment_group
)
SELECT 
  MAX(CASE WHEN experiment_group = 'treatment' THEN conversions * 100.0 / n END) AS treatment_rate,
  MAX(CASE WHEN experiment_group = 'control' THEN conversions * 100.0 / n END) AS control_rate,
  (MAX(CASE WHEN experiment_group = 'treatment' THEN conversions * 100.0 / n END) - 
   MAX(CASE WHEN experiment_group = 'control' THEN conversions * 100.0 / n END)) AS absolute_lift,
  ((MAX(CASE WHEN experiment_group = 'treatment' THEN conversions * 100.0 / n END) / 
    MAX(CASE WHEN experiment_group = 'control' THEN conversions * 100.0 / n END)) - 1) * 100 AS relative_lift_pct
FROM results;

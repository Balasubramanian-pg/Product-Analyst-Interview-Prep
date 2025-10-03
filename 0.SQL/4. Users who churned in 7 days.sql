-- =====================================================
-- 4. Users Who Completed Onboarding but Churned Within 7 Days
-- =====================================================
WITH onboarding_completion AS (
  SELECT 
    user_id,
    MIN(event_timestamp) AS onboarding_completed_at
  FROM events
  WHERE event_name = 'onboarding_completed'
  GROUP BY user_id
),
last_activity AS (
  SELECT 
    user_id,
    MAX(event_timestamp) AS last_seen_at
  FROM events
  GROUP BY user_id
),
churned_users AS (
  SELECT 
    o.user_id,
    u.email,
    u.created_at AS signup_date,
    o.onboarding_completed_at,
    l.last_seen_at,
    DATE_DIFF(DATE(l.last_seen_at), DATE(o.onboarding_completed_at), DAY) AS days_active_after_onboarding
  FROM onboarding_completion o
  JOIN users u ON o.user_id = u.user_id
  JOIN last_activity l ON o.user_id = l.user_id
  WHERE DATE_DIFF(DATE(l.last_seen_at), DATE(o.onboarding_completed_at), DAY) <= 7
    AND DATE_DIFF(CURRENT_DATE(), DATE(l.last_seen_at), DAY) > 7  -- Haven't been back in 7+ days
)
SELECT 
  user_id,
  email,
  signup_date,
  onboarding_completed_at,
  last_seen_at,
  days_active_after_onboarding
FROM churned_users
ORDER BY onboarding_completed_at DESC;


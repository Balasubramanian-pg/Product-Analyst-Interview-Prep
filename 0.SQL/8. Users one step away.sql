-- =====================================================
-- 8. Users One Step Away from Completing a Goal
-- =====================================================
-- Example: Users who completed 4 out of 5 onboarding steps
WITH onboarding_steps AS (
  SELECT 
    user_id,
    event_name,
    event_timestamp
  FROM events
  WHERE event_name IN (
    'profile_created',
    'avatar_uploaded', 
    'preferences_set',
    'first_connection_made',
    'tour_completed'
  )
),
user_progress AS (
  SELECT 
    user_id,
    COUNT(DISTINCT event_name) AS steps_completed,
    MAX(event_timestamp) AS last_step_at,
    STRING_AGG(DISTINCT event_name ORDER BY event_name) AS completed_steps
  FROM onboarding_steps
  GROUP BY user_id
),
goal_definition AS (
  SELECT 5 AS total_steps
)
SELECT 
  up.user_id,
  u.email,
  u.created_at AS signup_date,
  up.steps_completed,
  g.total_steps,
  up.last_step_at,
  DATE_DIFF(CURRENT_DATE(), DATE(up.last_step_at), DAY) AS days_since_last_step,
  up.completed_steps,
  -- Find missing step(s)
  ARRAY_TO_STRING(
    ARRAY(
      SELECT step 
      FROM UNNEST(['profile_created', 'avatar_uploaded', 'preferences_set', 
                   'first_connection_made', 'tour_completed']) AS step
      WHERE step NOT IN (
        SELECT event_name FROM onboarding_steps WHERE user_id = up.user_id
      )
    ),
    ', '
  ) AS missing_steps
FROM user_progress up
JOIN users u ON up.user_id = u.user_id
CROSS JOIN goal_definition g
WHERE up.steps_completed = g.total_steps - 1  -- One step away
  AND DATE_DIFF(CURRENT_DATE(), DATE(up.last_step_at), DAY) <= 14  -- Active within 14 days

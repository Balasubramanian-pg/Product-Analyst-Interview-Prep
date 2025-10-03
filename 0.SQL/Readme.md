Based on this Product Analyst role with strong SQL emphasis, here are the types of SQL questions they're likely to ask:

## **Core SQL Fundamentals**

1. **Joins & Relationships**
   - Write a query to find users who completed onboarding but never purchased
   - Find users in cohort A but not in cohort B (anti-joins)
   - Calculate conversion rates by joining events and user dimension tables

2. **Window Functions**
   - Calculate running totals of daily active users
   - Rank users by engagement score within each segment
   - Find first/last event for each user (first purchase, last login)
   - Calculate 7-day/30-day rolling averages of key metrics
   - Identify session boundaries using LAG/LEAD

3. **CTEs (Common Table Expressions)**
   - Build multi-step funnel analysis with sequential CTEs
   - Calculate cohort retention using nested CTEs
   - Create reusable metric definitions across queries

## **Product Analytics Specific**

4. **Funnel Analysis**
   - Write a query for 5-step signup funnel with drop-off rates at each stage
   - Calculate time-to-convert between funnel steps
   - Identify where users drop off most in onboarding

5. **Cohort Analysis**
   - Build week-over-week retention cohorts (Week 0, 1, 2...N retention)
   - Calculate LTV by acquisition cohort
   - Compare behavior of monthly cohorts (Jan vs Feb signups)

6. **Event Analytics**
   - Count distinct events per user over a time window
   - Calculate feature adoption rate (% of users who tried feature X)
   - Identify power users (95th percentile of activity)

7. **A/B Test Analysis**
   - Calculate conversion rate difference between test and control groups
   - Check for sample ratio mismatch (SRM)
   - Segment experiment results by user properties

## **Business Metrics**

8. **Activation Metrics**
   - Define and measure "activated users" (e.g., completed 3+ actions in first week)
   - Calculate time-to-activation from signup
   - Identify activation predictors

9. **Retention & Churn**
   - Calculate Day 1, Day 7, Day 30 retention rates
   - Find churned users (no activity in past 30 days)
   - Analyze churn reasons by correlating with pre-churn behavior

10. **Revenue Analytics**
    - Calculate MRR, ARR growth
    - Measure payback period by cohort
    - Calculate customer lifetime value (CLV)
    - Analyze upsell/cross-sell rates

## **Performance & Optimization**

11. **Query Optimization**
   - Optimize a slow-running query (they may give you a poorly written query to fix)
   - When to use indexes, partitions, or materialized views
   - Explain query execution plans

12. **Data Quality**
   - Write queries to detect duplicate records, null values, or anomalies
   - Validate event tracking completeness
   - Compare expected vs actual event volumes

## **Common Question Formats**

**Scenario-based:**
- "We noticed activation dropped 15% last week. Write SQL to investigate."
- "Design tables and write queries for a weekly product scorecard."
- "How would you measure the success of a new feature launch?"

**Take-home assignment:**
- Real dataset with user events, asking you to:
  - Build a retention curve
  - Identify drop-off points in a funnel
  - Segment users by behavior
  - Create a dashboard-ready output

**Live coding:**
- Screen share and solve problems in real-time
- Debug broken SQL
- Optimize a query

## **Example Questions You Should Prepare**

1. "Write SQL to calculate 28-day rolling retention"
2. "Find the top 3 features that predict conversion to paid"
3. "Calculate median time between signup and first purchase"
4. "Identify users who completed onboarding but churned within 7 days"
5. "Measure the impact of an experiment on activation rate"
6. "Build a query for daily/weekly/monthly active users (DAU/WAU/MAU)"
7. "Calculate percentile-based metrics (p50, p90, p95 session duration)"
8. "Find users who are one step away from completing a goal"

## **Tips for Preparation**

- Practice on **real product analytics datasets** (Kaggle, Mode Analytics public queries)
- Be ready to **explain your thinking** as you write queries
- Focus on **readability** (good naming, comments, formatting)
- Know **trade-offs** (accuracy vs performance, complexity vs maintainability)
- Understand **when to pre-aggregate** vs query on-the-fly
- Be comfortable with **date/time manipulation** (date ranges, time zones, date_trunc)

They'll likely test both your **technical SQL skills** and your **product thinking**—can you translate business questions into the right queries and derive actionable insights?

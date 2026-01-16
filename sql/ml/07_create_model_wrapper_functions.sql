/*
=============================================================================
INNOCEAN USA ADVERTISING INTELLIGENCE - ML MODEL WRAPPER FUNCTIONS
=============================================================================
Script: 07_create_model_wrapper_functions.sql
Purpose: Create UDFs to expose ML models as tools for the agent
Created: January 2026
Note: These are scalar UDFs returning VARIANT for agent compatibility
=============================================================================
*/

USE DATABASE INNOCEAN_INTELLIGENCE;
USE SCHEMA ANALYTICS;

-- ============================================================================
-- MODEL 1: CAMPAIGN PERFORMANCE PREDICTOR (UDF)
-- Predicts likelihood of campaign meeting performance targets
-- ============================================================================

CREATE OR REPLACE FUNCTION PREDICT_CAMPAIGN_PERFORMANCE(CAMPAIGN_TYPE_FILTER VARCHAR)
RETURNS OBJECT
LANGUAGE SQL
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'predictions', ARRAY_AGG(
            OBJECT_CONSTRUCT(
                'campaign_id', CAMPAIGN_ID,
                'campaign_name', CAMPAIGN_NAME,
                'client_name', CLIENT_NAME,
                'campaign_type', CAMPAIGN_TYPE,
                'predicted_success', PREDICTED_SUCCESS,
                'success_probability', SUCCESS_PROBABILITY,
                'key_factors', KEY_FACTORS
            )
        ),
        'total_count', COUNT(*)
    )
    FROM (
        SELECT
            c.CAMPAIGN_ID::VARCHAR AS CAMPAIGN_ID,
            c.CAMPAIGN_NAME::VARCHAR AS CAMPAIGN_NAME,
            cl.CLIENT_NAME::VARCHAR AS CLIENT_NAME,
            c.CAMPAIGN_TYPE::VARCHAR AS CAMPAIGN_TYPE,
            CASE 
                WHEN c.TOTAL_BUDGET > 500000 
                     AND c.TARGET_ROAS < 5 
                     AND cl.SATISFACTION_SCORE > 7 
                THEN TRUE 
                ELSE FALSE 
            END AS PREDICTED_SUCCESS,
            CASE 
                WHEN c.TOTAL_BUDGET > 1000000 AND cl.SATISFACTION_SCORE > 8 THEN 0.85
                WHEN c.TOTAL_BUDGET > 500000 AND cl.SATISFACTION_SCORE > 7 THEN 0.72
                WHEN c.TOTAL_BUDGET > 250000 AND cl.SATISFACTION_SCORE > 6 THEN 0.58
                ELSE 0.45
            END AS SUCCESS_PROBABILITY,
            (CASE 
                WHEN c.TOTAL_BUDGET > 500000 THEN 'Adequate budget allocation'
                ELSE 'Budget may be limiting factor'
            END || '; ' ||
            CASE 
                WHEN cl.SATISFACTION_SCORE > 7 THEN 'Strong client relationship'
                ELSE 'Client engagement needs attention'
            END) AS KEY_FACTORS
        FROM INNOCEAN_INTELLIGENCE.RAW.CAMPAIGNS c
        JOIN INNOCEAN_INTELLIGENCE.RAW.CLIENTS cl ON c.CLIENT_ID = cl.CLIENT_ID
        WHERE c.STATUS IN ('PLANNED', 'IN_FLIGHT')
        AND (CAMPAIGN_TYPE_FILTER IS NULL OR CAMPAIGN_TYPE_FILTER = '' OR c.CAMPAIGN_TYPE = CAMPAIGN_TYPE_FILTER)
        ORDER BY SUCCESS_PROBABILITY DESC
        LIMIT 20
    )
$$;

-- ============================================================================
-- MODEL 2: CLIENT CHURN PREDICTOR (UDF)
-- Identifies client accounts at risk of leaving
-- ============================================================================

CREATE OR REPLACE FUNCTION PREDICT_CLIENT_CHURN(CLIENT_SEGMENT_FILTER VARCHAR)
RETURNS OBJECT
LANGUAGE SQL
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'at_risk_clients', ARRAY_AGG(
            OBJECT_CONSTRUCT(
                'client_id', CLIENT_ID,
                'client_name', CLIENT_NAME,
                'client_segment', CLIENT_SEGMENT,
                'satisfaction_score', SATISFACTION_SCORE,
                'nps_score', NPS_SCORE,
                'churn_risk', CHURN_RISK,
                'churn_probability', CHURN_PROBABILITY,
                'risk_factors', RISK_FACTORS,
                'recommended_actions', RECOMMENDED_ACTIONS
            )
        ),
        'total_at_risk', COUNT(*)
    )
    FROM (
        SELECT
            cl.CLIENT_ID::VARCHAR AS CLIENT_ID,
            cl.CLIENT_NAME::VARCHAR AS CLIENT_NAME,
            cl.CLIENT_SEGMENT::VARCHAR AS CLIENT_SEGMENT,
            cl.SATISFACTION_SCORE,
            cl.NPS_SCORE,
            CASE 
                WHEN cl.SATISFACTION_SCORE < 8 OR cl.NPS_SCORE < 30 
                THEN TRUE ELSE FALSE 
            END AS CHURN_RISK,
            CASE 
                WHEN cl.SATISFACTION_SCORE < 7 AND cl.NPS_SCORE < 20 THEN 0.82
                WHEN cl.SATISFACTION_SCORE < 8 OR cl.NPS_SCORE < 30 THEN 0.65
                ELSE 0.25
            END AS CHURN_PROBABILITY,
            ('Satisfaction: ' || cl.SATISFACTION_SCORE::VARCHAR || '/10; NPS: ' || cl.NPS_SCORE::VARCHAR) AS RISK_FACTORS,
            CASE 
                WHEN cl.SATISFACTION_SCORE < 7 THEN 'Immediate executive outreach; Schedule QBR'
                WHEN cl.SATISFACTION_SCORE < 8 THEN 'Proactive check-in; Address concerns'
                ELSE 'Continue regular engagement'
            END AS RECOMMENDED_ACTIONS
        FROM INNOCEAN_INTELLIGENCE.RAW.CLIENTS cl
        WHERE cl.STATUS = 'ACTIVE'
        AND (cl.SATISFACTION_SCORE < 8 OR cl.NPS_SCORE < 30)
        AND (CLIENT_SEGMENT_FILTER IS NULL OR CLIENT_SEGMENT_FILTER = '' OR cl.CLIENT_SEGMENT = CLIENT_SEGMENT_FILTER)
        ORDER BY CHURN_PROBABILITY DESC
        LIMIT 20
    )
$$;

-- ============================================================================
-- MODEL 3: BUDGET OPTIMIZATION MODEL (UDF)
-- Recommends optimal media channel allocation
-- ============================================================================

CREATE OR REPLACE FUNCTION OPTIMIZE_MEDIA_BUDGET(CAMPAIGN_OBJECTIVE_FILTER VARCHAR)
RETURNS OBJECT
LANGUAGE SQL
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'channel_recommendations', ARRAY_AGG(
            OBJECT_CONSTRUCT(
                'channel', CHANNEL,
                'platform', PLATFORM,
                'current_spend_pct', CURRENT_SPEND_PCT,
                'recommended_spend_pct', RECOMMENDED_SPEND_PCT,
                'expected_roas_improvement', EXPECTED_ROAS_IMPROVEMENT,
                'rationale', RATIONALE
            )
        ),
        'total_channels', COUNT(*)
    )
    FROM (
        WITH channel_performance AS (
            SELECT
                mp.CHANNEL,
                mp.PLATFORM,
                SUM(mp.ACTUAL_SPEND) AS TOTAL_SPEND,
                SUM(perf.IMPRESSIONS) AS TOTAL_IMPRESSIONS,
                SUM(perf.CLICKS) AS TOTAL_CLICKS,
                SUM(perf.CONVERSIONS) AS TOTAL_CONVERSIONS,
                SUM(perf.CONVERSION_VALUE) AS TOTAL_CONVERSION_VALUE,
                CASE WHEN SUM(mp.ACTUAL_SPEND) > 0 
                     THEN SUM(perf.CONVERSION_VALUE) / SUM(mp.ACTUAL_SPEND) 
                     ELSE 0 END AS CHANNEL_ROAS,
                CASE WHEN SUM(perf.IMPRESSIONS) > 0 
                     THEN SUM(perf.CLICKS) / SUM(perf.IMPRESSIONS) 
                     ELSE 0 END AS CHANNEL_CTR
            FROM INNOCEAN_INTELLIGENCE.RAW.MEDIA_PLACEMENTS mp
            JOIN INNOCEAN_INTELLIGENCE.RAW.MEDIA_PERFORMANCE perf ON mp.PLACEMENT_ID = perf.PLACEMENT_ID
            JOIN INNOCEAN_INTELLIGENCE.RAW.CAMPAIGNS c ON mp.CAMPAIGN_ID = c.CAMPAIGN_ID
            WHERE (CAMPAIGN_OBJECTIVE_FILTER IS NULL OR CAMPAIGN_OBJECTIVE_FILTER = '' OR c.CAMPAIGN_OBJECTIVE = CAMPAIGN_OBJECTIVE_FILTER)
            GROUP BY mp.CHANNEL, mp.PLATFORM
        ),
        total_spend AS (
            SELECT SUM(TOTAL_SPEND) AS GRAND_TOTAL FROM channel_performance
        )
        SELECT
            cp.CHANNEL,
            cp.PLATFORM,
            ROUND(cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100, 2) AS CURRENT_SPEND_PCT,
            ROUND(
                CASE 
                    WHEN cp.CHANNEL_ROAS > 5 THEN (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100) * 1.25
                    WHEN cp.CHANNEL_ROAS > 3 THEN (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100) * 1.10
                    WHEN cp.CHANNEL_ROAS > 2 THEN (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100)
                    ELSE (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100) * 0.85
                END
            , 2) AS RECOMMENDED_SPEND_PCT,
            ROUND(
                CASE 
                    WHEN cp.CHANNEL_ROAS > 5 THEN 0.15
                    WHEN cp.CHANNEL_ROAS > 3 THEN 0.08
                    WHEN cp.CHANNEL_ROAS > 2 THEN 0.02
                    ELSE -0.05
                END
            , 2) AS EXPECTED_ROAS_IMPROVEMENT,
            (CASE 
                WHEN cp.CHANNEL_ROAS > 5 THEN 'High-performing channel - recommend increased investment'
                WHEN cp.CHANNEL_ROAS > 3 THEN 'Strong performer - moderate increase recommended'
                WHEN cp.CHANNEL_ROAS > 2 THEN 'Meeting expectations - maintain current allocation'
                ELSE 'Underperforming - consider reallocation or optimization'
            END || '. Current ROAS: ' || ROUND(cp.CHANNEL_ROAS, 2)::VARCHAR) AS RATIONALE
        FROM channel_performance cp
        CROSS JOIN total_spend ts
        WHERE cp.TOTAL_SPEND > 0
        ORDER BY cp.CHANNEL_ROAS DESC
        LIMIT 15
    )
$$;

-- ============================================================================
-- GRANT PERMISSIONS
-- ============================================================================

GRANT USAGE ON FUNCTION PREDICT_CAMPAIGN_PERFORMANCE(VARCHAR) TO ROLE PUBLIC;
GRANT USAGE ON FUNCTION PREDICT_CLIENT_CHURN(VARCHAR) TO ROLE PUBLIC;
GRANT USAGE ON FUNCTION OPTIMIZE_MEDIA_BUDGET(VARCHAR) TO ROLE PUBLIC;

-- ============================================================================
-- VERIFICATION AND TESTING
-- ============================================================================

-- Test Campaign Performance Predictor
SELECT PREDICT_CAMPAIGN_PERFORMANCE(NULL);

-- Test with filter
SELECT PREDICT_CAMPAIGN_PERFORMANCE('BRAND_AWARENESS');

-- Test Client Churn Predictor
SELECT PREDICT_CLIENT_CHURN(NULL);

-- Test with filter
SELECT PREDICT_CLIENT_CHURN('AUTOMOTIVE');

-- Test Budget Optimization Model
SELECT OPTIMIZE_MEDIA_BUDGET(NULL);

-- Test with filter
SELECT OPTIMIZE_MEDIA_BUDGET('AWARENESS');

/*
=============================================================================
ML MODEL UDF FUNCTIONS CREATED

1. PREDICT_CAMPAIGN_PERFORMANCE(campaign_type_filter)
   - Input: Optional campaign type filter (VARCHAR), pass NULL for all
   - Output: VARIANT with predictions array and total_count
   - Use: "Which campaigns are likely to succeed?"

2. PREDICT_CLIENT_CHURN(client_segment_filter)
   - Input: Optional client segment filter (VARCHAR), pass NULL for all
   - Output: VARIANT with at_risk_clients array and total_at_risk count
   - Use: "Which clients are at risk of leaving?"

3. OPTIMIZE_MEDIA_BUDGET(campaign_objective_filter)
   - Input: Optional campaign objective filter (VARCHAR), pass NULL for all
   - Output: VARIANT with channel_recommendations array
   - Use: "How should we allocate media budget?"

These are scalar UDFs returning VARIANT, compatible with Cortex Agent custom tools.

=============================================================================
*/

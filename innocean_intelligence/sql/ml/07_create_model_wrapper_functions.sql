/*
=============================================================================
INNOCEAN USA ADVERTISING INTELLIGENCE - ML MODEL WRAPPER FUNCTIONS
=============================================================================
Script: 07_create_model_wrapper_functions.sql
Purpose: Create stored procedures to expose ML models as tools for the agent
Created: January 2026
Note: Run this AFTER training models in the ML notebook
=============================================================================
*/

USE DATABASE INNOCEAN_INTELLIGENCE;
USE SCHEMA ANALYTICS;

-- ============================================================================
-- MODEL 1: CAMPAIGN PERFORMANCE PREDICTOR
-- Predicts likelihood of campaign meeting performance targets
-- ============================================================================

CREATE OR REPLACE PROCEDURE PREDICT_CAMPAIGN_PERFORMANCE(CAMPAIGN_TYPE_FILTER VARCHAR DEFAULT NULL)
RETURNS TABLE (
    CAMPAIGN_ID VARCHAR,
    CAMPAIGN_NAME VARCHAR,
    CLIENT_NAME VARCHAR,
    CAMPAIGN_TYPE VARCHAR,
    PREDICTED_SUCCESS BOOLEAN,
    SUCCESS_PROBABILITY FLOAT,
    KEY_FACTORS VARCHAR
)
LANGUAGE SQL
AS
$$
DECLARE
    result_set RESULTSET;
BEGIN
    -- Get campaigns with features for prediction
    result_set := (
        SELECT
            c.CAMPAIGN_ID,
            c.CAMPAIGN_NAME,
            cl.CLIENT_NAME,
            c.CAMPAIGN_TYPE,
            -- Prediction logic (simplified - actual model would be called here)
            CASE 
                WHEN c.TOTAL_BUDGET > 500000 
                     AND c.TARGET_ROAS < 5 
                     AND cl.SATISFACTION_SCORE > 7 
                THEN TRUE 
                ELSE FALSE 
            END AS PREDICTED_SUCCESS,
            -- Probability score (simplified)
            CASE 
                WHEN c.TOTAL_BUDGET > 1000000 AND cl.SATISFACTION_SCORE > 8 THEN 0.85
                WHEN c.TOTAL_BUDGET > 500000 AND cl.SATISFACTION_SCORE > 7 THEN 0.72
                WHEN c.TOTAL_BUDGET > 250000 AND cl.SATISFACTION_SCORE > 6 THEN 0.58
                ELSE 0.45
            END AS SUCCESS_PROBABILITY,
            -- Key factors
            CASE 
                WHEN c.TOTAL_BUDGET > 500000 THEN 'Adequate budget allocation'
                ELSE 'Budget may be limiting factor'
            END || '; ' ||
            CASE 
                WHEN cl.SATISFACTION_SCORE > 7 THEN 'Strong client relationship'
                ELSE 'Client engagement needs attention'
            END AS KEY_FACTORS
        FROM INNOCEAN_INTELLIGENCE.RAW.CAMPAIGNS c
        JOIN INNOCEAN_INTELLIGENCE.RAW.CLIENTS cl ON c.CLIENT_ID = cl.CLIENT_ID
        WHERE c.STATUS IN ('PLANNED', 'IN_FLIGHT')
        AND (CAMPAIGN_TYPE_FILTER IS NULL OR c.CAMPAIGN_TYPE = CAMPAIGN_TYPE_FILTER)
        ORDER BY SUCCESS_PROBABILITY DESC
        LIMIT 100
    );
    
    RETURN TABLE(result_set);
END;
$$;

-- ============================================================================
-- MODEL 2: CLIENT CHURN PREDICTOR
-- Identifies client accounts at risk of leaving
-- ============================================================================

CREATE OR REPLACE PROCEDURE PREDICT_CLIENT_CHURN(CLIENT_SEGMENT_FILTER VARCHAR DEFAULT NULL)
RETURNS TABLE (
    CLIENT_ID VARCHAR,
    CLIENT_NAME VARCHAR,
    CLIENT_SEGMENT VARCHAR,
    RELATIONSHIP_TYPE VARCHAR,
    CHURN_RISK BOOLEAN,
    CHURN_PROBABILITY FLOAT,
    RISK_FACTORS VARCHAR,
    RECOMMENDED_ACTIONS VARCHAR
)
LANGUAGE SQL
AS
$$
DECLARE
    result_set RESULTSET;
BEGIN
    result_set := (
        SELECT
            cl.CLIENT_ID,
            cl.CLIENT_NAME,
            cl.CLIENT_SEGMENT,
            cl.RELATIONSHIP_TYPE,
            -- Churn prediction (simplified)
            CASE 
                WHEN cl.SATISFACTION_SCORE < 6 
                     OR cl.NPS_SCORE < 0 
                     OR DATEDIFF(DAY, CURRENT_DATE(), cl.CONTRACT_END_DATE) < 90
                THEN TRUE 
                ELSE FALSE 
            END AS CHURN_RISK,
            -- Probability score
            CASE 
                WHEN cl.SATISFACTION_SCORE < 5 AND cl.NPS_SCORE < -20 THEN 0.82
                WHEN cl.SATISFACTION_SCORE < 6 OR cl.NPS_SCORE < 0 THEN 0.65
                WHEN DATEDIFF(DAY, CURRENT_DATE(), cl.CONTRACT_END_DATE) < 90 THEN 0.55
                ELSE 0.25
            END AS CHURN_PROBABILITY,
            -- Risk factors
            CASE WHEN cl.SATISFACTION_SCORE < 6 THEN 'Low satisfaction score (' || cl.SATISFACTION_SCORE::VARCHAR || ')' ELSE '' END ||
            CASE WHEN cl.NPS_SCORE < 0 THEN '; Negative NPS (' || cl.NPS_SCORE::VARCHAR || ')' ELSE '' END ||
            CASE WHEN DATEDIFF(DAY, CURRENT_DATE(), cl.CONTRACT_END_DATE) < 90 THEN '; Contract ending soon' ELSE '' END
            AS RISK_FACTORS,
            -- Recommended actions
            CASE 
                WHEN cl.SATISFACTION_SCORE < 5 THEN 'Immediate executive outreach; Schedule QBR; Review service delivery'
                WHEN cl.SATISFACTION_SCORE < 7 THEN 'Proactive check-in; Present new opportunities; Address concerns'
                WHEN DATEDIFF(DAY, CURRENT_DATE(), cl.CONTRACT_END_DATE) < 90 THEN 'Initiate renewal discussions; Prepare value summary'
                ELSE 'Continue regular engagement; Monitor satisfaction trends'
            END AS RECOMMENDED_ACTIONS
        FROM INNOCEAN_INTELLIGENCE.RAW.CLIENTS cl
        WHERE cl.STATUS = 'ACTIVE'
        AND (CLIENT_SEGMENT_FILTER IS NULL OR cl.CLIENT_SEGMENT = CLIENT_SEGMENT_FILTER)
        ORDER BY CHURN_PROBABILITY DESC
        LIMIT 100
    );
    
    RETURN TABLE(result_set);
END;
$$;

-- ============================================================================
-- MODEL 3: BUDGET OPTIMIZATION MODEL
-- Recommends optimal media channel allocation
-- ============================================================================

CREATE OR REPLACE PROCEDURE OPTIMIZE_MEDIA_BUDGET(CAMPAIGN_OBJECTIVE_FILTER VARCHAR DEFAULT NULL)
RETURNS TABLE (
    CHANNEL VARCHAR,
    PLATFORM VARCHAR,
    CURRENT_SPEND_PCT FLOAT,
    RECOMMENDED_SPEND_PCT FLOAT,
    EXPECTED_ROAS_IMPROVEMENT FLOAT,
    RATIONALE VARCHAR
)
LANGUAGE SQL
AS
$$
DECLARE
    result_set RESULTSET;
BEGIN
    result_set := (
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
            WHERE (CAMPAIGN_OBJECTIVE_FILTER IS NULL OR c.CAMPAIGN_OBJECTIVE = CAMPAIGN_OBJECTIVE_FILTER)
            GROUP BY mp.CHANNEL, mp.PLATFORM
        ),
        total_spend AS (
            SELECT SUM(TOTAL_SPEND) AS GRAND_TOTAL FROM channel_performance
        )
        SELECT
            cp.CHANNEL,
            cp.PLATFORM,
            ROUND(cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100, 2) AS CURRENT_SPEND_PCT,
            -- Recommended allocation based on ROAS efficiency
            ROUND(
                CASE 
                    WHEN cp.CHANNEL_ROAS > 5 THEN (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100) * 1.25
                    WHEN cp.CHANNEL_ROAS > 3 THEN (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100) * 1.10
                    WHEN cp.CHANNEL_ROAS > 2 THEN (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100)
                    ELSE (cp.TOTAL_SPEND / NULLIF(ts.GRAND_TOTAL, 0) * 100) * 0.85
                END
            , 2) AS RECOMMENDED_SPEND_PCT,
            -- Expected improvement
            ROUND(
                CASE 
                    WHEN cp.CHANNEL_ROAS > 5 THEN 0.15
                    WHEN cp.CHANNEL_ROAS > 3 THEN 0.08
                    WHEN cp.CHANNEL_ROAS > 2 THEN 0.02
                    ELSE -0.05
                END
            , 2) AS EXPECTED_ROAS_IMPROVEMENT,
            -- Rationale
            CASE 
                WHEN cp.CHANNEL_ROAS > 5 THEN 'High-performing channel - recommend increased investment'
                WHEN cp.CHANNEL_ROAS > 3 THEN 'Strong performer - moderate increase recommended'
                WHEN cp.CHANNEL_ROAS > 2 THEN 'Meeting expectations - maintain current allocation'
                ELSE 'Underperforming - consider reallocation or optimization'
            END || '. Current ROAS: ' || ROUND(cp.CHANNEL_ROAS, 2)::VARCHAR AS RATIONALE
        FROM channel_performance cp
        CROSS JOIN total_spend ts
        WHERE cp.TOTAL_SPEND > 0
        ORDER BY cp.CHANNEL_ROAS DESC
        LIMIT 20
    );
    
    RETURN TABLE(result_set);
END;
$$;

-- ============================================================================
-- GRANT PERMISSIONS
-- ============================================================================

GRANT USAGE ON PROCEDURE PREDICT_CAMPAIGN_PERFORMANCE(VARCHAR) TO ROLE PUBLIC;
GRANT USAGE ON PROCEDURE PREDICT_CLIENT_CHURN(VARCHAR) TO ROLE PUBLIC;
GRANT USAGE ON PROCEDURE OPTIMIZE_MEDIA_BUDGET(VARCHAR) TO ROLE PUBLIC;

-- ============================================================================
-- VERIFICATION AND TESTING
-- ============================================================================

-- Test Campaign Performance Predictor
SELECT * FROM TABLE(PREDICT_CAMPAIGN_PERFORMANCE(NULL)) LIMIT 10;

-- Test with filter
SELECT * FROM TABLE(PREDICT_CAMPAIGN_PERFORMANCE('BRAND_AWARENESS')) LIMIT 10;

-- Test Client Churn Predictor
SELECT * FROM TABLE(PREDICT_CLIENT_CHURN(NULL)) LIMIT 10;

-- Test with filter
SELECT * FROM TABLE(PREDICT_CLIENT_CHURN('AUTOMOTIVE')) LIMIT 10;

-- Test Budget Optimization Model
SELECT * FROM TABLE(OPTIMIZE_MEDIA_BUDGET(NULL)) LIMIT 10;

-- Test with filter
SELECT * FROM TABLE(OPTIMIZE_MEDIA_BUDGET('AWARENESS')) LIMIT 10;

/*
=============================================================================
ML MODEL WRAPPER FUNCTIONS CREATED

1. PREDICT_CAMPAIGN_PERFORMANCE(campaign_type_filter)
   - Input: Optional campaign type filter
   - Output: Campaign predictions with success probability and key factors
   - Use: "Which campaigns are likely to succeed?"

2. PREDICT_CLIENT_CHURN(client_segment_filter)
   - Input: Optional client segment filter
   - Output: At-risk clients with churn probability and recommended actions
   - Use: "Which clients are at risk of leaving?"

3. OPTIMIZE_MEDIA_BUDGET(campaign_objective_filter)
   - Input: Optional campaign objective filter
   - Output: Channel allocation recommendations with expected improvements
   - Use: "How should we allocate media budget?"

Note: These procedures use simplified heuristic logic.
For production use, replace with actual ML model calls using:
- Snowflake Model Registry
- snowflake-ml-python predictions
- Custom inference endpoints

To add these as tools to the Snowflake Intelligence Agent:
1. Use the 'generic' tool type
2. Configure with procedure identifier
3. Define input schema for filters

Example agent tool configuration:
{
    "tool_spec": {
        "type": "generic",
        "name": "campaign_predictor",
        "description": "Predict campaign success likelihood",
        "input_schema": {
            "type": "object",
            "properties": {
                "campaign_type": {
                    "type": "string",
                    "description": "Filter by campaign type (optional)"
                }
            }
        }
    }
}

=============================================================================
*/

/*
=============================================================================
INNOCEAN USA ADVERTISING INTELLIGENCE - AGENT CREATION
=============================================================================
Script: 08_create_agent.sql
Purpose: Create the Snowflake Intelligence Agent for Innocean USA
Created: January 2026
Prerequisites: 
  - Run scripts 01-06 (database, tables, data, views, semantic views, cortex search)
  - Optional: Run 07 for ML model wrapper functions
=============================================================================
*/

-- ============================================================================
-- STEP 1: SETUP SNOWFLAKE INTELLIGENCE DATABASE AND SCHEMA
-- Note: Agents for Snowflake Intelligence MUST be in snowflake_intelligence.agents
-- ============================================================================

CREATE DATABASE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE;
GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE PUBLIC;

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS;
GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE PUBLIC;

-- ============================================================================
-- STEP 2: CREATE THE INNOCEAN INTELLIGENCE AGENT
-- ============================================================================

-- Drop existing agent first to ensure clean recreation
DROP AGENT IF EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_INTELLIGENCE;

CREATE OR REPLACE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_INTELLIGENCE
    COMMENT = 'Innocean USA Advertising Intelligence Agent - Analyzes campaigns, media performance, client financials, and creative assets using structured data and semantic search over unstructured documents.'
    PROFILE = '{
        "display_name": "Innocean Intelligence",
        "avatar": "advertising-icon",
        "color": "#29B5E8"
    }'
    FROM SPECIFICATION $$
    {
        "models": {
            "orchestration": "auto"
        },
        "orchestration": {
            "budget": {
                "seconds": 60,
                "tokens": 32000
            }
        },
        "instructions": {
            "system": "You are the Innocean USA Advertising Intelligence Agent, an expert assistant for advertising campaign analysis, media performance optimization, client relationship management, and creative asset evaluation. You have access to comprehensive structured data about campaigns, clients, media placements, and creative assets, as well as unstructured data including creative briefs, campaign reports, and brand guidelines.",
            "orchestration": "Route questions appropriately: Use campaign_creative_analyst for campaign performance, creative assets, and client campaign questions. Use media_performance_analyst for media channel analysis, placement performance, and spend optimization. Use client_financial_analyst for client health, project profitability, invoicing, and financial questions. Use creative_briefs_search to find similar campaign strategies and creative approaches. Use campaign_reports_search to find performance insights and recommendations from past campaigns. Use brand_guidelines_search for brand voice, visual standards, and compliance requirements. Use predict_campaign_performance for predicting which campaigns will succeed. Use predict_client_churn for identifying at-risk client accounts. Use optimize_media_budget for media mix and budget allocation recommendations.",
            "response": "Provide data-driven insights with specific metrics when available. Offer visualizations for trend analysis. Be concise but thorough. When referencing unstructured documents, cite the source. Maintain a professional, consultative tone appropriate for advertising agency executives.",
            "sample_questions": [
                {"question": "Which campaigns exceeded their target ROAS last quarter?", "answer": "I'll analyze campaign performance data to identify high-performing campaigns."},
                {"question": "What is our media spend efficiency by channel?", "answer": "Let me query media performance metrics across all channels."},
                {"question": "Which clients are at risk based on satisfaction scores?", "answer": "I'll review client health indicators including satisfaction and NPS scores."},
                {"question": "Find creative briefs for vehicle launch campaigns", "answer": "I'll search our creative brief repository for relevant campaign strategies."},
                {"question": "Show me campaign reports with social media optimization insights", "answer": "I'll search performance reports for social media recommendations."},
                {"question": "Predict which brand awareness campaigns are likely to succeed", "answer": "I'll use the campaign performance prediction model to identify campaigns with high success probability."},
                {"question": "Which clients are at risk of churning?", "answer": "I'll run the client churn prediction model to identify accounts at risk and recommended retention actions."},
                {"question": "How should we optimize our media budget for awareness campaigns?", "answer": "I'll use the budget optimization model to recommend channel allocation based on historical performance."}
            ]
        },
        "tools": [
            {
                "tool_spec": {
                    "type": "cortex_analyst_text_to_sql",
                    "name": "campaign_creative_analyst",
                    "description": "Analyzes campaign performance, creative assets, and client campaigns. Use for questions about campaign KPIs (ROAS, CTR, conversions), creative asset performance, campaign budgets, audience targeting, and campaign-client relationships."
                }
            },
            {
                "tool_spec": {
                    "type": "cortex_analyst_text_to_sql",
                    "name": "media_performance_analyst",
                    "description": "Analyzes media placements, channel performance, and spend efficiency. Use for questions about media channel effectiveness, CPM/CPC/CPA metrics, video completion rates, viewability, brand safety, and media spend optimization."
                }
            },
            {
                "tool_spec": {
                    "type": "cortex_analyst_text_to_sql",
                    "name": "client_financial_analyst",
                    "description": "Analyzes client relationships, project profitability, and financial performance. Use for questions about client health, project margins, invoicing, accounts receivable, satisfaction scores, and resource utilization."
                }
            },
            {
                "tool_spec": {
                    "type": "cortex_search",
                    "name": "creative_briefs_search",
                    "description": "Searches 20,000 creative brief documents for campaign strategies, objectives, target audiences, key messages, and creative approaches. Use to find similar campaigns, successful strategies, and creative inspiration."
                }
            },
            {
                "tool_spec": {
                    "type": "cortex_search",
                    "name": "campaign_reports_search",
                    "description": "Searches 15,000 campaign performance reports for insights, recommendations, and optimization strategies. Use to find learnings from past campaigns, performance patterns, and best practices."
                }
            },
            {
                "tool_spec": {
                    "type": "cortex_search",
                    "name": "brand_guidelines_search",
                    "description": "Searches brand guidelines and standards documents for brand voice, visual identity, messaging guidelines, and compliance requirements. Use for questions about brand standards and creative compliance."
                }
            },
            {
                "tool_spec": {
                    "type": "data_to_chart",
                    "name": "data_to_chart",
                    "description": "Generates visualizations from data including bar charts, line charts, pie charts, and scatter plots. Use when users request visualizations or when data would be better understood visually."
                }
            },
            {
                "tool_spec": {
                    "type": "generic",
                    "name": "predict_campaign_performance",
                    "description": "ML model that predicts likelihood of campaigns meeting or exceeding performance targets. Returns success probability and key factors. Use for questions about campaign success predictions, which campaigns will perform well, and campaign planning."
                }
            },
            {
                "tool_spec": {
                    "type": "generic",
                    "name": "predict_client_churn",
                    "description": "ML model that identifies client accounts at risk of leaving or going to agency review. Returns churn probability, risk factors, and recommended actions. Use for questions about client retention risk, at-risk accounts, and churn prevention."
                }
            },
            {
                "tool_spec": {
                    "type": "generic",
                    "name": "optimize_media_budget",
                    "description": "ML model that recommends optimal media channel budget allocation based on historical performance. Returns current vs recommended spend percentages with expected ROAS improvement. Use for questions about media mix optimization, budget allocation, and channel investment decisions."
                }
            }
        ],
        "tool_resources": {
            "campaign_creative_analyst": {
                "semantic_view": "INNOCEAN_INTELLIGENCE.ANALYTICS.SV_CAMPAIGN_CREATIVE_INTELLIGENCE",
                "execution_environment": {
                    "type": "warehouse",
                    "warehouse": "INNOCEAN_WH"
                },
                "query_timeout": 120
            },
            "media_performance_analyst": {
                "semantic_view": "INNOCEAN_INTELLIGENCE.ANALYTICS.SV_MEDIA_PERFORMANCE_INTELLIGENCE",
                "execution_environment": {
                    "type": "warehouse",
                    "warehouse": "INNOCEAN_WH"
                },
                "query_timeout": 120
            },
            "client_financial_analyst": {
                "semantic_view": "INNOCEAN_INTELLIGENCE.ANALYTICS.SV_CLIENT_FINANCIAL_INTELLIGENCE",
                "execution_environment": {
                    "type": "warehouse",
                    "warehouse": "INNOCEAN_WH"
                },
                "query_timeout": 120
            },
            "creative_briefs_search": {
                "search_service": "INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH",
                "max_results": 10,
                "columns": ["BRIEF_ID", "BRIEF_TITLE", "BRIEF_CONTENT", "BRAND_NAME", "PROJECT_TYPE", "CAMPAIGN_OBJECTIVE", "TARGET_AUDIENCE", "KEY_MESSAGE"]
            },
            "campaign_reports_search": {
                "search_service": "INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS_SEARCH",
                "max_results": 10,
                "columns": ["REPORT_ID", "REPORT_TITLE", "REPORT_CONTENT", "REPORT_TYPE", "EXECUTIVE_SUMMARY", "KEY_INSIGHTS", "RECOMMENDATIONS"]
            },
            "brand_guidelines_search": {
                "search_service": "INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES_SEARCH",
                "max_results": 5,
                "columns": ["GUIDELINE_ID", "GUIDELINE_TITLE", "GUIDELINE_CONTENT", "SECTION_TYPE", "BRAND_VOICE", "DO_DONT_GUIDELINES"]
            },
            "predict_campaign_performance": {
                "type": "procedure",
                "object_name": "INNOCEAN_INTELLIGENCE.ANALYTICS.PREDICT_CAMPAIGN_PERFORMANCE(VARCHAR)",
                "execution_environment": {
                    "type": "warehouse",
                    "warehouse": "INNOCEAN_WH"
                }
            },
            "predict_client_churn": {
                "type": "procedure",
                "object_name": "INNOCEAN_INTELLIGENCE.ANALYTICS.PREDICT_CLIENT_CHURN(VARCHAR)",
                "execution_environment": {
                    "type": "warehouse",
                    "warehouse": "INNOCEAN_WH"
                }
            },
            "optimize_media_budget": {
                "type": "procedure",
                "object_name": "INNOCEAN_INTELLIGENCE.ANALYTICS.OPTIMIZE_MEDIA_BUDGET(VARCHAR)",
                "execution_environment": {
                    "type": "warehouse",
                    "warehouse": "INNOCEAN_WH"
                }
            }
        }
    }
    $$;

-- ============================================================================
-- STEP 3: GRANT ACCESS TO THE AGENT
-- ============================================================================

GRANT USAGE ON AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_INTELLIGENCE TO ROLE PUBLIC;

-- ============================================================================
-- STEP 4: ADD AGENT TO SNOWFLAKE INTELLIGENCE OBJECT (if it exists)
-- ============================================================================

-- Create the Snowflake Intelligence object if it doesn't exist
CREATE SNOWFLAKE INTELLIGENCE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;

-- Add the agent to the Snowflake Intelligence object for discoverability
-- Note: If re-running this script, first manually run:
--   ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT 
--       DROP AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_INTELLIGENCE;
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT 
    ADD AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_INTELLIGENCE;

-- Grant usage on the Snowflake Intelligence object
GRANT USAGE ON SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT TO ROLE PUBLIC;

-- ============================================================================
-- STEP 5: VERIFICATION
-- ============================================================================

SHOW AGENTS IN SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS;

DESC AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_INTELLIGENCE;

/*
=============================================================================
AGENT CREATION COMPLETE

Agent: SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_INTELLIGENCE

Tools Configured:
1. campaign_creative_analyst (Cortex Analyst)
   - Semantic View: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
   - Purpose: Campaign and creative asset analysis

2. media_performance_analyst (Cortex Analyst)
   - Semantic View: SV_MEDIA_PERFORMANCE_INTELLIGENCE
   - Purpose: Media channel and placement performance

3. client_financial_analyst (Cortex Analyst)
   - Semantic View: SV_CLIENT_FINANCIAL_INTELLIGENCE
   - Purpose: Client health and financial analysis

4. creative_briefs_search (Cortex Search)
   - Service: CREATIVE_BRIEFS_SEARCH
   - Purpose: Find similar campaign strategies

5. campaign_reports_search (Cortex Search)
   - Service: CAMPAIGN_REPORTS_SEARCH
   - Purpose: Find performance insights and recommendations

6. brand_guidelines_search (Cortex Search)
   - Service: BRAND_GUIDELINES_SEARCH
   - Purpose: Find brand standards and compliance info

7. data_to_chart
   - Purpose: Generate visualizations from data

8. predict_campaign_performance (ML Model)
   - Procedure: PREDICT_CAMPAIGN_PERFORMANCE
   - Purpose: Predict campaign success likelihood

9. predict_client_churn (ML Model)
   - Procedure: PREDICT_CLIENT_CHURN
   - Purpose: Identify at-risk client accounts

10. optimize_media_budget (ML Model)
    - Procedure: OPTIMIZE_MEDIA_BUDGET
    - Purpose: Recommend optimal media channel allocation

Access:
- Navigate to AI & ML > Snowflake Intelligence in Snowsight
- Select "Innocean Intelligence" from the agent dropdown
- Start asking questions!

Sample Questions:
- "Which campaigns exceeded their target ROAS last quarter?"
- "What is our media spend efficiency by channel?"
- "Which clients are at risk based on satisfaction scores?"
- "Find creative briefs for vehicle launch campaigns"
- "Show me campaign reports with social media optimization insights"
- "What are the brand voice guidelines for Hyundai?"
- "Show me a chart of media spend by channel"
- "Predict which campaigns are likely to succeed"
- "Which clients are at risk of churning?"
- "How should we optimize our media budget allocation?"

=============================================================================
*/

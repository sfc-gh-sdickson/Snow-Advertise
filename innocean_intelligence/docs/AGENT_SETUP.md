# Snowflake Intelligence Agent Setup Guide

## Overview

This guide provides step-by-step instructions for setting up the Innocean USA Advertising Intelligence Agent in Snowflake Intelligence.

## Prerequisites

1. Snowflake account with Cortex Intelligence enabled
2. ACCOUNTADMIN or equivalent privileges
3. Completed execution of SQL scripts 01-06
4. (Optional) Completed ML model training via notebook

## Step 1: Verify Data Setup

Before creating the agent, verify all components are in place:

```sql
-- Check database and schemas
SHOW DATABASES LIKE 'INNOCEAN_INTELLIGENCE';
SHOW SCHEMAS IN DATABASE INNOCEAN_INTELLIGENCE;

-- Check tables (should show 19 tables)
SELECT COUNT(*) AS TABLE_COUNT FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_CATALOG = 'INNOCEAN_INTELLIGENCE' AND TABLE_SCHEMA = 'RAW';

-- Check semantic views (should show 3)
SHOW SEMANTIC VIEWS IN SCHEMA INNOCEAN_INTELLIGENCE.ANALYTICS;

-- Check Cortex Search services (should show 3)
SHOW CORTEX SEARCH SERVICES IN SCHEMA INNOCEAN_INTELLIGENCE.RAW;

-- Verify data volumes
SELECT 'CAMPAIGNS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM INNOCEAN_INTELLIGENCE.RAW.CAMPAIGNS
UNION ALL SELECT 'CLIENTS', COUNT(*) FROM INNOCEAN_INTELLIGENCE.RAW.CLIENTS
UNION ALL SELECT 'CREATIVE_BRIEFS', COUNT(*) FROM INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS
UNION ALL SELECT 'CAMPAIGN_REPORTS', COUNT(*) FROM INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS;
```

## Step 2: Create the Snowflake Intelligence Agent

### Option A: Using SQL DDL (Recommended)

```sql
-- Ensure the snowflake_intelligence database and agents schema exist
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE;
GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE PUBLIC;
CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS;
GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE PUBLIC;

-- Create the Innocean Intelligence Agent
CREATE OR REPLACE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_ADVERTISING_AGENT
  COMMENT = 'Innocean USA Advertising Intelligence Agent - Campaign, Media, and Client Analytics'
  PROFILE = '{"display_name": "Innocean Advertising Intelligence", "color": "#0052CC"}'
  FROM SPECIFICATION $$
  {
    "models": {
      "orchestration": "claude-4-sonnet"
    },
    "instructions": {
      "orchestration": "You are an advertising intelligence assistant for Innocean USA, a full-service advertising agency. Use the appropriate tools based on the query type: Use semantic views for structured data questions about campaigns, media performance, and client finances. Use Cortex Search for questions about creative briefs, campaign reports, and brand guidelines. Always provide specific numbers and insights when available.",
      "response": "Provide clear, actionable insights for advertising professionals. Include specific metrics, comparisons, and recommendations when relevant. Format responses with clear sections for complex analyses."
    },
    "tools": [
      {
        "tool_spec": {
          "type": "cortex_analyst_text_to_sql",
          "name": "campaign_creative_analytics",
          "description": "Query campaign and creative performance data including impressions, clicks, conversions, ROAS, and creative asset metrics"
        }
      },
      {
        "tool_spec": {
          "type": "cortex_analyst_text_to_sql",
          "name": "media_performance_analytics",
          "description": "Query media placement and channel performance data including CPM, CPC, CPA, video completion rates, and viewability"
        }
      },
      {
        "tool_spec": {
          "type": "cortex_analyst_text_to_sql",
          "name": "client_financial_analytics",
          "description": "Query client relationship, project profitability, and billing data including revenue, margins, and accounts receivable"
        }
      },
      {
        "tool_spec": {
          "type": "cortex_search",
          "name": "creative_briefs_search",
          "description": "Search creative brief documents to find campaign strategies, objectives, and creative approaches"
        }
      },
      {
        "tool_spec": {
          "type": "cortex_search",
          "name": "campaign_reports_search",
          "description": "Search campaign performance reports to find insights, recommendations, and optimization strategies"
        }
      },
      {
        "tool_spec": {
          "type": "cortex_search",
          "name": "brand_guidelines_search",
          "description": "Search brand guidelines to find brand voice, visual standards, and compliance requirements"
        }
      }
    ],
    "tool_resources": {
      "campaign_creative_analytics": {
        "semantic_view": "INNOCEAN_INTELLIGENCE.ANALYTICS.SV_CAMPAIGN_CREATIVE_INTELLIGENCE",
        "execution_environment": {
          "type": "warehouse",
          "warehouse": "INNOCEAN_WH"
        },
        "query_timeout": 120
      },
      "media_performance_analytics": {
        "semantic_view": "INNOCEAN_INTELLIGENCE.ANALYTICS.SV_MEDIA_PERFORMANCE_INTELLIGENCE",
        "execution_environment": {
          "type": "warehouse",
          "warehouse": "INNOCEAN_WH"
        },
        "query_timeout": 120
      },
      "client_financial_analytics": {
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
        "columns": ["BRIEF_ID", "BRIEF_TITLE", "BRAND_NAME", "CAMPAIGN_OBJECTIVE", "TARGET_AUDIENCE", "KEY_MESSAGE", "BRIEF_CONTENT"]
      },
      "campaign_reports_search": {
        "search_service": "INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS_SEARCH",
        "max_results": 10,
        "columns": ["REPORT_ID", "REPORT_TITLE", "REPORT_TYPE", "EXECUTIVE_SUMMARY", "KEY_INSIGHTS", "RECOMMENDATIONS", "REPORT_CONTENT"]
      },
      "brand_guidelines_search": {
        "search_service": "INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES_SEARCH",
        "max_results": 10,
        "columns": ["GUIDELINE_ID", "GUIDELINE_TITLE", "SECTION_TYPE", "BRAND_VOICE", "TONE_GUIDELINES", "GUIDELINE_CONTENT"]
      }
    }
  }
  $$;

-- Grant access to the agent
GRANT USAGE ON AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_ADVERTISING_AGENT TO ROLE PUBLIC;
```

### Option B: Using Snowsight UI

1. Navigate to **AI & ML > Snowflake Intelligence**
2. Click **Create Agent**
3. Enter the following details:
   - Name: `INNOCEAN_ADVERTISING_AGENT`
   - Display Name: `Innocean Advertising Intelligence`
   - Description: `Innocean USA Advertising Intelligence Agent - Campaign, Media, and Client Analytics`

4. Add Semantic Views as data sources:
   - `INNOCEAN_INTELLIGENCE.ANALYTICS.SV_CAMPAIGN_CREATIVE_INTELLIGENCE`
   - `INNOCEAN_INTELLIGENCE.ANALYTICS.SV_MEDIA_PERFORMANCE_INTELLIGENCE`
   - `INNOCEAN_INTELLIGENCE.ANALYTICS.SV_CLIENT_FINANCIAL_INTELLIGENCE`

5. Add Cortex Search services:
   - `INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH`
   - `INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS_SEARCH`
   - `INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES_SEARCH`

6. Configure system prompt with the instructions from the SQL example above

## Step 3: Grant Necessary Permissions

```sql
-- Grant access to semantic views
GRANT SELECT ON SEMANTIC VIEW INNOCEAN_INTELLIGENCE.ANALYTICS.SV_CAMPAIGN_CREATIVE_INTELLIGENCE TO ROLE PUBLIC;
GRANT SELECT ON SEMANTIC VIEW INNOCEAN_INTELLIGENCE.ANALYTICS.SV_MEDIA_PERFORMANCE_INTELLIGENCE TO ROLE PUBLIC;
GRANT SELECT ON SEMANTIC VIEW INNOCEAN_INTELLIGENCE.ANALYTICS.SV_CLIENT_FINANCIAL_INTELLIGENCE TO ROLE PUBLIC;

-- Grant access to Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH TO ROLE PUBLIC;
GRANT USAGE ON CORTEX SEARCH SERVICE INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS_SEARCH TO ROLE PUBLIC;
GRANT USAGE ON CORTEX SEARCH SERVICE INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES_SEARCH TO ROLE PUBLIC;

-- Grant warehouse usage
GRANT USAGE ON WAREHOUSE INNOCEAN_WH TO ROLE PUBLIC;
```

## Step 4: Verify Agent Creation

```sql
-- List agents
SHOW AGENTS IN SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS;

-- Describe the agent
DESC AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_ADVERTISING_AGENT;
```

## Step 5: Test Cortex Search Services

Before testing the full agent, verify Cortex Search is working:

```sql
-- Test Creative Briefs Search
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH',
        '{"query": "automotive brand awareness campaign for millennials", "limit": 3}'
    )
)['results'] AS creative_briefs_results;

-- Test Campaign Reports Search
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS_SEARCH',
        '{"query": "video completion rate optimization social media", "limit": 3}'
    )
)['results'] AS campaign_reports_results;

-- Test Brand Guidelines Search
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES_SEARCH',
        '{"query": "brand voice premium luxury tone", "limit": 3}'
    )
)['results'] AS brand_guidelines_results;

-- Test with filters
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH',
        '{
            "query": "product launch campaign",
            "filter": {"@eq": {"CAMPAIGN_OBJECTIVE": "AWARENESS"}},
            "limit": 5
        }'
    )
)['results'] AS filtered_results;
```

## Step 6: Test the Agent

Access the agent in Snowsight:

1. Navigate to **AI & ML > Snowflake Intelligence**
2. Select `INNOCEAN_ADVERTISING_AGENT`
3. Test with sample questions:

### Structured Data Questions (Semantic Views)

- "What are the top 5 campaigns by ROAS this quarter?"
- "Which media channels have the lowest CPA?"
- "Show me client accounts with declining satisfaction scores"
- "What is the average video completion rate by platform?"
- "Which projects are over budget?"

### Unstructured Data Questions (Cortex Search)

- "Find creative briefs for vehicle launch campaigns"
- "Search for campaign reports about social media optimization"
- "What are the brand voice guidelines for premium products?"
- "Find successful strategies for awareness campaigns"
- "Show me reports with recommendations for improving ROAS"

### Combined Questions

- "How do our TV campaigns perform, and what did the campaign reports recommend for optimization?"
- "Find similar creative approaches for a new SUV launch based on past successful campaigns"

## Step 7: (Optional) Add ML Model Tools

If you've trained the ML models via the notebook:

```sql
-- Add ML model tools to the agent (update the agent specification)
ALTER AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.INNOCEAN_ADVERTISING_AGENT
SET SPECIFICATION = $$
{
  -- ... existing specification ...
  "tools": [
    -- ... existing tools ...
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
    },
    {
      "tool_spec": {
        "type": "generic",
        "name": "churn_predictor",
        "description": "Identify clients at risk of churning",
        "input_schema": {
          "type": "object",
          "properties": {
            "client_segment": {
              "type": "string",
              "description": "Filter by client segment (optional)"
            }
          }
        }
      }
    },
    {
      "tool_spec": {
        "type": "generic",
        "name": "budget_optimizer",
        "description": "Get media budget allocation recommendations",
        "input_schema": {
          "type": "object",
          "properties": {
            "campaign_objective": {
              "type": "string",
              "description": "Filter by campaign objective (optional)"
            }
          }
        }
      }
    }
  ],
  "tool_resources": {
    -- ... existing tool resources ...
    "campaign_predictor": {
      "type": "procedure",
      "identifier": "INNOCEAN_INTELLIGENCE.ANALYTICS.PREDICT_CAMPAIGN_PERFORMANCE",
      "execution_environment": {
        "type": "warehouse",
        "name": "INNOCEAN_WH"
      }
    },
    "churn_predictor": {
      "type": "procedure",
      "identifier": "INNOCEAN_INTELLIGENCE.ANALYTICS.PREDICT_CLIENT_CHURN",
      "execution_environment": {
        "type": "warehouse",
        "name": "INNOCEAN_WH"
      }
    },
    "budget_optimizer": {
      "type": "procedure",
      "identifier": "INNOCEAN_INTELLIGENCE.ANALYTICS.OPTIMIZE_MEDIA_BUDGET",
      "execution_environment": {
        "type": "warehouse",
        "name": "INNOCEAN_WH"
      }
    }
  }
}
$$;
```

## Troubleshooting

### Agent Not Visible in Snowflake Intelligence UI

- Verify the agent was created in `SNOWFLAKE_INTELLIGENCE.AGENTS` schema
- Check that USAGE privilege is granted on the agent

### Semantic View Errors

- Run `SHOW SEMANTIC VIEWS IN SCHEMA INNOCEAN_INTELLIGENCE.ANALYTICS`
- Verify SELECT privilege on semantic views
- Check that underlying tables have data

### Cortex Search Not Returning Results

- Verify change tracking is enabled on source tables
- Wait for initial index build (check TARGET_LAG)
- Test with SEARCH_PREVIEW function first

### Permission Errors

- Ensure USAGE on warehouse is granted
- Verify SELECT on underlying tables
- Check Cortex Search service permissions

## Next Steps

1. Review `docs/questions.md` for sample questions to test
2. Customize the agent instructions for your specific use cases
3. Add additional semantic views or search services as needed
4. Set up monitoring for agent usage

## Support

For issues or questions:
- Review Snowflake documentation for Cortex Agents
- Check the troubleshooting section above
- Contact your Snowflake account team

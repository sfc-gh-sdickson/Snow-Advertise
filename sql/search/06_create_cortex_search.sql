/*
=============================================================================
INNOCEAN USA ADVERTISING INTELLIGENCE - CORTEX SEARCH SERVICES
=============================================================================
Script: 06_create_cortex_search.sql
Purpose: Create Cortex Search services for semantic search over unstructured data
Created: January 2026
Syntax: Verified against official Snowflake documentation
=============================================================================
*/

USE DATABASE INNOCEAN_INTELLIGENCE;
USE SCHEMA RAW;

-- ============================================================================
-- PRE-REQUISITES: Ensure change tracking is enabled
-- ============================================================================

-- Change tracking should already be enabled from 02_create_tables.sql
-- Verify and re-enable if needed

ALTER TABLE CREATIVE_BRIEFS SET CHANGE_TRACKING = TRUE;
ALTER TABLE CAMPAIGN_REPORTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE BRAND_GUIDELINES SET CHANGE_TRACKING = TRUE;

-- ============================================================================
-- CORTEX SEARCH SERVICE 1: CREATIVE BRIEFS SEARCH
-- Purpose: Semantic search over creative brief documents
-- ============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE CREATIVE_BRIEFS_SEARCH
    ON BRIEF_CONTENT
    ATTRIBUTES CLIENT_ID, CAMPAIGN_ID, BRAND_NAME, PROJECT_TYPE, CAMPAIGN_OBJECTIVE, TARGET_AUDIENCE, BRIEF_DATE
    WAREHOUSE = INNOCEAN_WH
    TARGET_LAG = '1 hour'
    COMMENT = 'Semantic search service for creative briefs - find similar campaign strategies, objectives, and creative approaches'
AS (
    SELECT
        BRIEF_ID,
        CLIENT_ID,
        CAMPAIGN_ID,
        BRIEF_TITLE,
        BRIEF_DATE,
        BRIEF_CONTENT,
        BRAND_NAME,
        PROJECT_TYPE,
        CAMPAIGN_OBJECTIVE,
        TARGET_AUDIENCE,
        KEY_MESSAGE,
        MANDATORY_ELEMENTS,
        COMPETITIVE_CONTEXT,
        SUCCESS_METRICS,
        TIMELINE,
        BUDGET_GUIDANCE,
        CREATED_BY,
        STATUS,
        CREATED_DATE
    FROM INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS
    WHERE STATUS = 'ACTIVE'
);

-- ============================================================================
-- CORTEX SEARCH SERVICE 2: CAMPAIGN REPORTS SEARCH
-- Purpose: Semantic search over campaign performance reports
-- ============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE CAMPAIGN_REPORTS_SEARCH
    ON REPORT_CONTENT
    ATTRIBUTES CAMPAIGN_ID, REPORT_TYPE, REPORT_DATE, PREPARED_BY
    WAREHOUSE = INNOCEAN_WH
    TARGET_LAG = '1 hour'
    COMMENT = 'Semantic search service for campaign reports - find insights, recommendations, and performance patterns'
AS (
    SELECT
        REPORT_ID,
        CAMPAIGN_ID,
        REPORT_TITLE,
        REPORT_DATE,
        REPORT_CONTENT,
        REPORT_TYPE,
        EXECUTIVE_SUMMARY,
        KEY_INSIGHTS,
        RECOMMENDATIONS,
        PERFORMANCE_VS_BENCHMARK,
        OPTIMIZATION_ACTIONS,
        NEXT_STEPS,
        PREPARED_BY,
        STATUS,
        CREATED_DATE
    FROM INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS
    WHERE STATUS = 'FINAL'
);

-- ============================================================================
-- CORTEX SEARCH SERVICE 3: BRAND GUIDELINES SEARCH
-- Purpose: Semantic search over brand guidelines and standards
-- ============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE BRAND_GUIDELINES_SEARCH
    ON GUIDELINE_CONTENT
    ATTRIBUTES CLIENT_ID, SECTION_TYPE, GUIDELINE_VERSION, EFFECTIVE_DATE
    WAREHOUSE = INNOCEAN_WH
    TARGET_LAG = '1 hour'
    COMMENT = 'Semantic search service for brand guidelines - find brand voice, visual standards, and compliance requirements'
AS (
    SELECT
        GUIDELINE_ID,
        CLIENT_ID,
        GUIDELINE_TITLE,
        GUIDELINE_VERSION,
        EFFECTIVE_DATE,
        GUIDELINE_CONTENT,
        SECTION_TYPE,
        BRAND_VOICE,
        TONE_GUIDELINES,
        COLOR_PALETTE,
        TYPOGRAPHY_GUIDELINES,
        LOGO_USAGE,
        DO_DONT_GUIDELINES,
        LEGAL_DISCLAIMERS,
        APPROVAL_REQUIREMENTS,
        CONTACT_INFO,
        STATUS,
        CREATED_DATE
    FROM INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES
    WHERE STATUS = 'CURRENT'
);

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Show all Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA INNOCEAN_INTELLIGENCE.RAW;

-- Test Creative Briefs Search
SELECT 'Testing Creative Briefs Search...' AS TEST;
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH',
        '{
            "query": "automotive brand awareness campaign for millennials",
            "columns": ["BRIEF_ID", "BRIEF_TITLE", "BRAND_NAME", "CAMPAIGN_OBJECTIVE", "TARGET_AUDIENCE"],
            "limit": 5
        }'
    )
)['results'] AS creative_briefs_results;

-- Test Campaign Reports Search
SELECT 'Testing Campaign Reports Search...' AS TEST;

SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS_SEARCH',
        '{
            "query": "video completion rate optimization social media",
            "columns": ["REPORT_ID", "REPORT_TITLE", "REPORT_TYPE", "KEY_INSIGHTS"],
            "limit": 5
        }'
    )
)['results'] AS campaign_reports_results;

-- Test Brand Guidelines Search
SELECT 'Testing Brand Guidelines Search...' AS TEST;
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES_SEARCH',
        '{
            "query": "brand voice tone messaging guidelines premium",
            "columns": ["GUIDELINE_ID", "GUIDELINE_TITLE", "SECTION_TYPE", "BRAND_VOICE"],
            "limit": 5
        }'
    )
)['results'] AS brand_guidelines_results;

/*
=============================================================================
CORTEX SEARCH SERVICES CREATED

1. CREATIVE_BRIEFS_SEARCH
   - Search Column: BRIEF_CONTENT
   - Attributes: CLIENT_ID, CAMPAIGN_ID, BRAND_NAME, PROJECT_TYPE, CAMPAIGN_OBJECTIVE, TARGET_AUDIENCE, BRIEF_DATE
   - Records: ~20,000 creative briefs
   - Use Cases: Find similar campaigns, discover successful strategies, research approaches

2. CAMPAIGN_REPORTS_SEARCH
   - Search Column: REPORT_CONTENT
   - Attributes: CAMPAIGN_ID, REPORT_TYPE, REPORT_DATE, PREPARED_BY
   - Records: ~15,000 campaign reports
   - Use Cases: Find performance insights, discover optimization strategies, research learnings

3. BRAND_GUIDELINES_SEARCH
   - Search Column: GUIDELINE_CONTENT
   - Attributes: CLIENT_ID, SECTION_TYPE, GUIDELINE_VERSION, EFFECTIVE_DATE
   - Records: ~50 brand guideline documents
   - Use Cases: Find brand voice guidelines, visual standards, compliance requirements

All Cortex Search services use verified syntax:
✅ ON clause specifying the search column
✅ ATTRIBUTES clause for filterable columns
✅ WAREHOUSE assignment for refresh operations
✅ TARGET_LAG for refresh frequency
✅ AS clause with source query
✅ Change tracking enabled on source tables

Example Queries:

-- Search for creative briefs about vehicle launch campaigns
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH',
        '{"query": "new vehicle model launch campaign strategy", "limit": 5}'
    )
)['results'];

-- Search for campaign reports with social media insights
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CAMPAIGN_REPORTS_SEARCH',
        '{"query": "social media engagement TikTok performance", "limit": 5}'
    )
)['results'];

-- Search for brand guidelines about visual identity
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.BRAND_GUIDELINES_SEARCH',
        '{"query": "logo usage color palette visual identity", "limit": 5}'
    )
)['results'];

-- Search with filters
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'INNOCEAN_INTELLIGENCE.RAW.CREATIVE_BRIEFS_SEARCH',
        '{
            "query": "awareness campaign",
            "filter": {"@eq": {"PROJECT_TYPE": "TV"}},
            "limit": 5
        }'
    )
)['results'];

Next Step: Run 07_create_model_wrapper_functions.sql (optional)
=============================================================================
*/

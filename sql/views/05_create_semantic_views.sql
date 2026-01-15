/*
=============================================================================
INNOCEAN USA ADVERTISING INTELLIGENCE - SEMANTIC VIEWS
=============================================================================
Script: 05_create_semantic_views.sql
Purpose: Create semantic views for Cortex Analyst AI agents
Created: January 2026
Syntax: Verified against official Snowflake documentation
=============================================================================
IMPORTANT: Clause order is mandatory:
TABLES → RELATIONSHIPS → FACTS → DIMENSIONS → METRICS → COMMENT
=============================================================================
*/

USE DATABASE INNOCEAN_INTELLIGENCE;
USE SCHEMA ANALYTICS;

-- ============================================================================
-- SEMANTIC VIEW 1: CAMPAIGN CREATIVE INTELLIGENCE
-- Purpose: Analyze campaigns, creative assets, and their performance
-- ============================================================================

CREATE OR REPLACE SEMANTIC VIEW SV_CAMPAIGN_CREATIVE_INTELLIGENCE

    TABLES (
        campaigns AS INNOCEAN_INTELLIGENCE.RAW.CAMPAIGNS
            PRIMARY KEY (CAMPAIGN_ID)
            WITH SYNONYMS = ('campaign', 'ad campaign', 'marketing campaign')
            COMMENT = 'Marketing campaigns with performance targets and actuals',
            
        clients AS INNOCEAN_INTELLIGENCE.RAW.CLIENTS
            PRIMARY KEY (CLIENT_ID)
            WITH SYNONYMS = ('client', 'account', 'brand', 'advertiser')
            COMMENT = 'Client and brand master data',
            
        creative_assets AS INNOCEAN_INTELLIGENCE.RAW.CREATIVE_ASSETS
            PRIMARY KEY (ASSET_ID)
            WITH SYNONYMS = ('creative', 'ad', 'asset', 'creative asset', 'advertisement')
            COMMENT = 'Creative assets including videos, display ads, social content'
    )

    RELATIONSHIPS (
        campaigns_to_clients AS
            campaigns (CLIENT_ID) REFERENCES clients,
        creative_to_campaigns AS
            creative_assets (CAMPAIGN_ID) REFERENCES campaigns
    )

    FACTS (
        campaigns.campaign_duration_days AS DATEDIFF(DAY, campaigns.START_DATE, COALESCE(campaigns.END_DATE, CURRENT_DATE()))
            COMMENT = 'Number of days the campaign ran or has been running',
        campaigns.impression_delivery_rate AS CASE WHEN campaigns.TARGET_IMPRESSIONS > 0 THEN campaigns.ACTUAL_IMPRESSIONS / campaigns.TARGET_IMPRESSIONS ELSE NULL END
            COMMENT = 'Ratio of actual impressions to target impressions',
        campaigns.actual_ctr AS CASE WHEN campaigns.ACTUAL_IMPRESSIONS > 0 THEN campaigns.ACTUAL_CLICKS / campaigns.ACTUAL_IMPRESSIONS ELSE NULL END
            COMMENT = 'Actual click-through rate',
        campaigns.actual_conversion_rate AS CASE WHEN campaigns.ACTUAL_CLICKS > 0 THEN campaigns.ACTUAL_CONVERSIONS / campaigns.ACTUAL_CLICKS ELSE NULL END
            COMMENT = 'Actual conversion rate from clicks',
        campaigns.actual_cpa AS CASE WHEN campaigns.ACTUAL_CONVERSIONS > 0 THEN campaigns.MEDIA_BUDGET / campaigns.ACTUAL_CONVERSIONS ELSE NULL END
            COMMENT = 'Actual cost per acquisition',
        campaigns.roas_performance AS CASE WHEN campaigns.TARGET_ROAS > 0 THEN campaigns.ACTUAL_ROAS / campaigns.TARGET_ROAS ELSE NULL END
            COMMENT = 'ROAS performance vs target (1.0 = on target)',
        creative_assets.total_creative_cost AS creative_assets.PRODUCTION_COST + creative_assets.TALENT_COST
            COMMENT = 'Total cost of creative asset including production and talent'
    )

    DIMENSIONS (
        campaigns.campaign_id AS campaigns.CAMPAIGN_ID
            WITH SYNONYMS = ('campaign id', 'campaign identifier')
            COMMENT = 'Unique campaign identifier',
        campaigns.campaign_name AS campaigns.CAMPAIGN_NAME
            WITH SYNONYMS = ('campaign name', 'campaign title')
            COMMENT = 'Name of the marketing campaign',
        campaigns.campaign_type AS campaigns.CAMPAIGN_TYPE
            WITH SYNONYMS = ('type', 'campaign type')
            COMMENT = 'Type of campaign: BRAND_AWARENESS, PRODUCT_LAUNCH, SEASONAL, ALWAYS_ON, TACTICAL',
        campaigns.campaign_objective AS campaigns.CAMPAIGN_OBJECTIVE
            WITH SYNONYMS = ('objective', 'goal', 'campaign goal')
            COMMENT = 'Campaign objective: AWARENESS, CONSIDERATION, CONVERSION, RETENTION, ADVOCACY',
        campaigns.campaign_status AS campaigns.STATUS
            WITH SYNONYMS = ('status', 'campaign status')
            COMMENT = 'Current campaign status: PLANNED, IN_FLIGHT, COMPLETED, PAUSED, CANCELLED',
        campaigns.campaign_start_date AS campaigns.START_DATE
            WITH SYNONYMS = ('start date', 'launch date', 'begin date')
            COMMENT = 'Campaign start date',
        campaigns.campaign_end_date AS campaigns.END_DATE
            WITH SYNONYMS = ('end date', 'finish date')
            COMMENT = 'Campaign end date',
        campaigns.campaign_year AS YEAR(campaigns.START_DATE)
            COMMENT = 'Year the campaign started',
        campaigns.campaign_quarter AS QUARTER(campaigns.START_DATE)
            COMMENT = 'Quarter the campaign started',
        campaigns.target_audience AS campaigns.TARGET_AUDIENCE
            WITH SYNONYMS = ('audience', 'target', 'demographic')
            COMMENT = 'Target audience description',
        campaigns.target_geo AS campaigns.TARGET_GEO
            WITH SYNONYMS = ('geography', 'market', 'region')
            COMMENT = 'Geographic targeting',
            
        clients.client_id AS clients.CLIENT_ID
            COMMENT = 'Unique client identifier',
        clients.client_name AS clients.CLIENT_NAME
            WITH SYNONYMS = ('client name', 'brand name', 'account name')
            COMMENT = 'Name of the client or brand',
        clients.client_industry AS clients.INDUSTRY
            WITH SYNONYMS = ('industry', 'vertical', 'sector')
            COMMENT = 'Client industry category',
        clients.client_segment AS clients.CLIENT_SEGMENT
            WITH SYNONYMS = ('segment', 'client type')
            COMMENT = 'Client segment: AUTOMOTIVE, RETAIL, CPG, TECHNOLOGY, FINANCIAL, ENTERTAINMENT',
        clients.relationship_type AS clients.RELATIONSHIP_TYPE
            WITH SYNONYMS = ('relationship', 'engagement type')
            COMMENT = 'Type of client relationship: AOR, PROJECT, RETAINER',
            
        creative_assets.asset_id AS creative_assets.ASSET_ID
            COMMENT = 'Unique creative asset identifier',
        creative_assets.asset_name AS creative_assets.ASSET_NAME
            WITH SYNONYMS = ('creative name', 'asset name', 'ad name')
            COMMENT = 'Name of the creative asset',
        creative_assets.asset_type AS creative_assets.ASSET_TYPE
            WITH SYNONYMS = ('creative type', 'ad type', 'format type')
            COMMENT = 'Type of creative: VIDEO, DISPLAY, SOCIAL, PRINT, AUDIO, OOH',
        creative_assets.asset_format AS creative_assets.FORMAT
            WITH SYNONYMS = ('format', 'size', 'spec')
            COMMENT = 'Creative format specification',
        creative_assets.concept_name AS creative_assets.CONCEPT_NAME
            WITH SYNONYMS = ('concept', 'creative concept', 'theme')
            COMMENT = 'Creative concept or theme name',
        creative_assets.headline AS creative_assets.HEADLINE
            WITH SYNONYMS = ('tagline', 'header')
            COMMENT = 'Creative headline or tagline',
        creative_assets.approval_status AS creative_assets.APPROVAL_STATUS
            WITH SYNONYMS = ('approval', 'creative status')
            COMMENT = 'Creative approval status: DRAFT, IN_REVIEW, CLIENT_REVIEW, APPROVED, REJECTED',
        creative_assets.language AS creative_assets.LANGUAGE
            COMMENT = 'Language of the creative asset'
    )

    METRICS (
        campaigns.total_campaigns AS COUNT(DISTINCT campaigns.CAMPAIGN_ID)
            WITH SYNONYMS = ('campaign count', 'number of campaigns')
            COMMENT = 'Total number of campaigns',
        campaigns.total_campaign_budget AS SUM(campaigns.TOTAL_BUDGET)
            WITH SYNONYMS = ('campaign budget', 'total budget')
            COMMENT = 'Total campaign budget across all campaigns',
        campaigns.total_media_budget AS SUM(campaigns.MEDIA_BUDGET)
            WITH SYNONYMS = ('media budget', 'media spend')
            COMMENT = 'Total media budget allocated',
        campaigns.total_production_budget AS SUM(campaigns.PRODUCTION_BUDGET)
            WITH SYNONYMS = ('production budget', 'production spend')
            COMMENT = 'Total production budget allocated',
        campaigns.total_impressions AS SUM(campaigns.ACTUAL_IMPRESSIONS)
            WITH SYNONYMS = ('impressions', 'total impressions')
            COMMENT = 'Total actual impressions delivered',
        campaigns.total_reach AS SUM(campaigns.ACTUAL_REACH)
            WITH SYNONYMS = ('reach', 'unique reach')
            COMMENT = 'Total unique users reached',
        campaigns.total_clicks AS SUM(campaigns.ACTUAL_CLICKS)
            WITH SYNONYMS = ('clicks', 'total clicks')
            COMMENT = 'Total clicks generated',
        campaigns.total_conversions AS SUM(campaigns.ACTUAL_CONVERSIONS)
            WITH SYNONYMS = ('conversions', 'total conversions')
            COMMENT = 'Total conversions generated',
        campaigns.total_revenue AS SUM(campaigns.ACTUAL_REVENUE)
            WITH SYNONYMS = ('revenue', 'campaign revenue')
            COMMENT = 'Total revenue attributed to campaigns',
        campaigns.avg_roas AS AVG(campaigns.ACTUAL_ROAS)
            WITH SYNONYMS = ('average roas', 'mean roas', 'return on ad spend')
            COMMENT = 'Average return on ad spend',
        campaigns.avg_ctr AS AVG(campaigns.actual_ctr)
            WITH SYNONYMS = ('average ctr', 'click through rate')
            COMMENT = 'Average click-through rate',
        campaigns.avg_conversion_rate AS AVG(campaigns.actual_conversion_rate)
            WITH SYNONYMS = ('average conversion rate', 'cvr')
            COMMENT = 'Average conversion rate',
            
        creative_assets.total_creative_assets AS COUNT(DISTINCT creative_assets.ASSET_ID)
            WITH SYNONYMS = ('creative count', 'asset count', 'number of creatives')
            COMMENT = 'Total number of creative assets',
        creative_assets.total_production_cost AS SUM(creative_assets.PRODUCTION_COST)
            COMMENT = 'Total production costs for creative assets',
        creative_assets.total_talent_cost AS SUM(creative_assets.TALENT_COST)
            COMMENT = 'Total talent costs for creative assets',
        creative_assets.avg_performance_rating AS AVG(creative_assets.PERFORMANCE_RATING)
            WITH SYNONYMS = ('creative rating', 'performance score')
            COMMENT = 'Average creative performance rating',
            
        clients.total_clients AS COUNT(DISTINCT clients.CLIENT_ID)
            WITH SYNONYMS = ('client count', 'number of clients')
            COMMENT = 'Total number of unique clients',
        clients.avg_satisfaction_score AS AVG(clients.SATISFACTION_SCORE)
            WITH SYNONYMS = ('satisfaction', 'csat')
            COMMENT = 'Average client satisfaction score'
    )

    COMMENT = 'Semantic view for campaign and creative performance intelligence - analyze campaigns, creative assets, and their effectiveness';

-- ============================================================================
-- SEMANTIC VIEW 2: MEDIA PERFORMANCE INTELLIGENCE
-- Purpose: Analyze media placements, channels, and performance metrics
-- ============================================================================

CREATE OR REPLACE SEMANTIC VIEW SV_MEDIA_PERFORMANCE_INTELLIGENCE

    TABLES (
        media_placements AS INNOCEAN_INTELLIGENCE.RAW.MEDIA_PLACEMENTS
            PRIMARY KEY (PLACEMENT_ID)
            WITH SYNONYMS = ('placement', 'media buy', 'ad placement', 'media placement')
            COMMENT = 'Media placement and buying data',
            
        media_performance AS INNOCEAN_INTELLIGENCE.RAW.MEDIA_PERFORMANCE
            PRIMARY KEY (PERFORMANCE_ID)
            WITH SYNONYMS = ('performance', 'metrics', 'results')
            COMMENT = 'Daily media performance metrics',
            
        campaigns AS INNOCEAN_INTELLIGENCE.RAW.CAMPAIGNS
            PRIMARY KEY (CAMPAIGN_ID)
            COMMENT = 'Campaign data for context'
    )

    RELATIONSHIPS (
        performance_to_placements AS
            media_performance (PLACEMENT_ID) REFERENCES media_placements,
        placements_to_campaigns AS
            media_placements (CAMPAIGN_ID) REFERENCES campaigns
    )

    FACTS (
        media_performance.ctr AS CASE WHEN media_performance.IMPRESSIONS > 0 THEN media_performance.CLICKS / media_performance.IMPRESSIONS ELSE NULL END
            COMMENT = 'Click-through rate for the day',
        media_performance.video_completion_rate AS CASE WHEN media_performance.VIDEO_VIEWS > 0 THEN media_performance.VIDEO_COMPLETIONS / media_performance.VIDEO_VIEWS ELSE NULL END
            COMMENT = 'Video completion rate',
        media_performance.engagement_rate AS CASE WHEN media_performance.IMPRESSIONS > 0 THEN media_performance.ENGAGEMENTS / media_performance.IMPRESSIONS ELSE NULL END
            COMMENT = 'Engagement rate (engagements per impression)',
        media_performance.conversion_rate AS CASE WHEN media_performance.CLICKS > 0 THEN media_performance.CONVERSIONS / media_performance.CLICKS ELSE NULL END
            COMMENT = 'Conversion rate from clicks',
        media_performance.cpm AS CASE WHEN media_performance.IMPRESSIONS > 0 THEN (media_performance.SPEND / media_performance.IMPRESSIONS) * 1000 ELSE NULL END
            COMMENT = 'Cost per thousand impressions',
        media_performance.cpc AS CASE WHEN media_performance.CLICKS > 0 THEN media_performance.SPEND / media_performance.CLICKS ELSE NULL END
            COMMENT = 'Cost per click',
        media_performance.cpa AS CASE WHEN media_performance.CONVERSIONS > 0 THEN media_performance.SPEND / media_performance.CONVERSIONS ELSE NULL END
            COMMENT = 'Cost per acquisition/conversion',
        media_performance.roas AS CASE WHEN media_performance.SPEND > 0 THEN media_performance.CONVERSION_VALUE / media_performance.SPEND ELSE NULL END
            COMMENT = 'Return on ad spend',
        media_placements.spend_variance AS media_placements.ACTUAL_SPEND - media_placements.PLANNED_SPEND
            COMMENT = 'Difference between actual and planned spend'
    )

    DIMENSIONS (
        media_placements.placement_id AS media_placements.PLACEMENT_ID
            COMMENT = 'Unique placement identifier',
        media_placements.channel AS media_placements.CHANNEL
            WITH SYNONYMS = ('media channel', 'advertising channel', 'channel type')
            COMMENT = 'Media channel: TV, STREAMING, DIGITAL_DISPLAY, SOCIAL, SEARCH, OOH, RADIO, PRINT',
        media_placements.platform AS media_placements.PLATFORM
            WITH SYNONYMS = ('media platform', 'publisher', 'network')
            COMMENT = 'Specific platform or publisher name',
        media_placements.placement_type AS media_placements.PLACEMENT_TYPE
            WITH SYNONYMS = ('placement type', 'buy type')
            COMMENT = 'Type of placement: PRIME_TIME, DAY_PART, PROGRAMMATIC, DIRECT, SPONSORSHIP',
        media_placements.targeting_type AS media_placements.TARGETING_TYPE
            WITH SYNONYMS = ('targeting', 'audience targeting')
            COMMENT = 'Targeting strategy: DEMO, BEHAVIORAL, CONTEXTUAL, RETARGETING, LOOKALIKE',
        media_placements.buying_method AS media_placements.BUYING_METHOD
            WITH SYNONYMS = ('buying type', 'purchase method')
            COMMENT = 'Media buying method: UPFRONT, SCATTER, PROGRAMMATIC, DIRECT_IO',
        media_placements.placement_status AS media_placements.STATUS
            WITH SYNONYMS = ('status', 'placement status')
            COMMENT = 'Placement status: PLANNED, BOOKED, LIVE, COMPLETED, CANCELLED',
        media_placements.placement_start_date AS media_placements.START_DATE
            COMMENT = 'Placement start date',
        media_placements.placement_end_date AS media_placements.END_DATE
            COMMENT = 'Placement end date',
            
        media_performance.performance_date AS media_performance.PERFORMANCE_DATE
            WITH SYNONYMS = ('date', 'report date', 'day')
            COMMENT = 'Date of the performance metrics',
        media_performance.performance_year AS YEAR(media_performance.PERFORMANCE_DATE)
            COMMENT = 'Year of performance',
        media_performance.performance_month AS MONTH(media_performance.PERFORMANCE_DATE)
            COMMENT = 'Month of performance',
        media_performance.performance_week AS WEEKOFYEAR(media_performance.PERFORMANCE_DATE)
            COMMENT = 'Week of year for performance',
            
        campaigns.campaign_id AS campaigns.CAMPAIGN_ID
            COMMENT = 'Associated campaign identifier',
        campaigns.campaign_name AS campaigns.CAMPAIGN_NAME
            COMMENT = 'Associated campaign name',
        campaigns.campaign_type AS campaigns.CAMPAIGN_TYPE
            COMMENT = 'Type of associated campaign'
    )

    METRICS (
        media_placements.total_placements AS COUNT(DISTINCT media_placements.PLACEMENT_ID)
            WITH SYNONYMS = ('placement count', 'number of placements')
            COMMENT = 'Total number of media placements',
        media_placements.total_planned_spend AS SUM(media_placements.PLANNED_SPEND)
            WITH SYNONYMS = ('planned spend', 'budgeted spend')
            COMMENT = 'Total planned media spend',
        media_placements.total_actual_spend AS SUM(media_placements.ACTUAL_SPEND)
            WITH SYNONYMS = ('actual spend', 'media spend', 'total spend')
            COMMENT = 'Total actual media spend',
            
        media_performance.total_impressions AS SUM(media_performance.IMPRESSIONS)
            WITH SYNONYMS = ('impressions', 'total impressions', 'imps')
            COMMENT = 'Total impressions delivered',
        media_performance.total_reach AS SUM(media_performance.REACH)
            WITH SYNONYMS = ('reach', 'unique users', 'unique reach')
            COMMENT = 'Total unique users reached',
        media_performance.avg_frequency AS AVG(media_performance.FREQUENCY)
            WITH SYNONYMS = ('frequency', 'avg frequency')
            COMMENT = 'Average ad frequency per user',
        media_performance.total_clicks AS SUM(media_performance.CLICKS)
            WITH SYNONYMS = ('clicks', 'total clicks')
            COMMENT = 'Total clicks generated',
        media_performance.total_video_views AS SUM(media_performance.VIDEO_VIEWS)
            WITH SYNONYMS = ('video views', 'views')
            COMMENT = 'Total video views',
        media_performance.total_video_completions AS SUM(media_performance.VIDEO_COMPLETIONS)
            WITH SYNONYMS = ('completions', 'video completions')
            COMMENT = 'Total video completions (100% viewed)',
        media_performance.total_engagements AS SUM(media_performance.ENGAGEMENTS)
            WITH SYNONYMS = ('engagements', 'total engagements')
            COMMENT = 'Total engagements (likes, shares, comments)',
        media_performance.total_conversions AS SUM(media_performance.CONVERSIONS)
            WITH SYNONYMS = ('conversions', 'total conversions')
            COMMENT = 'Total conversions generated',
        media_performance.total_conversion_value AS SUM(media_performance.CONVERSION_VALUE)
            WITH SYNONYMS = ('conversion value', 'revenue')
            COMMENT = 'Total value of conversions',
        media_performance.total_spend AS SUM(media_performance.SPEND)
            WITH SYNONYMS = ('spend', 'cost', 'media cost')
            COMMENT = 'Total media spend',
        media_performance.avg_ctr AS AVG(media_performance.ctr)
            WITH SYNONYMS = ('ctr', 'click rate', 'click through rate')
            COMMENT = 'Average click-through rate',
        media_performance.avg_video_completion_rate AS AVG(media_performance.video_completion_rate)
            WITH SYNONYMS = ('vcr', 'completion rate')
            COMMENT = 'Average video completion rate',
        media_performance.avg_engagement_rate AS AVG(media_performance.engagement_rate)
            COMMENT = 'Average engagement rate',
        media_performance.avg_viewability AS AVG(media_performance.VIEWABILITY_RATE)
            WITH SYNONYMS = ('viewability', 'viewable rate')
            COMMENT = 'Average viewability rate',
        media_performance.avg_brand_safety AS AVG(media_performance.BRAND_SAFETY_SCORE)
            WITH SYNONYMS = ('brand safety', 'safety score')
            COMMENT = 'Average brand safety score',
        media_performance.avg_cpm AS AVG(media_performance.cpm)
            WITH SYNONYMS = ('cpm', 'cost per mille')
            COMMENT = 'Average cost per thousand impressions',
        media_performance.avg_cpc AS AVG(media_performance.cpc)
            WITH SYNONYMS = ('cpc', 'cost per click')
            COMMENT = 'Average cost per click',
        media_performance.avg_cpa AS AVG(media_performance.cpa)
            WITH SYNONYMS = ('cpa', 'cost per acquisition')
            COMMENT = 'Average cost per acquisition',
        media_performance.avg_roas AS AVG(media_performance.roas)
            WITH SYNONYMS = ('roas', 'return on ad spend')
            COMMENT = 'Average return on ad spend'
    )

    COMMENT = 'Semantic view for media performance intelligence - analyze channel effectiveness, placement performance, and media efficiency';

-- ============================================================================
-- SEMANTIC VIEW 3: CLIENT FINANCIAL INTELLIGENCE
-- Purpose: Analyze client relationships, projects, invoicing, and profitability
-- ============================================================================

CREATE OR REPLACE SEMANTIC VIEW SV_CLIENT_FINANCIAL_INTELLIGENCE

    TABLES (
        clients AS INNOCEAN_INTELLIGENCE.RAW.CLIENTS
            PRIMARY KEY (CLIENT_ID)
            WITH SYNONYMS = ('client', 'account', 'customer', 'brand')
            COMMENT = 'Client and account master data',
            
        projects AS INNOCEAN_INTELLIGENCE.RAW.PROJECTS
            PRIMARY KEY (PROJECT_ID)
            WITH SYNONYMS = ('project', 'engagement', 'job')
            COMMENT = 'Client project records',
            
        invoices AS INNOCEAN_INTELLIGENCE.RAW.INVOICES
            PRIMARY KEY (INVOICE_ID)
            WITH SYNONYMS = ('invoice', 'bill', 'billing')
            COMMENT = 'Client invoices and billing records',
            
        employees AS INNOCEAN_INTELLIGENCE.RAW.EMPLOYEES
            PRIMARY KEY (EMPLOYEE_ID)
            COMMENT = 'Employee data for project leads'
    )

    RELATIONSHIPS (
        projects_to_clients AS
            projects (CLIENT_ID) REFERENCES clients,
        invoices_to_clients AS
            invoices (CLIENT_ID) REFERENCES clients,
        invoices_to_projects AS
            invoices (PROJECT_ID) REFERENCES projects,
        projects_to_employees AS
            projects (PROJECT_LEAD_ID) REFERENCES employees
    )

    FACTS (
        clients.relationship_tenure_days AS DATEDIFF(DAY, clients.CONTRACT_START_DATE, CURRENT_DATE())
            COMMENT = 'Number of days since contract start',
        clients.days_until_contract_end AS DATEDIFF(DAY, CURRENT_DATE(), clients.CONTRACT_END_DATE)
            COMMENT = 'Days remaining until contract ends',
        projects.hours_variance AS projects.ACTUAL_HOURS - projects.ESTIMATED_HOURS
            COMMENT = 'Variance between actual and estimated hours',
        projects.hours_variance_pct AS CASE WHEN projects.ESTIMATED_HOURS > 0 THEN (projects.ACTUAL_HOURS - projects.ESTIMATED_HOURS) / projects.ESTIMATED_HOURS ELSE NULL END
            COMMENT = 'Hours variance as percentage of estimate',
        projects.budget_variance AS projects.ESTIMATED_BUDGET - projects.ACTUAL_COST
            COMMENT = 'Variance between budget and actual cost (positive = under budget)',
        projects.budget_variance_pct AS CASE WHEN projects.ESTIMATED_BUDGET > 0 THEN (projects.ESTIMATED_BUDGET - projects.ACTUAL_COST) / projects.ESTIMATED_BUDGET ELSE NULL END
            COMMENT = 'Budget variance as percentage',
        invoices.outstanding_amount AS invoices.TOTAL_AMOUNT - invoices.AMOUNT_PAID
            COMMENT = 'Amount still owed on invoice',
        invoices.days_to_payment AS CASE WHEN invoices.PAYMENT_DATE IS NOT NULL THEN DATEDIFF(DAY, invoices.INVOICE_DATE, invoices.PAYMENT_DATE) ELSE NULL END
            COMMENT = 'Number of days from invoice to payment',
        invoices.days_overdue AS CASE WHEN invoices.STATUS = 'OVERDUE' THEN DATEDIFF(DAY, invoices.DUE_DATE, CURRENT_DATE()) ELSE 0 END
            COMMENT = 'Number of days invoice is overdue'
    )

    DIMENSIONS (
        clients.client_id AS clients.CLIENT_ID
            COMMENT = 'Unique client identifier',
        clients.client_name AS clients.CLIENT_NAME
            WITH SYNONYMS = ('client name', 'account name', 'brand name')
            COMMENT = 'Name of the client',
        clients.parent_company AS clients.PARENT_COMPANY
            WITH SYNONYMS = ('parent', 'holding company')
            COMMENT = 'Parent company name',
        clients.industry AS clients.INDUSTRY
            WITH SYNONYMS = ('industry', 'vertical', 'sector')
            COMMENT = 'Client industry category',
        clients.client_segment AS clients.CLIENT_SEGMENT
            WITH SYNONYMS = ('segment', 'client type')
            COMMENT = 'Client segment classification',
        clients.relationship_type AS clients.RELATIONSHIP_TYPE
            WITH SYNONYMS = ('engagement type', 'contract type')
            COMMENT = 'Type of client relationship: AOR, PROJECT, RETAINER',
        clients.client_status AS clients.STATUS
            WITH SYNONYMS = ('status', 'account status')
            COMMENT = 'Client status: ACTIVE, INACTIVE, PROSPECT, CHURNED',
        clients.contract_start_date AS clients.CONTRACT_START_DATE
            COMMENT = 'Contract start date',
        clients.contract_end_date AS clients.CONTRACT_END_DATE
            COMMENT = 'Contract end date',
            
        projects.project_id AS projects.PROJECT_ID
            COMMENT = 'Unique project identifier',
        projects.project_name AS projects.PROJECT_NAME
            WITH SYNONYMS = ('project name', 'job name')
            COMMENT = 'Name of the project',
        projects.project_type AS projects.PROJECT_TYPE
            WITH SYNONYMS = ('project type', 'work type')
            COMMENT = 'Type of project: CAMPAIGN, PRODUCTION, STRATEGY, RESEARCH, RETAINER_WORK',
        projects.billing_type AS projects.BILLING_TYPE
            WITH SYNONYMS = ('billing method', 'fee structure')
            COMMENT = 'Billing type: FIXED_FEE, HOURLY, RETAINER, COMMISSION',
        projects.project_status AS projects.STATUS
            WITH SYNONYMS = ('status', 'project status')
            COMMENT = 'Project status: PLANNED, ACTIVE, ON_HOLD, COMPLETED, CANCELLED',
        projects.project_start_date AS projects.START_DATE
            COMMENT = 'Project start date',
        projects.project_end_date AS projects.END_DATE
            COMMENT = 'Project end date',
            
        invoices.invoice_id AS invoices.INVOICE_ID
            COMMENT = 'Unique invoice identifier',
        invoices.invoice_number AS invoices.INVOICE_NUMBER
            WITH SYNONYMS = ('invoice number', 'bill number')
            COMMENT = 'Invoice reference number',
        invoices.invoice_date AS invoices.INVOICE_DATE
            WITH SYNONYMS = ('bill date', 'invoice date')
            COMMENT = 'Date invoice was issued',
        invoices.due_date AS invoices.DUE_DATE
            WITH SYNONYMS = ('payment due date')
            COMMENT = 'Invoice payment due date',
        invoices.invoice_status AS invoices.STATUS
            WITH SYNONYMS = ('payment status', 'invoice status')
            COMMENT = 'Invoice status: DRAFT, SENT, PAID, OVERDUE, CANCELLED, DISPUTED',
        invoices.payment_terms AS invoices.PAYMENT_TERMS
            COMMENT = 'Payment terms: NET30, NET45, NET60',
        invoices.invoice_year AS YEAR(invoices.INVOICE_DATE)
            COMMENT = 'Year of invoice',
        invoices.invoice_quarter AS QUARTER(invoices.INVOICE_DATE)
            COMMENT = 'Quarter of invoice',
        invoices.invoice_month AS MONTH(invoices.INVOICE_DATE)
            COMMENT = 'Month of invoice',
            
        employees.project_lead_name AS employees.FIRST_NAME || ' ' || employees.LAST_NAME
            WITH SYNONYMS = ('project lead', 'project manager', 'lead')
            COMMENT = 'Name of project lead',
        employees.department AS employees.DEPARTMENT
            COMMENT = 'Department of project lead'
    )

    METRICS (
        clients.total_clients AS COUNT(DISTINCT clients.CLIENT_ID)
            WITH SYNONYMS = ('client count', 'number of clients')
            COMMENT = 'Total number of clients',
        clients.total_annual_budget AS SUM(clients.ANNUAL_BUDGET)
            WITH SYNONYMS = ('annual budget', 'total budget')
            COMMENT = 'Total annual client budgets',
        clients.avg_satisfaction_score AS AVG(clients.SATISFACTION_SCORE)
            WITH SYNONYMS = ('satisfaction', 'csat', 'satisfaction score')
            COMMENT = 'Average client satisfaction score',
        clients.avg_nps AS AVG(clients.NPS_SCORE)
            WITH SYNONYMS = ('nps', 'net promoter score')
            COMMENT = 'Average Net Promoter Score',
            
        projects.total_projects AS COUNT(DISTINCT projects.PROJECT_ID)
            WITH SYNONYMS = ('project count', 'number of projects')
            COMMENT = 'Total number of projects',
        projects.total_estimated_hours AS SUM(projects.ESTIMATED_HOURS)
            WITH SYNONYMS = ('estimated hours', 'budgeted hours')
            COMMENT = 'Total estimated hours across projects',
        projects.total_actual_hours AS SUM(projects.ACTUAL_HOURS)
            WITH SYNONYMS = ('actual hours', 'hours worked')
            COMMENT = 'Total actual hours worked',
        projects.total_estimated_budget AS SUM(projects.ESTIMATED_BUDGET)
            WITH SYNONYMS = ('project budget', 'estimated budget')
            COMMENT = 'Total estimated project budgets',
        projects.total_actual_cost AS SUM(projects.ACTUAL_COST)
            WITH SYNONYMS = ('actual cost', 'project cost')
            COMMENT = 'Total actual project costs',
        projects.avg_profit_margin AS AVG(projects.PROFIT_MARGIN)
            WITH SYNONYMS = ('margin', 'profit margin', 'profitability')
            COMMENT = 'Average project profit margin',
            
        invoices.total_invoices AS COUNT(DISTINCT invoices.INVOICE_ID)
            WITH SYNONYMS = ('invoice count', 'number of invoices')
            COMMENT = 'Total number of invoices',
        invoices.total_billed AS SUM(invoices.TOTAL_AMOUNT)
            WITH SYNONYMS = ('total billed', 'billed amount', 'revenue')
            COMMENT = 'Total amount billed',
        invoices.total_collected AS SUM(invoices.AMOUNT_PAID)
            WITH SYNONYMS = ('collected', 'paid', 'payments received')
            COMMENT = 'Total amount collected',
        invoices.total_outstanding AS SUM(invoices.outstanding_amount)
            WITH SYNONYMS = ('outstanding', 'accounts receivable', 'ar')
            COMMENT = 'Total outstanding balance',
        invoices.overdue_invoices AS COUNT(DISTINCT CASE WHEN invoices.STATUS = 'OVERDUE' THEN invoices.INVOICE_ID END)
            WITH SYNONYMS = ('overdue count', 'late invoices')
            COMMENT = 'Number of overdue invoices',
        invoices.avg_days_to_payment AS AVG(invoices.days_to_payment)
            WITH SYNONYMS = ('dso', 'days sales outstanding')
            COMMENT = 'Average days to receive payment'
    )

    COMMENT = 'Semantic view for client financial intelligence - analyze client relationships, project profitability, billing, and accounts receivable';

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SHOW SEMANTIC VIEWS IN SCHEMA INNOCEAN_INTELLIGENCE.ANALYTICS;

-- Verify semantic view structure
DESCRIBE SEMANTIC VIEW SV_CAMPAIGN_CREATIVE_INTELLIGENCE;
DESCRIBE SEMANTIC VIEW SV_MEDIA_PERFORMANCE_INTELLIGENCE;
DESCRIBE SEMANTIC VIEW SV_CLIENT_FINANCIAL_INTELLIGENCE;

/*
=============================================================================
SEMANTIC VIEWS CREATED

1. SV_CAMPAIGN_CREATIVE_INTELLIGENCE
   - Tables: campaigns, clients, creative_assets
   - Purpose: Analyze campaign and creative performance
   - Key metrics: ROAS, CTR, conversion rate, impressions, reach

2. SV_MEDIA_PERFORMANCE_INTELLIGENCE
   - Tables: media_placements, media_performance, campaigns
   - Purpose: Analyze media channel and placement effectiveness
   - Key metrics: CPM, CPC, CPA, video completion rate, viewability

3. SV_CLIENT_FINANCIAL_INTELLIGENCE
   - Tables: clients, projects, invoices, employees
   - Purpose: Analyze client relationships and financial performance
   - Key metrics: Revenue, profit margin, satisfaction, DSO

All semantic views follow verified Snowflake syntax:
✅ TABLES clause with PRIMARY KEY definitions
✅ RELATIONSHIPS clause defining foreign keys
✅ FACTS clause for calculated values
✅ DIMENSIONS clause with synonyms and comments
✅ METRICS clause with aggregations
✅ Proper clause ordering maintained

Next Step: Run 06_create_cortex_search.sql
=============================================================================
*/

/*
=============================================================================
INNOCEAN USA ADVERTISING INTELLIGENCE - DATABASE AND SCHEMA SETUP
=============================================================================
Script: 01_database_and_schema.sql
Purpose: Create database and schemas for Innocean Intelligence solution
Created: January 2026
=============================================================================
*/

-- ============================================================================
-- STEP 1: CREATE DATABASE
-- ============================================================================

USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS INNOCEAN_INTELLIGENCE
    COMMENT = 'Innocean USA Advertising Intelligence - Campaign, Media, and Client Analytics';

-- ============================================================================
-- STEP 2: CREATE SCHEMAS
-- ============================================================================

-- RAW schema for source data tables
CREATE SCHEMA IF NOT EXISTS INNOCEAN_INTELLIGENCE.RAW
    COMMENT = 'Raw source data tables for advertising operations';

-- ANALYTICS schema for curated views and semantic models
CREATE SCHEMA IF NOT EXISTS INNOCEAN_INTELLIGENCE.ANALYTICS
    COMMENT = 'Analytical views and semantic models for AI agents';

-- ============================================================================
-- STEP 3: CREATE WAREHOUSE (if needed)
-- ============================================================================

CREATE WAREHOUSE IF NOT EXISTS INNOCEAN_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    COMMENT = 'Warehouse for Innocean Intelligence workloads';

-- ============================================================================
-- STEP 4: SET CONTEXT
-- ============================================================================

USE WAREHOUSE INNOCEAN_WH;
USE DATABASE INNOCEAN_INTELLIGENCE;
USE SCHEMA RAW;

-- ============================================================================
-- STEP 5: GRANT PERMISSIONS
-- ============================================================================

-- Grant usage on database
GRANT USAGE ON DATABASE INNOCEAN_INTELLIGENCE TO ROLE PUBLIC;

-- Grant usage on schemas
GRANT USAGE ON SCHEMA INNOCEAN_INTELLIGENCE.RAW TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA INNOCEAN_INTELLIGENCE.ANALYTICS TO ROLE PUBLIC;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE INNOCEAN_WH TO ROLE PUBLIC;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SHOW DATABASES LIKE 'INNOCEAN_INTELLIGENCE';
SHOW SCHEMAS IN DATABASE INNOCEAN_INTELLIGENCE;
SHOW WAREHOUSES LIKE 'INNOCEAN_WH';

/*
=============================================================================
SETUP COMPLETE
Next Step: Run 02_create_tables.sql
=============================================================================
*/

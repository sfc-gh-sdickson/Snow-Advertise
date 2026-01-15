/*
=============================================================================
INNOCEAN USA ADVERTISING INTELLIGENCE - SYNTHETIC DATA GENERATION
=============================================================================
Script: 03_generate_synthetic_data.sql
Purpose: Generate realistic sample data for all tables
Created: January 2026
Estimated Runtime: 5-15 minutes
=============================================================================
*/

USE DATABASE INNOCEAN_INTELLIGENCE;
USE SCHEMA RAW;

-- ============================================================================
-- STEP 1: GENERATE CLIENTS (500 records)
-- ============================================================================

INSERT INTO CLIENTS (
    CLIENT_ID, CLIENT_NAME, PARENT_COMPANY, INDUSTRY, CLIENT_SEGMENT,
    RELATIONSHIP_TYPE, CONTRACT_START_DATE, CONTRACT_END_DATE, ANNUAL_BUDGET,
    PRIMARY_CONTACT_NAME, PRIMARY_CONTACT_EMAIL, BILLING_ADDRESS,
    SATISFACTION_SCORE, NPS_SCORE, STATUS, CREATED_DATE
)
SELECT
    'CLI-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS CLIENT_ID,
    CASE MOD(SEQ4(), 50)
        WHEN 0 THEN 'Hyundai Motor America'
        WHEN 1 THEN 'Kia America'
        WHEN 2 THEN 'Genesis Motor America'
        WHEN 3 THEN 'Supernal'
        WHEN 4 THEN 'Hyundai Capital America'
        ELSE 
            CASE MOD(SEQ4(), 10)
                WHEN 0 THEN 'Apex ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Motors' WHEN 1 THEN 'Financial' WHEN 2 THEN 'Retail' WHEN 3 THEN 'Tech' ELSE 'Foods' END
                WHEN 1 THEN 'Summit ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Automotive' WHEN 1 THEN 'Insurance' WHEN 2 THEN 'Beverages' WHEN 3 THEN 'Electronics' ELSE 'Healthcare' END
                WHEN 2 THEN 'Horizon ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Cars' WHEN 1 THEN 'Bank' WHEN 2 THEN 'Coffee' WHEN 3 THEN 'Software' ELSE 'Pharma' END
                WHEN 3 THEN 'Pinnacle ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Auto' WHEN 1 THEN 'Credit' WHEN 2 THEN 'Snacks' WHEN 3 THEN 'Cloud' ELSE 'Medical' END
                WHEN 4 THEN 'Vanguard ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Vehicles' WHEN 1 THEN 'Wealth' WHEN 2 THEN 'Organic' WHEN 3 THEN 'AI' ELSE 'Wellness' END
                WHEN 5 THEN 'Elite ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Luxury' WHEN 1 THEN 'Investments' WHEN 2 THEN 'Gourmet' WHEN 3 THEN 'Security' ELSE 'Fitness' END
                WHEN 6 THEN 'Prime ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Auto Group' WHEN 1 THEN 'Lending' WHEN 2 THEN 'Restaurants' WHEN 3 THEN 'Data' ELSE 'Beauty' END
                WHEN 7 THEN 'Dynamic ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Trucks' WHEN 1 THEN 'Solutions' WHEN 2 THEN 'Brands' WHEN 3 THEN 'Networks' ELSE 'Living' END
                WHEN 8 THEN 'Global ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Transit' WHEN 1 THEN 'Capital' WHEN 2 THEN 'Consumer' WHEN 3 THEN 'Digital' ELSE 'Care' END
                ELSE 'Regional ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Motors' WHEN 1 THEN 'Finance' WHEN 2 THEN 'Products' WHEN 3 THEN 'Tech' ELSE 'Health' END
            END || ' ' || LPAD(SEQ4()::VARCHAR, 3, '0')
    END AS CLIENT_NAME,
    CASE 
        WHEN MOD(SEQ4(), 50) IN (0, 2, 3, 4) THEN 'Hyundai Motor Group'
        WHEN MOD(SEQ4(), 50) = 1 THEN 'Kia Corporation'
        WHEN MOD(SEQ4(), 3) = 0 THEN 'Independent'
        ELSE 'Holdings Corp ' || MOD(SEQ4(), 20)::VARCHAR
    END AS PARENT_COMPANY,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'AUTOMOTIVE'
        WHEN 1 THEN 'FINANCIAL_SERVICES'
        WHEN 2 THEN 'RETAIL'
        WHEN 3 THEN 'TECHNOLOGY'
        WHEN 4 THEN 'CPG'
        WHEN 5 THEN 'HEALTHCARE'
        WHEN 6 THEN 'ENTERTAINMENT'
        ELSE 'OTHER'
    END AS INDUSTRY,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'AUTOMOTIVE'
        WHEN 1 THEN 'RETAIL'
        WHEN 2 THEN 'CPG'
        WHEN 3 THEN 'TECHNOLOGY'
        WHEN 4 THEN 'FINANCIAL'
        ELSE 'ENTERTAINMENT'
    END AS CLIENT_SEGMENT,
    CASE MOD(SEQ4(), 3)
        WHEN 0 THEN 'AOR'
        WHEN 1 THEN 'PROJECT'
        ELSE 'RETAINER'
    END AS RELATIONSHIP_TYPE,
    DATEADD(DAY, -UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS CONTRACT_START_DATE,
    DATEADD(DAY, UNIFORM(365, 1095, RANDOM()), CURRENT_DATE()) AS CONTRACT_END_DATE,
    UNIFORM(100000, 50000000, RANDOM())::NUMBER(15,2) AS ANNUAL_BUDGET,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Sarah Johnson'
        WHEN 1 THEN 'Michael Chen'
        WHEN 2 THEN 'Emily Rodriguez'
        WHEN 3 THEN 'David Kim'
        WHEN 4 THEN 'Jessica Martinez'
        WHEN 5 THEN 'Robert Williams'
        WHEN 6 THEN 'Amanda Thompson'
        WHEN 7 THEN 'Christopher Lee'
        WHEN 8 THEN 'Michelle Garcia'
        WHEN 9 THEN 'Daniel Brown'
        WHEN 10 THEN 'Jennifer Davis'
        WHEN 11 THEN 'James Wilson'
        WHEN 12 THEN 'Ashley Miller'
        WHEN 13 THEN 'Matthew Taylor'
        WHEN 14 THEN 'Stephanie Anderson'
        WHEN 15 THEN 'Andrew Thomas'
        WHEN 16 THEN 'Nicole Jackson'
        WHEN 17 THEN 'Joshua White'
        WHEN 18 THEN 'Samantha Harris'
        ELSE 'William Martin'
    END AS PRIMARY_CONTACT_NAME,
    LOWER(REPLACE(PRIMARY_CONTACT_NAME, ' ', '.')) || '@' || LOWER(REPLACE(REPLACE(CLIENT_NAME, ' ', ''), '''', '')) || '.com' AS PRIMARY_CONTACT_EMAIL,
    UNIFORM(100, 9999, RANDOM())::VARCHAR || ' ' ||
    CASE MOD(SEQ4(), 10) 
        WHEN 0 THEN 'Main St' WHEN 1 THEN 'Oak Ave' WHEN 2 THEN 'Corporate Blvd'
        WHEN 3 THEN 'Business Park Dr' WHEN 4 THEN 'Innovation Way' WHEN 5 THEN 'Commerce St'
        WHEN 6 THEN 'Executive Dr' WHEN 7 THEN 'Market St' WHEN 8 THEN 'Industry Ave'
        ELSE 'Center Blvd'
    END || ', ' ||
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'Los Angeles, CA 90001'
        WHEN 1 THEN 'New York, NY 10001'
        WHEN 2 THEN 'Chicago, IL 60601'
        WHEN 3 THEN 'Houston, TX 77001'
        WHEN 4 THEN 'Phoenix, AZ 85001'
        WHEN 5 THEN 'San Diego, CA 92101'
        WHEN 6 THEN 'Dallas, TX 75201'
        WHEN 7 THEN 'San Francisco, CA 94101'
        WHEN 8 THEN 'Seattle, WA 98101'
        WHEN 9 THEN 'Denver, CO 80201'
        WHEN 10 THEN 'Atlanta, GA 30301'
        WHEN 11 THEN 'Miami, FL 33101'
        WHEN 12 THEN 'Boston, MA 02101'
        WHEN 13 THEN 'Detroit, MI 48201'
        ELSE 'Austin, TX 78701'
    END AS BILLING_ADDRESS,
    ROUND(UNIFORM(6.0, 10.0, RANDOM()), 1) AS SATISFACTION_SCORE,
    UNIFORM(-20, 80, RANDOM()) AS NPS_SCORE,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'ACTIVE'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'INACTIVE'
        ELSE 'CHURNED'
    END AS STATUS,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- ============================================================================
-- STEP 2: GENERATE CAMPAIGNS (100,000 records)
-- ============================================================================

INSERT INTO CAMPAIGNS (
    CAMPAIGN_ID, CLIENT_ID, CAMPAIGN_NAME, CAMPAIGN_TYPE, CAMPAIGN_OBJECTIVE,
    START_DATE, END_DATE, TOTAL_BUDGET, MEDIA_BUDGET, PRODUCTION_BUDGET,
    TARGET_AUDIENCE, TARGET_GEO, TARGET_IMPRESSIONS, TARGET_REACH, TARGET_FREQUENCY,
    TARGET_CTR, TARGET_CONVERSION_RATE, TARGET_ROAS, ACTUAL_IMPRESSIONS, ACTUAL_REACH,
    ACTUAL_CLICKS, ACTUAL_CONVERSIONS, ACTUAL_REVENUE, ACTUAL_ROAS, STATUS, CREATED_DATE
)
SELECT
    'CAM-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS CAMPAIGN_ID,
    'CLI-' || LPAD(UNIFORM(0, 499, RANDOM())::VARCHAR, 6, '0') AS CLIENT_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Spring Sales Event'
        WHEN 1 THEN 'Summer Drive Campaign'
        WHEN 2 THEN 'Fall Model Launch'
        WHEN 3 THEN 'Holiday Season Push'
        WHEN 4 THEN 'Brand Awareness Initiative'
        WHEN 5 THEN 'Digital First Campaign'
        WHEN 6 THEN 'Social Media Blitz'
        WHEN 7 THEN 'Performance Max'
        WHEN 8 THEN 'Conquest Campaign'
        WHEN 9 THEN 'Loyalty Rewards Program'
        WHEN 10 THEN 'New Model Introduction'
        WHEN 11 THEN 'End of Year Clearance'
        WHEN 12 THEN 'Test Drive Event'
        WHEN 13 THEN 'Tier 2 Dealer Support'
        WHEN 14 THEN 'National TV Flight'
        WHEN 15 THEN 'Connected TV Campaign'
        WHEN 16 THEN 'Streaming Audio Push'
        WHEN 17 THEN 'Influencer Partnership'
        WHEN 18 THEN 'Experiential Activation'
        ELSE 'Always On Campaign'
    END || ' ' || (2020 + MOD(SEQ4(), 6))::VARCHAR || ' Q' || (1 + MOD(SEQ4(), 4))::VARCHAR AS CAMPAIGN_NAME,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'BRAND_AWARENESS'
        WHEN 1 THEN 'PRODUCT_LAUNCH'
        WHEN 2 THEN 'SEASONAL'
        WHEN 3 THEN 'ALWAYS_ON'
        ELSE 'TACTICAL'
    END AS CAMPAIGN_TYPE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'AWARENESS'
        WHEN 1 THEN 'CONSIDERATION'
        WHEN 2 THEN 'CONVERSION'
        WHEN 3 THEN 'RETENTION'
        ELSE 'ADVOCACY'
    END AS CAMPAIGN_OBJECTIVE,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS START_DATE,
    DATEADD(DAY, UNIFORM(14, 90, RANDOM()), START_DATE) AS END_DATE,
    UNIFORM(50000, 5000000, RANDOM())::NUMBER(15,2) AS TOTAL_BUDGET,
    TOTAL_BUDGET * UNIFORM(0.60, 0.85, RANDOM()) AS MEDIA_BUDGET,
    TOTAL_BUDGET * UNIFORM(0.10, 0.25, RANDOM()) AS PRODUCTION_BUDGET,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Adults 25-54, HHI $75K+, In-market for vehicle'
        WHEN 1 THEN 'Millennials 25-40, Urban, Tech-savvy'
        WHEN 2 THEN 'Gen Z 18-24, Social media active'
        WHEN 3 THEN 'Families with children, Suburban'
        WHEN 4 THEN 'Luxury intenders, HHI $150K+'
        WHEN 5 THEN 'First-time buyers, Credit-qualified'
        WHEN 6 THEN 'Current owners, Loyalty segment'
        ELSE 'Conquest segment, Competitive brand owners'
    END AS TARGET_AUDIENCE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'National US'
        WHEN 1 THEN 'Top 25 DMAs'
        WHEN 2 THEN 'California + Texas'
        WHEN 3 THEN 'Northeast Region'
        ELSE 'Southeast Region'
    END AS TARGET_GEO,
    UNIFORM(1000000, 500000000, RANDOM()) AS TARGET_IMPRESSIONS,
    TARGET_IMPRESSIONS * UNIFORM(0.30, 0.60, RANDOM()) AS TARGET_REACH,
    UNIFORM(2.0, 8.0, RANDOM()) AS TARGET_FREQUENCY,
    UNIFORM(0.005, 0.030, RANDOM()) AS TARGET_CTR,
    UNIFORM(0.01, 0.08, RANDOM()) AS TARGET_CONVERSION_RATE,
    UNIFORM(2.0, 8.0, RANDOM()) AS TARGET_ROAS,
    TARGET_IMPRESSIONS * UNIFORM(0.85, 1.15, RANDOM()) AS ACTUAL_IMPRESSIONS,
    TARGET_REACH * UNIFORM(0.80, 1.10, RANDOM()) AS ACTUAL_REACH,
    ACTUAL_IMPRESSIONS * UNIFORM(0.004, 0.035, RANDOM()) AS ACTUAL_CLICKS,
    ACTUAL_CLICKS * UNIFORM(0.01, 0.10, RANDOM()) AS ACTUAL_CONVERSIONS,
    ACTUAL_CONVERSIONS * UNIFORM(1000, 50000, RANDOM()) AS ACTUAL_REVENUE,
    ACTUAL_REVENUE / NULLIF(MEDIA_BUDGET, 0) AS ACTUAL_ROAS,
    CASE 
        WHEN END_DATE < CURRENT_DATE() THEN 'COMPLETED'
        WHEN START_DATE > CURRENT_DATE() THEN 'PLANNED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'IN_FLIGHT'
        ELSE 'PAUSED'
    END AS STATUS,
    DATEADD(DAY, -UNIFORM(1, 365, RANDOM()), START_DATE) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- ============================================================================
-- STEP 3: GENERATE CREATIVE ASSETS (250,000 records)
-- ============================================================================

INSERT INTO CREATIVE_ASSETS (
    ASSET_ID, CAMPAIGN_ID, ASSET_NAME, ASSET_TYPE, FORMAT, DURATION_SECONDS,
    DIMENSIONS, FILE_SIZE_MB, LANGUAGE, VERSION_NUMBER, CONCEPT_NAME,
    HEADLINE, BODY_COPY, CTA_TEXT, PRODUCTION_COST, TALENT_COST,
    APPROVAL_STATUS, APPROVED_DATE, APPROVED_BY, PERFORMANCE_RATING, CREATED_DATE
)
SELECT
    'AST-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS ASSET_ID,
    'CAM-' || LPAD(UNIFORM(0, 99999, RANDOM())::VARCHAR, 8, '0') AS CAMPAIGN_ID,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'Hero Video'
        WHEN 1 THEN 'Social Cutdown'
        WHEN 2 THEN 'Display Banner'
        WHEN 3 THEN 'Pre-roll'
        WHEN 4 THEN 'Native Ad'
        WHEN 5 THEN 'Carousel'
        WHEN 6 THEN 'Story Ad'
        WHEN 7 THEN 'Audio Spot'
        WHEN 8 THEN 'Print Ad'
        WHEN 9 THEN 'OOH Billboard'
        WHEN 10 THEN 'Digital OOH'
        WHEN 11 THEN 'Email Creative'
        WHEN 12 THEN 'Landing Page'
        WHEN 13 THEN 'Rich Media'
        ELSE 'Video Bumper'
    END || ' v' || (1 + MOD(SEQ4(), 5))::VARCHAR AS ASSET_NAME,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'VIDEO'
        WHEN 1 THEN 'DISPLAY'
        WHEN 2 THEN 'SOCIAL'
        WHEN 3 THEN 'PRINT'
        WHEN 4 THEN 'AUDIO'
        ELSE 'OOH'
    END AS ASSET_TYPE,
    CASE ASSET_TYPE
        WHEN 'VIDEO' THEN CASE MOD(SEQ4(), 5) WHEN 0 THEN ':60TV' WHEN 1 THEN ':30TV' WHEN 2 THEN ':15TV' WHEN 3 THEN ':06BUMPER' ELSE ':90TV' END
        WHEN 'DISPLAY' THEN CASE MOD(SEQ4(), 6) WHEN 0 THEN '300x250' WHEN 1 THEN '728x90' WHEN 2 THEN '160x600' WHEN 3 THEN '320x50' WHEN 4 THEN '300x600' ELSE '970x250' END
        WHEN 'SOCIAL' THEN CASE MOD(SEQ4(), 4) WHEN 0 THEN '1080x1080' WHEN 1 THEN '1080x1920' WHEN 2 THEN 'CAROUSEL' ELSE '1200x628' END
        WHEN 'PRINT' THEN CASE MOD(SEQ4(), 3) WHEN 0 THEN 'FULL_PAGE' WHEN 1 THEN 'HALF_PAGE' ELSE 'SPREAD' END
        WHEN 'AUDIO' THEN CASE MOD(SEQ4(), 3) WHEN 0 THEN ':30AUDIO' WHEN 1 THEN ':15AUDIO' ELSE ':60AUDIO' END
        ELSE CASE MOD(SEQ4(), 3) WHEN 0 THEN 'BILLBOARD' WHEN 1 THEN 'BUS_SHELTER' ELSE 'DIGITAL_BOARD' END
    END AS FORMAT,
    CASE ASSET_TYPE WHEN 'VIDEO' THEN UNIFORM(6, 90, RANDOM()) WHEN 'AUDIO' THEN UNIFORM(15, 60, RANDOM()) ELSE NULL END AS DURATION_SECONDS,
    CASE WHEN ASSET_TYPE IN ('VIDEO', 'DISPLAY', 'SOCIAL') THEN FORMAT ELSE NULL END AS DIMENSIONS,
    UNIFORM(0.5, 500, RANDOM())::NUMBER(10,2) AS FILE_SIZE_MB,
    CASE MOD(SEQ4(), 10) WHEN 0 THEN 'ES' WHEN 1 THEN 'KO' WHEN 2 THEN 'ZH' ELSE 'EN' END AS LANGUAGE,
    1 + MOD(SEQ4(), 5) AS VERSION_NUMBER,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Freedom'
        WHEN 1 THEN 'Innovation'
        WHEN 2 THEN 'Adventure'
        WHEN 3 THEN 'Family'
        WHEN 4 THEN 'Performance'
        WHEN 5 THEN 'Luxury'
        WHEN 6 THEN 'Sustainability'
        WHEN 7 THEN 'Technology'
        WHEN 8 THEN 'Value'
        ELSE 'Reliability'
    END AS CONCEPT_NAME,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Drive Your Dreams'
        WHEN 1 THEN 'The Future is Now'
        WHEN 2 THEN 'Beyond Expectations'
        WHEN 3 THEN 'Engineered for Excellence'
        WHEN 4 THEN 'Adventure Awaits'
        WHEN 5 THEN 'Innovation at Every Turn'
        WHEN 6 THEN 'Designed for You'
        WHEN 7 THEN 'Power Meets Efficiency'
        WHEN 8 THEN 'The Smart Choice'
        WHEN 9 THEN 'Luxury Redefined'
        WHEN 10 THEN 'Safety First, Always'
        ELSE 'Experience the Difference'
    END AS HEADLINE,
    'Discover a new standard of excellence with our latest innovation. ' ||
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Built for those who demand more from life.'
        WHEN 1 THEN 'Where cutting-edge technology meets timeless design.'
        WHEN 2 THEN 'Crafted with precision, designed with passion.'
        WHEN 3 THEN 'The perfect blend of performance and comfort.'
        ELSE 'Your journey to extraordinary starts here.'
    END AS BODY_COPY,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Learn More'
        WHEN 1 THEN 'Shop Now'
        WHEN 2 THEN 'Schedule Test Drive'
        WHEN 3 THEN 'Get a Quote'
        WHEN 4 THEN 'Find a Dealer'
        WHEN 5 THEN 'Explore Features'
        WHEN 6 THEN 'Build Yours'
        ELSE 'See Offers'
    END AS CTA_TEXT,
    CASE ASSET_TYPE
        WHEN 'VIDEO' THEN UNIFORM(50000, 2000000, RANDOM())
        WHEN 'PRINT' THEN UNIFORM(5000, 50000, RANDOM())
        WHEN 'OOH' THEN UNIFORM(10000, 100000, RANDOM())
        ELSE UNIFORM(1000, 25000, RANDOM())
    END::NUMBER(12,2) AS PRODUCTION_COST,
    CASE WHEN ASSET_TYPE = 'VIDEO' THEN UNIFORM(10000, 500000, RANDOM()) ELSE 0 END::NUMBER(12,2) AS TALENT_COST,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'APPROVED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'CLIENT_REVIEW'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'IN_REVIEW'
        ELSE 'DRAFT'
    END AS APPROVAL_STATUS,
    CASE WHEN APPROVAL_STATUS = 'APPROVED' THEN DATEADD(DAY, -UNIFORM(1, 180, RANDOM()), CURRENT_DATE()) ELSE NULL END AS APPROVED_DATE,
    CASE WHEN APPROVAL_STATUS = 'APPROVED' THEN 
        CASE MOD(SEQ4(), 10) 
            WHEN 0 THEN 'John Smith' WHEN 1 THEN 'Maria Garcia' WHEN 2 THEN 'David Lee'
            WHEN 3 THEN 'Sarah Johnson' WHEN 4 THEN 'Mike Chen' ELSE 'Lisa Wong'
        END
    ELSE NULL END AS APPROVED_BY,
    ROUND(UNIFORM(4.0, 10.0, RANDOM()), 1) AS PERFORMANCE_RATING,
    DATEADD(DAY, -UNIFORM(1, 365, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 250000));

-- ============================================================================
-- STEP 4: GENERATE MEDIA PLACEMENTS (500,000 records)
-- ============================================================================

INSERT INTO MEDIA_PLACEMENTS (
    PLACEMENT_ID, CAMPAIGN_ID, ASSET_ID, CHANNEL, PLATFORM, PLACEMENT_TYPE,
    TARGETING_TYPE, START_DATE, END_DATE, PLANNED_SPEND, ACTUAL_SPEND,
    PLANNED_IMPRESSIONS, CPM_RATE, CPC_RATE, CPV_RATE, BUYING_METHOD, STATUS, CREATED_DATE
)
SELECT
    'PLC-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS PLACEMENT_ID,
    'CAM-' || LPAD(UNIFORM(0, 99999, RANDOM())::VARCHAR, 8, '0') AS CAMPAIGN_ID,
    'AST-' || LPAD(UNIFORM(0, 249999, RANDOM())::VARCHAR, 8, '0') AS ASSET_ID,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'TV'
        WHEN 1 THEN 'STREAMING'
        WHEN 2 THEN 'DIGITAL_DISPLAY'
        WHEN 3 THEN 'SOCIAL'
        WHEN 4 THEN 'SEARCH'
        WHEN 5 THEN 'OOH'
        WHEN 6 THEN 'RADIO'
        ELSE 'PRINT'
    END AS CHANNEL,
    CASE CHANNEL
        WHEN 'TV' THEN CASE MOD(SEQ4(), 6) WHEN 0 THEN 'NBC' WHEN 1 THEN 'CBS' WHEN 2 THEN 'ABC' WHEN 3 THEN 'FOX' WHEN 4 THEN 'ESPN' ELSE 'NFL Network' END
        WHEN 'STREAMING' THEN CASE MOD(SEQ4(), 6) WHEN 0 THEN 'Hulu' WHEN 1 THEN 'YouTube TV' WHEN 2 THEN 'Peacock' WHEN 3 THEN 'Paramount+' WHEN 4 THEN 'Amazon Prime' ELSE 'Disney+' END
        WHEN 'DIGITAL_DISPLAY' THEN CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Google Display Network' WHEN 1 THEN 'Trade Desk' WHEN 2 THEN 'DV360' WHEN 3 THEN 'Yahoo DSP' ELSE 'Amazon DSP' END
        WHEN 'SOCIAL' THEN CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Meta' WHEN 1 THEN 'TikTok' WHEN 2 THEN 'Snapchat' WHEN 3 THEN 'Pinterest' ELSE 'LinkedIn' END
        WHEN 'SEARCH' THEN CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Google Ads' WHEN 1 THEN 'Microsoft Ads' ELSE 'Amazon Search' END
        WHEN 'OOH' THEN CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Clear Channel' WHEN 1 THEN 'Lamar' WHEN 2 THEN 'JCDecaux' ELSE 'Outfront Media' END
        WHEN 'RADIO' THEN CASE MOD(SEQ4(), 4) WHEN 0 THEN 'iHeartRadio' WHEN 1 THEN 'Spotify' WHEN 2 THEN 'Pandora' ELSE 'SiriusXM' END
        ELSE CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Hearst' WHEN 1 THEN 'Conde Nast' WHEN 2 THEN 'Meredith' ELSE 'Time Inc' END
    END AS PLATFORM,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'PRIME_TIME'
        WHEN 1 THEN 'DAY_PART'
        WHEN 2 THEN 'PROGRAMMATIC'
        WHEN 3 THEN 'DIRECT'
        ELSE 'SPONSORSHIP'
    END AS PLACEMENT_TYPE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'DEMO'
        WHEN 1 THEN 'BEHAVIORAL'
        WHEN 2 THEN 'CONTEXTUAL'
        WHEN 3 THEN 'RETARGETING'
        ELSE 'LOOKALIKE'
    END AS TARGETING_TYPE,
    DATEADD(DAY, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) AS START_DATE,
    DATEADD(DAY, UNIFORM(7, 60, RANDOM()), START_DATE) AS END_DATE,
    UNIFORM(1000, 500000, RANDOM())::NUMBER(12,2) AS PLANNED_SPEND,
    PLANNED_SPEND * UNIFORM(0.90, 1.05, RANDOM()) AS ACTUAL_SPEND,
    UNIFORM(10000, 50000000, RANDOM()) AS PLANNED_IMPRESSIONS,
    UNIFORM(2.00, 50.00, RANDOM())::NUMBER(8,4) AS CPM_RATE,
    UNIFORM(0.50, 5.00, RANDOM())::NUMBER(8,4) AS CPC_RATE,
    UNIFORM(0.01, 0.10, RANDOM())::NUMBER(8,4) AS CPV_RATE,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'UPFRONT'
        WHEN 1 THEN 'SCATTER'
        WHEN 2 THEN 'PROGRAMMATIC'
        ELSE 'DIRECT_IO'
    END AS BUYING_METHOD,
    CASE 
        WHEN END_DATE < CURRENT_DATE() THEN 'COMPLETED'
        WHEN START_DATE > CURRENT_DATE() THEN 'PLANNED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'LIVE'
        ELSE 'CANCELLED'
    END AS STATUS,
    DATEADD(DAY, -UNIFORM(1, 30, RANDOM()), START_DATE) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 500000));

-- ============================================================================
-- STEP 5: GENERATE MEDIA PERFORMANCE (2,000,000 records)
-- ============================================================================

INSERT INTO MEDIA_PERFORMANCE (
    PERFORMANCE_ID, PLACEMENT_ID, PERFORMANCE_DATE, IMPRESSIONS, REACH, FREQUENCY,
    CLICKS, VIDEO_VIEWS, VIDEO_COMPLETIONS, VIDEO_25_PCT, VIDEO_50_PCT, VIDEO_75_PCT,
    ENGAGEMENTS, LIKES, SHARES, COMMENTS, CONVERSIONS, CONVERSION_VALUE, SPEND,
    VIEWABILITY_RATE, BRAND_SAFETY_SCORE, CREATED_DATE
)
SELECT
    'PRF-' || LPAD(SEQ4()::VARCHAR, 10, '0') AS PERFORMANCE_ID,
    'PLC-' || LPAD(UNIFORM(0, 499999, RANDOM())::VARCHAR, 8, '0') AS PLACEMENT_ID,
    DATEADD(DAY, -UNIFORM(0, 365, RANDOM()), CURRENT_DATE()) AS PERFORMANCE_DATE,
    UNIFORM(100, 5000000, RANDOM()) AS IMPRESSIONS,
    IMPRESSIONS * UNIFORM(0.40, 0.70, RANDOM()) AS REACH,
    IMPRESSIONS / NULLIF(REACH, 0) AS FREQUENCY,
    IMPRESSIONS * UNIFORM(0.002, 0.05, RANDOM()) AS CLICKS,
    IMPRESSIONS * UNIFORM(0.30, 0.80, RANDOM()) AS VIDEO_VIEWS,
    VIDEO_VIEWS * UNIFORM(0.20, 0.60, RANDOM()) AS VIDEO_COMPLETIONS,
    VIDEO_VIEWS * UNIFORM(0.70, 0.95, RANDOM()) AS VIDEO_25_PCT,
    VIDEO_VIEWS * UNIFORM(0.50, 0.85, RANDOM()) AS VIDEO_50_PCT,
    VIDEO_VIEWS * UNIFORM(0.30, 0.70, RANDOM()) AS VIDEO_75_PCT,
    IMPRESSIONS * UNIFORM(0.01, 0.10, RANDOM()) AS ENGAGEMENTS,
    ENGAGEMENTS * UNIFORM(0.40, 0.70, RANDOM()) AS LIKES,
    ENGAGEMENTS * UNIFORM(0.05, 0.15, RANDOM()) AS SHARES,
    ENGAGEMENTS * UNIFORM(0.05, 0.20, RANDOM()) AS COMMENTS,
    CLICKS * UNIFORM(0.01, 0.15, RANDOM()) AS CONVERSIONS,
    CONVERSIONS * UNIFORM(50, 5000, RANDOM()) AS CONVERSION_VALUE,
    IMPRESSIONS * UNIFORM(0.002, 0.050, RANDOM()) AS SPEND,
    UNIFORM(0.50, 0.95, RANDOM())::NUMBER(5,4) AS VIEWABILITY_RATE,
    UNIFORM(85, 100, RANDOM())::NUMBER(5,2) AS BRAND_SAFETY_SCORE,
    PERFORMANCE_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 2000000));

-- ============================================================================
-- STEP 6: GENERATE EMPLOYEES (1,000 records)
-- ============================================================================

INSERT INTO EMPLOYEES (
    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, DEPARTMENT, TITLE,
    EMPLOYMENT_TYPE, HIRE_DATE, TERMINATION_DATE, HOURLY_RATE, ANNUAL_SALARY,
    BILLABLE_RATE, MANAGER_ID, SKILLS, CERTIFICATIONS, UTILIZATION_TARGET, STATUS, CREATED_DATE
)
SELECT
    'EMP-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS EMPLOYEE_ID,
    CASE MOD(SEQ4(), 50)
        WHEN 0 THEN 'James' WHEN 1 THEN 'Mary' WHEN 2 THEN 'John' WHEN 3 THEN 'Patricia' WHEN 4 THEN 'Robert'
        WHEN 5 THEN 'Jennifer' WHEN 6 THEN 'Michael' WHEN 7 THEN 'Linda' WHEN 8 THEN 'William' WHEN 9 THEN 'Elizabeth'
        WHEN 10 THEN 'David' WHEN 11 THEN 'Barbara' WHEN 12 THEN 'Richard' WHEN 13 THEN 'Susan' WHEN 14 THEN 'Joseph'
        WHEN 15 THEN 'Jessica' WHEN 16 THEN 'Thomas' WHEN 17 THEN 'Sarah' WHEN 18 THEN 'Charles' WHEN 19 THEN 'Karen'
        WHEN 20 THEN 'Christopher' WHEN 21 THEN 'Nancy' WHEN 22 THEN 'Daniel' WHEN 23 THEN 'Lisa' WHEN 24 THEN 'Matthew'
        WHEN 25 THEN 'Betty' WHEN 26 THEN 'Anthony' WHEN 27 THEN 'Margaret' WHEN 28 THEN 'Mark' WHEN 29 THEN 'Sandra'
        WHEN 30 THEN 'Donald' WHEN 31 THEN 'Ashley' WHEN 32 THEN 'Steven' WHEN 33 THEN 'Kimberly' WHEN 34 THEN 'Paul'
        WHEN 35 THEN 'Emily' WHEN 36 THEN 'Andrew' WHEN 37 THEN 'Donna' WHEN 38 THEN 'Joshua' WHEN 39 THEN 'Michelle'
        WHEN 40 THEN 'Kenneth' WHEN 41 THEN 'Dorothy' WHEN 42 THEN 'Kevin' WHEN 43 THEN 'Carol' WHEN 44 THEN 'Brian'
        WHEN 45 THEN 'Amanda' WHEN 46 THEN 'George' WHEN 47 THEN 'Melissa' WHEN 48 THEN 'Timothy' ELSE 'Deborah'
    END AS FIRST_NAME,
    CASE MOD(SEQ4(), 40)
        WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' WHEN 3 THEN 'Brown' WHEN 4 THEN 'Jones'
        WHEN 5 THEN 'Garcia' WHEN 6 THEN 'Miller' WHEN 7 THEN 'Davis' WHEN 8 THEN 'Rodriguez' WHEN 9 THEN 'Martinez'
        WHEN 10 THEN 'Hernandez' WHEN 11 THEN 'Lopez' WHEN 12 THEN 'Gonzalez' WHEN 13 THEN 'Wilson' WHEN 14 THEN 'Anderson'
        WHEN 15 THEN 'Thomas' WHEN 16 THEN 'Taylor' WHEN 17 THEN 'Moore' WHEN 18 THEN 'Jackson' WHEN 19 THEN 'Martin'
        WHEN 20 THEN 'Lee' WHEN 21 THEN 'Perez' WHEN 22 THEN 'Thompson' WHEN 23 THEN 'White' WHEN 24 THEN 'Harris'
        WHEN 25 THEN 'Sanchez' WHEN 26 THEN 'Clark' WHEN 27 THEN 'Ramirez' WHEN 28 THEN 'Lewis' WHEN 29 THEN 'Robinson'
        WHEN 30 THEN 'Walker' WHEN 31 THEN 'Young' WHEN 32 THEN 'Allen' WHEN 33 THEN 'King' WHEN 34 THEN 'Wright'
        WHEN 35 THEN 'Scott' WHEN 36 THEN 'Torres' WHEN 37 THEN 'Nguyen' WHEN 38 THEN 'Hill' ELSE 'Flores'
    END AS LAST_NAME,
    LOWER(FIRST_NAME) || '.' || LOWER(LAST_NAME) || '@innoceanusa.com' AS EMAIL,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 'CREATIVE'
        WHEN 1 THEN 'MEDIA'
        WHEN 2 THEN 'ACCOUNT'
        WHEN 3 THEN 'STRATEGY'
        WHEN 4 THEN 'PRODUCTION'
        WHEN 5 THEN 'FINANCE'
        ELSE 'HR'
    END AS DEPARTMENT,
    CASE DEPARTMENT
        WHEN 'CREATIVE' THEN CASE MOD(SEQ4(), 6) WHEN 0 THEN 'Creative Director' WHEN 1 THEN 'Art Director' WHEN 2 THEN 'Copywriter' WHEN 3 THEN 'Designer' WHEN 4 THEN 'Associate Creative Director' ELSE 'Junior Designer' END
        WHEN 'MEDIA' THEN CASE MOD(SEQ4(), 6) WHEN 0 THEN 'Media Director' WHEN 1 THEN 'Media Supervisor' WHEN 2 THEN 'Media Planner' WHEN 3 THEN 'Media Buyer' WHEN 4 THEN 'Digital Strategist' ELSE 'Associate Media Planner' END
        WHEN 'ACCOUNT' THEN CASE MOD(SEQ4(), 6) WHEN 0 THEN 'VP Account Director' WHEN 1 THEN 'Account Director' WHEN 2 THEN 'Account Supervisor' WHEN 3 THEN 'Account Executive' WHEN 4 THEN 'Account Manager' ELSE 'Account Coordinator' END
        WHEN 'STRATEGY' THEN CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Chief Strategy Officer' WHEN 1 THEN 'Strategy Director' WHEN 2 THEN 'Brand Strategist' WHEN 3 THEN 'Consumer Insights Manager' ELSE 'Junior Strategist' END
        WHEN 'PRODUCTION' THEN CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Head of Production' WHEN 1 THEN 'Senior Producer' WHEN 2 THEN 'Producer' WHEN 3 THEN 'Production Coordinator' ELSE 'Traffic Manager' END
        WHEN 'FINANCE' THEN CASE MOD(SEQ4(), 4) WHEN 0 THEN 'CFO' WHEN 1 THEN 'Finance Director' WHEN 2 THEN 'Senior Accountant' ELSE 'Billing Specialist' END
        ELSE CASE MOD(SEQ4(), 4) WHEN 0 THEN 'HR Director' WHEN 1 THEN 'HR Manager' WHEN 2 THEN 'Recruiter' ELSE 'HR Coordinator' END
    END AS TITLE,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'CONTRACTOR'
        WHEN 1 THEN 'FREELANCE'
        ELSE 'FTE'
    END AS EMPLOYMENT_TYPE,
    DATEADD(DAY, -UNIFORM(30, 3650, RANDOM()), CURRENT_DATE()) AS HIRE_DATE,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 10 THEN DATEADD(DAY, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) ELSE NULL END AS TERMINATION_DATE,
    UNIFORM(35, 250, RANDOM())::NUMBER(8,2) AS HOURLY_RATE,
    HOURLY_RATE * 2080 AS ANNUAL_SALARY,
    HOURLY_RATE * UNIFORM(1.5, 3.0, RANDOM())::NUMBER(8,2) AS BILLABLE_RATE,
    CASE WHEN MOD(SEQ4(), 10) != 0 THEN 'EMP-' || LPAD(UNIFORM(0, 100, RANDOM())::VARCHAR, 6, '0') ELSE NULL END AS MANAGER_ID,
    CASE DEPARTMENT
        WHEN 'CREATIVE' THEN 'Adobe Creative Suite, Figma, After Effects, Cinema 4D, Photography'
        WHEN 'MEDIA' THEN 'Google Ads, Meta Business Suite, DV360, Trade Desk, Excel, SQL'
        WHEN 'ACCOUNT' THEN 'Client Management, Presentation, Project Management, Salesforce'
        WHEN 'STRATEGY' THEN 'Research, Analytics, Consumer Insights, Brand Strategy, Competitive Analysis'
        WHEN 'PRODUCTION' THEN 'Video Production, Post Production, Talent Management, Budget Management'
        WHEN 'FINANCE' THEN 'Accounting, Financial Analysis, Budgeting, SAP, QuickBooks'
        ELSE 'Recruiting, Employee Relations, Benefits Administration, Workday'
    END AS SKILLS,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Google Ads Certified, Meta Blueprint'
        WHEN 1 THEN 'Adobe Certified Expert'
        WHEN 2 THEN 'PMP Certified'
        WHEN 3 THEN 'CPA, CMA'
        ELSE NULL
    END AS CERTIFICATIONS,
    UNIFORM(0.70, 0.90, RANDOM())::NUMBER(5,2) AS UTILIZATION_TARGET,
    CASE WHEN TERMINATION_DATE IS NULL THEN 'ACTIVE' ELSE 'TERMINATED' END AS STATUS,
    HIRE_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

-- ============================================================================
-- STEP 7: GENERATE PROJECTS (50,000 records)
-- ============================================================================

INSERT INTO PROJECTS (
    PROJECT_ID, CLIENT_ID, CAMPAIGN_ID, PROJECT_NAME, PROJECT_TYPE,
    START_DATE, END_DATE, ESTIMATED_HOURS, ACTUAL_HOURS, ESTIMATED_BUDGET,
    ACTUAL_COST, BILLING_TYPE, PROJECT_LEAD_ID, STATUS, PROFIT_MARGIN, CREATED_DATE
)
SELECT
    'PRJ-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS PROJECT_ID,
    'CLI-' || LPAD(UNIFORM(0, 499, RANDOM())::VARCHAR, 6, '0') AS CLIENT_ID,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'CAM-' || LPAD(UNIFORM(0, 99999, RANDOM())::VARCHAR, 8, '0') ELSE NULL END AS CAMPAIGN_ID,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'Q1 Brand Campaign'
        WHEN 1 THEN 'Product Launch'
        WHEN 2 THEN 'Annual Media Plan'
        WHEN 3 THEN 'Holiday Creative'
        WHEN 4 THEN 'Digital Transformation'
        WHEN 5 THEN 'Social Strategy'
        WHEN 6 THEN 'TV Production'
        WHEN 7 THEN 'Research Study'
        WHEN 8 THEN 'Brand Refresh'
        WHEN 9 THEN 'Dealer Support'
        WHEN 10 THEN 'Event Activation'
        WHEN 11 THEN 'Content Development'
        WHEN 12 THEN 'Competitive Analysis'
        WHEN 13 THEN 'Website Redesign'
        ELSE 'Retainer Work'
    END || ' ' || (2020 + MOD(SEQ4(), 6))::VARCHAR AS PROJECT_NAME,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'CAMPAIGN'
        WHEN 1 THEN 'PRODUCTION'
        WHEN 2 THEN 'STRATEGY'
        WHEN 3 THEN 'RESEARCH'
        ELSE 'RETAINER_WORK'
    END AS PROJECT_TYPE,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS START_DATE,
    DATEADD(DAY, UNIFORM(14, 180, RANDOM()), START_DATE) AS END_DATE,
    UNIFORM(50, 5000, RANDOM())::NUMBER(10,2) AS ESTIMATED_HOURS,
    ESTIMATED_HOURS * UNIFORM(0.80, 1.30, RANDOM())::NUMBER(10,2) AS ACTUAL_HOURS,
    UNIFORM(10000, 2000000, RANDOM())::NUMBER(12,2) AS ESTIMATED_BUDGET,
    ESTIMATED_BUDGET * UNIFORM(0.85, 1.15, RANDOM())::NUMBER(12,2) AS ACTUAL_COST,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'FIXED_FEE'
        WHEN 1 THEN 'HOURLY'
        WHEN 2 THEN 'RETAINER'
        ELSE 'COMMISSION'
    END AS BILLING_TYPE,
    'EMP-' || LPAD(UNIFORM(0, 999, RANDOM())::VARCHAR, 6, '0') AS PROJECT_LEAD_ID,
    CASE 
        WHEN END_DATE < CURRENT_DATE() THEN 'COMPLETED'
        WHEN START_DATE > CURRENT_DATE() THEN 'PLANNED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'ACTIVE'
        ELSE 'ON_HOLD'
    END AS STATUS,
    (ESTIMATED_BUDGET - ACTUAL_COST) / NULLIF(ESTIMATED_BUDGET, 0) AS PROFIT_MARGIN,
    DATEADD(DAY, -UNIFORM(1, 30, RANDOM()), START_DATE) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

-- ============================================================================
-- STEP 8: GENERATE TIMESHEETS (500,000 records)
-- ============================================================================

INSERT INTO TIMESHEETS (
    TIMESHEET_ID, EMPLOYEE_ID, PROJECT_ID, WORK_DATE, HOURS_WORKED,
    BILLABLE_HOURS, TASK_TYPE, TASK_DESCRIPTION, APPROVED, APPROVED_BY, APPROVED_DATE, CREATED_DATE
)
SELECT
    'TSH-' || LPAD(SEQ4()::VARCHAR, 10, '0') AS TIMESHEET_ID,
    'EMP-' || LPAD(UNIFORM(0, 999, RANDOM())::VARCHAR, 6, '0') AS EMPLOYEE_ID,
    'PRJ-' || LPAD(UNIFORM(0, 49999, RANDOM())::VARCHAR, 8, '0') AS PROJECT_ID,
    DATEADD(DAY, -UNIFORM(0, 365, RANDOM()), CURRENT_DATE()) AS WORK_DATE,
    UNIFORM(0.5, 12.0, RANDOM())::NUMBER(5,2) AS HOURS_WORKED,
    HOURS_WORKED * UNIFORM(0.70, 1.0, RANDOM())::NUMBER(5,2) AS BILLABLE_HOURS,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'CREATIVE'
        WHEN 1 THEN 'STRATEGY'
        WHEN 2 THEN 'MEETINGS'
        WHEN 3 THEN 'ADMIN'
        WHEN 4 THEN 'PRODUCTION'
        ELSE 'REVIEW'
    END AS TASK_TYPE,
    CASE TASK_TYPE
        WHEN 'CREATIVE' THEN 'Creative development and design work'
        WHEN 'STRATEGY' THEN 'Strategic planning and analysis'
        WHEN 'MEETINGS' THEN 'Client and internal meetings'
        WHEN 'ADMIN' THEN 'Administrative tasks'
        WHEN 'PRODUCTION' THEN 'Production coordination'
        ELSE 'Review and revisions'
    END AS TASK_DESCRIPTION,
    CASE WHEN WORK_DATE < DATEADD(DAY, -7, CURRENT_DATE()) THEN TRUE ELSE FALSE END AS APPROVED,
    CASE WHEN APPROVED THEN 'EMP-' || LPAD(UNIFORM(0, 100, RANDOM())::VARCHAR, 6, '0') ELSE NULL END AS APPROVED_BY,
    CASE WHEN APPROVED THEN DATEADD(DAY, UNIFORM(1, 7, RANDOM()), WORK_DATE) ELSE NULL END AS APPROVED_DATE,
    WORK_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 500000));

-- ============================================================================
-- STEP 9: GENERATE INVOICES (200,000 records)
-- ============================================================================

INSERT INTO INVOICES (
    INVOICE_ID, CLIENT_ID, PROJECT_ID, INVOICE_NUMBER, INVOICE_DATE, DUE_DATE,
    SUBTOTAL, TAX_AMOUNT, TOTAL_AMOUNT, AMOUNT_PAID, PAYMENT_DATE,
    STATUS, PAYMENT_TERMS, NOTES, CREATED_DATE
)
SELECT
    'INV-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS INVOICE_ID,
    'CLI-' || LPAD(UNIFORM(0, 499, RANDOM())::VARCHAR, 6, '0') AS CLIENT_ID,
    'PRJ-' || LPAD(UNIFORM(0, 49999, RANDOM())::VARCHAR, 8, '0') AS PROJECT_ID,
    'INV-' || (2020 + MOD(SEQ4(), 6))::VARCHAR || '-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS INVOICE_NUMBER,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS INVOICE_DATE,
    DATEADD(DAY, CASE MOD(SEQ4(), 3) WHEN 0 THEN 30 WHEN 1 THEN 45 ELSE 60 END, INVOICE_DATE) AS DUE_DATE,
    UNIFORM(5000, 500000, RANDOM())::NUMBER(15,2) AS SUBTOTAL,
    SUBTOTAL * 0.0875 AS TAX_AMOUNT,
    SUBTOTAL + TAX_AMOUNT AS TOTAL_AMOUNT,
    CASE 
        WHEN INVOICE_DATE < DATEADD(DAY, -60, CURRENT_DATE()) THEN TOTAL_AMOUNT
        WHEN INVOICE_DATE < DATEADD(DAY, -30, CURRENT_DATE()) THEN TOTAL_AMOUNT * UNIFORM(0, 1, RANDOM())
        ELSE 0
    END AS AMOUNT_PAID,
    CASE WHEN AMOUNT_PAID > 0 THEN DATEADD(DAY, UNIFORM(1, 45, RANDOM()), INVOICE_DATE) ELSE NULL END AS PAYMENT_DATE,
    CASE 
        WHEN AMOUNT_PAID >= TOTAL_AMOUNT THEN 'PAID'
        WHEN DUE_DATE < CURRENT_DATE() AND AMOUNT_PAID < TOTAL_AMOUNT THEN 'OVERDUE'
        WHEN AMOUNT_PAID > 0 THEN 'SENT'
        ELSE 'DRAFT'
    END AS STATUS,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'NET30' WHEN 1 THEN 'NET45' ELSE 'NET60' END AS PAYMENT_TERMS,
    'Invoice for professional services rendered' AS NOTES,
    INVOICE_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 200000));

-- ============================================================================
-- STEP 10: GENERATE INVOICE LINE ITEMS (600,000 records)
-- ============================================================================

INSERT INTO INVOICE_LINE_ITEMS (
    LINE_ITEM_ID, INVOICE_ID, DESCRIPTION, QUANTITY, UNIT_PRICE, LINE_TOTAL, CATEGORY, BILLABLE_TYPE, CREATED_DATE
)
SELECT
    'LIN-' || LPAD(SEQ4()::VARCHAR, 10, '0') AS LINE_ITEM_ID,
    'INV-' || LPAD(UNIFORM(0, 199999, RANDOM())::VARCHAR, 8, '0') AS INVOICE_ID,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Creative Development Services'
        WHEN 1 THEN 'Media Planning and Buying'
        WHEN 2 THEN 'Production Services'
        WHEN 3 THEN 'Strategy Consulting'
        WHEN 4 THEN 'Account Management'
        WHEN 5 THEN 'Research and Analytics'
        WHEN 6 THEN 'Digital Marketing Services'
        WHEN 7 THEN 'Video Production'
        WHEN 8 THEN 'Talent Fees'
        ELSE 'Miscellaneous Expenses'
    END AS DESCRIPTION,
    UNIFORM(1, 100, RANDOM())::NUMBER(10,2) AS QUANTITY,
    UNIFORM(100, 5000, RANDOM())::NUMBER(12,2) AS UNIT_PRICE,
    QUANTITY * UNIT_PRICE AS LINE_TOTAL,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'MEDIA'
        WHEN 1 THEN 'PRODUCTION'
        WHEN 2 THEN 'FEES'
        WHEN 3 THEN 'TALENT'
        WHEN 4 THEN 'TRAVEL'
        ELSE 'MISC'
    END AS CATEGORY,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'TIME'
        WHEN 1 THEN 'EXPENSE'
        WHEN 2 THEN 'COMMISSION'
        ELSE 'MARKUP'
    END AS BILLABLE_TYPE,
    CURRENT_TIMESTAMP() AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 600000));

-- ============================================================================
-- STEP 11: GENERATE VENDORS (200 records)
-- ============================================================================

INSERT INTO VENDORS (
    VENDOR_ID, VENDOR_NAME, VENDOR_TYPE, CONTACT_NAME, CONTACT_EMAIL, CONTACT_PHONE,
    ADDRESS, PAYMENT_TERMS, PREFERRED_VENDOR, QUALITY_RATING, STATUS, CREATED_DATE
)
SELECT
    'VND-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS VENDOR_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Blackbird Productions'
        WHEN 1 THEN 'Lighthouse Post'
        WHEN 2 THEN 'Sonic Union'
        WHEN 3 THEN 'Company 3'
        WHEN 4 THEN 'MPC'
        WHEN 5 THEN 'The Mill'
        WHEN 6 THEN 'Framestore'
        WHEN 7 THEN 'Method Studios'
        WHEN 8 THEN 'Biscuit Filmworks'
        WHEN 9 THEN 'RadicalMedia'
        WHEN 10 THEN 'RSA Films'
        WHEN 11 THEN 'MJZ'
        WHEN 12 THEN 'Anonymous Content'
        WHEN 13 THEN 'Smuggler'
        WHEN 14 THEN 'Caviar'
        WHEN 15 THEN 'Park Pictures'
        WHEN 16 THEN 'Psyop'
        WHEN 17 THEN 'Brand New School'
        WHEN 18 THEN 'Buck'
        ELSE 'Hornet'
    END || ' ' || LPAD(SEQ4()::VARCHAR, 3, '0') AS VENDOR_NAME,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 'PRODUCTION'
        WHEN 1 THEN 'POST'
        WHEN 2 THEN 'MUSIC'
        WHEN 3 THEN 'PHOTOGRAPHY'
        WHEN 4 THEN 'MEDIA'
        WHEN 5 THEN 'RESEARCH'
        ELSE 'TECH'
    END AS VENDOR_TYPE,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Alex Producer'
        WHEN 1 THEN 'Sam Creative'
        WHEN 2 THEN 'Jordan Director'
        WHEN 3 THEN 'Taylor Manager'
        WHEN 4 THEN 'Morgan Sales'
        ELSE 'Casey Representative'
    END AS CONTACT_NAME,
    LOWER(REPLACE(CONTACT_NAME, ' ', '.')) || '@' || LOWER(REPLACE(REPLACE(VENDOR_NAME, ' ', ''), '''', '')) || '.com' AS CONTACT_EMAIL,
    '(310) ' || UNIFORM(100, 999, RANDOM())::VARCHAR || '-' || UNIFORM(1000, 9999, RANDOM())::VARCHAR AS CONTACT_PHONE,
    UNIFORM(100, 9999, RANDOM())::VARCHAR || ' Creative Way, Los Angeles, CA 90028' AS ADDRESS,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'NET30' WHEN 1 THEN 'NET45' ELSE 'NET60' END AS PAYMENT_TERMS,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 30 THEN TRUE ELSE FALSE END AS PREFERRED_VENDOR,
    ROUND(UNIFORM(6.0, 10.0, RANDOM()), 1) AS QUALITY_RATING,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'ACTIVE' ELSE 'INACTIVE' END AS STATUS,
    DATEADD(DAY, -UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 200));

-- ============================================================================
-- STEP 12: GENERATE VENDOR CONTRACTS (500 records)
-- ============================================================================

INSERT INTO VENDOR_CONTRACTS (
    CONTRACT_ID, VENDOR_ID, CONTRACT_NAME, START_DATE, END_DATE, CONTRACT_VALUE, TERMS, STATUS, CREATED_DATE
)
SELECT
    'VCT-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS CONTRACT_ID,
    'VND-' || LPAD(UNIFORM(0, 199, RANDOM())::VARCHAR, 6, '0') AS VENDOR_ID,
    'Service Agreement ' || (2020 + MOD(SEQ4(), 6))::VARCHAR AS CONTRACT_NAME,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS START_DATE,
    DATEADD(DAY, UNIFORM(365, 1095, RANDOM()), START_DATE) AS END_DATE,
    UNIFORM(50000, 5000000, RANDOM())::NUMBER(15,2) AS CONTRACT_VALUE,
    'Standard terms and conditions apply. Payment terms as specified. Confidentiality agreement included.' AS TERMS,
    CASE 
        WHEN END_DATE < CURRENT_DATE() THEN 'EXPIRED'
        WHEN START_DATE > CURRENT_DATE() THEN 'DRAFT'
        ELSE 'ACTIVE'
    END AS STATUS,
    DATEADD(DAY, -UNIFORM(1, 30, RANDOM()), START_DATE) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- ============================================================================
-- STEP 13: GENERATE TALENT (500 records)
-- ============================================================================

INSERT INTO TALENT (
    TALENT_ID, TALENT_NAME, TALENT_TYPE, AGENCY_NAME, AGENT_NAME, AGENT_EMAIL,
    DAY_RATE, USAGE_RATE, EXCLUSIVITY_CATEGORY, STATUS, CREATED_DATE
)
SELECT
    'TLT-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS TALENT_ID,
    CASE MOD(SEQ4(), 50)
        WHEN 0 THEN 'Marcus Johnson' WHEN 1 THEN 'Sophia Chen' WHEN 2 THEN 'James Wilson' WHEN 3 THEN 'Emma Rodriguez'
        WHEN 4 THEN 'William Kim' WHEN 5 THEN 'Olivia Martinez' WHEN 6 THEN 'Benjamin Lee' WHEN 7 THEN 'Ava Thompson'
        WHEN 8 THEN 'Lucas Garcia' WHEN 9 THEN 'Mia Anderson' WHEN 10 THEN 'Henry Brown' WHEN 11 THEN 'Isabella Davis'
        WHEN 12 THEN 'Alexander Miller' WHEN 13 THEN 'Charlotte Taylor' WHEN 14 THEN 'Daniel Moore' WHEN 15 THEN 'Amelia Jackson'
        WHEN 16 THEN 'Matthew White' WHEN 17 THEN 'Harper Harris' WHEN 18 THEN 'Joseph Martin' WHEN 19 THEN 'Evelyn Clark'
        WHEN 20 THEN 'David Lewis' WHEN 21 THEN 'Abigail Walker' WHEN 22 THEN 'Andrew Hall' WHEN 23 THEN 'Emily Young'
        WHEN 24 THEN 'Christopher King' WHEN 25 THEN 'Elizabeth Scott' WHEN 26 THEN 'Joshua Green' WHEN 27 THEN 'Sofia Adams'
        WHEN 28 THEN 'Ryan Baker' WHEN 29 THEN 'Avery Nelson' WHEN 30 THEN 'Nathan Hill' WHEN 31 THEN 'Scarlett Rivera'
        WHEN 32 THEN 'Brandon Campbell' WHEN 33 THEN 'Victoria Mitchell' WHEN 34 THEN 'Tyler Roberts' WHEN 35 THEN 'Grace Carter'
        WHEN 36 THEN 'Kevin Phillips' WHEN 37 THEN 'Chloe Evans' WHEN 38 THEN 'Justin Turner' WHEN 39 THEN 'Lily Parker'
        WHEN 40 THEN 'Austin Collins' WHEN 41 THEN 'Zoey Edwards' WHEN 42 THEN 'Dylan Stewart' WHEN 43 THEN 'Penelope Sanchez'
        WHEN 44 THEN 'Aaron Morris' WHEN 45 THEN 'Riley Rogers' WHEN 46 THEN 'Chase Reed' WHEN 47 THEN 'Layla Cook'
        WHEN 48 THEN 'Jason Morgan' ELSE 'Hannah Bell'
    END AS TALENT_NAME,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'ACTOR'
        WHEN 1 THEN 'MODEL'
        WHEN 2 THEN 'VOICEOVER'
        WHEN 3 THEN 'INFLUENCER'
        ELSE 'CELEBRITY'
    END AS TALENT_TYPE,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'CAA' WHEN 1 THEN 'WME' WHEN 2 THEN 'UTA' WHEN 3 THEN 'ICM'
        WHEN 4 THEN 'Paradigm' WHEN 5 THEN 'APA' WHEN 6 THEN 'Abrams Artists'
        WHEN 7 THEN 'Innovative Artists' WHEN 8 THEN 'Gersh' ELSE 'Independent'
    END AS AGENCY_NAME,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Jennifer Agent' WHEN 1 THEN 'Michael Representative' WHEN 2 THEN 'Sarah Manager'
        WHEN 3 THEN 'David Handler' WHEN 4 THEN 'Lisa Booker' ELSE 'Robert Contact'
    END AS AGENT_NAME,
    LOWER(REPLACE(AGENT_NAME, ' ', '.')) || '@' || LOWER(REPLACE(AGENCY_NAME, ' ', '')) || '.com' AS AGENT_EMAIL,
    UNIFORM(500, 50000, RANDOM())::NUMBER(12,2) AS DAY_RATE,
    DAY_RATE * UNIFORM(2, 10, RANDOM())::NUMBER(12,2) AS USAGE_RATE,
    CASE MOD(SEQ4(), 3)
        WHEN 0 THEN 'AUTOMOTIVE'
        WHEN 1 THEN 'NONE'
        ELSE 'BRAND_SPECIFIC'
    END AS EXCLUSIVITY_CATEGORY,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'ACTIVE' ELSE 'INACTIVE' END AS STATUS,
    DATEADD(DAY, -UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- ============================================================================
-- STEP 14: GENERATE TALENT USAGE (10,000 records)
-- ============================================================================

INSERT INTO TALENT_USAGE (
    USAGE_ID, TALENT_ID, ASSET_ID, USAGE_TYPE, TERRITORY, START_DATE, END_DATE,
    USAGE_FEE, RENEWAL_DATE, STATUS, CREATED_DATE
)
SELECT
    'TUS-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS USAGE_ID,
    'TLT-' || LPAD(UNIFORM(0, 499, RANDOM())::VARCHAR, 6, '0') AS TALENT_ID,
    'AST-' || LPAD(UNIFORM(0, 249999, RANDOM())::VARCHAR, 8, '0') AS ASSET_ID,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'BROADCAST'
        WHEN 1 THEN 'DIGITAL'
        WHEN 2 THEN 'SOCIAL'
        WHEN 3 THEN 'PRINT'
        ELSE 'OOH'
    END AS USAGE_TYPE,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'US'
        WHEN 1 THEN 'NORTH_AMERICA'
        WHEN 2 THEN 'GLOBAL'
        ELSE 'REGIONAL'
    END AS TERRITORY,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS START_DATE,
    DATEADD(DAY, UNIFORM(90, 365, RANDOM()), START_DATE) AS END_DATE,
    UNIFORM(5000, 500000, RANDOM())::NUMBER(12,2) AS USAGE_FEE,
    DATEADD(DAY, -30, END_DATE) AS RENEWAL_DATE,
    CASE 
        WHEN END_DATE < CURRENT_DATE() THEN 'EXPIRED'
        WHEN RENEWAL_DATE < CURRENT_DATE() AND END_DATE >= CURRENT_DATE() THEN 'PENDING_RENEWAL'
        ELSE 'ACTIVE'
    END AS STATUS,
    START_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

-- ============================================================================
-- STEP 15: GENERATE AUDIENCE SEGMENTS (100 records)
-- ============================================================================

INSERT INTO AUDIENCE_SEGMENTS (
    SEGMENT_ID, SEGMENT_NAME, SEGMENT_TYPE, DESCRIPTION, AGE_MIN, AGE_MAX,
    GENDER, INCOME_MIN, INCOME_MAX, INTERESTS, BEHAVIORS, GEO_TARGETING,
    ESTIMATED_SIZE, DATA_SOURCE, STATUS, CREATED_DATE
)
SELECT
    'SEG-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS SEGMENT_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'In-Market Auto Buyers'
        WHEN 1 THEN 'Luxury Intenders'
        WHEN 2 THEN 'First-Time Buyers'
        WHEN 3 THEN 'Family SUV Shoppers'
        WHEN 4 THEN 'EV Enthusiasts'
        WHEN 5 THEN 'Urban Millennials'
        WHEN 6 THEN 'Suburban Families'
        WHEN 7 THEN 'Gen Z Digital Natives'
        WHEN 8 THEN 'Conquest Segment'
        WHEN 9 THEN 'Current Owners'
        WHEN 10 THEN 'High Income Professionals'
        WHEN 11 THEN 'Outdoor Adventurers'
        WHEN 12 THEN 'Tech-Forward Consumers'
        WHEN 13 THEN 'Value Seekers'
        WHEN 14 THEN 'Performance Enthusiasts'
        WHEN 15 THEN 'Safety-Conscious Parents'
        WHEN 16 THEN 'Eco-Conscious Consumers'
        WHEN 17 THEN 'Commuters'
        WHEN 18 THEN 'Empty Nesters'
        ELSE 'Young Professionals'
    END AS SEGMENT_NAME,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'DEMOGRAPHIC'
        WHEN 1 THEN 'BEHAVIORAL'
        WHEN 2 THEN 'INTEREST'
        WHEN 3 THEN 'CUSTOM'
        ELSE 'LOOKALIKE'
    END AS SEGMENT_TYPE,
    'Target audience segment for advertising campaigns based on ' || SEGMENT_TYPE || ' criteria' AS DESCRIPTION,
    UNIFORM(18, 35, RANDOM()) AS AGE_MIN,
    UNIFORM(45, 75, RANDOM()) AS AGE_MAX,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'ALL' WHEN 1 THEN 'MALE' ELSE 'FEMALE' END AS GENDER,
    UNIFORM(30000, 75000, RANDOM()) AS INCOME_MIN,
    UNIFORM(100000, 300000, RANDOM()) AS INCOME_MAX,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Automotive, Technology, Travel'
        WHEN 1 THEN 'Luxury, Fashion, Fine Dining'
        WHEN 2 THEN 'Family, Home, Education'
        WHEN 3 THEN 'Outdoor, Sports, Adventure'
        ELSE 'Technology, Gaming, Entertainment'
    END AS INTERESTS,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Online car shopping, Dealer visits'
        WHEN 1 THEN 'Premium purchases, Brand loyalty'
        WHEN 2 THEN 'Research-heavy, Comparison shopping'
        WHEN 3 THEN 'Mobile-first, Social media active'
        ELSE 'Early adopter, Tech savvy'
    END AS BEHAVIORS,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'National US'
        WHEN 1 THEN 'Top 25 DMAs'
        WHEN 2 THEN 'West Coast'
        ELSE 'East Coast'
    END AS GEO_TARGETING,
    UNIFORM(100000, 50000000, RANDOM()) AS ESTIMATED_SIZE,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'FIRST_PARTY'
        WHEN 1 THEN 'THIRD_PARTY'
        WHEN 2 THEN 'PLATFORM'
        ELSE 'RESEARCH'
    END AS DATA_SOURCE,
    'ACTIVE' AS STATUS,
    DATEADD(DAY, -UNIFORM(30, 730, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- ============================================================================
-- STEP 16: GENERATE CAMPAIGN AUDIENCES (200,000 records)
-- ============================================================================

INSERT INTO CAMPAIGN_AUDIENCES (
    ASSIGNMENT_ID, CAMPAIGN_ID, SEGMENT_ID, PRIORITY, BUDGET_ALLOCATION, CREATED_DATE
)
SELECT
    'CAS-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS ASSIGNMENT_ID,
    'CAM-' || LPAD(UNIFORM(0, 99999, RANDOM())::VARCHAR, 8, '0') AS CAMPAIGN_ID,
    'SEG-' || LPAD(UNIFORM(0, 99, RANDOM())::VARCHAR, 6, '0') AS SEGMENT_ID,
    UNIFORM(1, 3, RANDOM()) AS PRIORITY,
    UNIFORM(0.10, 0.50, RANDOM())::NUMBER(5,4) AS BUDGET_ALLOCATION,
    DATEADD(DAY, -UNIFORM(1, 365, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 200000));

-- ============================================================================
-- STEP 17: GENERATE CREATIVE BRIEFS (20,000 records)
-- ============================================================================

INSERT INTO CREATIVE_BRIEFS (
    BRIEF_ID, CLIENT_ID, CAMPAIGN_ID, BRIEF_TITLE, BRIEF_DATE, BRIEF_CONTENT,
    BRAND_NAME, PROJECT_TYPE, CAMPAIGN_OBJECTIVE, TARGET_AUDIENCE, KEY_MESSAGE,
    MANDATORY_ELEMENTS, COMPETITIVE_CONTEXT, SUCCESS_METRICS, TIMELINE, BUDGET_GUIDANCE,
    CREATED_BY, STATUS, CREATED_DATE
)
SELECT
    'BRF-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS BRIEF_ID,
    'CLI-' || LPAD(UNIFORM(0, 499, RANDOM())::VARCHAR, 6, '0') AS CLIENT_ID,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'CAM-' || LPAD(UNIFORM(0, 99999, RANDOM())::VARCHAR, 8, '0') ELSE NULL END AS CAMPAIGN_ID,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'New Vehicle Launch Campaign Brief'
        WHEN 1 THEN 'Brand Awareness Initiative Brief'
        WHEN 2 THEN 'Holiday Sales Event Brief'
        WHEN 3 THEN 'Digital-First Campaign Brief'
        WHEN 4 THEN 'Social Media Campaign Brief'
        WHEN 5 THEN 'Product Feature Highlight Brief'
        WHEN 6 THEN 'Competitive Conquest Brief'
        WHEN 7 THEN 'Customer Retention Brief'
        WHEN 8 THEN 'Multicultural Marketing Brief'
        WHEN 9 THEN 'Experiential Activation Brief'
        WHEN 10 THEN 'Sports Sponsorship Activation Brief'
        WHEN 11 THEN 'Influencer Partnership Brief'
        WHEN 12 THEN 'Dealer Support Campaign Brief'
        WHEN 13 THEN 'Electric Vehicle Launch Brief'
        ELSE 'Brand Refresh Campaign Brief'
    END || ' - ' || (2020 + MOD(SEQ4(), 6))::VARCHAR AS BRIEF_TITLE,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS BRIEF_DATE,
    'CREATIVE BRIEF\n\n' ||
    'PROJECT OVERVIEW:\n' ||
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'We are launching a new integrated campaign to drive awareness and consideration for our latest vehicle model. This campaign will span TV, digital, social, and experiential channels to create a cohesive brand experience that resonates with our target audience.'
        WHEN 1 THEN 'The objective of this campaign is to strengthen our brand positioning and differentiate ourselves from key competitors. We need creative that communicates our unique value proposition while maintaining brand consistency across all touchpoints.'
        WHEN 2 THEN 'This holiday sales event campaign aims to drive traffic to dealerships and increase sales during the crucial Q4 period. Creative should balance promotional messaging with brand storytelling to maintain premium perception.'
        WHEN 3 THEN 'We are developing a digital-first campaign to reach younger consumers where they spend most of their time. Content should be native to each platform while maintaining consistent brand messaging and visual identity.'
        WHEN 4 THEN 'This social media campaign will focus on engagement and community building. We need thumb-stopping creative that encourages sharing and conversation while authentically representing our brand voice.'
        WHEN 5 THEN 'The campaign will highlight specific product features that differentiate us from competitors. Creative should clearly communicate technical benefits in an emotionally engaging way that connects with consumer needs.'
        WHEN 6 THEN 'This conquest campaign targets current owners of competitive brands. Messaging should address pain points with competitor vehicles while highlighting our superior alternatives.'
        WHEN 7 THEN 'We need to strengthen relationships with current customers and encourage repeat purchases. Creative should recognize their loyalty while introducing new products and services.'
        WHEN 8 THEN 'This multicultural campaign will resonate with Hispanic and Asian-American audiences. Creative must be culturally authentic while maintaining brand consistency.'
        ELSE 'We are activating our sports sponsorship with an experiential campaign that brings fans closer to the action. Creative should leverage our partnership assets while creating shareable moments.'
    END ||
    '\n\nTARGET AUDIENCE INSIGHTS:\n' ||
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Our primary target is adults 25-54 with household income $75K+. They are in-market for a new vehicle within the next 6 months and value quality, reliability, and technology. They research extensively online before visiting dealerships.'
        WHEN 1 THEN 'We are targeting millennials aged 25-40 who live in urban areas and are tech-savvy. They prioritize sustainability and social responsibility in their purchasing decisions. They are heavy social media users and trust peer recommendations.'
        WHEN 2 THEN 'Gen Z consumers aged 18-24 are our focus for this campaign. They are digital natives who consume content primarily on mobile devices. They value authenticity and are skeptical of traditional advertising.'
        WHEN 3 THEN 'Families with children in suburban areas represent our core audience. They prioritize safety, space, and value. They make purchasing decisions collaboratively and are influenced by word-of-mouth.'
        WHEN 4 THEN 'Luxury intenders with HHI $150K+ seeking premium experiences. They appreciate craftsmanship, exclusivity, and personalized service. They are willing to pay more for superior quality.'
        WHEN 5 THEN 'First-time buyers who are credit-qualified and entering the market. They need guidance through the purchase process and value transparent pricing and financing options.'
        WHEN 6 THEN 'Current brand owners who are approaching the end of their lease or loan. They have positive brand experience and are likely to repurchase if presented with compelling offers.'
        ELSE 'Conquest targets who currently own competitive vehicles. They may be experiencing pain points with their current brand and are open to switching if presented with superior alternatives.'
    END ||
    '\n\nKEY INSIGHTS:\n' ||
    '- Consumer research indicates strong interest in ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'advanced technology features' WHEN 1 THEN 'fuel efficiency and sustainability' WHEN 2 THEN 'safety and reliability' WHEN 3 THEN 'design and styling' ELSE 'value and affordability' END ||
    '\n- Competitive analysis shows opportunity to differentiate on ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'warranty coverage' WHEN 1 THEN 'customer service' WHEN 2 THEN 'technology innovation' WHEN 3 THEN 'design language' ELSE 'price positioning' END ||
    '\n- Social listening reveals conversations around ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'electric vehicle adoption' WHEN 1 THEN 'connected car features' WHEN 2 THEN 'autonomous driving' WHEN 3 THEN 'sustainability initiatives' ELSE 'customer experience improvements' END ||
    '\n\nCREATIVE DIRECTION:\n' ||
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'The creative should feel aspirational yet attainable. Visual style should be cinematic with dynamic vehicle footage. Talent should reflect diversity of our target audience. Music should be contemporary and energetic.'
        WHEN 1 THEN 'We want a documentary-style approach that feels authentic and real. Real customers and employees should be featured. Visual style should be natural and unpolished. Soundtrack should be organic and emotional.'
        WHEN 2 THEN 'High-energy, fast-paced creative that captures attention quickly. Bold graphics and motion design. Music should be upbeat and trending. Quick cuts and dynamic transitions.'
        WHEN 3 THEN 'Elegant, sophisticated creative befitting a luxury brand. High production values with attention to detail. Premium locations and settings. Classical or ambient soundtrack.'
        WHEN 4 THEN 'Playful, fun creative that doesn''t take itself too seriously. Humor should be smart and relatable. Bright, vibrant color palette. Upbeat, catchy music.'
        ELSE 'Emotional storytelling that connects with human experiences. Focus on real moments and genuine connections. Warm, natural cinematography. Moving, inspirational soundtrack.'
    END AS BRIEF_CONTENT,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Hyundai' WHEN 1 THEN 'Kia' WHEN 2 THEN 'Genesis' WHEN 3 THEN 'Supernal'
        WHEN 4 THEN 'Hyundai Capital' ELSE 'Client Brand ' || MOD(SEQ4(), 50)::VARCHAR
    END AS BRAND_NAME,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'TV' WHEN 1 THEN 'DIGITAL' WHEN 2 THEN 'SOCIAL' WHEN 3 THEN 'INTEGRATED' ELSE 'OOH' END AS PROJECT_TYPE,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'AWARENESS' WHEN 1 THEN 'CONSIDERATION' WHEN 2 THEN 'CONVERSION' WHEN 3 THEN 'RETENTION' ELSE 'ADVOCACY' END AS CAMPAIGN_OBJECTIVE,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'Adults 25-54, HHI $75K+, In-market for vehicle'
        WHEN 1 THEN 'Millennials 25-40, Urban, Tech-savvy'
        WHEN 2 THEN 'Gen Z 18-24, Digital natives'
        WHEN 3 THEN 'Families with children, Suburban'
        WHEN 4 THEN 'Luxury intenders, HHI $150K+'
        ELSE 'Current owners, Loyalty segment'
    END AS TARGET_AUDIENCE,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Experience innovation that moves you forward'
        WHEN 1 THEN 'Designed for the way you live'
        WHEN 2 THEN 'Performance without compromise'
        WHEN 3 THEN 'Safety you can trust, style you deserve'
        WHEN 4 THEN 'The smart choice for smart drivers'
        WHEN 5 THEN 'Luxury redefined for modern life'
        WHEN 6 THEN 'Adventure awaits. Are you ready?'
        ELSE 'Drive your dreams'
    END AS KEY_MESSAGE,
    'Logo usage per brand guidelines, Legal disclaimers required, ' ||
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'EPA fuel economy statement' WHEN 1 THEN 'MSRP disclosure' WHEN 2 THEN 'Warranty information' ELSE 'Safety ratings' END AS MANDATORY_ELEMENTS,
    'Key competitors include Toyota, Honda, Ford, and ' || CASE MOD(SEQ4(), 4) WHEN 0 THEN 'BMW' WHEN 1 THEN 'Mercedes' WHEN 2 THEN 'Lexus' ELSE 'Tesla' END ||
    '. They are currently emphasizing ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'reliability' WHEN 1 THEN 'technology' WHEN 2 THEN 'value' WHEN 3 THEN 'sustainability' ELSE 'performance' END AS COMPETITIVE_CONTEXT,
    'KPIs include: Awareness lift of ' || UNIFORM(5, 15, RANDOM())::VARCHAR || '%, Consideration increase of ' || UNIFORM(3, 10, RANDOM())::VARCHAR || '%, ' ||
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Website traffic increase of 25%' WHEN 1 THEN 'Dealer visit increase of 15%' ELSE 'Lead generation of 10,000 qualified leads' END AS SUCCESS_METRICS,
    'Creative concept presentation: Week 2, Client review: Week 3, Revisions: Week 4, Final delivery: Week 6, Campaign launch: Week 8' AS TIMELINE,
    '$' || (UNIFORM(1, 10, RANDOM()) * 100000)::VARCHAR || ' - $' || (UNIFORM(11, 50, RANDOM()) * 100000)::VARCHAR AS BUDGET_GUIDANCE,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Sarah Johnson' WHEN 1 THEN 'Michael Chen' WHEN 2 THEN 'Emily Rodriguez'
        WHEN 3 THEN 'David Kim' WHEN 4 THEN 'Jessica Martinez' ELSE 'Robert Williams'
    END AS CREATED_BY,
    'ACTIVE' AS STATUS,
    BRIEF_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 20000));

-- ============================================================================
-- STEP 18: GENERATE CAMPAIGN REPORTS (15,000 records)
-- ============================================================================

INSERT INTO CAMPAIGN_REPORTS (
    REPORT_ID, CAMPAIGN_ID, REPORT_TITLE, REPORT_DATE, REPORT_CONTENT,
    REPORT_TYPE, EXECUTIVE_SUMMARY, KEY_INSIGHTS, RECOMMENDATIONS,
    PERFORMANCE_VS_BENCHMARK, OPTIMIZATION_ACTIONS, NEXT_STEPS, PREPARED_BY, STATUS, CREATED_DATE
)
SELECT
    'RPT-' || LPAD(SEQ4()::VARCHAR, 8, '0') AS REPORT_ID,
    'CAM-' || LPAD(UNIFORM(0, 99999, RANDOM())::VARCHAR, 8, '0') AS CAMPAIGN_ID,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Weekly Performance Report'
        WHEN 1 THEN 'Monthly Campaign Analysis'
        WHEN 2 THEN 'Quarterly Business Review'
        WHEN 3 THEN 'Campaign Final Report'
        ELSE 'Post-Mortem Analysis'
    END || ' - ' || (2020 + MOD(SEQ4(), 6))::VARCHAR || ' Q' || (1 + MOD(SEQ4(), 4))::VARCHAR AS REPORT_TITLE,
    DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS REPORT_DATE,
    'CAMPAIGN PERFORMANCE REPORT\n\n' ||
    'PERIOD: ' || CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Week ' || UNIFORM(1, 52, RANDOM())::VARCHAR WHEN 1 THEN 'Month ' || UNIFORM(1, 12, RANDOM())::VARCHAR WHEN 2 THEN 'Q' || UNIFORM(1, 4, RANDOM())::VARCHAR ELSE 'Full Campaign' END || '\n\n' ||
    'EXECUTIVE SUMMARY:\n' ||
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Campaign performance exceeded expectations across all key metrics. Impressions delivered at 115% of goal, with strong engagement rates particularly in digital channels. CTR outperformed industry benchmarks by 23%. Conversion rates improved week-over-week, indicating effective optimization efforts.'
        WHEN 1 THEN 'This reporting period showed steady performance with opportunities for optimization. While impression delivery was on target, engagement metrics fell slightly below benchmark. Recommend increasing frequency in high-performing segments and reallocating budget from underperforming placements.'
        WHEN 2 THEN 'Strong results driven by creative refresh mid-campaign. New video assets drove 45% higher completion rates versus previous creative. Social engagement increased significantly following influencer partnership activation. Overall ROAS improved to 4.2x.'
        WHEN 3 THEN 'Campaign reached target audience effectively with 85% reach against primary target. Brand lift study showed significant increases in awareness (+12 points) and consideration (+8 points). Purchase intent among exposed users increased by 15% versus control group.'
        WHEN 4 THEN 'Digital channels outperformed traditional media significantly. Programmatic display delivered efficient CPMs with strong viewability (78%). Connected TV showed highest completion rates. Recommend shifting additional budget to digital channels for remaining flight.'
        WHEN 5 THEN 'Performance varied by market with strongest results in coastal DMAs. Midwest markets showed lower engagement requiring localized creative approach. Recommend developing market-specific messaging for next campaign phase.'
        WHEN 6 THEN 'Attribution analysis reveals strong upper-funnel impact driving lower-funnel conversions. Users exposed to TV showed 35% higher conversion rates in digital channels. Multi-touch attribution model demonstrates value of integrated approach.'
        ELSE 'Competitive share of voice increased during campaign flight. Brand mentions positive sentiment improved from 65% to 78%. Share of search increased 12 points versus competitive set during campaign period.'
    END ||
    '\n\nKEY PERFORMANCE METRICS:\n' ||
    '- Impressions Delivered: ' || UNIFORM(1, 500, RANDOM())::VARCHAR || 'M (' || UNIFORM(95, 120, RANDOM())::VARCHAR || '% of goal)\n' ||
    '- Reach: ' || UNIFORM(10, 100, RANDOM())::VARCHAR || 'M unique users (' || UNIFORM(80, 110, RANDOM())::VARCHAR || '% of target)\n' ||
    '- Frequency: ' || ROUND(UNIFORM(2.0, 8.0, RANDOM()), 1)::VARCHAR || 'x average\n' ||
    '- CTR: ' || ROUND(UNIFORM(0.5, 3.0, RANDOM()), 2)::VARCHAR || '% (' || CASE WHEN UNIFORM(1, 100, RANDOM()) > 50 THEN '+' ELSE '-' END || UNIFORM(5, 30, RANDOM())::VARCHAR || '% vs benchmark)\n' ||
    '- Video Completion Rate: ' || UNIFORM(60, 90, RANDOM())::VARCHAR || '%\n' ||
    '- Conversions: ' || UNIFORM(1000, 50000, RANDOM())::VARCHAR || '\n' ||
    '- CPA: $' || UNIFORM(20, 200, RANDOM())::VARCHAR || '\n' ||
    '- ROAS: ' || ROUND(UNIFORM(2.0, 8.0, RANDOM()), 1)::VARCHAR || 'x\n' ||
    '\n\nCHANNEL BREAKDOWN:\n' ||
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN '- TV: Strong reach driver, 45% of impressions. Primetime spots outperformed daytime by 30%.\n- Digital Display: Efficient CPMs at $8.50. Programmatic outperformed direct by 15%.\n- Social: Highest engagement rates. Video content drove 3x engagement vs static.\n- Search: Lowest CPA at $25. Brand terms converting at 12%.'
        WHEN 1 THEN '- Connected TV: 85% completion rates, highest of all video channels. Hulu and YouTube TV top performers.\n- Programmatic: Behavioral targeting outperformed contextual by 25%. Retargeting showing diminishing returns.\n- Social: TikTok exceeding expectations with 2.5% engagement rate. Instagram Stories driving efficient reach.\n- Audio: Spotify showing strong reach among younger demo. Podcast sponsorships driving consideration.'
        WHEN 2 THEN '- Linear TV: Delivered reach goals but frequency may be excessive. Consider shifting to streaming.\n- OOH: High visibility in target markets. Digital billboards allowing message rotation.\n- Digital: Mobile outperforming desktop 2:1. In-app placements showing strong viewability.\n- Social: Influencer content outperforming brand content by 40% on engagement.'
        ELSE '- Video: Pre-roll showing best efficiency. Mid-roll on long-form content strong for completion.\n- Display: Native ads outperforming standard banners by 65%. High-impact units driving awareness.\n- Social: Stories format outperforming feed posts. User-generated content resonating strongly.\n- Search: Competitor conquesting delivering qualified traffic. Shopping campaigns driving direct conversions.'
    END ||
    '\n\nOPTIMIZATION ACTIONS TAKEN:\n' ||
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN '1. Increased bid on high-performing audience segments\n2. Paused underperforming creative variants\n3. Shifted budget from display to video based on engagement\n4. Added new lookalike audiences based on converters'
        WHEN 1 THEN '1. Implemented dayparting based on conversion patterns\n2. Refreshed creative to address ad fatigue\n3. Expanded targeting to include new behavioral segments\n4. Reduced frequency caps on retargeting'
        WHEN 2 THEN '1. A/B tested landing pages, improving conversion by 15%\n2. Optimized bid strategy from manual to automated\n3. Implemented cross-device targeting\n4. Added exclusion audiences to reduce waste'
        WHEN 3 THEN '1. Reallocated budget to top-performing DMAs\n2. Adjusted creative messaging for underperforming segments\n3. Increased video length based on completion data\n4. Implemented brand safety measures across programmatic'
        ELSE '1. Launched new creative concepts mid-campaign\n2. Expanded to additional platforms based on audience analysis\n3. Implemented sequential messaging strategy\n4. Optimized landing page load time improving bounce rate'
    END AS REPORT_CONTENT,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'WEEKLY' WHEN 1 THEN 'MONTHLY' WHEN 2 THEN 'QUARTERLY' WHEN 3 THEN 'FINAL' ELSE 'POST_MORTEM' END AS REPORT_TYPE,
    'Campaign ' || CASE WHEN UNIFORM(1, 100, RANDOM()) > 50 THEN 'exceeded' ELSE 'met' END || ' overall objectives with ' ||
    UNIFORM(95, 120, RANDOM())::VARCHAR || '% delivery against impressions goal and ' ||
    ROUND(UNIFORM(2.0, 6.0, RANDOM()), 1)::VARCHAR || 'x ROAS.' AS EXECUTIVE_SUMMARY,
    '1. ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Video content significantly outperformed static creative' WHEN 1 THEN 'Mobile engagement exceeded desktop by 2x' WHEN 2 THEN 'Retargeting showing highest conversion rates' WHEN 3 THEN 'Upper-funnel investment driving lower-funnel efficiency' ELSE 'Younger demographics engaging at higher rates' END ||
    '\n2. ' || CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Social platforms driving efficient awareness' WHEN 1 THEN 'Connected TV showing strong completion rates' WHEN 2 THEN 'Search capturing high-intent users' ELSE 'Programmatic delivering efficient CPMs' END ||
    '\n3. ' || CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Creative refresh mid-campaign improved performance' WHEN 1 THEN 'Audience expansion revealed new opportunities' WHEN 2 THEN 'Dayparting optimization reduced waste' ELSE 'Cross-device targeting improved attribution' END AS KEY_INSIGHTS,
    '1. ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Increase video investment for next campaign' WHEN 1 THEN 'Expand successful targeting strategies' WHEN 2 THEN 'Test new creative concepts in always-on' WHEN 3 THEN 'Implement learnings across other brand campaigns' ELSE 'Consider increased frequency against core segments' END ||
    '\n2. ' || CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Shift budget to higher-performing channels' WHEN 1 THEN 'Develop platform-specific creative' WHEN 2 THEN 'Expand to new audience segments' ELSE 'Increase testing budget for optimization' END AS RECOMMENDATIONS,
    'Performance exceeded industry benchmark by ' || UNIFORM(10, 40, RANDOM())::VARCHAR || '% on ' ||
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'CTR' WHEN 1 THEN 'video completion' WHEN 2 THEN 'engagement rate' ELSE 'conversion rate' END AS PERFORMANCE_VS_BENCHMARK,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Paused low-performing placements, increased bids on top segments'
        WHEN 1 THEN 'Refreshed creative, expanded targeting to lookalike audiences'
        WHEN 2 THEN 'Implemented dayparting, adjusted frequency caps'
        ELSE 'A/B tested landing pages, optimized bid strategy'
    END AS OPTIMIZATION_ACTIONS,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Continue monitoring and optimization, prepare for next phase creative'
        WHEN 1 THEN 'Develop recommendations for next campaign based on learnings'
        WHEN 2 THEN 'Share insights with broader team, update playbooks'
        ELSE 'Schedule post-campaign review meeting with client'
    END AS NEXT_STEPS,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Analytics Team' WHEN 1 THEN 'Media Strategy' WHEN 2 THEN 'Account Management'
        WHEN 3 THEN 'Performance Marketing' WHEN 4 THEN 'Brand Strategy' ELSE 'Digital Operations'
    END AS PREPARED_BY,
    'FINAL' AS STATUS,
    REPORT_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 15000));

-- ============================================================================
-- STEP 19: GENERATE BRAND GUIDELINES (50 records)
-- ============================================================================

INSERT INTO BRAND_GUIDELINES (
    GUIDELINE_ID, CLIENT_ID, GUIDELINE_TITLE, GUIDELINE_VERSION, EFFECTIVE_DATE,
    GUIDELINE_CONTENT, SECTION_TYPE, BRAND_VOICE, TONE_GUIDELINES, COLOR_PALETTE,
    TYPOGRAPHY_GUIDELINES, LOGO_USAGE, DO_DONT_GUIDELINES, LEGAL_DISCLAIMERS,
    APPROVAL_REQUIREMENTS, CONTACT_INFO, STATUS, CREATED_DATE
)
SELECT
    'GDL-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS GUIDELINE_ID,
    'CLI-' || LPAD(UNIFORM(0, 499, RANDOM())::VARCHAR, 6, '0') AS CLIENT_ID,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Brand Voice and Messaging Guidelines'
        WHEN 1 THEN 'Visual Identity Standards'
        WHEN 2 THEN 'Social Media Guidelines'
        WHEN 3 THEN 'Advertising Compliance Guide'
        ELSE 'Partner Co-Branding Guidelines'
    END || ' v' || (1 + MOD(SEQ4(), 3))::VARCHAR || '.0' AS GUIDELINE_TITLE,
    (1 + MOD(SEQ4(), 3))::VARCHAR || '.0' AS GUIDELINE_VERSION,
    DATEADD(DAY, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) AS EFFECTIVE_DATE,
    'BRAND GUIDELINES\n\n' ||
    'INTRODUCTION:\n' ||
    'These guidelines establish the standards for representing our brand across all communications and touchpoints. Consistent application of these guidelines ensures our brand is presented cohesively and professionally, building recognition and trust with our audiences.\n\n' ||
    'BRAND ESSENCE:\n' ||
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Our brand stands for innovation, quality, and customer-centricity. We believe in pushing boundaries while maintaining the highest standards of excellence. Our communications should reflect confidence without arrogance, innovation without alienation.'
        WHEN 1 THEN 'We are a premium brand that values craftsmanship, attention to detail, and exceptional experiences. Every touchpoint should reflect our commitment to excellence and our respect for our discerning customers.'
        WHEN 2 THEN 'Our brand is accessible, friendly, and trustworthy. We speak to real people with real needs, offering genuine solutions that improve their lives. Authenticity and transparency are at our core.'
        WHEN 3 THEN 'We are forward-thinking pioneers in our industry. Our brand embraces change and leads with innovation. Communications should feel modern, progressive, and inspiring while remaining grounded in practicality.'
        ELSE 'Our brand celebrates diversity, inclusion, and community. We believe everyone deserves to feel seen and valued. Our communications should reflect the full spectrum of human experience and foster connection.'
    END ||
    '\n\nBRAND VOICE:\n' ||
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Confident but not arrogant. We speak with authority earned through expertise and results. We make bold statements backed by substance, never empty claims.'
        WHEN 1 THEN 'Warm and approachable. We communicate like a knowledgeable friend, not a corporate entity. We use conversational language that feels natural and genuine.'
        WHEN 2 THEN 'Clear and direct. We value our audience''s time and intelligence. We get to the point without jargon or unnecessary complexity. Every word serves a purpose.'
        ELSE 'Inspiring and aspirational. We paint a picture of possibilities and invite our audience to join us on the journey. We motivate action through hope, not fear.'
    END ||
    '\n\nMESSAGING HIERARCHY:\n' ||
    '1. BRAND PROMISE: ' || CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Innovation that moves you' WHEN 1 THEN 'Excellence in every detail' WHEN 2 THEN 'Real solutions for real life' WHEN 3 THEN 'Leading the way forward' ELSE 'Together, we thrive' END ||
    '\n2. BRAND PILLARS: Quality, Innovation, Service, Value' ||
    '\n3. PROOF POINTS: Awards, testimonials, statistics, product features' ||
    '\n4. CALL TO ACTION: Clear, specific, benefit-focused' ||
    '\n\nVISUAL IDENTITY:\n' ||
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Our visual identity is clean, modern, and sophisticated. We use generous white space, bold typography, and strategic color accents. Photography should feel aspirational yet authentic, capturing real moments and genuine emotions.'
        WHEN 1 THEN 'Our visual style is vibrant and dynamic. We embrace bold colors, energetic compositions, and movement. Imagery should feel alive and engaging, capturing moments of joy, discovery, and connection.'
        WHEN 2 THEN 'Our visual identity emphasizes craft and detail. We use refined typography, subtle textures, and a sophisticated color palette. Photography should showcase product excellence and attention to quality.'
        ELSE 'Our visual approach is warm and human-centered. We prioritize diverse representation and authentic imagery. Visual elements should feel inclusive, welcoming, and emotionally resonant.'
    END ||
    '\n\nCOLOR USAGE:\n' ||
    '- Primary: Used for logos, headlines, and key brand elements\n' ||
    '- Secondary: Supporting colors for accents and hierarchy\n' ||
    '- Background: Neutral tones that allow content to breathe\n' ||
    '- Alert: Used sparingly for calls to action and important information\n' ||
    '\nAlways ensure sufficient contrast for accessibility (WCAG 2.1 AA minimum)\n' ||
    '\n\nTYPOGRAPHY:\n' ||
    'Headlines: Brand typeface, bold weight, used for primary messaging\n' ||
    'Subheads: Brand typeface, medium weight, supporting hierarchy\n' ||
    'Body: System font or secondary typeface for readability\n' ||
    'Legal: Small, legible type that meets regulatory requirements\n' ||
    '\nMaintain consistent type hierarchy across all materials\n' ||
    '\n\nLOGO GUIDELINES:\n' ||
    '- Minimum clear space: Height of logo letter on all sides\n' ||
    '- Minimum size: 1 inch width for print, 100px for digital\n' ||
    '- Approved color variations: Full color, single color, reversed\n' ||
    '- Never: Stretch, rotate, add effects, or modify logo elements\n' ||
    '\n\nPHOTOGRAPHY STYLE:\n' ||
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Lifestyle imagery should feel authentic and aspirational. Real people in real situations, but elevated. Natural lighting, genuine expressions, diverse casting.'
        WHEN 1 THEN 'Product photography should be precise and detailed. Clean backgrounds, perfect lighting, multiple angles. Show craftsmanship and quality through imagery.'
        WHEN 2 THEN 'Environmental imagery should connect product to context. Show how our products fit into customers'' lives. Balance product focus with lifestyle elements.'
        ELSE 'Editorial-style photography that tells a story. Capture moments of discovery, connection, and joy. Less posed, more documentary feel.'
    END ||
    '\n\nSOCIAL MEDIA GUIDELINES:\n' ||
    '- Maintain brand voice while adapting to platform conventions\n' ||
    '- Respond to comments and messages within 24 hours\n' ||
    '- User-generated content must be properly credited and approved\n' ||
    '- Crisis response must follow approved protocols\n' ||
    '- Influencer partnerships require legal review and disclosure\n' ||
    '\n\nLEGAL REQUIREMENTS:\n' ||
    '- All claims must be substantiated and approved by legal\n' ||
    '- Disclaimers must meet regulatory requirements for size and placement\n' ||
    '- Talent usage must be within contracted rights\n' ||
    '- Music and stock imagery must be properly licensed\n' ||
    '- Competitor references must be reviewed by legal' AS GUIDELINE_CONTENT,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'BRAND_VOICE'
        WHEN 1 THEN 'VISUAL_IDENTITY'
        WHEN 2 THEN 'MESSAGING'
        WHEN 3 THEN 'LEGAL'
        ELSE 'SOCIAL'
    END AS SECTION_TYPE,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Confident, innovative, forward-thinking. We speak with authority while remaining approachable.'
        WHEN 1 THEN 'Premium, sophisticated, refined. Every word should reflect our commitment to excellence.'
        WHEN 2 THEN 'Friendly, helpful, genuine. We communicate like a trusted advisor, not a salesperson.'
        ELSE 'Inspiring, inclusive, empowering. We celebrate possibility and invite participation.'
    END AS BRAND_VOICE,
    'Headlines: Bold and direct. Body: Conversational and clear. CTAs: Action-oriented and specific. Legal: Factual and compliant.' AS TONE_GUIDELINES,
    'Primary: #' || LPAD(UNIFORM(0, 16777215, RANDOM())::VARCHAR, 6, '0') || 
    ', Secondary: #' || LPAD(UNIFORM(0, 16777215, RANDOM())::VARCHAR, 6, '0') ||
    ', Accent: #' || LPAD(UNIFORM(0, 16777215, RANDOM())::VARCHAR, 6, '0') ||
    ', Background: #F5F5F5, Text: #333333' AS COLOR_PALETTE,
    'Primary: Custom brand font for headlines. Secondary: Sans-serif system font for body. Minimum sizes: Headlines 24pt, Body 12pt, Legal 8pt' AS TYPOGRAPHY_GUIDELINES,
    'Maintain clear space equal to logo height. Never modify, stretch, or apply effects. Use approved color versions only. Minimum print size 1 inch.' AS LOGO_USAGE,
    'DO: Use approved assets, follow templates, maintain consistency. DON''T: Create new logo versions, use unapproved colors, skip legal review.' AS DO_DONT_GUIDELINES,
    'All advertising must include required legal disclaimers. Pricing must reflect accurate MSRP. Claims must be substantiated. Talent usage within contracted rights.' AS LEGAL_DISCLAIMERS,
    'All creative requires client approval. Major campaigns require CMO sign-off. Legal review required for all claims. Final approval authority with brand manager.' AS APPROVAL_REQUIREMENTS,
    'Brand Team: brand@client.com, Legal: legal@client.com, Creative Approval: creative.approval@client.com' AS CONTACT_INFO,
    'CURRENT' AS STATUS,
    EFFECTIVE_DATE AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 50));

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 'CLIENTS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM CLIENTS
UNION ALL SELECT 'CAMPAIGNS', COUNT(*) FROM CAMPAIGNS
UNION ALL SELECT 'CREATIVE_ASSETS', COUNT(*) FROM CREATIVE_ASSETS
UNION ALL SELECT 'MEDIA_PLACEMENTS', COUNT(*) FROM MEDIA_PLACEMENTS
UNION ALL SELECT 'MEDIA_PERFORMANCE', COUNT(*) FROM MEDIA_PERFORMANCE
UNION ALL SELECT 'EMPLOYEES', COUNT(*) FROM EMPLOYEES
UNION ALL SELECT 'PROJECTS', COUNT(*) FROM PROJECTS
UNION ALL SELECT 'TIMESHEETS', COUNT(*) FROM TIMESHEETS
UNION ALL SELECT 'INVOICES', COUNT(*) FROM INVOICES
UNION ALL SELECT 'INVOICE_LINE_ITEMS', COUNT(*) FROM INVOICE_LINE_ITEMS
UNION ALL SELECT 'VENDORS', COUNT(*) FROM VENDORS
UNION ALL SELECT 'VENDOR_CONTRACTS', COUNT(*) FROM VENDOR_CONTRACTS
UNION ALL SELECT 'TALENT', COUNT(*) FROM TALENT
UNION ALL SELECT 'TALENT_USAGE', COUNT(*) FROM TALENT_USAGE
UNION ALL SELECT 'AUDIENCE_SEGMENTS', COUNT(*) FROM AUDIENCE_SEGMENTS
UNION ALL SELECT 'CAMPAIGN_AUDIENCES', COUNT(*) FROM CAMPAIGN_AUDIENCES
UNION ALL SELECT 'CREATIVE_BRIEFS', COUNT(*) FROM CREATIVE_BRIEFS
UNION ALL SELECT 'CAMPAIGN_REPORTS', COUNT(*) FROM CAMPAIGN_REPORTS
UNION ALL SELECT 'BRAND_GUIDELINES', COUNT(*) FROM BRAND_GUIDELINES
ORDER BY TABLE_NAME;

/*
=============================================================================
DATA GENERATION COMPLETE

Summary:
- CLIENTS: 500
- CAMPAIGNS: 100,000
- CREATIVE_ASSETS: 250,000
- MEDIA_PLACEMENTS: 500,000
- MEDIA_PERFORMANCE: 2,000,000
- EMPLOYEES: 1,000
- PROJECTS: 50,000
- TIMESHEETS: 500,000
- INVOICES: 200,000
- INVOICE_LINE_ITEMS: 600,000
- VENDORS: 200
- VENDOR_CONTRACTS: 500
- TALENT: 500
- TALENT_USAGE: 10,000
- AUDIENCE_SEGMENTS: 100
- CAMPAIGN_AUDIENCES: 200,000
- CREATIVE_BRIEFS: 20,000 (unstructured)
- CAMPAIGN_REPORTS: 15,000 (unstructured)
- BRAND_GUIDELINES: 50 (unstructured)

Next Step: Run 04_create_views.sql
=============================================================================
*/

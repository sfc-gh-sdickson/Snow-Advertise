# Sample Questions for Innocean Advertising Intelligence Agent

This document contains example questions organized by category that the Innocean Intelligence Agent can answer.

---

## Campaign Performance Questions (Semantic Views)

### Basic Metrics

1. **"What were the top 10 campaigns by ROAS last quarter?"**
   - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
   - Returns: Campaign names, ROAS, revenue, spend

2. **"Show me all active campaigns with their budget and performance metrics"**
   - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
   - Returns: Campaign list with status, budget, impressions, conversions

3. **"Which campaign types have the highest average conversion rate?"**
   - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
   - Returns: Campaign type comparison with CVR

4. **"What is our total media spend by client segment this year?"**
   - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
   - Returns: Spend breakdown by segment

5. **"Compare brand awareness vs product launch campaigns on key metrics"**
   - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
   - Returns: Side-by-side comparison

---

## Media Performance Questions (Semantic Views)

### Channel Analysis

6. **"Which media channels have the lowest CPA?"**
   - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE
   - Returns: Channel ranking by CPA

7. **"What is the average video completion rate by platform?"**
   - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE
   - Returns: Platform comparison with VCR

8. **"Show me programmatic vs direct media buying performance"**
   - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE
   - Returns: Buying method comparison

9. **"Which targeting types drive the best engagement rates?"**
   - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE
   - Returns: Targeting type analysis

10. **"What is our average viewability rate across display placements?"**
    - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE
    - Returns: Viewability metrics by channel/platform

---

## Client & Financial Questions (Semantic Views)

### Account Health

11. **"Which clients have satisfaction scores below 7?"**
    - Uses: SV_CLIENT_FINANCIAL_INTELLIGENCE
    - Returns: At-risk client list

12. **"Show me projects that are over budget by more than 10%"**
    - Uses: SV_CLIENT_FINANCIAL_INTELLIGENCE
    - Returns: Project list with budget variance

13. **"What is our total outstanding accounts receivable by client?"**
    - Uses: SV_CLIENT_FINANCIAL_INTELLIGENCE
    - Returns: AR aging by client

14. **"Which clients have contracts expiring in the next 90 days?"**
    - Uses: SV_CLIENT_FINANCIAL_INTELLIGENCE
    - Returns: Contract renewal pipeline

15. **"What is the average project profit margin by billing type?"**
    - Uses: SV_CLIENT_FINANCIAL_INTELLIGENCE
    - Returns: Profitability by fee structure

---

## Creative Brief Search Questions (Cortex Search)

### Strategy Discovery

16. **"Find creative briefs for automotive brand awareness campaigns"**
    - Uses: CREATIVE_BRIEFS_SEARCH
    - Returns: Relevant brief documents

17. **"Show me briefs targeting millennial audiences"**
    - Uses: CREATIVE_BRIEFS_SEARCH
    - Returns: Briefs with millennial targeting

18. **"Find campaign strategies for new product launches"**
    - Uses: CREATIVE_BRIEFS_SEARCH
    - Returns: Launch campaign briefs

19. **"Search for briefs about digital-first campaigns"**
    - Uses: CREATIVE_BRIEFS_SEARCH
    - Returns: Digital campaign strategies

20. **"Find creative approaches for conquest campaigns"**
    - Uses: CREATIVE_BRIEFS_SEARCH
    - Returns: Competitive conquest briefs

---

## Campaign Report Search Questions (Cortex Search)

### Performance Insights

21. **"Find campaign reports with insights about video performance"**
    - Uses: CAMPAIGN_REPORTS_SEARCH
    - Returns: Reports with video analysis

22. **"Search for reports recommending social media optimization"**
    - Uses: CAMPAIGN_REPORTS_SEARCH
    - Returns: Social optimization recommendations

23. **"Show me reports where campaigns exceeded ROAS targets"**
    - Uses: CAMPAIGN_REPORTS_SEARCH
    - Returns: High-performing campaign reports

24. **"Find learnings from underperforming campaigns"**
    - Uses: CAMPAIGN_REPORTS_SEARCH
    - Returns: Optimization learnings

25. **"Search for reports about connected TV performance"**
    - Uses: CAMPAIGN_REPORTS_SEARCH
    - Returns: CTV campaign analysis

---

## Brand Guidelines Search Questions (Cortex Search)

### Brand Standards

26. **"What are the brand voice guidelines for premium messaging?"**
    - Uses: BRAND_GUIDELINES_SEARCH
    - Returns: Voice and tone guidelines

27. **"Find logo usage requirements"**
    - Uses: BRAND_GUIDELINES_SEARCH
    - Returns: Logo standards

28. **"Search for color palette specifications"**
    - Uses: BRAND_GUIDELINES_SEARCH
    - Returns: Color guidelines

29. **"What are the legal disclaimer requirements for advertising?"**
    - Uses: BRAND_GUIDELINES_SEARCH
    - Returns: Legal compliance info

30. **"Find social media content guidelines"**
    - Uses: BRAND_GUIDELINES_SEARCH
    - Returns: Social standards

---

## Combined Analysis Questions

### Cross-Tool Queries

31. **"How do our TV campaigns perform, and what optimization strategies were recommended in campaign reports?"**
    - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE + CAMPAIGN_REPORTS_SEARCH
    - Returns: Performance data + report insights

32. **"Find successful creative approaches for SUV launches and show their campaign results"**
    - Uses: CREATIVE_BRIEFS_SEARCH + SV_CAMPAIGN_CREATIVE_INTELLIGENCE
    - Returns: Strategy + performance correlation

33. **"Which clients have low satisfaction, and what do their campaign reports suggest?"**
    - Uses: SV_CLIENT_FINANCIAL_INTELLIGENCE + CAMPAIGN_REPORTS_SEARCH
    - Returns: At-risk clients + improvement recommendations

34. **"Show me high-performing social campaigns and find similar creative briefs for inspiration"**
    - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE + CREATIVE_BRIEFS_SEARCH
    - Returns: Top campaigns + similar strategies

35. **"What brand guidelines apply to our automotive clients, and how are those campaigns performing?"**
    - Uses: BRAND_GUIDELINES_SEARCH + SV_CAMPAIGN_CREATIVE_INTELLIGENCE
    - Returns: Guidelines + performance context

---

## ML Model Prediction Questions (Optional)

If ML models are configured:

36. **"Which planned campaigns are most likely to succeed?"**
    - Uses: PREDICT_CAMPAIGN_PERFORMANCE procedure
    - Returns: Success predictions with probability

37. **"Identify our top 10 clients at risk of churning"**
    - Uses: PREDICT_CLIENT_CHURN procedure
    - Returns: Churn risk scores + recommended actions

38. **"How should we optimize media budget allocation for awareness campaigns?"**
    - Uses: OPTIMIZE_MEDIA_BUDGET procedure
    - Returns: Channel allocation recommendations

39. **"Predict performance for BRAND_AWARENESS campaigns"**
    - Uses: PREDICT_CAMPAIGN_PERFORMANCE('BRAND_AWARENESS')
    - Returns: Filtered predictions

40. **"Which automotive clients are at risk?"**
    - Uses: PREDICT_CLIENT_CHURN('AUTOMOTIVE')
    - Returns: Segment-specific risk assessment

---

## Advanced Analytics Questions

### Trend Analysis

41. **"Show me month-over-month trend in CTR by channel"**
    - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE
    - Returns: Time series analysis

42. **"Compare Q1 vs Q2 campaign performance"**
    - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
    - Returns: Quarterly comparison

43. **"What is the correlation between budget and ROAS?"**
    - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
    - Returns: Budget efficiency analysis

### Segmentation

44. **"Break down media performance by client segment and channel"**
    - Uses: SV_MEDIA_PERFORMANCE_INTELLIGENCE + SV_CAMPAIGN_CREATIVE_INTELLIGENCE
    - Returns: Multi-dimensional analysis

45. **"Which creative concepts perform best by campaign objective?"**
    - Uses: SV_CAMPAIGN_CREATIVE_INTELLIGENCE
    - Returns: Concept performance matrix

---

## Tips for Effective Questions

### Be Specific
- ❌ "Show me campaigns"
- ✅ "Show me active campaigns with ROAS above 3.0"

### Include Time Frames
- ❌ "What is our spend?"
- ✅ "What is our total media spend in Q4 2025?"

### Request Comparisons
- ❌ "How are TV campaigns doing?"
- ✅ "Compare TV vs streaming campaigns on CPM and video completion rate"

### Ask for Recommendations
- ❌ "Show underperforming channels"
- ✅ "Which channels should we reduce spend on based on CPA?"

### Combine Data Sources
- ❌ "Find briefs"
- ✅ "Find creative briefs similar to our top-performing automotive campaigns"

---

## Question Categories Summary

| Category | Data Source | Question Count |
|----------|-------------|----------------|
| Campaign Performance | Semantic View | 5 |
| Media Performance | Semantic View | 5 |
| Client & Financial | Semantic View | 5 |
| Creative Briefs | Cortex Search | 5 |
| Campaign Reports | Cortex Search | 5 |
| Brand Guidelines | Cortex Search | 5 |
| Combined Analysis | Multiple | 5 |
| ML Predictions | Procedures | 5 |
| Advanced Analytics | Multiple | 5 |

**Total: 45 sample questions**

# ML Notebook Guide

## Overview

This guide explains how to use the `innocean_ml_models.ipynb` notebook to train and register ML models for the Innocean Intelligence solution.

## Prerequisites

1. **Database Setup Complete**: Execute SQL scripts 01-06 before running the notebook
2. **Snowflake Notebook Access**: Open the notebook in Snowflake Notebooks
3. **Required Packages**: The notebook requires these packages:
   - `snowflake-ml-python`
   - `scikit-learn`
   - `xgboost`
   - `matplotlib`

## Adding Packages in Snowflake Notebooks

1. Open the notebook in Snowflake
2. Click on **Packages** in the notebook toolbar
3. Search for and add:
   - `snowflake-ml-python`
   - `scikit-learn`
   - `xgboost`
   - `matplotlib`
4. Click **Start** to restart the notebook with packages

## Models Overview

### 1. Campaign Performance Predictor

**Purpose**: Predict likelihood of campaign meeting performance targets

**Algorithm**: Random Forest Classifier

**Features**:
- `TOTAL_BUDGET`: Campaign total budget
- `MEDIA_BUDGET`: Media spend allocation
- `BUDGET_RATIO`: Media budget as % of total
- `PRODUCTION_RATIO`: Production budget as % of total
- `TARGET_IMPRESSIONS`: Target impression goal
- `TARGET_ROAS`: Target return on ad spend
- `SATISFACTION_SCORE`: Client satisfaction rating
- `NPS_SCORE`: Net Promoter Score
- `CLIENT_ANNUAL_BUDGET`: Client's total annual budget
- `CAMPAIGN_TYPE_ENC`: Encoded campaign type
- `CAMPAIGN_OBJECTIVE_ENC`: Encoded objective
- `CLIENT_SEGMENT_ENC`: Encoded client segment
- `RELATIONSHIP_TYPE_ENC`: Encoded relationship type

**Target**: Binary classification (campaign met ROAS target or not)

**Output**:
- `PREDICTED_SUCCESS`: Boolean prediction
- `SUCCESS_PROBABILITY`: Probability score (0-1)

### 2. Client Churn Predictor

**Purpose**: Identify client accounts at risk of leaving

**Algorithm**: Gradient Boosting Classifier

**Features**:
- `ANNUAL_BUDGET`: Client's annual budget
- `SATISFACTION_SCORE`: Client satisfaction rating
- `NPS_SCORE`: Net Promoter Score
- `TENURE_DAYS`: Days since contract start
- `DAYS_TO_CONTRACT_END`: Days until contract expires
- `CAMPAIGN_COUNT`: Number of campaigns
- `TOTAL_CAMPAIGN_SPEND`: Total spend across campaigns
- `AVG_CAMPAIGN_ROAS`: Average ROAS across campaigns
- `PROJECT_COUNT`: Number of projects
- `AVG_PROJECT_MARGIN`: Average project profit margin
- `CLIENT_SEGMENT_ENC`: Encoded segment
- `RELATIONSHIP_TYPE_ENC`: Encoded relationship

**Target**: Binary classification (client churned or active)

**Output**:
- `CHURN_RISK`: Boolean risk flag
- `CHURN_PROBABILITY`: Probability score (0-1)
- `RISK_FACTORS`: Key contributing factors
- `RECOMMENDED_ACTIONS`: Suggested interventions

### 3. Budget Optimization Model

**Purpose**: Predict channel ROAS to optimize media budget allocation

**Algorithm**: Gradient Boosting Regressor

**Features**:
- `CHANNEL_SPEND`: Total spend in channel
- `TOTAL_IMPRESSIONS`: Impressions delivered
- `TOTAL_CLICKS`: Clicks generated
- `CHANNEL_CTR`: Channel click-through rate
- `CHANNEL_ENC`: Encoded channel type
- `TARGETING_TYPE_ENC`: Encoded targeting method
- `CAMPAIGN_OBJECTIVE_ENC`: Encoded campaign objective

**Target**: ROAS (continuous value)

**Output**:
- `CHANNEL`: Media channel
- `CURRENT_SPEND_PCT`: Current allocation percentage
- `RECOMMENDED_SPEND_PCT`: Recommended allocation
- `EXPECTED_ROAS_IMPROVEMENT`: Predicted improvement

## Running the Notebook

### Step-by-Step Execution

1. **Cell c1**: Introduction and overview (Markdown - no execution needed)

2. **Cell c2**: Setup and imports
   - Imports required libraries
   - Establishes Snowflake session
   - Run this first

3. **Cell c3**: Load campaign data (SQL)
   - Queries campaign data for training
   - Creates `campaign_data` DataFrame

4. **Cell c4**: Train campaign performance model
   - Feature engineering
   - Model training
   - Evaluation metrics

5. **Cell c5**: Load client data (SQL)
   - Queries client data for training
   - Creates `client_data` DataFrame

6. **Cell c6**: Train churn model
   - Feature encoding
   - Model training
   - Evaluation metrics

7. **Cell c7**: Load media data (SQL)
   - Queries media performance data
   - Creates `media_data` DataFrame

8. **Cell c8**: Train budget optimization model
   - Feature preparation
   - Model training
   - Evaluation metrics

9. **Cell c9**: Visualize model performance
   - Creates feature importance charts
   - Visual comparison of models

10. **Cell c10-c12**: Register models to Snowflake
    - Registers each model to Model Registry
    - Creates model versions

11. **Cell c13**: Verify registered models (SQL)
    - Lists models in registry

12. **Cell c14**: Summary
    - Displays final results and next steps

### Running All Cells

```bash
jupyter nbconvert --execute --to notebook --inplace notebooks/innocean_ml_models.ipynb
```

### Running Individual Cells

```bash
# Run setup cell
jupyter nbconvert --execute --cell c2 --to notebook --inplace notebooks/innocean_ml_models.ipynb

# Run from cell c2 onwards
jupyter nbconvert --execute --cell c2 --run-type after --to notebook --inplace notebooks/innocean_ml_models.ipynb
```

## Expected Results

### Campaign Performance Model
- **Accuracy**: ~0.70-0.80
- **ROC AUC**: ~0.75-0.85
- **Top Features**: Budget, satisfaction score, target ROAS

### Client Churn Model
- **Accuracy**: ~0.85-0.95 (depends on churn rate)
- **ROC AUC**: ~0.80-0.90
- **Top Features**: Satisfaction, NPS, tenure, campaign count

### Budget Optimization Model
- **R² Score**: ~0.40-0.60
- **RMSE**: Varies by data distribution
- **Top Features**: CTR, impressions, channel type

## Troubleshooting

### Import Errors

If packages are not found:
1. Check that packages are added in notebook settings
2. Restart the notebook kernel
3. Verify package versions are compatible

### Data Loading Errors

If SQL queries fail:
1. Verify database/schema access
2. Check that data generation scripts ran successfully
3. Confirm table names are correct

### Model Registration Errors

If model registration fails:
1. Check Model Registry permissions
2. Verify schema exists for registry
3. Try with different version name if version exists

### Memory Issues

If notebook runs out of memory:
1. Reduce data sample size (add LIMIT to queries)
2. Use smaller model hyperparameters
3. Request larger warehouse

## Post-Training Steps

After successfully running the notebook:

1. **Execute wrapper functions**:
   ```sql
   -- Run the ML wrapper procedures script
   @sql/ml/07_create_model_wrapper_functions.sql
   ```

2. **Test predictions**:
   ```sql
   -- Test campaign predictor
   SELECT * FROM TABLE(PREDICT_CAMPAIGN_PERFORMANCE(NULL)) LIMIT 10;
   
   -- Test churn predictor
   SELECT * FROM TABLE(PREDICT_CLIENT_CHURN(NULL)) LIMIT 10;
   
   -- Test budget optimizer
   SELECT * FROM TABLE(OPTIMIZE_MEDIA_BUDGET(NULL)) LIMIT 10;
   ```

3. **Add to agent** (see AGENT_SETUP.md Step 7)

## Model Maintenance

### Retraining Schedule

- **Recommended**: Monthly retraining with new data
- **Trigger**: Performance degradation >5%
- **Process**: Re-run notebook, increment version

### Monitoring

- Track prediction accuracy over time
- Monitor feature drift
- Compare predictions vs actual outcomes

### Version Control

- Keep previous model versions
- Document changes between versions
- A/B test new models before full deployment

## Support

For issues with the ML notebook:
1. Check Snowflake Notebooks documentation
2. Review error messages in cell output
3. Verify data quality and completeness
4. Contact your Snowflake account team

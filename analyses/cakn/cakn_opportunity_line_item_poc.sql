-- CAKN reference: simplified OPPORTUNITY_CED (EDH only)
-- Grain: one row per opportunity line item
-- DO NOT materialize — specification only.
-- Implemented in models/transform/opportunities/transform_opportunity_line_item.sql

SELECT
    edh_line.line_item_number
    ,edh_opp.source_record_id AS opportunity_id
    ,acct.account_csn
    ,edh_line.line_item_acv_usd
    ,CASE
        WHEN edh_opp.opportunity_stage IN (
            '0-Closed/Lost', 'Closed/Lost', 'Closed', 'Closed Lost', '--None--'
        ) THEN 'Closed/Lost'
        WHEN edh_opp.opportunity_stage IN ('Won', '5-Closed/Won') THEN 'Won'
        WHEN edh_opp.opportunity_stage IN ('Stage 1', 'Stage1', '1-Prospecting') THEN 'Stage 1'
        WHEN edh_opp.opportunity_stage IN ('Stage 2', 'Stage2', '2-Qualifying') THEN 'Stage 2'
        WHEN edh_opp.opportunity_stage IN ('Stage 3', 'Stage3', '3-Solution Building') THEN 'Stage 3'
        WHEN edh_opp.opportunity_stage IN ('Stage 4', '4-Proposal/Negotiation') THEN 'Stage 4'
        WHEN edh_opp.opportunity_stage = 'Stage 5' THEN 'Stage 5'
        ELSE edh_opp.opportunity_stage
    END AS opportunity_stage
    ,acct.account_name
    ,acct.account_type
FROM {{ source('edh_shared', 'opportunity') }} AS edh_opp
INNER JOIN {{ source('edh_shared', 'opportunity_line_item') }} AS edh_line
    ON edh_opp.opportunity_number = edh_line.opportunity_number
INNER JOIN {{ source('edh_shared', 'account_ced') }} AS acct
    ON edh_opp.end_customer_account_csn = acct.account_csn
WHERE acct.account_type IN (
        'End Customer', 'Strategic Account', 'Government', 'A.D.N.'
    )
    AND acct.is_visible = TRUE
    AND COALESCE(acct.account_category, '') NOT IN ('Internal', 'Partner')
    AND edh_opp.opportunity_type = 'UnifiedOpportunity'

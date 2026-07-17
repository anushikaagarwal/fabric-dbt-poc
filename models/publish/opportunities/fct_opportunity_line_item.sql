SELECT
    line_item_number
    ,opportunity_id
    ,account_csn
    ,line_item_acv_usd
    ,opportunity_stage
FROM {{ ref('transform_opportunity_line_item') }}

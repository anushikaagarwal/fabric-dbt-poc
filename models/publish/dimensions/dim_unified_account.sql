SELECT DISTINCT
    account_csn
    ,account_name
    ,account_type
FROM {{ ref('transform_opportunity_line_item') }}
WHERE account_csn IS NOT NULL

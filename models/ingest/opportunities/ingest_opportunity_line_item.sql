SELECT
    line_item_number
    ,opportunity_number
    ,line_item_acv_usd
FROM {{ source('edh_shared', 'opportunity_line_item') }}

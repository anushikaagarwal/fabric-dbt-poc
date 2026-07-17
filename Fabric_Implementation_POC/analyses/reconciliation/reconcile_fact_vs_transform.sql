-- Reconciliation: fact row count and ACV must match transform layer.

SELECT
    'transform' AS layer
    ,COUNT(*) AS row_count
    ,SUM(line_item_acv_usd) AS total_acv_usd
FROM {{ ref('transform_opportunity_line_item') }}

UNION ALL

SELECT
    'fact' AS layer
    ,COUNT(*) AS row_count
    ,SUM(line_item_acv_usd) AS total_acv_usd
FROM {{ ref('fct_opportunity_line_item') }}

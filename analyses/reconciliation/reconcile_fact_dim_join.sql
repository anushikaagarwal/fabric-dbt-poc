-- Reconciliation: join sanity — account_name on dim matches transform via FK.

SELECT
    COUNT(*) AS fact_rows
    ,SUM(CASE WHEN d.account_name IS NULL THEN 1 ELSE 0 END) AS orphan_or_missing_dim_rows
FROM {{ ref('fct_opportunity_line_item') }} AS f
LEFT JOIN {{ ref('dim_unified_account') }} AS d
    ON f.account_csn = d.account_csn

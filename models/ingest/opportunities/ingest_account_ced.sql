SELECT
    account_csn
    ,account_name
    ,account_type
    ,account_category
    ,is_visible
FROM {{ source('edh_shared', 'account_ced') }}

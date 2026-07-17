SELECT
    opportunity_number
    ,source_record_id
    ,opportunity_stage
    ,end_customer_account_csn
    ,opportunity_type
FROM {{ source('edh_shared', 'opportunity') }}
WHERE opportunity_type = '{{ var("edh_opportunity_type_filter") }}'

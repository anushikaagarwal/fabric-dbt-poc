SELECT
    edh_line.line_item_number
    ,edh_opp.source_record_id AS opportunity_id
    ,acct.account_csn
    ,edh_line.line_item_acv_usd
    ,{{ standardize_opportunity_stage('edh_opp.opportunity_stage') }} AS opportunity_stage
    ,acct.account_name
    ,acct.account_type

FROM {{ ref('ingest_opportunity') }} AS edh_opp

INNER JOIN {{ ref('ingest_opportunity_line_item') }} AS edh_line
    ON edh_opp.opportunity_number = edh_line.opportunity_number

INNER JOIN {{ ref('ingest_account_ced') }} AS acct
    ON edh_opp.end_customer_account_csn = acct.account_csn

WHERE acct.account_type IN (
        {% for account_type in var('valid_account_types') %}
        '{{ account_type }}'{% if not loop.last %},{% endif %}
        {% endfor %}
    )
    AND acct.is_visible = 1
    AND COALESCE(acct.account_category, '') NOT IN (
        {% for category in var('excluded_account_categories') %}
        '{{ category }}'{% if not loop.last %},{% endif %}
        {% endfor %}
    )

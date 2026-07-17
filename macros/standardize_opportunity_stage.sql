{% macro standardize_opportunity_stage(raw_stage_expr) %}

    CASE
        WHEN {{ raw_stage_expr }} IN (
            '0-Closed/Lost', 'Closed/Lost', 'Closed', 'Closed Lost', '--None--'
        )
            THEN 'Closed/Lost'
        WHEN {{ raw_stage_expr }} IN ('Won', '5-Closed/Won')
            THEN 'Won'
        WHEN {{ raw_stage_expr }} IN ('Stage 1', 'Stage1', '1-Prospecting')
            THEN 'Stage 1'
        WHEN {{ raw_stage_expr }} IN ('Stage 2', 'Stage2', '2-Qualifying')
            THEN 'Stage 2'
        WHEN {{ raw_stage_expr }} IN ('Stage 3', 'Stage3', '3-Solution Building')
            THEN 'Stage 3'
        WHEN {{ raw_stage_expr }} IN ('Stage 4', '4-Proposal/Negotiation')
            THEN 'Stage 4'
        WHEN {{ raw_stage_expr }} = 'Stage 5'
            THEN 'Stage 5'
        ELSE {{ raw_stage_expr }}
    END

{% endmacro %}

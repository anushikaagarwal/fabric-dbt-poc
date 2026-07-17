# CAKN OPPORTUNITY_CED POC — Column classification

**Grain:** one row per opportunity line item (EDH only)

## Source tables (3)

| Source | Role |
|--------|------|
| `edh_shared.opportunity` | Opportunity header + raw stage |
| `edh_shared.opportunity_line_item` | Line item grain + ACV |
| `edh_shared.account_ced` | Account attributes |

## Fact — `fct_opportunity_line_item`

| Column | Classification |
|--------|----------------|
| line_item_number | PK |
| opportunity_id | Degenerate attribute |
| account_csn | FK → dim_unified_account |
| line_item_acv_usd | Measure input |
| opportunity_stage | Row-level calculation |

## Dimension — `dim_unified_account`

| Column | Classification |
|--------|----------------|
| account_csn | PK |
| account_name | Attribute (dropped from fact) |
| account_type | Attribute (dropped from fact) |

## Bridge

Not required.

## Measure (DAX reference)

`Total Line Item ACV (USD)` = SUM(line_item_acv_usd)

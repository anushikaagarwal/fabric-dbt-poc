# Fabric Implementation POC

Minimal dbt project to validate **CAKN → star schema → compile → Fabric pipeline** using simplified OPPORTUNITY_CED (EDH only).

## Scope

| Item | Detail |
|------|--------|
| **Sources** | 3 tables in `edh_shared` |
| **Fact** | `fct_opportunity_line_item` |
| **Dim** | `dim_unified_account` (conformed) |
| **Row calc** | `opportunity_stage` (normalized stage) |
| **Measure** | `Total Line Item ACV (USD)` in `.measures.dax` |
| **Materialization** | All ephemeral → `dbt compile` |

## Source tables to ingest into Fabric

Load into warehouse `WH_FabricDBTTest` (or update `sources.yml`):

| Schema | Table |
|--------|-------|
| `edh_shared` | `opportunity` |
| `edh_shared` | `opportunity_line_item` |
| `edh_shared` | `account_ced` |

## Folder structure

```
Fabric_Implementation_POC/
├── analyses/cakn/                    # CAKN reference SQL
├── analyses/reconciliation/          # Sign-off queries
├── docs/column_classification/       # Fact vs dim worksheet
├── macros/                           # standardize_opportunity_stage
├── models/
│   ├── sources.yml
│   ├── exposures.yml
│   ├── ingest/opportunities/         # 3 ingest models
│   ├── transform/opportunities/      # Joins + row-level logic
│   └── publish/
│       ├── dimensions/               # dim_unified_account
│       ├── bridges/                  # README only (no bridge)
│       └── opportunities/            # fct + metadata
├── dbt_project.yml
└── profiles.yml.example
```

## Fabric dbt job steps

1. Zip or import this folder into Fabric dbt job.
2. Set profile: **Fabric Data Warehouse** + schema `BI_LAYER_FABRIC_POC`.
3. Confirm `sources.yml` `database` matches your Fabric warehouse name.
4. Run command: **`compile`**.
5. Copy compiled SQL from output panel or `target/compiled/.../publish/`:
   - `fct_opportunity_line_item.sql`
   - `dim_unified_account.sql`
6. Paste each into Fabric Data Pipeline **`source_query`** → materialize 2 tables.
7. Build semantic model using:
   - `fct_opportunity_line_item.relationships.yml`
   - `fct_opportunity_line_item.measures.dax`

## Local compile

```bash
cd dags/dbt/bi_layer/Fabric_Implementation_POC
dbt deps
dbt compile --select fct_opportunity_line_item dim_unified_account
```

## Compiled output (not in Git)

```
target/compiled/fabric_implementation_poc/models/publish/
├── dimensions/dim_unified_account.sql
└── opportunities/fct_opportunity_line_item.sql
```

## Deliverables checklist

- [x] CAKN reference in `analyses/cakn/`
- [x] Column classification worksheet
- [x] ingest + transform models
- [x] fct + dim publish models
- [x] fct `.yml` with tests
- [x] `.relationships.yml`
- [x] `.measures.dax`
- [x] Reconciliation queries
- [ ] Compiled SQL extracted for Fabric pipeline (after `dbt compile`)

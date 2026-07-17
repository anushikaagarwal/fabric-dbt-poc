-- =============================================================================
-- Fabric POC sample data — aligned with models/sources.yml
-- =============================================================================
-- Warehouse (database): WH_dbtJob_GITPOC
-- Schema:               edh_shared          ← must match sources.yml
-- Tables:               account_ced, opportunity, opportunity_line_item
--
-- Run in Fabric Warehouse SQL endpoint before dbt compile.
-- =============================================================================

-- Create schema if it does not exist
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'edh_shared')
BEGIN
    EXEC('CREATE SCHEMA edh_shared');
END;
GO

-- Drop and recreate for clean POC reruns (optional)
DROP TABLE IF EXISTS edh_shared.opportunity_line_item;
DROP TABLE IF EXISTS edh_shared.opportunity;
DROP TABLE IF EXISTS edh_shared.account_ced;
GO

-- -----------------------------------------------------------------------------
-- account_ced
-- Columns used by dbt: account_csn, account_name, account_type,
--                      account_category, is_visible
-- -----------------------------------------------------------------------------
CREATE TABLE edh_shared.account_ced (
    account_csn       VARCHAR(50)   NOT NULL,
    account_name      VARCHAR(200)  NOT NULL,
    account_type      VARCHAR(50)   NOT NULL,
    account_category  VARCHAR(50)   NULL,
    is_visible        BIT           NOT NULL
);
GO

INSERT INTO edh_shared.account_ced (
    account_csn, account_name, account_type, account_category, is_visible
) VALUES
    ('CSN-100001', 'Acme Construction Ltd',   'End Customer',       NULL,       1),
    ('CSN-100002', 'Globex Strategic Corp',   'Strategic Account',  NULL,       1),
    ('CSN-100003', 'Ministry of Infrastructure', 'Government',      NULL,       1);
GO

-- -----------------------------------------------------------------------------
-- opportunity
-- Columns used by dbt: opportunity_number, source_record_id, opportunity_stage,
--                      end_customer_account_csn, opportunity_type
-- Filter in dbt: opportunity_type = 'UnifiedOpportunity'
-- -----------------------------------------------------------------------------
CREATE TABLE edh_shared.opportunity (
    opportunity_number        VARCHAR(50)   NOT NULL,
    source_record_id          VARCHAR(50)   NOT NULL,
    opportunity_stage         VARCHAR(100)  NOT NULL,
    end_customer_account_csn  VARCHAR(50)   NOT NULL,
    opportunity_type          VARCHAR(50)   NOT NULL
);
GO

INSERT INTO edh_shared.opportunity (
    opportunity_number, source_record_id, opportunity_stage,
    end_customer_account_csn, opportunity_type
) VALUES
    ('OPP-2026-001', '006ABC000001', 'Stage 3',           'CSN-100001', 'UnifiedOpportunity'),
    ('OPP-2026-002', '006ABC000002', '5-Closed/Won',      'CSN-100002', 'UnifiedOpportunity'),
    ('OPP-2026-003', '006ABC000003', '1-Prospecting',     'CSN-100003', 'UnifiedOpportunity'),
    ('OPP-2026-004', '006ABC000004', 'Stage 2',           'CSN-100001', 'UnifiedOpportunity');
GO

-- -----------------------------------------------------------------------------
-- opportunity_line_item
-- Columns used by dbt: line_item_number, opportunity_number, line_item_acv_usd
-- Grain: one row per line_item_number
-- -----------------------------------------------------------------------------
CREATE TABLE edh_shared.opportunity_line_item (
    line_item_number   VARCHAR(50)     NOT NULL,
    opportunity_number VARCHAR(50)     NOT NULL,
    line_item_acv_usd  DECIMAL(18, 2)  NOT NULL
);
GO

INSERT INTO edh_shared.opportunity_line_item (
    line_item_number, opportunity_number, line_item_acv_usd
) VALUES
    ('OLI-001', 'OPP-2026-001', 125000.00),
    ('OLI-002', 'OPP-2026-001',  45000.00),
    ('OLI-003', 'OPP-2026-002', 210000.00),
    ('OLI-004', 'OPP-2026-003',  87500.00),
    ('OLI-005', 'OPP-2026-004',  32000.00);
GO

-- -----------------------------------------------------------------------------
-- Quick validation (expect 5 line items, total ACV = 499500)
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS line_item_count, SUM(line_item_acv_usd) AS total_acv
FROM edh_shared.opportunity_line_item;

-- =============================================
-- Gartle Planning
-- Version 5.2, January 9, 2023
--
-- Copyright 2017-2023 Gartle LLC
--
-- License: MIT
-- =============================================

IF 502 <= COALESCE((SELECT CAST(LEFT(HANDLER_CODE, CHARINDEX('.', HANDLER_CODE) - 1) AS int) * 100 + CAST(RIGHT(HANDLER_CODE, LEN(HANDLER_CODE) - CHARINDEX('.', HANDLER_CODE)) AS float) FROM xls.handlers WHERE TABLE_SCHEMA = 'xls25' AND TABLE_NAME = 'application' AND COLUMN_NAME = 'version' AND EVENT_NAME = 'Information'), 0)
    RAISERROR('Gartle Planning is up-to-date. Update skipped', 11, 0)
GO

UPDATE xls.handlers
SET
    HANDLER_TYPE = s.HANDLER_TYPE
    , HANDLER_CODE = s.HANDLER_CODE
    , TARGET_WORKSHEET = s.TARGET_WORKSHEET
    , MENU_ORDER = s.MENU_ORDER
    , EDIT_PARAMETERS = s.EDIT_PARAMETERS
FROM
    (
    SELECT
        CAST(NULL AS nvarchar) AS TABLE_SCHEMA
        , CAST(NULL AS nvarchar) AS TABLE_NAME
        , CAST(NULL AS nvarchar) AS COLUMN_NAME
        , CAST(NULL AS nvarchar) AS EVENT_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_SCHEMA
        , CAST(NULL AS nvarchar) AS HANDLER_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_TYPE
        , CAST(NULL AS nvarchar) HANDLER_CODE
        , CAST(NULL AS nvarchar) AS TARGET_WORKSHEET
        , CAST(NULL AS int) AS MENU_ORDER
        , CAST(NULL AS bit) AS EDIT_PARAMETERS

    UNION ALL SELECT N'xls25', N'application', N'version', N'Information', NULL, NULL, N'ATTRIBUTE', N'5.2', NULL, NULL, NULL

    ) s
    LEFT OUTER JOIN xls.handlers t ON
        t.TABLE_SCHEMA = s.TABLE_SCHEMA
        AND t.TABLE_NAME = s.TABLE_NAME
        AND COALESCE(t.COLUMN_NAME, '') = COALESCE(s.COLUMN_NAME, '')
        AND t.EVENT_NAME = s.EVENT_NAME
        AND COALESCE(t.HANDLER_SCHEMA, '') = COALESCE(s.HANDLER_SCHEMA, '')
        AND COALESCE(t.HANDLER_NAME, '') = COALESCE(s.HANDLER_NAME, '')
WHERE
    NOT COALESCE(t.HANDLER_TYPE, '') = COALESCE(s.HANDLER_TYPE, '')
    OR NOT COALESCE(t.HANDLER_CODE, '')  = COALESCE(s.HANDLER_CODE, '')
    OR NOT COALESCE(t.TARGET_WORKSHEET, '') = COALESCE(s.TARGET_WORKSHEET, '')
    OR NOT COALESCE(t.MENU_ORDER, -1) = COALESCE(s.MENU_ORDER, -1)
    OR NOT COALESCE(t.EDIT_PARAMETERS, 0) = COALESCE(s.EDIT_PARAMETERS, 0);
GO

INSERT INTO xls.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS)
SELECT s.TABLE_SCHEMA, s.TABLE_NAME, s.COLUMN_NAME, s.EVENT_NAME, s.HANDLER_SCHEMA, s.HANDLER_NAME, s.HANDLER_TYPE, s.HANDLER_CODE, s.TARGET_WORKSHEET, s.MENU_ORDER, s.EDIT_PARAMETERS
FROM
    (
    SELECT
        CAST(NULL AS nvarchar) AS TABLE_SCHEMA
        , CAST(NULL AS nvarchar) AS TABLE_NAME
        , CAST(NULL AS nvarchar) AS COLUMN_NAME
        , CAST(NULL AS nvarchar) AS EVENT_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_SCHEMA
        , CAST(NULL AS nvarchar) AS HANDLER_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_TYPE
        , CAST(NULL AS nvarchar) HANDLER_CODE
        , CAST(NULL AS nvarchar) AS TARGET_WORKSHEET
        , CAST(NULL AS int) AS MENU_ORDER
        , CAST(NULL AS bit) AS EDIT_PARAMETERS

    UNION ALL SELECT N'xls25', N'application', N'version', N'Information', NULL, NULL, N'ATTRIBUTE', N'5.2', NULL, NULL, NULL

    ) s
    LEFT OUTER JOIN xls.handlers t ON
        t.TABLE_SCHEMA = s.TABLE_SCHEMA
        AND t.TABLE_NAME = s.TABLE_NAME
        AND COALESCE(t.COLUMN_NAME, '') = COALESCE(s.COLUMN_NAME, '')
        AND t.EVENT_NAME = s.EVENT_NAME
        AND COALESCE(t.HANDLER_SCHEMA, '') = COALESCE(s.HANDLER_SCHEMA, '')
        AND COALESCE(t.HANDLER_NAME, '') = COALESCE(s.HANDLER_NAME, '')
        AND COALESCE(t.HANDLER_TYPE, '') = COALESCE(s.HANDLER_TYPE, '')
WHERE
    t.TABLE_NAME IS NULL
    AND s.TABLE_NAME IS NOT NULL;
GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on update of dbo25.companies
-- =============================================

ALTER TRIGGER [dbo25].[tr_companies_update]
   ON  [dbo25].[companies]
   AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;

IF TRIGGER_NESTLEVEL() > 1
    RETURN

UPDATE dbo25.companies
SET
    created_by = COALESCE(deleted.created_by, t.created_by, USER_NAME())
    , created_on = COALESCE(deleted.created_on, t.created_on, CAST(GETDATE() AS datetime2(0)))
    , modified_by = USER_NAME()
    , modified_on = CAST(GETDATE() AS datetime2(0))
FROM
    dbo25.companies t INNER JOIN deleted ON t.id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on delete from dbo25.dimension_properties
-- =============================================

ALTER TRIGGER [dbo25].[tr_dimension_properties_delete]
   ON  [dbo25].[dimension_properties]
   AFTER DELETE
AS
BEGIN

SET NOCOUNT ON;

DELETE dbo25.translations FROM deleted INNER JOIN dbo25.translations t ON t.company_id = deleted.company_id AND t.table_id IN (5, 6) AND t.member_id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on delete from dbo25.form_rows
-- =============================================

ALTER TRIGGER [dbo25].[tr_form_rows_delete]
   ON  [dbo25].[form_rows]
   AFTER DELETE
AS
BEGIN

SET NOCOUNT ON;

DELETE dbo25.translations FROM deleted INNER JOIN dbo25.members m ON m.id = deleted.rowset_id INNER JOIN dbo25.translations t ON t.company_id = m.company_id AND t.table_id = 8 AND t.member_id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on update of dbo25.form_rows
-- =============================================

ALTER TRIGGER [dbo25].[tr_form_rows_update]
   ON  [dbo25].[form_rows]
   AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;

IF TRIGGER_NESTLEVEL() > 1
    RETURN

UPDATE dbo25.form_rows
SET
    created_by = COALESCE(deleted.created_by, t.created_by, USER_NAME())
    , created_on = COALESCE(deleted.created_on, t.created_on, CAST(GETDATE() AS datetime2(0)))
    , modified_by = USER_NAME()
    , modified_on = CAST(GETDATE() AS datetime2(0))
FROM
    dbo25.form_rows t INNER JOIN deleted ON t.id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on delete from dbo25.forms
-- =============================================

ALTER TRIGGER [dbo25].[tr_forms_delete]
   ON  [dbo25].[forms]
   AFTER DELETE
AS
BEGIN

SET NOCOUNT ON;

DELETE dbo25.translations FROM deleted INNER JOIN dbo25.translations t ON t.company_id = deleted.company_id AND t.table_id = 7 AND t.member_id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on update of dbo25.forms
-- =============================================

ALTER TRIGGER [dbo25].[tr_forms_update]
   ON  [dbo25].[forms]
   AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;

IF TRIGGER_NESTLEVEL() > 1
    RETURN

UPDATE dbo25.forms
SET
    created_by = COALESCE(deleted.created_by, t.created_by, USER_NAME())
    , created_on = COALESCE(deleted.created_on, t.created_on, CAST(GETDATE() AS datetime2(0)))
    , modified_by = USER_NAME()
    , modified_on = CAST(GETDATE() AS datetime2(0))
FROM
    dbo25.forms t INNER JOIN deleted ON t.id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on delete from dbo25.members
-- =============================================

ALTER TRIGGER [dbo25].[tr_members_delete]
   ON  [dbo25].[members]
   AFTER DELETE
AS
BEGIN

SET NOCOUNT ON;

DELETE dbo25.translations FROM deleted INNER JOIN dbo25.translations t ON t.company_id = deleted.company_id AND t.table_id = 1 AND t.member_id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on update of dbo25.members
-- =============================================

ALTER TRIGGER [dbo25].[tr_members_update]
   ON  [dbo25].[members]
   AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;

IF TRIGGER_NESTLEVEL() > 1
    RETURN

UPDATE dbo25.members
SET
    created_by = COALESCE(deleted.created_by, t.created_by, USER_NAME())
    , created_on = COALESCE(deleted.created_on, t.created_on, CAST(GETDATE() AS datetime2(0)))
    , modified_by = USER_NAME()
    , modified_on = CAST(GETDATE() AS datetime2(0))
FROM
    dbo25.members t INNER JOIN deleted ON t.id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on delete from dbo25.tax_rates
-- =============================================

ALTER TRIGGER [dbo25].[tr_tax_rates_delete]
   ON  [dbo25].[tax_rates]
   AFTER DELETE
AS
BEGIN

SET NOCOUNT ON;

DELETE dbo25.translations FROM deleted INNER JOIN dbo25.translations t ON t.company_id = deleted.company_id AND t.table_id = 4 AND t.member_id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on update of dbo25.tax_rates
-- =============================================

ALTER TRIGGER [dbo25].[tr_tax_rates_update]
   ON  [dbo25].[tax_rates]
   AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;

IF TRIGGER_NESTLEVEL() > 1
    RETURN

UPDATE dbo25.tax_rates
SET
    created_by = COALESCE(deleted.created_by, t.created_by, USER_NAME())
    , created_on = COALESCE(deleted.created_on, t.created_on, CAST(GETDATE() AS datetime2(0)))
    , modified_by = USER_NAME()
    , modified_on = CAST(GETDATE() AS datetime2(0))
FROM
    dbo25.tax_rates t INNER JOIN deleted ON t.id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on delete from dbo25.units
-- =============================================

ALTER TRIGGER [dbo25].[tr_units_delete]
   ON  [dbo25].[units]
   AFTER DELETE
AS
BEGIN

SET NOCOUNT ON;

DELETE dbo25.translations FROM deleted INNER JOIN dbo25.translations t ON t.company_id = deleted.company_id AND t.table_id = 3 AND t.member_id = deleted.id

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     5.1, 2022-10-14
-- Description: This trigger fires on update of dbo25.units
-- =============================================

ALTER TRIGGER [dbo25].[tr_units_update]
   ON  [dbo25].[units]
   AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;

IF TRIGGER_NESTLEVEL() > 1
    RETURN

UPDATE dbo25.units
SET
    created_by = COALESCE(deleted.created_by, t.created_by, USER_NAME())
    , created_on = COALESCE(deleted.created_on, t.created_on, CAST(GETDATE() AS datetime2(0)))
    , modified_by = USER_NAME()
    , modified_on = CAST(GETDATE() AS datetime2(0))
FROM
    dbo25.units t INNER JOIN deleted ON t.id = deleted.id

END


GO

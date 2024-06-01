-- =============================================
-- Database Help Framework for Microsoft SQL Server
-- Version 3.2, January 9, 2023
--
-- Copyright 2018-2023 Gartle LLC
--
-- License: MIT
-- =============================================

SET NOCOUNT ON
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[doc].[FK_help_sections]') AND parent_object_id = OBJECT_ID(N'[doc].[help]'))
    ALTER TABLE [doc].[help] DROP CONSTRAINT [FK_help_sections];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[doc].[FK_history_history_sections]') AND parent_object_id = OBJECT_ID(N'[doc].[history]'))
    ALTER TABLE [doc].[history] DROP CONSTRAINT [FK_history_history_sections];
GO

IF OBJECT_ID('[doc].[usp_translations]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[usp_translations];
GO
IF OBJECT_ID('[doc].[usp_translations_change]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[usp_translations_change];
GO
IF OBJECT_ID('[doc].[xl_actions_database_documentation]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_actions_database_documentation];
GO
IF OBJECT_ID('[doc].[xl_actions_refresh_modules]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_actions_refresh_modules];
GO
IF OBJECT_ID('[doc].[xl_actions_set_role_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_actions_set_role_permissions];
GO
IF OBJECT_ID('[doc].[xl_delete_help_column]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_delete_help_column];
GO
IF OBJECT_ID('[doc].[xl_delete_help_object]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_delete_help_object];
GO
IF OBJECT_ID('[doc].[xl_delete_help_parameter]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_delete_help_parameter];
GO
IF OBJECT_ID('[doc].[xl_delete_help_row]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_delete_help_row];
GO
IF OBJECT_ID('[doc].[xl_export_help]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_export_help];
GO
IF OBJECT_ID('[doc].[xl_export_settings]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_export_settings];
GO
IF OBJECT_ID('[doc].[xl_import_help]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_import_help];
GO
IF OBJECT_ID('[doc].[xl_import_history]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_import_history];
GO
IF OBJECT_ID('[doc].[xl_insert_help_diagram]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_insert_help_diagram];
GO
IF OBJECT_ID('[doc].[xl_update_help_column]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_update_help_column];
GO
IF OBJECT_ID('[doc].[xl_update_help_diagram]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_update_help_diagram];
GO
IF OBJECT_ID('[doc].[xl_update_help_object]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_update_help_object];
GO
IF OBJECT_ID('[doc].[xl_update_help_page]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_update_help_page];
GO
IF OBJECT_ID('[doc].[xl_update_help_parameter]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_update_help_parameter];
GO
IF OBJECT_ID('[doc].[xl_validation_list_history_section_id]', 'P') IS NOT NULL
DROP PROCEDURE [doc].[xl_validation_list_history_section_id];
GO

IF OBJECT_ID('[doc].[view_diagrams]', 'V') IS NOT NULL
DROP VIEW [doc].[view_diagrams];
GO
IF OBJECT_ID('[doc].[view_history]', 'V') IS NOT NULL
DROP VIEW [doc].[view_history];
GO
IF OBJECT_ID('[doc].[view_index]', 'V') IS NOT NULL
DROP VIEW [doc].[view_index];
GO
IF OBJECT_ID('[doc].[view_objects]', 'V') IS NOT NULL
DROP VIEW [doc].[view_objects];
GO
IF OBJECT_ID('[doc].[view_online_help_handlers]', 'V') IS NOT NULL
DROP VIEW [doc].[view_online_help_handlers];
GO
IF OBJECT_ID('[doc].[view_orphan_rows]', 'V') IS NOT NULL
DROP VIEW [doc].[view_orphan_rows];
GO
IF OBJECT_ID('[doc].[view_pages]', 'V') IS NOT NULL
DROP VIEW [doc].[view_pages];
GO
IF OBJECT_ID('[doc].[view_properties]', 'V') IS NOT NULL
DROP VIEW [doc].[view_properties];
GO
IF OBJECT_ID('[doc].[view_query_list]', 'V') IS NOT NULL
DROP VIEW [doc].[view_query_list];
GO
IF OBJECT_ID('[doc].[view_routine_columns]', 'V') IS NOT NULL
DROP VIEW [doc].[view_routine_columns];
GO
IF OBJECT_ID('[doc].[view_routine_parameters]', 'V') IS NOT NULL
DROP VIEW [doc].[view_routine_parameters];
GO
IF OBJECT_ID('[doc].[view_table_columns]', 'V') IS NOT NULL
DROP VIEW [doc].[view_table_columns];
GO
IF OBJECT_ID('[doc].[view_translations]', 'V') IS NOT NULL
DROP VIEW [doc].[view_translations];
GO
IF OBJECT_ID('[doc].[view_view_columns]', 'V') IS NOT NULL
DROP VIEW [doc].[view_view_columns];
GO

IF OBJECT_ID('[doc].[get_escaped_parameter_name]', 'FN') IS NOT NULL
DROP FUNCTION [doc].[get_escaped_parameter_name];
GO

IF OBJECT_ID('[doc].[formats]', 'U') IS NOT NULL
DROP TABLE [doc].[formats];
GO
IF OBJECT_ID('[doc].[handlers]', 'U') IS NOT NULL
DROP TABLE [doc].[handlers];
GO
IF OBJECT_ID('[doc].[help]', 'U') IS NOT NULL
DROP TABLE [doc].[help];
GO
IF OBJECT_ID('[doc].[help_sections]', 'U') IS NOT NULL
DROP TABLE [doc].[help_sections];
GO
IF OBJECT_ID('[doc].[history]', 'U') IS NOT NULL
DROP TABLE [doc].[history];
GO
IF OBJECT_ID('[doc].[history_sections]', 'U') IS NOT NULL
DROP TABLE [doc].[history_sections];
GO
IF OBJECT_ID('[doc].[objects]', 'U') IS NOT NULL
DROP TABLE [doc].[objects];
GO
IF OBJECT_ID('[doc].[translations]', 'U') IS NOT NULL
DROP TABLE [doc].[translations];
GO
IF OBJECT_ID('[doc].[workbooks]', 'U') IS NOT NULL
DROP TABLE [doc].[workbooks];
GO


DECLARE @sql nvarchar(max) = ''

SELECT
    @sql = @sql + 'ALTER ROLE ' + QUOTENAME(r.name) + ' DROP MEMBER ' + QUOTENAME(m.name) + ';' + CHAR(13) + CHAR(10)
FROM
    sys.database_role_members rm
    INNER JOIN sys.database_principals r ON r.principal_id = rm.role_principal_id
    INNER JOIN sys.database_principals m ON m.principal_id = rm.member_principal_id
WHERE
    r.name IN ('doc_readers', 'doc_writers')

IF LEN(@sql) > 1
    BEGIN
    EXEC (@sql);
    PRINT @sql
    END
GO

IF DATABASE_PRINCIPAL_ID('doc_readers') IS NOT NULL
DROP ROLE [doc_readers];
GO
IF DATABASE_PRINCIPAL_ID('doc_writers') IS NOT NULL
DROP ROLE [doc_writers];
GO

IF SCHEMA_ID('doc') IS NOT NULL
DROP SCHEMA [doc];
GO

print 'Database Help Framework removed';

-- =============================================
-- Gartle Planning
-- Version 5.2, January 9, 2023
--
-- Copyright 2017-2023 Gartle LLC
--
-- License: MIT
-- =============================================

SET NOCOUNT ON
GO

DELETE FROM [xls].[formats]                        WHERE TABLE_SCHEMA IN (N'dbo25', N'xls25', N'xls25a', N'xls25b');
DELETE FROM [xls].[handlers]                       WHERE TABLE_SCHEMA IN (N'dbo25', N'xls25', N'xls25a', N'xls25b');
DELETE FROM [xls].[objects]                        WHERE TABLE_SCHEMA IN (N'dbo25', N'xls25', N'xls25a', N'xls25b');
DELETE FROM [xls].[translations]                   WHERE TABLE_SCHEMA IN (N'dbo25', N'xls25', N'xls25a', N'xls25b');
DELETE FROM [xls].[workbooks]                      WHERE TABLE_SCHEMA IN (N'dbo25', N'xls25', N'xls25a', N'xls25b');
GO

DECLARE @id int

SET @id = COALESCE((SELECT MAX(ID) FROM xls.formats), 0);

DBCC CHECKIDENT ('xls.formats', RESEED, @id) WITH NO_INFOMSGS;

SET @id = COALESCE((SELECT MAX(ID) FROM xls.handlers), 0);

DBCC CHECKIDENT ('xls.handlers', RESEED, @id) WITH NO_INFOMSGS;

SET @id = COALESCE((SELECT MAX(ID) FROM xls.objects), 0);

DBCC CHECKIDENT ('xls.objects', RESEED, @id) WITH NO_INFOMSGS;

SET @id = COALESCE((SELECT MAX(ID) FROM xls.translations), 0);

DBCC CHECKIDENT ('xls.translations', RESEED, @id) WITH NO_INFOMSGS;

SET @id = COALESCE((SELECT MAX(ID) FROM xls.workbooks), 0);

DBCC CHECKIDENT ('xls.workbooks', RESEED, @id) WITH NO_INFOMSGS;
GO

IF OBJECT_ID('doc.history', 'U') IS NOT NULL
DELETE FROM doc.history WHERE TABLE_SCHEMA IN ('dbo25', 'xls25', 'xls25a', 'xls25b');
GO
IF OBJECT_ID('doc.help', 'U') IS NOT NULL
DELETE FROM doc.help WHERE TABLE_SCHEMA IN ('dbo25', 'xls25', 'xls25a', 'xls25b');
GO
IF OBJECT_ID('doc.help', 'U') IS NOT NULL
DELETE FROM doc.help WHERE SECTION_ID = 2 AND TABLE_NAME IN ('dbo25', 'xls25', 'xls25a', 'xls25b');
GO
IF OBJECT_ID('doc.help', 'U') IS NOT NULL
DELETE FROM doc.help WHERE SECTION_ID = 3 AND TABLE_NAME IN ('planning_app_admins', 'planning_app_analysts', 'planning_app_developers', 'planning_app_users');
GO
IF OBJECT_ID('logs.base_tables', 'U') IS NOT NULL
DELETE FROM logs.base_tables WHERE BASE_TABLE_SCHEMA IN ('dbo25', 'xls25', 'xls25a', 'xls25b');
GO
IF OBJECT_ID('logs.xl_actions_drop_all_change_tracking_triggers', 'P') IS NOT NULL
EXEC logs.xl_actions_drop_all_change_tracking_triggers '%25%', 1;
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_currency_rates_members_category_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[currency_rates]'))
    ALTER TABLE [dbo25].[currency_rates] DROP CONSTRAINT [FK_currency_rates_members_category_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_currency_rates_members_time_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[currency_rates]'))
    ALTER TABLE [dbo25].[currency_rates] DROP CONSTRAINT [FK_currency_rates_members_time_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_currency_rates_units_from_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[currency_rates]'))
    ALTER TABLE [dbo25].[currency_rates] DROP CONSTRAINT [FK_currency_rates_units_from_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_currency_rates_units_to_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[currency_rates]'))
    ALTER TABLE [dbo25].[currency_rates] DROP CONSTRAINT [FK_currency_rates_units_to_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimension_calc_types_calc_types]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimension_calc_types]'))
    ALTER TABLE [dbo25].[dimension_calc_types] DROP CONSTRAINT [FK_dimension_calc_types_calc_types];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimension_calc_types_dimensions]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimension_calc_types]'))
    ALTER TABLE [dbo25].[dimension_calc_types] DROP CONSTRAINT [FK_dimension_calc_types_dimensions];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimension_properties_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimension_properties]'))
    ALTER TABLE [dbo25].[dimension_properties] DROP CONSTRAINT [FK_dimension_properties_companies];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimension_properties_dimensions]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimension_properties]'))
    ALTER TABLE [dbo25].[dimension_properties] DROP CONSTRAINT [FK_dimension_properties_dimensions];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimension_properties_members_default_member_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimension_properties]'))
    ALTER TABLE [dbo25].[dimension_properties] DROP CONSTRAINT [FK_dimension_properties_members_default_member_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimension_properties_members_root_member_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimension_properties]'))
    ALTER TABLE [dbo25].[dimension_properties] DROP CONSTRAINT [FK_dimension_properties_members_root_member_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimension_properties_name_formats]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimension_properties]'))
    ALTER TABLE [dbo25].[dimension_properties] DROP CONSTRAINT [FK_dimension_properties_name_formats];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_dimensions_name_formats]') AND parent_object_id = OBJECT_ID(N'[dbo25].[dimensions]'))
    ALTER TABLE [dbo25].[dimensions] DROP CONSTRAINT [FK_dimensions_name_formats];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_factors_calc_types_calc_type_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[factors]'))
    ALTER TABLE [dbo25].[factors] DROP CONSTRAINT [FK_factors_calc_types_calc_type_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_factors_members_member_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[factors]'))
    ALTER TABLE [dbo25].[factors] DROP CONSTRAINT [FK_factors_members_member_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_factors_members_parent_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[factors]'))
    ALTER TABLE [dbo25].[factors] DROP CONSTRAINT [FK_factors_members_parent_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_facts_members_id1]') AND parent_object_id = OBJECT_ID(N'[dbo25].[facts]'))
    ALTER TABLE [dbo25].[facts] DROP CONSTRAINT [FK_facts_members_id1];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_facts_members_id2]') AND parent_object_id = OBJECT_ID(N'[dbo25].[facts]'))
    ALTER TABLE [dbo25].[facts] DROP CONSTRAINT [FK_facts_members_id2];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_facts_members_id3]') AND parent_object_id = OBJECT_ID(N'[dbo25].[facts]'))
    ALTER TABLE [dbo25].[facts] DROP CONSTRAINT [FK_facts_members_id3];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_facts_members_id4]') AND parent_object_id = OBJECT_ID(N'[dbo25].[facts]'))
    ALTER TABLE [dbo25].[facts] DROP CONSTRAINT [FK_facts_members_id4];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_facts_members_id5]') AND parent_object_id = OBJECT_ID(N'[dbo25].[facts]'))
    ALTER TABLE [dbo25].[facts] DROP CONSTRAINT [FK_facts_members_id5];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_facts_members_id6]') AND parent_object_id = OBJECT_ID(N'[dbo25].[facts]'))
    ALTER TABLE [dbo25].[facts] DROP CONSTRAINT [FK_facts_members_id6];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_facts_members_id7]') AND parent_object_id = OBJECT_ID(N'[dbo25].[facts]'))
    ALTER TABLE [dbo25].[facts] DROP CONSTRAINT [FK_facts_members_id7];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_dimensions_axis_types]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_dimensions]'))
    ALTER TABLE [dbo25].[form_dimensions] DROP CONSTRAINT [FK_form_dimensions_axis_types];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_dimensions_dimensions]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_dimensions]'))
    ALTER TABLE [dbo25].[form_dimensions] DROP CONSTRAINT [FK_form_dimensions_dimensions];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_dimensions_forms]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_dimensions]'))
    ALTER TABLE [dbo25].[form_dimensions] DROP CONSTRAINT [FK_form_dimensions_forms];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_dimensions_members]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_dimensions]'))
    ALTER TABLE [dbo25].[form_dimensions] DROP CONSTRAINT [FK_form_dimensions_members];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_permissions_forms]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_permissions]'))
    ALTER TABLE [dbo25].[form_permissions] DROP CONSTRAINT [FK_form_permissions_forms];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_rows_members]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_rows]'))
    ALTER TABLE [dbo25].[form_rows] DROP CONSTRAINT [FK_form_rows_members];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_rows_members_rowset_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_rows]'))
    ALTER TABLE [dbo25].[form_rows] DROP CONSTRAINT [FK_form_rows_members_rowset_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_subtotals_dimensions_dimension_id1]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_subtotals]'))
    ALTER TABLE [dbo25].[form_subtotals] DROP CONSTRAINT [FK_form_subtotals_dimensions_dimension_id1];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_subtotals_dimensions_dimension_id2]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_subtotals]'))
    ALTER TABLE [dbo25].[form_subtotals] DROP CONSTRAINT [FK_form_subtotals_dimensions_dimension_id2];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_subtotals_dimensions_dimension_id3]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_subtotals]'))
    ALTER TABLE [dbo25].[form_subtotals] DROP CONSTRAINT [FK_form_subtotals_dimensions_dimension_id3];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_subtotals_forms]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_subtotals]'))
    ALTER TABLE [dbo25].[form_subtotals] DROP CONSTRAINT [FK_form_subtotals_forms];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_subtotals_members_member_id1]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_subtotals]'))
    ALTER TABLE [dbo25].[form_subtotals] DROP CONSTRAINT [FK_form_subtotals_members_member_id1];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_subtotals_members_member_id2]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_subtotals]'))
    ALTER TABLE [dbo25].[form_subtotals] DROP CONSTRAINT [FK_form_subtotals_members_member_id2];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_form_subtotals_members_member_id3]') AND parent_object_id = OBJECT_ID(N'[dbo25].[form_subtotals]'))
    ALTER TABLE [dbo25].[form_subtotals] DROP CONSTRAINT [FK_form_subtotals_members_member_id3];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_formats_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[formats]'))
    ALTER TABLE [dbo25].[formats] DROP CONSTRAINT [FK_formats_companies];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_forms_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[forms]'))
    ALTER TABLE [dbo25].[forms] DROP CONSTRAINT [FK_forms_companies];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_hierarchies_members_member_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[hierarchies]'))
    ALTER TABLE [dbo25].[hierarchies] DROP CONSTRAINT [FK_hierarchies_members_member_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_hierarchies_members_parent_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[hierarchies]'))
    ALTER TABLE [dbo25].[hierarchies] DROP CONSTRAINT [FK_hierarchies_members_parent_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_member_permissions_members_member_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[member_permissions]'))
    ALTER TABLE [dbo25].[member_permissions] DROP CONSTRAINT [FK_member_permissions_members_member_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_member_relations_members_member_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[member_relations]'))
    ALTER TABLE [dbo25].[member_relations] DROP CONSTRAINT [FK_member_relations_members_member_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_member_relations_members_partner_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[member_relations]'))
    ALTER TABLE [dbo25].[member_relations] DROP CONSTRAINT [FK_member_relations_members_partner_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_members_calc_types]') AND parent_object_id = OBJECT_ID(N'[dbo25].[members]'))
    ALTER TABLE [dbo25].[members] DROP CONSTRAINT [FK_members_calc_types];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_members_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[members]'))
    ALTER TABLE [dbo25].[members] DROP CONSTRAINT [FK_members_companies];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_members_dimensions]') AND parent_object_id = OBJECT_ID(N'[dbo25].[members]'))
    ALTER TABLE [dbo25].[members] DROP CONSTRAINT [FK_members_dimensions];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_members_members_same_period_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[members]'))
    ALTER TABLE [dbo25].[members] DROP CONSTRAINT [FK_members_members_same_period_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_members_previous_period]') AND parent_object_id = OBJECT_ID(N'[dbo25].[members]'))
    ALTER TABLE [dbo25].[members] DROP CONSTRAINT [FK_members_previous_period];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_members_tax_rates]') AND parent_object_id = OBJECT_ID(N'[dbo25].[members]'))
    ALTER TABLE [dbo25].[members] DROP CONSTRAINT [FK_members_tax_rates];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_members_units]') AND parent_object_id = OBJECT_ID(N'[dbo25].[members]'))
    ALTER TABLE [dbo25].[members] DROP CONSTRAINT [FK_members_units];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_parents_members_member_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[parents]'))
    ALTER TABLE [dbo25].[parents] DROP CONSTRAINT [FK_parents_members_member_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_parents_members_parent_id]') AND parent_object_id = OBJECT_ID(N'[dbo25].[parents]'))
    ALTER TABLE [dbo25].[parents] DROP CONSTRAINT [FK_parents_members_parent_id];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_strings_members_id1]') AND parent_object_id = OBJECT_ID(N'[dbo25].[strings]'))
    ALTER TABLE [dbo25].[strings] DROP CONSTRAINT [FK_strings_members_id1];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_strings_members_id2]') AND parent_object_id = OBJECT_ID(N'[dbo25].[strings]'))
    ALTER TABLE [dbo25].[strings] DROP CONSTRAINT [FK_strings_members_id2];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_strings_members_id3]') AND parent_object_id = OBJECT_ID(N'[dbo25].[strings]'))
    ALTER TABLE [dbo25].[strings] DROP CONSTRAINT [FK_strings_members_id3];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_strings_members_id4]') AND parent_object_id = OBJECT_ID(N'[dbo25].[strings]'))
    ALTER TABLE [dbo25].[strings] DROP CONSTRAINT [FK_strings_members_id4];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_strings_members_id5]') AND parent_object_id = OBJECT_ID(N'[dbo25].[strings]'))
    ALTER TABLE [dbo25].[strings] DROP CONSTRAINT [FK_strings_members_id5];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_strings_members_id6]') AND parent_object_id = OBJECT_ID(N'[dbo25].[strings]'))
    ALTER TABLE [dbo25].[strings] DROP CONSTRAINT [FK_strings_members_id6];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_strings_members_id7]') AND parent_object_id = OBJECT_ID(N'[dbo25].[strings]'))
    ALTER TABLE [dbo25].[strings] DROP CONSTRAINT [FK_strings_members_id7];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_tax_rates_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[tax_rates]'))
    ALTER TABLE [dbo25].[tax_rates] DROP CONSTRAINT [FK_tax_rates_companies];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_translations_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[translations]'))
    ALTER TABLE [dbo25].[translations] DROP CONSTRAINT [FK_translations_companies];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_translations_translated_tables]') AND parent_object_id = OBJECT_ID(N'[dbo25].[translations]'))
    ALTER TABLE [dbo25].[translations] DROP CONSTRAINT [FK_translations_translated_tables];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_units_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[units]'))
    ALTER TABLE [dbo25].[units] DROP CONSTRAINT [FK_units_companies];
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo25].[FK_users_companies]') AND parent_object_id = OBJECT_ID(N'[dbo25].[users]'))
    ALTER TABLE [dbo25].[users] DROP CONSTRAINT [FK_users_companies];
GO

IF OBJECT_ID('[dbo25].[usp_export_all]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_all];
GO
IF OBJECT_ID('[dbo25].[usp_export_companies]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_companies];
GO
IF OBJECT_ID('[dbo25].[usp_export_currency_rates]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_currency_rates];
GO
IF OBJECT_ID('[dbo25].[usp_export_dimension_calc_types]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_dimension_calc_types];
GO
IF OBJECT_ID('[dbo25].[usp_export_dimension_members]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_dimension_members];
GO
IF OBJECT_ID('[dbo25].[usp_export_dimension_properties]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_dimension_properties];
GO
IF OBJECT_ID('[dbo25].[usp_export_dimensions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_dimensions];
GO
IF OBJECT_ID('[dbo25].[usp_export_facts]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_facts];
GO
IF OBJECT_ID('[dbo25].[usp_export_form_dimensions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_form_dimensions];
GO
IF OBJECT_ID('[dbo25].[usp_export_form_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_form_permissions];
GO
IF OBJECT_ID('[dbo25].[usp_export_form_rows]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_form_rows];
GO
IF OBJECT_ID('[dbo25].[usp_export_form_subtotals]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_form_subtotals];
GO
IF OBJECT_ID('[dbo25].[usp_export_formats]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_formats];
GO
IF OBJECT_ID('[dbo25].[usp_export_forms]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_forms];
GO
IF OBJECT_ID('[dbo25].[usp_export_member_parents]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_member_parents];
GO
IF OBJECT_ID('[dbo25].[usp_export_member_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_member_permissions];
GO
IF OBJECT_ID('[dbo25].[usp_export_member_properties]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_member_properties];
GO
IF OBJECT_ID('[dbo25].[usp_export_member_relations]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_member_relations];
GO
IF OBJECT_ID('[dbo25].[usp_export_members]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_members];
GO
IF OBJECT_ID('[dbo25].[usp_export_strings]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_strings];
GO
IF OBJECT_ID('[dbo25].[usp_export_tax_rates]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_tax_rates];
GO
IF OBJECT_ID('[dbo25].[usp_export_translations]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_translations];
GO
IF OBJECT_ID('[dbo25].[usp_export_units]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_units];
GO
IF OBJECT_ID('[dbo25].[usp_export_users]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_export_users];
GO
IF OBJECT_ID('[dbo25].[usp_import_clear_all_data]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_clear_all_data];
GO
IF OBJECT_ID('[dbo25].[usp_import_companies]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_companies];
GO
IF OBJECT_ID('[dbo25].[usp_import_currency_rates]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_currency_rates];
GO
IF OBJECT_ID('[dbo25].[usp_import_dimension_calc_types]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_dimension_calc_types];
GO
IF OBJECT_ID('[dbo25].[usp_import_dimension_members]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_dimension_members];
GO
IF OBJECT_ID('[dbo25].[usp_import_dimension_properties]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_dimension_properties];
GO
IF OBJECT_ID('[dbo25].[usp_import_dimensions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_dimensions];
GO
IF OBJECT_ID('[dbo25].[usp_import_facts]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_facts];
GO
IF OBJECT_ID('[dbo25].[usp_import_finish]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_finish];
GO
IF OBJECT_ID('[dbo25].[usp_import_form_dimensions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_form_dimensions];
GO
IF OBJECT_ID('[dbo25].[usp_import_form_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_form_permissions];
GO
IF OBJECT_ID('[dbo25].[usp_import_form_rows]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_form_rows];
GO
IF OBJECT_ID('[dbo25].[usp_import_form_subtotals]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_form_subtotals];
GO
IF OBJECT_ID('[dbo25].[usp_import_formats]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_formats];
GO
IF OBJECT_ID('[dbo25].[usp_import_forms]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_forms];
GO
IF OBJECT_ID('[dbo25].[usp_import_member_parents]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_member_parents];
GO
IF OBJECT_ID('[dbo25].[usp_import_member_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_member_permissions];
GO
IF OBJECT_ID('[dbo25].[usp_import_member_properties]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_member_properties];
GO
IF OBJECT_ID('[dbo25].[usp_import_member_relations]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_member_relations];
GO
IF OBJECT_ID('[dbo25].[usp_import_members]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_members];
GO
IF OBJECT_ID('[dbo25].[usp_import_strings]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_strings];
GO
IF OBJECT_ID('[dbo25].[usp_import_tax_rates]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_tax_rates];
GO
IF OBJECT_ID('[dbo25].[usp_import_translations]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_translations];
GO
IF OBJECT_ID('[dbo25].[usp_import_units]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_units];
GO
IF OBJECT_ID('[dbo25].[usp_import_users]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[usp_import_users];
GO
IF OBJECT_ID('[dbo25].[xl_actions_create_standard_forms]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[xl_actions_create_standard_forms];
GO
IF OBJECT_ID('[dbo25].[xl_actions_create_standard_members]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[xl_actions_create_standard_members];
GO
IF OBJECT_ID('[dbo25].[xl_actions_create_standard_tax_rates]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[xl_actions_create_standard_tax_rates];
GO
IF OBJECT_ID('[dbo25].[xl_actions_create_standard_units]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[xl_actions_create_standard_units];
GO
IF OBJECT_ID('[dbo25].[xl_actions_set_doc_role_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[xl_actions_set_doc_role_permissions];
GO
IF OBJECT_ID('[dbo25].[xl_actions_set_log_role_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[xl_actions_set_log_role_permissions];
GO
IF OBJECT_ID('[dbo25].[xl_actions_set_role_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [dbo25].[xl_actions_set_role_permissions];
GO
IF OBJECT_ID('[xls25].[usp_axis_types]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_axis_types];
GO
IF OBJECT_ID('[xls25].[usp_calc_types]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_calc_types];
GO
IF OBJECT_ID('[xls25].[usp_closed_periods]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_closed_periods];
GO
IF OBJECT_ID('[xls25].[usp_closed_periods_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_closed_periods_change];
GO
IF OBJECT_ID('[xls25].[usp_companies]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_companies];
GO
IF OBJECT_ID('[xls25].[usp_companies_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_companies_delete];
GO
IF OBJECT_ID('[xls25].[usp_companies_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_companies_insert];
GO
IF OBJECT_ID('[xls25].[usp_companies_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_companies_update];
GO
IF OBJECT_ID('[xls25].[usp_currency_rates]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_currency_rates];
GO
IF OBJECT_ID('[xls25].[usp_currency_rates_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_currency_rates_change];
GO
IF OBJECT_ID('[xls25].[usp_data_management]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_data_management];
GO
IF OBJECT_ID('[xls25].[usp_dimensions]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_dimensions];
GO
IF OBJECT_ID('[xls25].[usp_dimensions_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_dimensions_change];
GO
IF OBJECT_ID('[xls25].[usp_dimensions_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_dimensions_delete];
GO
IF OBJECT_ID('[xls25].[usp_dimensions_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_dimensions_insert];
GO
IF OBJECT_ID('[xls25].[usp_dimensions_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_dimensions_update];
GO
IF OBJECT_ID('[xls25].[usp_facts]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_facts];
GO
IF OBJECT_ID('[xls25].[usp_facts_data]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_facts_data];
GO
IF OBJECT_ID('[xls25].[usp_facts_strings]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_facts_strings];
GO
IF OBJECT_ID('[xls25].[usp_form_dimensions]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_dimensions];
GO
IF OBJECT_ID('[xls25].[usp_form_dimensions_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_dimensions_delete];
GO
IF OBJECT_ID('[xls25].[usp_form_dimensions_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_dimensions_insert];
GO
IF OBJECT_ID('[xls25].[usp_form_dimensions_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_dimensions_update];
GO
IF OBJECT_ID('[xls25].[usp_form_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_permissions];
GO
IF OBJECT_ID('[xls25].[usp_form_permissions_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_permissions_change];
GO
IF OBJECT_ID('[xls25].[usp_form_rows]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_rows];
GO
IF OBJECT_ID('[xls25].[usp_form_rows_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_rows_delete];
GO
IF OBJECT_ID('[xls25].[usp_form_rows_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_rows_insert];
GO
IF OBJECT_ID('[xls25].[usp_form_rows_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_form_rows_update];
GO
IF OBJECT_ID('[xls25].[usp_forms]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_forms];
GO
IF OBJECT_ID('[xls25].[usp_forms_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_forms_delete];
GO
IF OBJECT_ID('[xls25].[usp_forms_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_forms_insert];
GO
IF OBJECT_ID('[xls25].[usp_forms_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_forms_update];
GO
IF OBJECT_ID('[xls25].[usp_member_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_member_permissions];
GO
IF OBJECT_ID('[xls25].[usp_member_permissions_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_member_permissions_change];
GO
IF OBJECT_ID('[xls25].[usp_member_relations]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_member_relations];
GO
IF OBJECT_ID('[xls25].[usp_member_relations_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_member_relations_change];
GO
IF OBJECT_ID('[xls25].[usp_members]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_members];
GO
IF OBJECT_ID('[xls25].[usp_members_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_members_delete];
GO
IF OBJECT_ID('[xls25].[usp_members_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_members_insert];
GO
IF OBJECT_ID('[xls25].[usp_members_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_members_update];
GO
IF OBJECT_ID('[xls25].[usp_name_formats]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_name_formats];
GO
IF OBJECT_ID('[xls25].[usp_role_members]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_role_members];
GO
IF OBJECT_ID('[xls25].[usp_role_members_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_role_members_change];
GO
IF OBJECT_ID('[xls25].[usp_rowsets]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_rowsets];
GO
IF OBJECT_ID('[xls25].[usp_rowsets_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_rowsets_delete];
GO
IF OBJECT_ID('[xls25].[usp_rowsets_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_rowsets_insert];
GO
IF OBJECT_ID('[xls25].[usp_rowsets_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_rowsets_update];
GO
IF OBJECT_ID('[xls25].[usp_run_form]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_run_form];
GO
IF OBJECT_ID('[xls25].[usp_run_form_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_run_form_change];
GO
IF OBJECT_ID('[xls25].[usp_run_json_form]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_run_json_form];
GO
IF OBJECT_ID('[xls25].[usp_run_offline_form]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_run_offline_form];
GO
IF OBJECT_ID('[xls25].[usp_run_offline_form_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_run_offline_form_delete];
GO
IF OBJECT_ID('[xls25].[usp_run_offline_form_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_run_offline_form_insert];
GO
IF OBJECT_ID('[xls25].[usp_run_offline_form_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_run_offline_form_update];
GO
IF OBJECT_ID('[xls25].[usp_tax_rates]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_tax_rates];
GO
IF OBJECT_ID('[xls25].[usp_tax_rates_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_tax_rates_delete];
GO
IF OBJECT_ID('[xls25].[usp_tax_rates_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_tax_rates_insert];
GO
IF OBJECT_ID('[xls25].[usp_tax_rates_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_tax_rates_update];
GO
IF OBJECT_ID('[xls25].[usp_translations]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_translations];
GO
IF OBJECT_ID('[xls25].[usp_translations_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_translations_change];
GO
IF OBJECT_ID('[xls25].[usp_translations_common]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_translations_common];
GO
IF OBJECT_ID('[xls25].[usp_translations_xls]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_translations_xls];
GO
IF OBJECT_ID('[xls25].[usp_translations_xls_change]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_translations_xls_change];
GO
IF OBJECT_ID('[xls25].[usp_units]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_units];
GO
IF OBJECT_ID('[xls25].[usp_units_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_units_delete];
GO
IF OBJECT_ID('[xls25].[usp_units_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_units_insert];
GO
IF OBJECT_ID('[xls25].[usp_units_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_units_update];
GO
IF OBJECT_ID('[xls25].[usp_users]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_users];
GO
IF OBJECT_ID('[xls25].[usp_users_delete]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_users_delete];
GO
IF OBJECT_ID('[xls25].[usp_users_insert]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_users_insert];
GO
IF OBJECT_ID('[xls25].[usp_users_update]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[usp_users_update];
GO
IF OBJECT_ID('[xls25].[xl_actions_add_language]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_add_language];
GO
IF OBJECT_ID('[xls25].[xl_actions_add_quarters]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_add_quarters];
GO
IF OBJECT_ID('[xls25].[xl_actions_add_year]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_add_year];
GO
IF OBJECT_ID('[xls25].[xl_actions_copy_data]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_copy_data];
GO
IF OBJECT_ID('[xls25].[xl_actions_delete_data]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_delete_data];
GO
IF OBJECT_ID('[xls25].[xl_actions_delete_year]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_delete_year];
GO
IF OBJECT_ID('[xls25].[xl_actions_run_form_cell_data]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_run_form_cell_data];
GO
IF OBJECT_ID('[xls25].[xl_actions_set_functional_currency]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_set_functional_currency];
GO
IF OBJECT_ID('[xls25].[xl_actions_update_facts]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_update_facts];
GO
IF OBJECT_ID('[xls25].[xl_actions_update_hierarchies]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_update_hierarchies];
GO
IF OBJECT_ID('[xls25].[xl_actions_update_member_permissions]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_actions_update_member_permissions];
GO
IF OBJECT_ID('[xls25].[xl_aliases_members]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_aliases_members];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_0_or_1]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_0_or_1];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_calc_type_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_calc_type_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_calc_type_id_or_null]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_calc_type_id_or_null];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_company_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_company_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_currency_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_currency_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_dimension_id_or_null]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_dimension_id_or_null];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_form_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_form_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_form_id_or_null]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_form_id_or_null];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_by_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_by_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_dim1]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_dim1];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_dim2]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_dim2];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_dim3]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_dim3];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_dim4]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_dim4];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_dim5]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_dim5];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_dim6]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_dim6];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_member_id_dim7]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_member_id_dim7];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_relation_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_relation_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_relation_partner_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_relation_partner_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_root_member_id_code]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_root_member_id_code];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_rowset_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_rowset_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_rowset_id_or_null]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_rowset_id_or_null];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p1]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p1];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p2]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p2];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p3]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p3];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p4]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p4];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p5]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p5];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p6]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p6];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_run_form_p7]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_run_form_p7];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_unit_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_unit_id];
GO
IF OBJECT_ID('[xls25].[xl_parameter_values_username]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_parameter_values_username];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_axis_type_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_axis_type_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_calc_type_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_calc_type_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_calc_type_id_by_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_calc_type_id_by_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_default_member_id_code]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_default_member_id_code];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_member_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_member_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_member_id_code_by_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_member_id_code_by_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_member_id_code_by_rowset_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_member_id_code_by_rowset_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_name_format_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_name_format_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_previous_period_id_by_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_previous_period_id_by_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_root_member_id_code]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_root_member_id_code];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_root_member_or_rowset_id_code]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_root_member_or_rowset_id_code];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_rowset_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_rowset_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_same_period_id_by_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_same_period_id_by_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_tax_rate_id_by_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_tax_rate_id_by_dimension_id];
GO
IF OBJECT_ID('[xls25].[xl_validation_list_unit_id_by_dimension_id]', 'P') IS NOT NULL
DROP PROCEDURE [xls25].[xl_validation_list_unit_id_by_dimension_id];
GO
IF OBJECT_ID('[xls25a].[usp_update_table_format]', 'P') IS NOT NULL
DROP PROCEDURE [xls25a].[usp_update_table_format];
GO
IF OBJECT_ID('[xls25b].[usp_update_table_format]', 'P') IS NOT NULL
DROP PROCEDURE [xls25b].[usp_update_table_format];
GO

IF OBJECT_ID('[dbo25].[view_dynamic_form_fields]', 'V') IS NOT NULL
DROP VIEW [dbo25].[view_dynamic_form_fields];
GO
IF OBJECT_ID('[dbo25].[view_facts]', 'V') IS NOT NULL
DROP VIEW [dbo25].[view_facts];
GO
IF OBJECT_ID('[dbo25].[view_facts_data]', 'V') IS NOT NULL
DROP VIEW [dbo25].[view_facts_data];
GO
IF OBJECT_ID('[dbo25].[view_query_list]', 'V') IS NOT NULL
DROP VIEW [dbo25].[view_query_list];
GO
IF OBJECT_ID('[xls25].[view_hierarchies]', 'V') IS NOT NULL
DROP VIEW [xls25].[view_hierarchies];
GO
IF OBJECT_ID('[xls25].[xl_formats]', 'V') IS NOT NULL
DROP VIEW [xls25].[xl_formats];
GO
IF OBJECT_ID('[xls25].[xl_handlers]', 'V') IS NOT NULL
DROP VIEW [xls25].[xl_handlers];
GO
IF OBJECT_ID('[xls25].[xl_query_list]', 'V') IS NOT NULL
DROP VIEW [xls25].[xl_query_list];
GO
IF OBJECT_ID('[xls25].[xl_query_list_offline_forms]', 'V') IS NOT NULL
DROP VIEW [xls25].[xl_query_list_offline_forms];
GO
IF OBJECT_ID('[xls25].[xl_query_list_online_forms]', 'V') IS NOT NULL
DROP VIEW [xls25].[xl_query_list_online_forms];
GO
IF OBJECT_ID('[xls25].[xl_translations]', 'V') IS NOT NULL
DROP VIEW [xls25].[xl_translations];
GO

IF OBJECT_ID('[dbo25].[get_translated_string]', 'FN') IS NOT NULL
DROP FUNCTION [dbo25].[get_translated_string];
GO

IF OBJECT_ID('[dbo25].[get_json_array_values]', 'TF') IS NOT NULL
DROP FUNCTION [dbo25].[get_json_array_values];
GO
IF OBJECT_ID('[dbo25].[get_json_object_values]', 'TF') IS NOT NULL
DROP FUNCTION [dbo25].[get_json_object_values];
GO
IF OBJECT_ID('[dbo25].[get_quarter_members]', 'TF') IS NOT NULL
DROP FUNCTION [dbo25].[get_quarter_members];
GO
IF OBJECT_ID('[dbo25].[get_standard_members]', 'TF') IS NOT NULL
DROP FUNCTION [dbo25].[get_standard_members];
GO
IF OBJECT_ID('[dbo25].[get_year_members]', 'TF') IS NOT NULL
DROP FUNCTION [dbo25].[get_year_members];
GO

IF OBJECT_ID('[dbo25].[axis_types]', 'U') IS NOT NULL
DROP TABLE [dbo25].[axis_types];
GO
IF OBJECT_ID('[dbo25].[calc_types]', 'U') IS NOT NULL
DROP TABLE [dbo25].[calc_types];
GO
IF OBJECT_ID('[dbo25].[companies]', 'U') IS NOT NULL
DROP TABLE [dbo25].[companies];
GO
IF OBJECT_ID('[dbo25].[currency_rates]', 'U') IS NOT NULL
DROP TABLE [dbo25].[currency_rates];
GO
IF OBJECT_ID('[dbo25].[dimension_calc_types]', 'U') IS NOT NULL
DROP TABLE [dbo25].[dimension_calc_types];
GO
IF OBJECT_ID('[dbo25].[dimension_properties]', 'U') IS NOT NULL
DROP TABLE [dbo25].[dimension_properties];
GO
IF OBJECT_ID('[dbo25].[dimensions]', 'U') IS NOT NULL
DROP TABLE [dbo25].[dimensions];
GO
IF OBJECT_ID('[dbo25].[factors]', 'U') IS NOT NULL
DROP TABLE [dbo25].[factors];
GO
IF OBJECT_ID('[dbo25].[facts]', 'U') IS NOT NULL
DROP TABLE [dbo25].[facts];
GO
IF OBJECT_ID('[dbo25].[form_dimensions]', 'U') IS NOT NULL
DROP TABLE [dbo25].[form_dimensions];
GO
IF OBJECT_ID('[dbo25].[form_permissions]', 'U') IS NOT NULL
DROP TABLE [dbo25].[form_permissions];
GO
IF OBJECT_ID('[dbo25].[form_rows]', 'U') IS NOT NULL
DROP TABLE [dbo25].[form_rows];
GO
IF OBJECT_ID('[dbo25].[form_subtotals]', 'U') IS NOT NULL
DROP TABLE [dbo25].[form_subtotals];
GO
IF OBJECT_ID('[dbo25].[formats]', 'U') IS NOT NULL
DROP TABLE [dbo25].[formats];
GO
IF OBJECT_ID('[dbo25].[forms]', 'U') IS NOT NULL
DROP TABLE [dbo25].[forms];
GO
IF OBJECT_ID('[dbo25].[hierarchies]', 'U') IS NOT NULL
DROP TABLE [dbo25].[hierarchies];
GO
IF OBJECT_ID('[dbo25].[member_permissions]', 'U') IS NOT NULL
DROP TABLE [dbo25].[member_permissions];
GO
IF OBJECT_ID('[dbo25].[member_relations]', 'U') IS NOT NULL
DROP TABLE [dbo25].[member_relations];
GO
IF OBJECT_ID('[dbo25].[members]', 'U') IS NOT NULL
DROP TABLE [dbo25].[members];
GO
IF OBJECT_ID('[dbo25].[name_formats]', 'U') IS NOT NULL
DROP TABLE [dbo25].[name_formats];
GO
IF OBJECT_ID('[dbo25].[parents]', 'U') IS NOT NULL
DROP TABLE [dbo25].[parents];
GO
IF OBJECT_ID('[dbo25].[strings]', 'U') IS NOT NULL
DROP TABLE [dbo25].[strings];
GO
IF OBJECT_ID('[dbo25].[tax_rates]', 'U') IS NOT NULL
DROP TABLE [dbo25].[tax_rates];
GO
IF OBJECT_ID('[dbo25].[translated_tables]', 'U') IS NOT NULL
DROP TABLE [dbo25].[translated_tables];
GO
IF OBJECT_ID('[dbo25].[translations]', 'U') IS NOT NULL
DROP TABLE [dbo25].[translations];
GO
IF OBJECT_ID('[dbo25].[units]', 'U') IS NOT NULL
DROP TABLE [dbo25].[units];
GO
IF OBJECT_ID('[dbo25].[users]', 'U') IS NOT NULL
DROP TABLE [dbo25].[users];
GO


DECLARE @sql nvarchar(max) = ''

SELECT
    @sql = @sql + 'ALTER ROLE ' + QUOTENAME(r.name) + ' DROP MEMBER ' + QUOTENAME(m.name) + ';' + CHAR(13) + CHAR(10)
FROM
    sys.database_role_members rm
    INNER JOIN sys.database_principals r ON r.principal_id = rm.role_principal_id
    INNER JOIN sys.database_principals m ON m.principal_id = rm.member_principal_id
WHERE
    r.name IN ('planning_app_admins', 'planning_app_analysts', 'planning_app_developers', 'planning_app_users')

IF LEN(@sql) > 1
    BEGIN
    EXEC (@sql);
    PRINT @sql
    END
GO

IF DATABASE_PRINCIPAL_ID('planning_app_admins') IS NOT NULL
DROP ROLE [planning_app_admins];
GO
IF DATABASE_PRINCIPAL_ID('planning_app_analysts') IS NOT NULL
DROP ROLE [planning_app_analysts];
GO
IF DATABASE_PRINCIPAL_ID('planning_app_developers') IS NOT NULL
DROP ROLE [planning_app_developers];
GO
IF DATABASE_PRINCIPAL_ID('planning_app_users') IS NOT NULL
DROP ROLE [planning_app_users];
GO

IF SCHEMA_ID('dbo25') IS NOT NULL
DROP SCHEMA [dbo25];
GO
IF SCHEMA_ID('xls25') IS NOT NULL
DROP SCHEMA [xls25];
GO
IF SCHEMA_ID('xls25a') IS NOT NULL
DROP SCHEMA [xls25a];
GO
IF SCHEMA_ID('xls25b') IS NOT NULL
DROP SCHEMA [xls25b];
GO


IF DATABASE_PRINCIPAL_ID('pa_admin_01') IS NOT NULL
DROP USER [pa_admin_01];
GO
IF DATABASE_PRINCIPAL_ID('pa_analyst_01') IS NOT NULL
DROP USER [pa_analyst_01];
GO
IF DATABASE_PRINCIPAL_ID('pa_developer_01') IS NOT NULL
DROP USER [pa_developer_01];
GO
IF DATABASE_PRINCIPAL_ID('pa_user_01') IS NOT NULL
DROP USER [pa_user_01];
GO
IF DATABASE_PRINCIPAL_ID('pa_user_101') IS NOT NULL
DROP USER [pa_user_101];
GO
IF DATABASE_PRINCIPAL_ID('pa_user_201') IS NOT NULL
DROP USER [pa_user_201];
GO
IF DATABASE_PRINCIPAL_ID('pa_user_301') IS NOT NULL
DROP USER [pa_user_301];
GO
IF DATABASE_PRINCIPAL_ID('pa_user_401') IS NOT NULL
DROP USER [pa_user_401];
GO

IF DATABASE_PRINCIPAL_ID('planning_app') IS NOT NULL
DROP USER [planning_app];
GO

print 'Application removed';

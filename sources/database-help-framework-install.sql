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

CREATE SCHEMA doc;
GO

CREATE TABLE doc.formats (
    ID int IDENTITY(1,1) NOT NULL
    , TABLE_SCHEMA nvarchar(20) NOT NULL
    , TABLE_NAME nvarchar(128) NOT NULL
    , TABLE_EXCEL_FORMAT_XML xml NULL
    , APP nvarchar(50) NULL
    , CONSTRAINT PK_formats PRIMARY KEY (ID)
    , CONSTRAINT IX_formats UNIQUE (TABLE_SCHEMA, TABLE_NAME, APP)
);
GO

CREATE TABLE doc.handlers (
    ID int IDENTITY(1,1) NOT NULL
    , TABLE_SCHEMA nvarchar(20) NULL
    , TABLE_NAME nvarchar(128) NOT NULL
    , COLUMN_NAME nvarchar(128) NULL
    , EVENT_NAME varchar(25) NULL
    , HANDLER_SCHEMA nvarchar(20) NULL
    , HANDLER_NAME nvarchar(128) NULL
    , HANDLER_TYPE varchar(25) NULL
    , HANDLER_CODE nvarchar(max) NULL
    , TARGET_WORKSHEET nvarchar(128) NULL
    , MENU_ORDER int NULL
    , EDIT_PARAMETERS bit NULL
    , CONSTRAINT PK_handlers PRIMARY KEY (ID)
    , CONSTRAINT IX_handlers UNIQUE (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME)
);
GO

CREATE TABLE doc.help_sections (
    ID tinyint NOT NULL
    , SECTION nvarchar(50) NOT NULL
    , CONSTRAINT PK_help_sections PRIMARY KEY (ID)
    , CONSTRAINT IX_help_sections_section UNIQUE (SECTION)
);
GO

CREATE TABLE doc.history_sections (
    ID tinyint NOT NULL
    , SECTION nvarchar(50) NOT NULL
    , CONSTRAINT PK_history_sections PRIMARY KEY (ID)
    , CONSTRAINT IX_history_sections_section UNIQUE (SECTION)
);
GO

CREATE TABLE doc.objects (
    ID int IDENTITY(1,1) NOT NULL
    , TABLE_SCHEMA nvarchar(20) NOT NULL
    , TABLE_NAME nvarchar(128) NOT NULL
    , TABLE_TYPE nvarchar(128) NOT NULL
    , TABLE_CODE nvarchar(max) NULL
    , INSERT_OBJECT nvarchar(max) NULL
    , UPDATE_OBJECT nvarchar(max) NULL
    , DELETE_OBJECT nvarchar(max) NULL
    , CONSTRAINT PK_objects PRIMARY KEY (ID)
    , CONSTRAINT IX_objects UNIQUE (TABLE_SCHEMA, TABLE_NAME)
);
GO

CREATE TABLE doc.translations (
    ID int IDENTITY(1,1) NOT NULL
    , TABLE_SCHEMA nvarchar(20) NULL
    , TABLE_NAME nvarchar(128) NULL
    , COLUMN_NAME nvarchar(128) NULL
    , LANGUAGE_NAME varchar(10) NULL
    , TRANSLATED_NAME nvarchar(128) NULL
    , TRANSLATED_DESC nvarchar(1024) NULL
    , TRANSLATED_COMMENT nvarchar(2000) NULL
    , CONSTRAINT PK_translations PRIMARY KEY (ID)
    , CONSTRAINT IX_translations UNIQUE (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME)
);
GO

CREATE TABLE doc.workbooks (
    ID int IDENTITY(1,1) NOT NULL
    , NAME nvarchar(128) NOT NULL
    , TEMPLATE nvarchar(255) NULL
    , DEFINITION nvarchar(max) NOT NULL
    , TABLE_SCHEMA nvarchar(128) NULL
    , CONSTRAINT PK_workbooks PRIMARY KEY (ID)
    , CONSTRAINT IX_workbooks UNIQUE (NAME)
);
GO

CREATE TABLE doc.help (
    ID int IDENTITY(1,1) NOT NULL
    , SECTION_ID tinyint NOT NULL
    , TABLE_SCHEMA nvarchar(20) NOT NULL
    , TABLE_NAME nvarchar(128) NOT NULL
    , COLUMN_NAME nvarchar(255) NULL
    , LANGUAGE_NAME varchar(10) NOT NULL
    , VERSION nvarchar(50) NULL
    , DESCRIPTION nvarchar(1024) NULL
    , COMMENT nvarchar(max) NULL
    , CONSTRAINT PK_help PRIMARY KEY (ID)
    , CONSTRAINT IX_help UNIQUE (SECTION_ID, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME)
);
GO

ALTER TABLE doc.help ADD CONSTRAINT FK_help_sections FOREIGN KEY (SECTION_ID) REFERENCES doc.help_sections (ID) ON UPDATE CASCADE;
GO

CREATE TABLE doc.history (
    ID int IDENTITY(1,1) NOT NULL
    , TABLE_SCHEMA nvarchar(20) NOT NULL
    , LANGUAGE_NAME varchar(10) NOT NULL
    , VERSION nvarchar(50) NOT NULL
    , SECTION_ID tinyint NOT NULL
    , SORT_ORDER tinyint NULL
    , DESCRIPTION nvarchar(1024) NULL
    , COMMENT nvarchar(max) NULL
    , CONSTRAINT PK_help_history PRIMARY KEY (ID)
);
GO

CREATE INDEX IX_history_doc ON doc.history (TABLE_SCHEMA, LANGUAGE_NAME, VERSION, SECTION_ID, SORT_ORDER);
GO

ALTER TABLE doc.history ADD CONSTRAINT FK_history_history_sections FOREIGN KEY (SECTION_ID) REFERENCES doc.history_sections (ID) ON UPDATE CASCADE;
GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Returns the escaped parameter name
-- =============================================

CREATE FUNCTION [doc].[get_escaped_parameter_name]
(
    @name nvarchar(128) = NULL
)
RETURNS nvarchar(255)
AS
BEGIN

RETURN
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    REPLACE(REPLACE(@name
    , ' ', '_x0020_'), '!', '_x0021_'), '"', '_x0022_'), '#', '_x0023_'), '$', '_x0024_')
    , '%', '_x0025_'), '&', '_x0026_'), '''', '_x0027_'), '(', '_x0028_'), ')', '_x0029_')
    , '*', '_x002A_'), '+', '_x002B_'), ',', '_x002C_'), '-', '_x002D_'), '.', '_x002E_')
    , '/', '_x002F_'), ':', '_x003A_'), ';', '_x003B_'), '<', '_x003C_'), '=', '_x003D_')
    , '>', '_x003E_'), '?', '_x003F_'), '@', '_x0040_'), '[', '_x005B_'), '\', '_x005C_')
    , ']', '_x005D_'), '^', '_x005E_'), '`', '_x0060_'), '{', '_x007B_'), '|', '_x007C_')
    , '}', '_x007D_'), '~', '_x007E_')

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects diagrams
-- =============================================

CREATE VIEW [doc].[view_diagrams]
AS

SELECT
    d.ID
    , d.TABLE_SCHEMA AS DIAGRAM_SCHEMA
    , d.TABLE_NAME AS DIAGRAM_NAME
    , d.COLUMN_NAME AS DIAGRAM_URL
    , d.LANGUAGE_NAME
    , d.VERSION
    , d.DESCRIPTION AS TITLE
    , d.COMMENT
FROM
    doc.help d
WHERE
    d.SECTION_ID = 4
    AND NOT d.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects the history
-- =============================================

CREATE VIEW [doc].[view_history]
AS

SELECT
    t.ID
    , ROW_NUMBER() OVER (ORDER BY t.LANGUAGE_NAME, t.TABLE_SCHEMA, t.VERSION, t.SECTION_ID, t.SORT_ORDER, t.ID) AS EXCEL_SORT_ORDER
    , t.SECTION_ID AS SECTION_SORT_ORDER
    , t.TABLE_SCHEMA
    , t.SECTION_ID
    , t.LANGUAGE_NAME
    , t.VERSION
    , t.SORT_ORDER
    , t.DESCRIPTION
    , t.COMMENT
FROM
    doc.history t
WHERE
    NOT t.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Selects an index of database objects for Excel worksheets
-- =============================================

CREATE VIEW [doc].[view_index]
AS

SELECT
    ROW_NUMBER() OVER(ORDER BY s.name, o.name) AS [#]
    , s.name + '.' + o.name AS [object]
FROM
    sys.objects o
    INNER JOIN sys.schemas s ON s.[schema_id] = o.[schema_id]
WHERE
    o.[type] IN ('U', 'V', 'P')
    AND s.name IN ('doc')
    AND NOT o.name LIKE 'xl_%'
    AND NOT o.name LIKE '%_change'
    AND NOT o.name IN (
        'formats',
        'help',
        'help_sections',
        'history',
        'history_sections',
        'view_index',
        'view_online_help_handlers',
        'view_query_list'
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects objects
-- =============================================

CREATE VIEW [doc].[view_objects]
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY t.SECTION, t.TABLE_SCHEMA, t.TABLE_NAME, t.LANGUAGE_NAME) AS SORT_ORDER
    , t.SECTION_ID
    , t.TABLE_SCHEMA
    , t.TABLE_NAME
    , t.TYPE
    , t.LANGUAGE_NAME
    , t.VERSION
    , t.DESCRIPTION
    , t.COMMENT
    , CASE WHEN t.COMMENT IS NOT NULL THEN 1
        ELSE CASE RIGHT(t.TABLE_NAME, 7) WHEN '_insert' THEN 1 WHEN '_update' THEN 1 WHEN '_delete' THEN 1 WHEN '_change' THEN 1 ELSE 0 END
        END AS HAS_COMMENTS
FROM
    (
        SELECT
            DISTINCT
            3 AS SECTION_ID
            , 'roles' AS TABLE_SCHEMA
            , p.name AS TABLE_NAME
            , 'role' AS TYPE
            , g.LANGUAGE_NAME
            , tr.VERSION
            , tr.DESCRIPTION
            , tr.COMMENT
            , 101 AS SECTION
        FROM
            sys.database_permissions dp
            INNER JOIN sys.database_principals p ON p.principal_id = dp.grantee_principal_id

            CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

            LEFT OUTER JOIN doc.help tr
                ON tr.SECTION_ID = 3 AND tr.TABLE_SCHEMA = 'roles' AND tr.TABLE_NAME = p.name
                    AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME
        WHERE
            dp.class IN (1, 3)
            AND p.is_fixed_role = 0
            AND NOT p.sid IS NULL
            AND NOT p.name IN ('dbo', 'guest', 'public')
            AND p.[type] = 'R'
            AND NOT p.name IN (
                SELECT
                    t.name
                FROM
                    (VALUES
                        ('doc', 'doc_readers'),
                        ('doc', 'doc_writers'),
                        ('logs', 'log_admins'),
                        ('logs', 'log_users'),
                        ('xls', 'xls_admins'),
                        ('xls', 'xls_developers'),
                        ('xls', 'xls_formats'),
                        ('xls', 'xls_users')
                        ) t(schema_name, name)
                WHERE
                    t.schema_name IN (
                        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
                    )
                )

        UNION ALL
        SELECT
            2 AS SECTION_ID
            , 'schemas' AS TABLE_SCHEMA
            , t.name AS TABLE_NAME
            , 'schema' AS TYPE
            , g.LANGUAGE_NAME
            , tr.VERSION
            , tr.DESCRIPTION
            , tr.COMMENT
            , 102 AS SECTION
        FROM
            (
                SELECT
                    t.TABLE_SCHEMA AS name
                FROM
                    INFORMATION_SCHEMA.TABLES t
                WHERE
                    NOT t.TABLE_NAME IN ('sysdiagrams')
                    AND NOT t.TABLE_SCHEMA IN ('sys')
                UNION
                SELECT
                    t.ROUTINE_SCHEMA AS name
                FROM
                    INFORMATION_SCHEMA.ROUTINES t
                WHERE
                    NOT t.ROUTINE_NAME LIKE 'sp_%'
                    AND NOT t.ROUTINE_NAME LIKE 'fn_%'
            ) t

            CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

            LEFT OUTER JOIN doc.help tr
                ON tr.SECTION_ID = 2 AND tr.TABLE_SCHEMA = 'schemas' AND tr.TABLE_NAME = t.name
                    AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME
        WHERE
            NOT t.name IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
            )

        UNION ALL
        SELECT
            1 AS SECTION_ID
            , t.TABLE_SCHEMA
            , t.TABLE_NAME
            , LOWER(REPLACE(t.TABLE_TYPE, 'BASE ', '')) AS TYPE
            , g.LANGUAGE_NAME
            , tr.VERSION
            , tr.DESCRIPTION
            , tr.COMMENT
            , CASE WHEN t.TABLE_TYPE = 'VIEW' THEN 104 ELSE 103 END AS SECTION
        FROM
            INFORMATION_SCHEMA.TABLES t

            CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

            LEFT OUTER JOIN doc.help tr
                ON tr.SECTION_ID = 1 AND tr.TABLE_SCHEMA = t.TABLE_SCHEMA AND tr.TABLE_NAME = t.TABLE_NAME
                    AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME
        WHERE
            NOT t.TABLE_NAME IN ('sysdiagrams')
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
            )

        UNION ALL
        SELECT
            1 AS SECTION_ID
            , t.ROUTINE_SCHEMA AS TABLE_SCHEMA
            , t.ROUTINE_NAME AS TABLE_NAME
            , LOWER(t.ROUTINE_TYPE) AS TYPE
            , g.LANGUAGE_NAME
            , tr.VERSION
            , tr.DESCRIPTION
            , tr.COMMENT
            , CASE WHEN t.ROUTINE_TYPE = 'FUNCTION' THEN 106 ELSE 105 END AS SECTION
        FROM
            INFORMATION_SCHEMA.ROUTINES t

            CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

            LEFT OUTER JOIN doc.help tr
                ON tr.SECTION_ID = 1 AND tr.TABLE_SCHEMA = t.ROUTINE_SCHEMA AND tr.TABLE_NAME = t.ROUTINE_NAME
                    AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME
        WHERE
            NOT t.ROUTINE_NAME LIKE 'sp_%'
            AND NOT t.ROUTINE_NAME LIKE 'fn_%'
            AND NOT t.ROUTINE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
            )

        UNION ALL
        SELECT
            1 AS SECTION_ID
            , s.name AS TABLE_SCHEMA
            , o.name AS TABLE_NAME
            , 'trigger' AS TYPE
            , g.LANGUAGE_NAME
            , tr.VERSION
            , tr.DESCRIPTION
            , tr.COMMENT
            , 107 AS SECTION
        FROM
            sys.objects o
            INNER JOIN sys.schemas s ON s.schema_id = o.schema_id

            CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

            LEFT OUTER JOIN doc.help tr
                ON tr.SECTION_ID = 1 AND tr.TABLE_SCHEMA = s.name AND tr.TABLE_NAME = o.name
                    AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME
        WHERE
            o.type IN ('tr')
            AND NOT s.name IN ('sys')
            AND NOT o.name IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
            )
    ) t


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects Actions menu handlers for online help
-- =============================================

CREATE VIEW [doc].[view_online_help_handlers]
AS

SELECT
    t.TABLE_SCHEMA
    , t.TABLE_NAME
    , CAST(NULL AS nvarchar(128)) AS COLUMN_NAME
    , 'Actions' AS EVENT_NAME
    , t.TABLE_SCHEMA AS HANDLER_SCHEMA
    , CASE WHEN v.menu_order = 90 THEN 'MenuSeparator90' ELSE 'Online Database Help - ' + t.TABLE_SCHEMA + '.' + t.TABLE_NAME END AS HANDLER_NAME
    , CASE WHEN v.menu_order = 90 THEN 'MENUSEPARATOR' ELSE 'HTTP' END AS HANDLER_TYPE
    , CASE WHEN v.menu_order = 90 THEN NULL ELSE CASE
        WHEN p.TABLE_NAME IS NULL THEN u.[COMMENT]
        WHEN t1.TABLE_TYPE = 'BASE TABLE' THEN REPLACE(u.[COMMENT], '.htm', '-tables.htm')
        WHEN t1.TABLE_TYPE = 'VIEW' THEN REPLACE(u.[COMMENT], '.htm', '-views.htm')
        WHEN r1.ROUTINE_TYPE = 'PROCEDURE' THEN REPLACE(u.[COMMENT], '.htm', '-procedures.htm')
        WHEN r1.ROUTINE_TYPE = 'FUNCTION' THEN REPLACE(u.[COMMENT], '.htm', '-functions.htm')
        ELSE u.[COMMENT]
        END + '#' + REPLACE(t.TABLE_SCHEMA, ' ', '') + '.' + REPLACE(t.TABLE_NAME, ' ', '') END HANDLER_CODE
    , CAST(NULL AS nvarchar) AS TARGET_WORKSHEET
    , v.menu_order AS MENU_ORDER
    , CAST(NULL AS bit) AS EDIT_PARAMETERS
FROM
    (
        SELECT
            DISTINCT
            tr.TABLE_SCHEMA
            , tr.TABLE_NAME
        FROM
            doc.help tr
        WHERE
            tr.SECTION_ID = 1
    ) t
    INNER JOIN doc.help u ON u.SECTION_ID = 6 AND u.TABLE_SCHEMA = t.TABLE_SCHEMA AND u.TABLE_NAME = 'online_help_url'
    LEFT OUTER JOIN doc.help p ON u.SECTION_ID = 6 AND p.TABLE_SCHEMA = t.TABLE_SCHEMA AND p.TABLE_NAME = 'multi_page' AND p.COMMENT IS NOT NULL
    LEFT OUTER JOIN INFORMATION_SCHEMA.TABLES t1 ON t1.TABLE_SCHEMA = t.TABLE_SCHEMA AND t1.TABLE_NAME = t.TABLE_NAME
    LEFT OUTER JOIN INFORMATION_SCHEMA.ROUTINES r1 ON r1.ROUTINE_SCHEMA = t.TABLE_SCHEMA AND r1.ROUTINE_NAME = t.TABLE_NAME
    CROSS JOIN (VALUES
        (90),
        (91)
        ) v(menu_order)
WHERE
    u.[COMMENT] IS NOT NULL
    AND NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'dbo25', 'xls25', 'dbo27', 'xls27')
    AND NOT t.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )

UNION ALL
SELECT
    t.TABLE_SCHEMA
    , t.TABLE_NAME
    , CAST(NULL AS nvarchar(128)) AS COLUMN_NAME
    , 'Actions' AS EVENT_NAME
    , t.TABLE_SCHEMA AS HANDLER_SCHEMA
    , CASE WHEN v.menu_order = 90 THEN 'MenuSeparator90' ELSE 'Online Database Help - ' + t.TABLE_SCHEMA + '.' + t.TABLE_NAME END AS HANDLER_NAME
    , CASE WHEN v.menu_order = 90 THEN 'MENUSEPARATOR' ELSE 'HTTP' END AS HANDLER_TYPE
    , CASE WHEN v.menu_order = 90 THEN NULL ELSE CASE
        WHEN t.TABLE_TYPE = 'BASE TABLE' THEN REPLACE(t.URL, '.htm', '-tables.htm')
        WHEN t.TABLE_TYPE = 'VIEW' THEN REPLACE(t.URL, '.htm', '-views.htm')
        WHEN t.TABLE_TYPE = 'PROCEDURE' THEN REPLACE(t.URL, '.htm', '-procedures.htm')
        WHEN t.TABLE_TYPE = 'FUNCTION' THEN REPLACE(t.URL, '.htm', '-functions.htm')
        ELSE t.URL
        END + '#' + REPLACE(t.TABLE_SCHEMA, ' ', '') + '.' + REPLACE(t.TABLE_NAME, ' ', '') END HANDLER_CODE
    , CAST(NULL AS nvarchar) AS TARGET_WORKSHEET
    , v.menu_order AS MENU_ORDER
    , CAST(NULL AS bit) AS EDIT_PARAMETERS
FROM
    (
        SELECT
            t.TABLE_SCHEMA
            , t.TABLE_NAME
            , t.TABLE_TYPE
            , 'https://www.savetodb.com/help/database-help-framework.htm' AS URL
        FROM
            INFORMATION_SCHEMA.TABLES t
        WHERE
            t.TABLE_SCHEMA IN ('doc')
        UNION ALL
        SELECT
            t.ROUTINE_SCHEMA AS TABLE_SCHEMA
            , t.ROUTINE_NAME AS TABLE_NAME
            , t.ROUTINE_TYPE AS TABLE_TYPE
            , 'https://www.savetodb.com/help/database-help-framework.htm' AS URL
        FROM
            INFORMATION_SCHEMA.ROUTINES t
        WHERE
            t.ROUTINE_SCHEMA IN ('doc')
            AND t.ROUTINE_TYPE IN ('PROCEDURE')
            AND NOT t.ROUTINE_NAME LIKE 'xl_%'
            AND NOT t.ROUTINE_NAME LIKE 'usp_import_%'
            AND NOT t.ROUTINE_NAME LIKE 'usp_export_%'
            AND NOT t.ROUTINE_NAME LIKE '%_change'
            AND NOT t.ROUTINE_NAME LIKE '%_insert'
            AND NOT t.ROUTINE_NAME LIKE '%_update'
            AND NOT t.ROUTINE_NAME LIKE '%_delete'
    ) t
    CROSS JOIN (VALUES (90), (91)) v(menu_order)
WHERE
    t.URL IS NOT NULL


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects orphan rows
-- =============================================

CREATE VIEW [doc].[view_orphan_rows]
AS

SELECT
    h.*
FROM
    doc.help h
    LEFT OUTER JOIN sys.schemas s ON s.name = h.TABLE_SCHEMA
    LEFT OUTER JOIN sys.objects o ON o.name = h.TABLE_NAME AND o.schema_id = s.schema_id
    LEFT OUTER JOIN INFORMATION_SCHEMA.COLUMNS c ON c.TABLE_SCHEMA = h.TABLE_SCHEMA AND c.TABLE_NAME = h.TABLE_NAME AND c.COLUMN_NAME = h.COLUMN_NAME
    LEFT OUTER JOIN INFORMATION_SCHEMA.PARAMETERS p ON p.SPECIFIC_SCHEMA = h.TABLE_SCHEMA AND p.SPECIFIC_NAME = h.TABLE_NAME AND (p.PARAMETER_NAME = h.COLUMN_NAME OR p.ORDINAL_POSITION = 0 AND h.COLUMN_NAME = 'Result')
    LEFT OUTER JOIN INFORMATION_SCHEMA.ROUTINE_COLUMNS f ON f.TABLE_SCHEMA = h.TABLE_SCHEMA AND f.TABLE_NAME = h.TABLE_NAME AND f.COLUMN_NAME = h.COLUMN_NAME
WHERE
    h.SECTION_ID = 1
    AND (
        o.name IS NULL
        OR h.COLUMN_NAME IS NOT NULL AND c.COLUMN_NAME IS NULL AND p.PARAMETER_NAME IS NULL AND f.COLUMN_NAME IS NULL
        )
    AND NOT h.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects pages
-- =============================================

CREATE VIEW [doc].[view_pages]
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY t.TABLE_SCHEMA, p.sort_order, p.TABLE_NAME, g.LANGUAGE_NAME) AS SORT_ORDER
    , t.TABLE_SCHEMA
    , p.TABLE_NAME
    , g.LANGUAGE_NAME
    , tr.VERSION
    , tr.DESCRIPTION
    , tr.COMMENT
FROM
    (
        SELECT
            t.TABLE_SCHEMA
        FROM
            INFORMATION_SCHEMA.TABLES t
        WHERE
            NOT t.TABLE_NAME IN ('sysdiagrams')
            AND NOT t.TABLE_SCHEMA IN ('sys')
        UNION
        SELECT
            t.ROUTINE_SCHEMA AS TABLE_SCHEMA
        FROM
            INFORMATION_SCHEMA.ROUTINES t
        WHERE
            NOT t.ROUTINE_NAME LIKE 'sp_%'
            AND NOT t.ROUTINE_NAME LIKE 'fn_%'
    ) t
    CROSS JOIN (VALUES (11, 'introduction'),(51, 'diagrams'),(52, 'roles'),(53, 'schemas'),(54, 'tables'),(55, 'views'),(56, 'procedures'),(57, 'functions'),(81, 'conclusion')) p(sort_order, TABLE_NAME)
    CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g
    LEFT OUTER JOIN doc.help tr
        ON tr.SECTION_ID = 5 AND tr.TABLE_SCHEMA = t.TABLE_SCHEMA AND tr.TABLE_NAME = p.TABLE_NAME AND tr.COLUMN_NAME IS NULL
        AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME
WHERE
    NOT t.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects documentation properties
-- =============================================

CREATE VIEW [doc].[view_properties]
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY t.SECTION, t.SORT_ORDER, t.TABLE_SCHEMA, t.TABLE_NAME, t.LANGUAGE_NAME) AS SORT_ORDER
    , t.SECTION_ID
    , t.TABLE_SCHEMA
    , t.TABLE_NAME
    , t.LANGUAGE_NAME
    , t.COMMENT
FROM
    (
        SELECT
            DISTINCT
            6 AS SECTION_ID
            , 'database' AS TABLE_SCHEMA
            , t.TABLE_NAME
            , 'property' AS TYPE
            , g.LANGUAGE_NAME
            , tr.VERSION
            , tr.DESCRIPTION
            , COALESCE(tr.COMMENT, t.DEFAULT_VALUE) AS COMMENT
            , SECTION
            , t.SORT_ORDER
        FROM
            (VALUES
                (1, 1, 'title', DB_NAME()),
                (1, 2, 'description', NULL),
                (1, 3, 'h1', DB_NAME()),
                (1, 4, 'subtitle', NULL),
                (1, 5, 'exclude_columns', NULL),
                (3, 5, 'online_help_url', NULL),
                (4, 6, 'multi_page', NULL),
                (5, 7, 'manifest_url', NULL),
                (6, 8, 'stylesheet_url', 'https://www.savetodb.com/help/doc-style.css'),
                (7, 9, 'theme_color', '#0070C0'),
                (8, 10, 'html_class', NULL),
                (9, 11, 'body_class', NULL),
                (10, 12, 'head_content', NULL)
            ) t (SECTION, SORT_ORDER, TABLE_NAME, DEFAULT_VALUE)

            CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

            LEFT OUTER JOIN doc.help tr
                ON tr.SECTION_ID = 6 AND tr.TABLE_SCHEMA = 'database' AND tr.TABLE_NAME = t.TABLE_NAME
                    AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME

        UNION ALL
        SELECT
            DISTINCT
            6 AS SECTION_ID
            , s.TABLE_SCHEMA
            , t.TABLE_NAME
            , 'property' AS TYPE
            , g.LANGUAGE_NAME
            , tr.VERSION
            , tr.DESCRIPTION
            , COALESCE(tr.COMMENT, t.DEFAULT_VALUE) AS COMMENT
            , SECTION
            , 100 + ROW_NUMBER() OVER(ORDER BY t.SECTION, s.TABLE_SCHEMA, t.SORT_ORDER, t.TABLE_NAME) AS SORT_ORDER
        FROM
            (
                SELECT
                    t.TABLE_SCHEMA
                FROM
                    INFORMATION_SCHEMA.TABLES t
                WHERE
                    NOT t.TABLE_NAME IN ('sysdiagrams')
                    AND NOT t.TABLE_SCHEMA IN ('sys')
                UNION
                SELECT
                    t.ROUTINE_SCHEMA AS TABLE_SCHEMA
                FROM
                    INFORMATION_SCHEMA.ROUTINES t
                WHERE
                    NOT t.ROUTINE_NAME LIKE 'sp_%'
                    AND NOT t.ROUTINE_NAME LIKE 'fn_%'
            ) s
            CROSS JOIN (VALUES
                (2, 1, 'disabled', NULL),
                (3, 2, 'title', NULL),
                (3, 3, 'description', NULL),
                (3, 4, 'h1', NULL),
                (3, 5, 'subtitle', NULL),
                (4, 6, 'online_help_url', NULL),
                (5, 7, 'multi_page', NULL),
                (6, 8, 'manifest_url', NULL),
                (7, 9, 'stylesheet_url', 'https://www.savetodb.com/help/doc-style.css'),
                (8, 10, 'theme_color', '#0070C0'),
                (9, 11, 'html_class', NULL),
                (10, 12, 'body_class', NULL),
                (11, 13, 'head_content', NULL)
            ) t (SECTION, SORT_ORDER, TABLE_NAME, DEFAULT_VALUE)

            CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

            LEFT OUTER JOIN doc.help tr
                ON tr.SECTION_ID = 6 AND tr.TABLE_SCHEMA = s.TABLE_SCHEMA AND tr.TABLE_NAME = t.TABLE_NAME
                    AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = g.LANGUAGE_NAME
        WHERE
            t.SECTION = 2
            OR NOT s.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
            )

    ) t


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects end-user objects for SaveToDB Query List
-- =============================================

CREATE VIEW [doc].[view_query_list]
AS

SELECT
    t.TABLE_SCHEMA
    , t.TABLE_NAME
    , t.TABLE_TYPE
    , o.TABLE_CODE AS TABLE_CODE
    , o.INSERT_OBJECT AS INSERT_PROCEDURE
    , o.UPDATE_OBJECT AS UPDATE_PROCEDURE
    , o.DELETE_OBJECT AS DELETE_PROCEDURE
    , CASE WHEN o.INSERT_OBJECT IS NULL THEN NULL WHEN o.INSERT_OBJECT = o.DELETE_OBJECT THEN 'TABLE' ELSE 'PROCEDURE' END AS PROCEDURE_TYPE
FROM
    INFORMATION_SCHEMA.TABLES t
    LEFT OUTER JOIN doc.objects o ON o.TABLE_SCHEMA = t.TABLE_SCHEMA AND o.TABLE_NAME = t.TABLE_NAME
WHERE
    t.TABLE_SCHEMA = 'doc'
    AND t.TABLE_TYPE = 'view'
    AND NOT t.TABLE_NAME IN ('view_query_list')


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects routine columns
-- =============================================

CREATE VIEW [doc].[view_routine_columns]
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY p.TABLE_SCHEMA, p.TABLE_NAME, p.ORDINAL_POSITION, g.LANGUAGE_NAME) AS SORT_ORDER
    , p.TABLE_SCHEMA
    , p.TABLE_NAME
    , p.ORDINAL_POSITION
    , p.COLUMN_NAME
    , CASE
        WHEN RIGHT(p.DATA_TYPE, 4) = 'char' AND p.CHARACTER_MAXIMUM_LENGTH = -1 THEN p.DATA_TYPE + '(max)'
        WHEN RIGHT(p.DATA_TYPE, 4) = 'char' THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN p.DATA_TYPE IN ('binary', 'varbinary') THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN p.DATA_TYPE IN ('decimal', 'numeric') THEN p.DATA_TYPE + '(' + CAST(p.NUMERIC_PRECISION AS varchar) + ',' +  CAST(p.NUMERIC_SCALE AS varchar) + ')'
        WHEN p.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN p.DATA_TYPE + '(' + CAST(p.DATETIME_PRECISION AS varchar) + ')'
        ELSE p.DATA_TYPE END AS DATA_TYPE
    , g.LANGUAGE_NAME
    , trc.DESCRIPTION
    , CAST(CASE WHEN trc.DESCRIPTION IS NOT NULL THEN 1 ELSE 0 END AS bit) AS HAS_COMMENTS
FROM
    INFORMATION_SCHEMA.ROUTINE_COLUMNS p

    CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

    LEFT OUTER JOIN doc.help trc
        ON trc.SECTION_ID = 1 AND trc.TABLE_SCHEMA = p.TABLE_SCHEMA AND trc.TABLE_NAME = p.TABLE_NAME AND trc.COLUMN_NAME = p.COLUMN_NAME AND trc.LANGUAGE_NAME = g.LANGUAGE_NAME
WHERE
    NOT p.TABLE_NAME LIKE 'fn_%'
    AND NOT p.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects procedure parameters
-- =============================================

CREATE VIEW [doc].[view_routine_parameters]
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY p.SPECIFIC_SCHEMA, p.SPECIFIC_NAME, p.ORDINAL_POSITION, g.LANGUAGE_NAME) AS SORT_ORDER
    , p.SPECIFIC_SCHEMA AS ROUTINE_SCHEMA
    , p.SPECIFIC_NAME AS ROUTINE_NAME
    , p.ORDINAL_POSITION
    , CASE WHEN p.ORDINAL_POSITION = 0 THEN 'Result' ELSE p.PARAMETER_NAME END AS PARAMETER_NAME
    , CASE
        WHEN RIGHT(p.DATA_TYPE, 4) = 'char' AND p.CHARACTER_MAXIMUM_LENGTH = -1 THEN p.DATA_TYPE + '(max)'
        WHEN RIGHT(p.DATA_TYPE, 4) = 'char' THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN p.DATA_TYPE IN ('binary', 'varbinary') THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN p.DATA_TYPE IN ('decimal', 'numeric') THEN p.DATA_TYPE + '(' + CAST(p.NUMERIC_PRECISION AS varchar) + ',' +  CAST(p.NUMERIC_SCALE AS varchar) + ')'
        WHEN p.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN p.DATA_TYPE + '(' + CAST(p.DATETIME_PRECISION AS varchar) + ')'
        ELSE p.DATA_TYPE END AS DATA_TYPE
    , p.PARAMETER_MODE
    , g.LANGUAGE_NAME
    , trc.DESCRIPTION
    , CAST(CASE WHEN trc.DESCRIPTION IS NOT NULL THEN 1 ELSE 0 END AS bit) AS HAS_COMMENTS
FROM
    INFORMATION_SCHEMA.PARAMETERS p

    CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

    LEFT OUTER JOIN doc.help trc
        ON trc.SECTION_ID = 1 AND trc.TABLE_SCHEMA = p.SPECIFIC_SCHEMA AND trc.TABLE_NAME = p.SPECIFIC_NAME
            AND trc.COLUMN_NAME = CASE WHEN p.ORDINAL_POSITION = 0 THEN 'Result' ELSE p.PARAMETER_NAME END
            AND trc.LANGUAGE_NAME = g.LANGUAGE_NAME
WHERE
    NOT p.SPECIFIC_NAME LIKE 'sp_%'
    AND NOT p.SPECIFIC_NAME LIKE 'fn_%'
    AND NOT p.SPECIFIC_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects table columns
-- =============================================

CREATE VIEW [doc].[view_table_columns]
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY s.name, o.name, c.ORDINAL_POSITION, g.LANGUAGE_NAME) AS SORT_ORDER
    , s.name AS TABLE_SCHEMA
    , o.name AS TABLE_NAME
    , c.ORDINAL_POSITION
    , c.COLUMN_NAME
    , CASE
        WHEN RIGHT(c.DATA_TYPE, 4) = 'char' AND c.CHARACTER_MAXIMUM_LENGTH = -1 THEN c.DATA_TYPE + '(max)'
        WHEN RIGHT(c.DATA_TYPE, 4) = 'char' THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN c.DATA_TYPE IN ('binary', 'varbinary') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN c.DATA_TYPE IN ('decimal', 'numeric') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ',' +  CAST(c.NUMERIC_SCALE AS varchar) + ')'
        WHEN c.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN c.DATA_TYPE + '(' + CAST(c.DATETIME_PRECISION AS varchar) + ')'
        ELSE c.DATA_TYPE END AS DATA_TYPE
    , CASE WHEN ccu1.column_id IS NULL THEN NULL ELSE 1 END AS IS_PK
    , CASE WHEN sc.is_identity = 1 THEN 1 ELSE NULL END AS IS_IDENTITY
    , CASE WHEN c.IS_NULLABLE = 'NO' THEN NULL ELSE 1 END AS IS_NULLABLE
    , ccu2.REFERENTIAL_TABLE_SCHEMA + '.' + ccu2.REFERENTIAL_TABLE_NAME + '.' + ccu2.REFERENTIAL_COLUMN_NAME AS REFERENTIAL_COLUMN
    , g.LANGUAGE_NAME
    , trc.DESCRIPTION
    , CAST(CASE WHEN sc.is_identity = 1 OR ccu2.column_id IS NOT NULL OR trc.DESCRIPTION IS NOT NULL THEN 1 ELSE 0 END AS bit) AS HAS_COMMENTS
FROM
    sys.columns sc
    INNER JOIN sys.objects o ON o.[object_id] = sc.[object_id]
    INNER JOIN sys.schemas s ON s.[schema_id] = o.[schema_id]

    INNER JOIN INFORMATION_SCHEMA.COLUMNS c
        ON c.TABLE_SCHEMA = s.name AND c.TABLE_NAME = o.name AND c.COLUMN_NAME = sc.name

    LEFT OUTER JOIN (
        SELECT
            ic.object_id
            , ic.column_id
        FROM
            sys.index_columns ic
            INNER JOIN sys.indexes i ON i.[object_id] = ic.[object_id] AND i.index_id = ic.index_id
            INNER JOIN sys.objects o ON o.[object_id] = ic.[object_id]
        WHERE
            NOT o.[schema_id] IN (SCHEMA_ID('sys'))
            AND i.type = 1
            AND o.type = 'U'
        ) ccu1 ON ccu1.[object_id] = sc.[object_id] AND ccu1.column_id = sc.column_id

    LEFT OUTER JOIN (
        SELECT
            kc.parent_object_id AS [object_id]
            , kc.parent_column_id AS [column_id]
            , ps.name AS REFERENTIAL_TABLE_SCHEMA
            , po.name AS REFERENTIAL_TABLE_NAME
            , pc.name AS REFERENTIAL_COLUMN_NAME
        FROM
            sys.foreign_key_columns kc
            INNER JOIN sys.objects fo ON fo.[object_id] = kc.parent_object_id
            INNER JOIN sys.objects po ON po.[object_id] = kc.referenced_object_id
            INNER JOIN sys.schemas ps ON ps.[schema_id] = po.[schema_id]
            INNER JOIN sys.columns pc ON pc.[object_id] = kc.referenced_object_id AND pc.column_id = kc.referenced_column_id
            INNER JOIN sys.foreign_keys fk ON fk.[object_id] = kc.constraint_object_id
            INNER JOIN sys.index_columns ic ON ic.[object_id] = kc.referenced_object_id AND ic.column_id = kc.referenced_column_id AND ic.index_id = fk.key_index_id
        WHERE
            NOT fo.[schema_id] IN (SCHEMA_ID('sys'))
        ) ccu2 ON ccu2.[object_id] = sc.[object_id] AND ccu2.column_id = sc.column_id

    CROSS JOIN (SELECT DISTINCT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

    LEFT OUTER JOIN doc.help trc
        ON trc.SECTION_ID = 1 AND trc.TABLE_SCHEMA = s.name AND trc.TABLE_NAME = o.name
            AND trc.COLUMN_NAME = sc.name AND trc.LANGUAGE_NAME = g.LANGUAGE_NAME

WHERE
    o.type = 'U'
    AND NOT o.name IN ('sysdiagrams')
    AND NOT s.name IN ('sys')
    AND NOT s.name IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Selects translations
-- =============================================

CREATE VIEW [doc].[view_translations]
AS

SELECT
    *
FROM
    doc.translations t
WHERE
    NOT t.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The view selects view columns
-- =============================================

CREATE VIEW [doc].[view_view_columns]
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY c.TABLE_SCHEMA, c.TABLE_NAME, c.ORDINAL_POSITION, g.LANGUAGE_NAME) AS SORT_ORDER
    , c.TABLE_SCHEMA
    , c.TABLE_NAME
    , c.ORDINAL_POSITION
    , c.COLUMN_NAME
    , CASE
        WHEN RIGHT(c.DATA_TYPE, 4) = 'char' AND c.CHARACTER_MAXIMUM_LENGTH = -1 THEN c.DATA_TYPE + '(max)'
        WHEN RIGHT(c.DATA_TYPE, 4) = 'char' THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN c.DATA_TYPE IN ('binary', 'varbinary') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
        WHEN c.DATA_TYPE IN ('decimal', 'numeric') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ',' +  CAST(c.NUMERIC_SCALE AS varchar) + ')'
        WHEN c.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN c.DATA_TYPE + '(' + CAST(c.DATETIME_PRECISION AS varchar) + ')'
        ELSE c.DATA_TYPE END AS DATA_TYPE
    , tc.TABLE_SCHEMA + '.' + tc.TABLE_NAME + '.' + tc.COLUMN_NAME AS REFERENTIAL_COLUMN
    , g.LANGUAGE_NAME
    , trc.DESCRIPTION
    , CAST(CASE WHEN tc.COLUMN_NAME IS NOT NULL OR trc.DESCRIPTION IS NOT NULL THEN 1 ELSE 0 END AS bit) AS HAS_COMMENTS
FROM
    INFORMATION_SCHEMA.COLUMNS c

    INNER JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME

    LEFT OUTER JOIN (
        SELECT
            t.VIEW_SCHEMA
            , t.VIEW_NAME
            , t.COLUMN_NAME
            , MAX(t.TABLE_SCHEMA) AS TABLE_SCHEMA
            , MAX(t.TABLE_NAME) AS TABLE_NAME
        FROM
            INFORMATION_SCHEMA.VIEW_COLUMN_USAGE t
        GROUP BY
            t.VIEW_SCHEMA
            , t.VIEW_NAME
            , t.COLUMN_NAME
        HAVING
            COUNT(*) = 1
    ) tc ON tc.VIEW_SCHEMA = c.TABLE_SCHEMA AND tc.VIEW_NAME = c.TABLE_NAME AND tc.COLUMN_NAME = c.COLUMN_NAME

    CROSS JOIN (SELECT LANGUAGE_NAME FROM doc.help UNION SELECT 'en' AS LANGUAGE_NAME) g

    LEFT OUTER JOIN doc.help trc
        ON trc.SECTION_ID = 1 AND trc.TABLE_SCHEMA = c.TABLE_SCHEMA AND trc.TABLE_NAME = c.TABLE_NAME
            AND trc.COLUMN_NAME = c.COLUMN_NAME AND trc.LANGUAGE_NAME = g.LANGUAGE_NAME
WHERE
    t.TABLE_TYPE = 'VIEW'
    AND NOT t.TABLE_SCHEMA IN ('sys')
    AND NOT t.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL
    )


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Selects translations
-- =============================================

CREATE PROCEDURE [doc].[usp_translations]
    @field nvarchar(128) = NULL
AS
BEGIN

SET NOCOUNT ON;

IF @field IS NULL
    SET @field = 'TRANSLATED_NAME'
ELSE IF @field NOT IN ('TRANSLATED_NAME', 'TRANSLATED_DESC', 'TRANSLATED_COMMENT')
    BEGIN
    DECLARE @message nvarchar(max) = N'Invalid column name: %s' + CHAR(13) + CHAR(10)
         + 'Use TRANSLATED_NAME, TRANSLATED_DESC, or TRANSLATED_COMMENT'
    RAISERROR(@message, 11, 0, @field);
    RETURN
    END

DECLARE @sql nvarchar(max)
DECLARE @languages nvarchar(max)

SELECT @languages = STUFF((
    SELECT
        t.name
    FROM
        (
        SELECT
            DISTINCT
            ', [' + t.LANGUAGE_NAME + ']' AS name
            , CASE
                WHEN t.LANGUAGE_NAME = 'en' THEN '1'
                WHEN t.LANGUAGE_NAME = 'fr' THEN '2'
                WHEN t.LANGUAGE_NAME = 'it' THEN '3'
                WHEN t.LANGUAGE_NAME = 'es' THEN '4'
                ELSE t.LANGUAGE_NAME
                END AS sort_order
        FROM
            doc.translations t
        ) t
    ORDER BY
        t.sort_order
    FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)'), 1, 2, '')

IF @languages IS NULL SET @languages = '[en]'

SET @sql = 'SELECT
    t.TABLE_SCHEMA
    , t.TABLE_NAME
    , t.COLUMN_NAME AS [COLUMN]
    , ' + @languages + '
FROM
    (
        SELECT
            t.TABLE_SCHEMA
            , t.TABLE_NAME
            , t.COLUMN_NAME
            , t.LANGUAGE_NAME
            , t.' + @field + ' AS name
        FROM
            doc.translations t
    ) s PIVOT (
        MAX(name) FOR LANGUAGE_NAME IN (' + @languages + ')
    ) t
WHERE
    NOT t.TABLE_SCHEMA IN (
        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = ''disabled'' AND COMMENT IS NOT NULL
    )
ORDER BY
    t.TABLE_SCHEMA
    , t.TABLE_NAME
    , t.COLUMN_NAME'

-- PRINT @sql

EXEC (@sql)

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Cell change event handler for usp_translations
--
-- @column_name is a column name of the edited cell
-- @cell_value is a new cell value
-- @field is a value of the field parameter of the usp_translations
-- @TABLE_SCHEMA, @TABLE_NAME, and @COLUMN are values of the Excel table columns
-- =============================================

CREATE PROCEDURE [doc].[usp_translations_change]
    @column_name nvarchar(128) = NULL
    , @cell_value nvarchar(max) = NULL
    , @TABLE_SCHEMA nvarchar(128) = NULL
    , @TABLE_NAME nvarchar(128) = NULL
    , @COLUMN nvarchar(128) = NULL
    , @field nvarchar(128) = NULL
AS
BEGIN

SET NOCOUNT ON

DECLARE @message nvarchar(max)

IF NOT EXISTS(SELECT TOP 1 ID FROM doc.translations WHERE LANGUAGE_NAME = @column_name)
    RETURN

IF @field IS NULL SET @field = 'TRANSLATED_NAME'

IF @field = 'TRANSLATED_NAME'
    UPDATE doc.translations    SET TRANSLATED_NAME = @cell_value
        WHERE COALESCE(TABLE_SCHEMA, '') = COALESCE(@TABLE_SCHEMA, '') AND COALESCE(TABLE_NAME, '') = COALESCE(@TABLE_NAME, '')
            AND COALESCE(COLUMN_NAME, '') = COALESCE(@COLUMN, '') AND LANGUAGE_NAME = @column_name
ELSE IF @field = 'TRANSLATED_DESC'
    UPDATE doc.translations    SET TRANSLATED_DESC = @cell_value
        WHERE COALESCE(TABLE_SCHEMA, '') = COALESCE(@TABLE_SCHEMA, '') AND COALESCE(TABLE_NAME, '') = COALESCE(@TABLE_NAME, '')
            AND COALESCE(COLUMN_NAME, '') = COALESCE(@COLUMN, '') AND LANGUAGE_NAME = @column_name
ELSE IF @field = 'TRANSLATED_COMMENT'
    UPDATE doc.translations    SET TRANSLATED_COMMENT = @cell_value
        WHERE COALESCE(TABLE_SCHEMA, '') = COALESCE(@TABLE_SCHEMA, '') AND COALESCE(TABLE_NAME, '') = COALESCE(@TABLE_NAME, '')
            AND COALESCE(COLUMN_NAME, '') = COALESCE(@COLUMN, '') AND LANGUAGE_NAME = @column_name
ELSE
    BEGIN
    SET @message = N'Invalid column name: %s' + CHAR(13) + CHAR(10)
         + 'Use TRANSLATED_NAME, TRANSLATED_DESC, or TRANSLATED_COMMENT'
    RAISERROR(@message, 11, 0, @field);
    RETURN
    END

IF @@ROWCOUNT > 0 RETURN

IF @cell_value IS NULL RETURN

IF @field = 'TRANSLATED_NAME'
    INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME)
        VALUES (@TABLE_SCHEMA, @TABLE_NAME, @COLUMN, @column_name, @cell_value)
ELSE IF @field = 'TRANSLATED_DESC'
    INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_DESC)
        VALUES (@TABLE_SCHEMA, @TABLE_NAME, @COLUMN, @column_name, @cell_value)
ELSE IF @field = 'TRANSLATED_COMMENT'
    INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_COMMENT)
        VALUES (@TABLE_SCHEMA, @TABLE_NAME, @COLUMN, @column_name, @cell_value)

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The procedure generates database documentation
--
-- The procedure uses descriptions and comments from the doc.help table:
--
-- TABLE_SCHEMA     TABLE_NAME      COLUMN_NAME     DESCRIPTION             COMMENT
-- --------------   --------------- --------------- ----------------------- --------------------
-- 'database'       database name   NULL            database description    database comment
-- 'roles'          role name       NULL            role description        role comment
-- 'schemas'        schema name     NULL            schema description      schema comment
-- object schema    object name     NULL            object description      object comment
-- object schema    object name     column name     column description      not used
-- object schema    object name     parameter name  parameter description   not used
--
-- Schemas of known frameworks excluded with @schema = 'x':
--
-- xls                          - SaveToDB Framework 8/9            (use xls to show)
-- savetodb_dev, savetodb_xls   - SaveToDB Framework 7 (MySQL style)(use savetodb_% to show)
-- etl01, dbo01, xls01          - SaveToDB Framework 7              (use %01 to show)
-- etl02, dbo02, xls02          - Row Permission Framework          (use %02 to show)
-- etl03, dbo03, xls03          - Application Framework             (use %03 to show)
-- doc                          - Database Help Framework           (use doc to show)
-- logs                         - Change Tracking Framework         (use logs to show)
--
-- Help Framework 2.0 does not include the help of these frameworks by default.
-- It creates links to the online documentation instead.
--
-- You may disable output for any schema using the disabled field in doc.view_properties.
--
-- @part values:
-- 0 - all, 1 - contents-schemas, 2 - tables, 3 - views, 4 - procedures, 5 - functions
-- 11 - contents, 12 - introduction, 13 - change history, 14 - diagrams, 15 - roles, 16 - schemas, 17 - conclusion
--
-- The SaveToDB add-in and DBEdit apply regular expressions specified in doc.handlers.
--
-- The download package includes a sample of generating the documentation using batch files.
--
-- =============================================

CREATE PROCEDURE [doc].[xl_actions_database_documentation]
    @language varchar(10) = 'en'
    , @schema nvarchar(128) = NULL
    , @part tinyint = NULL
    , @content_only bit = 0
    , @header_level int = NULL
    , @header_prefix nvarchar(100) = NULL
    , @header_suffix nvarchar(100) = NULL
    , @bottom_toc bit = 0
    , @exclude_names nvarchar(100) = NULL
    , @include_names nvarchar(100) = NULL
AS
BEGIN

BEGIN -- COMMON DECLARATIONS --

SET NOCOUNT ON

-- Define a maximum row count to output table values

DECLARE @value_output_limit int = 20

-- DECLARE @language varchar(10) = 'en'
-- DECLARE @schema nvarchar(128) = NULL

IF @language IS NULL SET @language = 'en'

DECLARE @app_schema_only bit = 0

IF @schema = 'x'
    BEGIN
    SET @schema = NULL
    SET @app_schema_only = 1
    END

IF @part IS NULL SET @part = 0
IF @content_only IS NULL SET @content_only = 0
IF @bottom_toc IS NULL SET @bottom_toc = 0

IF @header_prefix IS NULL OR @header_prefix = '' SET @header_prefix = '' ELSE SET @header_prefix = LTRIM(RTRIM(@header_prefix)) + ' '
IF @header_suffix IS NULL OR @header_suffix = '' SET @header_suffix = '' ELSE SET @header_suffix = ' ' + LTRIM(RTRIM(@header_suffix))

IF @include_names IS NULL SET @include_names = '%'
IF @exclude_names IS NULL SET @exclude_names = ''

DECLARE @h2o char(3) = '<h2'
DECLARE @h3o char(3) = '<h3'
DECLARE @h2c char(5) = '</h2>'
DECLARE @h3c char(5) = '</h3>'

IF NOT @part = 0
    BEGIN
    IF @header_level = 1
        BEGIN
        SET @h2o = '<h1'
        SET @h3o = '<h2'
        SET @h2c = '</h1>'
        SET @h3c = '</h2>'
        END
    END

DECLARE @result TABLE (id int IDENTITY(1,1) PRIMARY KEY, line nvarchar(max))

DECLARE @SQL nvarchar(max)
DECLARE @pages nvarchar(max)
DECLARE @diagrams nvarchar(max)
DECLARE @triggers nvarchar(max)

DECLARE @crlf nchar(2) = CHAR(13) + CHAR(10)
DECLARE @lf nchar(1) = CHAR(10)

-- Cursor variables

DECLARE @TABLE_SCHEMA nvarchar(128)
DECLARE @TABLE_NAME nvarchar(128)
DECLARE @DESCRIPTION nvarchar(1024)
DECLARE @COMMENT nvarchar(max)
DECLARE @TABLE_DESCRIPTION nvarchar(1024)
DECLARE @TABLE_COMMENT nvarchar(max)
DECLARE @TABLE_VALUES nvarchar(max)

DECLARE @ROUTINE_SCHEMA nvarchar(128)
DECLARE @ROUTINE_NAME nvarchar(128)

DECLARE @PREV_SCHEMA nvarchar(128)
DECLARE @PREV_NAME nvarchar(128)
DECLARE @PREV_COMMENT nvarchar(max)

DECLARE @COLUMN_NAME nvarchar(128)
DECLARE @DATA_TYPE nvarchar(128)
DECLARE @ORDINAL_POSITION int
DECLARE @IS_NULLABLE nvarchar(128)
DECLARE @IS_PK nvarchar(128)
DECLARE @IS_IDENTITY nvarchar(128)
DECLARE @REFERENTIAL_TABLE_SCHEMA nvarchar(128)
DECLARE @REFERENTIAL_TABLE_NAME nvarchar(128)
DECLARE @REFERENTIAL_COLUMN_NAME nvarchar(128)

DECLARE @PARAMETER_NAME nvarchar(128)
DECLARE @PARAMETER_MODE nvarchar(128)
DECLARE @SECTION int
DECLARE @PREV_SECTION int

DECLARE @HAS_PARAMETERS tinyint

END

BEGIN -- SECTION FLAGS --

DECLARE @has_diagrams bit
DECLARE @has_roles bit
DECLARE @has_schemas bit
DECLARE @has_tables bit
DECLARE @has_views bit
DECLARE @has_procedures bit
DECLARE @has_functions bit
DECLARE @has_introduction bit
DECLARE @has_conclusion bit
DECLARE @has_history bit

SET @has_diagrams = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        doc.help t
    WHERE
        t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.SECTION_ID = 4
        AND t.LANGUAGE_NAME = @language
        AND NOT t.TABLE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_roles = CASE WHEN EXISTS(
    SELECT
        r.name
    FROM
        sys.database_permissions p
        INNER JOIN sys.database_principals r ON r.principal_id = p.grantee_principal_id
        INNER JOIN sys.objects o ON o.object_id = p.major_id
        INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
    WHERE
        p.class = 1
        AND r.is_fixed_role = 0
        AND NOT r.sid IS NULL
        AND r.[type] = 'R'
        AND NOT r.name IN ('dbo', 'guest', 'public')
        AND s.name LIKE COALESCE(@schema, s.name)
        AND (@app_schema_only = 0 OR NOT s.name IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND NOT r.name IN (
            SELECT
                t.name
            FROM
                (VALUES
                    ('doc', 'doc_readers'),
                    ('doc', 'doc_writers'),
                    ('logs', 'log_admins'),
                    ('logs', 'log_users'),
                    ('xls', 'xls_admins'),
                    ('xls', 'xls_developers'),
                    ('xls', 'xls_formats'),
                    ('xls', 'xls_users')
                    ) t(schema_name, name)
            WHERE
                t.schema_name IN (
                    SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
                )
            )
    UNION
    SELECT
        r.name
    FROM
        sys.database_permissions p
        INNER JOIN sys.database_principals r ON r.principal_id = p.grantee_principal_id
        INNER JOIN sys.schemas s ON s.schema_id = p.major_id
    WHERE
        p.class = 3
        AND r.is_fixed_role = 0
        AND NOT r.sid IS NULL
        AND r.[type] = 'R'
        AND NOT r.name IN ('dbo', 'guest', 'public')
        AND s.name LIKE COALESCE(@schema, s.name)
        AND (@app_schema_only = 0 OR NOT s.name IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND NOT r.name IN (
            SELECT
                t.name
            FROM
                (VALUES
                    ('doc', 'doc_readers'),
                    ('doc', 'doc_writers'),
                    ('logs', 'log_admins'),
                    ('logs', 'log_users'),
                    ('xls', 'xls_admins'),
                    ('xls', 'xls_developers'),
                    ('xls', 'xls_formats'),
                    ('xls', 'xls_users')
                    ) t(schema_name, name)
            WHERE
                t.schema_name IN (
                    SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
                )
            )
    ) THEN 1 ELSE 0 END

SET @has_schemas = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        INFORMATION_SCHEMA.TABLES t
    WHERE
        t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND NOT t.TABLE_NAME IN ('sysdiagrams')
        AND NOT t.TABLE_SCHEMA IN ('sys')
        AND NOT t.TABLE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    UNION ALL
    SELECT TOP 1 1
    FROM
        INFORMATION_SCHEMA.ROUTINES t
    WHERE
        t.ROUTINE_SCHEMA LIKE COALESCE(@schema, t.ROUTINE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND NOT t.ROUTINE_NAME LIKE 'sp_%'
        AND NOT t.ROUTINE_NAME LIKE 'fn_%'
        AND NOT t.ROUTINE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_tables = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        INFORMATION_SCHEMA.TABLES t
    WHERE
        t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.TABLE_TYPE = 'BASE TABLE'
        AND NOT t.TABLE_NAME IN ('sysdiagrams')
        AND NOT t.TABLE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_views = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        INFORMATION_SCHEMA.TABLES t
    WHERE
        t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.TABLE_TYPE = 'VIEW'
        AND NOT t.TABLE_SCHEMA IN ('sys')
        AND NOT t.TABLE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_procedures = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        INFORMATION_SCHEMA.ROUTINES t
    WHERE
        t.ROUTINE_SCHEMA LIKE COALESCE(@schema, t.ROUTINE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.ROUTINE_TYPE = 'PROCEDURE'
        AND NOT t.ROUTINE_NAME LIKE 'sp_%'
        AND NOT t.ROUTINE_SCHEMA IN ('sys')
        AND NOT t.ROUTINE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_functions = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        INFORMATION_SCHEMA.ROUTINES t
    WHERE
        t.ROUTINE_SCHEMA LIKE COALESCE(@schema, t.ROUTINE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.ROUTINE_TYPE = 'FUNCTION'
        AND NOT t.ROUTINE_NAME LIKE 'fn_%'
        AND NOT t.ROUTINE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_introduction = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        doc.help t
    WHERE
        t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.COMMENT IS NOT NULL
        AND t.SECTION_ID = 5
        AND t.TABLE_NAME = 'introduction'
        AND NOT t.TABLE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_conclusion = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        doc.help t
    WHERE
        t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.COMMENT IS NOT NULL
        AND t.SECTION_ID = 5
        AND t.TABLE_NAME = 'conclusion'
        AND NOT t.TABLE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

SET @has_history = CASE WHEN EXISTS(
    SELECT TOP 1 1
    FROM
        doc.history t
    WHERE
        t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
        AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
        AND t.DESCRIPTION IS NOT NULL
        AND NOT t.TABLE_SCHEMA IN (
            SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
        )
    ) THEN 1 ELSE 0 END

END

BEGIN -- WORD TRANSLATION --

DECLARE @word_contents nvarchar(128)        = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Contents'        AND LANGUAGE_NAME = @language), 'Contents')
DECLARE @word_introduction nvarchar(128)    = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Introduction'    AND LANGUAGE_NAME = @language), 'Introduction')
DECLARE @word_conclusion nvarchar(128)      = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Conclusion'      AND LANGUAGE_NAME = @language), 'Conclusion')
DECLARE @word_history nvarchar(128)         = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'History'         AND LANGUAGE_NAME = @language), 'History')
DECLARE @word_change_history nvarchar(128)  = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Change History'  AND LANGUAGE_NAME = @language), 'Change History')
DECLARE @word_diagrams nvarchar(128)        = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Diagrams'        AND LANGUAGE_NAME = @language), 'Diagrams')
DECLARE @word_roles nvarchar(128)           = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Roles'           AND LANGUAGE_NAME = @language), 'Roles')
DECLARE @word_schemas nvarchar(128)         = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Schemas'         AND LANGUAGE_NAME = @language), 'Schemas')
DECLARE @word_tables nvarchar(128)          = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Tables'          AND LANGUAGE_NAME = @language), 'Tables')
DECLARE @word_views nvarchar(128)           = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Views'           AND LANGUAGE_NAME = @language), 'Views')
DECLARE @word_procedures nvarchar(128)      = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Procedures'      AND LANGUAGE_NAME = @language), 'Procedures')
DECLARE @word_functions nvarchar(128)       = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Functions'       AND LANGUAGE_NAME = @language), 'Functions')
DECLARE @word_triggers nvarchar(128)        = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Triggers'        AND LANGUAGE_NAME = @language), 'Triggers')
DECLARE @word_diagram nvarchar(128)         = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Diagram'         AND LANGUAGE_NAME = @language), 'Diagram')
DECLARE @word_role nvarchar(128)            = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Role'            AND LANGUAGE_NAME = @language), 'Role')
DECLARE @word_schema nvarchar(128)          = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Schema'          AND LANGUAGE_NAME = @language), 'Schema')
DECLARE @word_table nvarchar(128)           = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Table'           AND LANGUAGE_NAME = @language), 'Table')
DECLARE @word_view nvarchar(128)            = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'View'            AND LANGUAGE_NAME = @language), 'View')
DECLARE @word_procedure nvarchar(128)       = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Procedure'       AND LANGUAGE_NAME = @language), 'Procedure')
DECLARE @word_function nvarchar(128)        = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Function'        AND LANGUAGE_NAME = @language), 'Function')
DECLARE @word_trigger nvarchar(128)         = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Trigger'         AND LANGUAGE_NAME = @language), 'Trigger')
DECLARE @word_description nvarchar(128)     = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Description'     AND LANGUAGE_NAME = @language), 'Description')
DECLARE @word_column nvarchar(128)          = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Column'          AND LANGUAGE_NAME = @language), 'Column')
DECLARE @word_parameter nvarchar(128)       = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Parameter'       AND LANGUAGE_NAME = @language), 'Parameter')
DECLARE @word_dataType nvarchar(128)        = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'DataType'        AND LANGUAGE_NAME = @language), 'DataType')
DECLARE @word_nullable nvarchar(128)        = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Null'            AND LANGUAGE_NAME = @language), 'Null')
DECLARE @word_pk nvarchar(128)              = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'PK'              AND LANGUAGE_NAME = @language), 'PK')
DECLARE @word_identity nvarchar(128)        = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Identity'        AND LANGUAGE_NAME = @language), 'Identity')
DECLARE @word_key nvarchar(128)             = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Key'             AND LANGUAGE_NAME = @language), 'Key')
DECLARE @word_mode nvarchar(128)            = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Mode'            AND LANGUAGE_NAME = @language), 'Mode')
DECLARE @word_type nvarchar(128)            = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Type'            AND LANGUAGE_NAME = @language), 'Type')
DECLARE @word_comment nvarchar(128)         = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Comment'         AND LANGUAGE_NAME = @language), 'Comment')
DECLARE @word_values nvarchar(128)          = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Values'          AND LANGUAGE_NAME = @language), 'Values')
DECLARE @word_source_tables nvarchar(128)   = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Source tables'   AND LANGUAGE_NAME = @language), 'Source tables')
DECLARE @word_backtotop nvarchar(128)       = COALESCE((SELECT TRANSLATED_NAME FROM doc.translations WHERE TABLE_SCHEMA = 'doc' AND TABLE_NAME = 'uspDatabaseDocumentation' AND COLUMN_NAME = 'Back to top'     AND LANGUAGE_NAME = @language), 'Back to top')

END

BEGIN -- HEADERS, MENU, CONTENT --

DECLARE @exclude_columns nvarchar(max)

SELECT TOP 1 @exclude_columns   = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE 'database' AND TABLE_NAME = 'exclude_columns' AND LANGUAGE_NAME = @language

SET @exclude_columns = COALESCE(' ' + REPLACE(@exclude_columns, ',', ' ') + ' ', '')

DECLARE @head_title nvarchar(255)
DECLARE @head_description nvarchar(1024)
DECLARE @head_content nvarchar(max)
DECLARE @h1 nvarchar(1024)
DECLARE @subtitle nvarchar(max)
DECLARE @theme_color nvarchar(255)
DECLARE @html_class nvarchar(255)
DECLARE @body_class nvarchar(255)
DECLARE @help_url nvarchar(255)
DECLARE @manifest_url nvarchar(255)
DECLARE @stylesheet_url nvarchar(255)
DECLARE @contents_url nvarchar(255)

SELECT TOP 1 @head_title        = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'title'           AND LANGUAGE_NAME = @language
SELECT TOP 1 @head_description  = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'description'     AND LANGUAGE_NAME = @language
SELECT TOP 1 @head_content      = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'head_content'    AND LANGUAGE_NAME = @language
SELECT TOP 1 @h1                = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'h1'              AND LANGUAGE_NAME = @language
SELECT TOP 1 @subtitle          = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'subtitle'        AND LANGUAGE_NAME = @language
SELECT TOP 1 @theme_color       = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'theme_color'     AND LANGUAGE_NAME = @language
SELECT TOP 1 @html_class        = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'html_class'      AND LANGUAGE_NAME = @language
SELECT TOP 1 @body_class        = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'body_class'      AND LANGUAGE_NAME = @language
SELECT TOP 1 @help_url          = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'online_help_url' AND LANGUAGE_NAME = @language
SELECT TOP 1 @manifest_url      = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'manifest_url'    AND LANGUAGE_NAME = @language
SELECT TOP 1 @stylesheet_url    = COMMENT FROM doc.help WHERE SECTION_ID = 6 AND TABLE_SCHEMA LIKE COALESCE(@schema, 'database') AND TABLE_NAME = 'stylesheet_url'  AND LANGUAGE_NAME = @language

IF @part = 0 OR @help_url IS NULL
    SET @contents_url = ''
ELSE
    SET @contents_url = @help_url

IF @head_title IS NULL
    SET @head_title = DB_NAME() + CASE WHEN @schema IS NULL THEN '' ELSE ' - ' + STUFF((
        SELECT ', ' + name FROM sys.schemas WHERE name LIKE @schema ORDER BY name
            FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)'), 1, 2, '') END

IF @content_only = 0
    BEGIN

    INSERT INTO @result (line) VALUES
        ('<!DOCTYPE html' + CASE WHEN @html_class IS NOT NULL THEN ' class="' + @html_class + '"' ELSE '' END + '>'),
        ('<html lang="' + @language + '">'),
        ('<head>'),
        ('<meta charset="utf-8" />'),
        ('<meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1" />'),
        ('<meta name="theme-color" content="' + COALESCE(@theme_color, '#0070C0') + '" />');

    IF @head_description IS NOT NULL
    INSERT INTO @result (line) VALUES
        ('<meta name="description" content="' + REPLACE(REPLACE(@head_description, @lf, ' '), '"', ' ') + '" />');

    INSERT INTO @result (line) VALUES
        ('<title>' + REPLACE(@head_title, @lf, ' ') + '</title>');

    IF @help_url IS NOT NULL
    INSERT INTO @result (line) VALUES
        ('<link href="' + @help_url + '" rel="canonical" />');

    IF @manifest_url IS NOT NULL
    INSERT INTO @result (line) VALUES
        ('<link href="' + @manifest_url + '" rel="manifest" />');

    IF NOT COALESCE(@stylesheet_url, '') = '-'
    INSERT INTO @result (line) VALUES
        ('<link rel="stylesheet" type="text/css" href="' + COALESCE(@stylesheet_url, 'https://www.savetodb.com/help/doc-style.css') + '" />');

    IF @head_content IS NOT NULL
    INSERT INTO @result (line) VALUES
        (@head_content);

    INSERT INTO @result (line) VALUES
        ('</head>'),
        ('<body' + CASE WHEN @body_class IS NOT NULL THEN ' class="' + @body_class + '"' ELSE '' END + '>');

    INSERT INTO @result (line) VALUES
        (''),
        ('<div id="topmenu">');

    -- INSERT INTO @result (line) VALUES ('<a id="m01" href="' + @contents_url + '#contents">' + @word_contents + '</a>');

    IF @has_introduction = 1    INSERT INTO @result (line) VALUES ('<a id="m02" href="' + @contents_url + '#introduction">'+ @word_introduction  + '</a>');
    IF @has_history = 1         INSERT INTO @result (line) VALUES ('<a id="m03" href="' + @contents_url + '#history">'     + @word_history       + '</a>');
    IF @has_diagrams = 1        INSERT INTO @result (line) VALUES ('<a id="m04" href="' + @contents_url + '#diagrams">'    + @word_diagrams      + '</a>');
    IF @has_roles = 1           INSERT INTO @result (line) VALUES ('<a id="m05" href="' + @contents_url + '#roles">'       + @word_roles         + '</a>');
    IF @has_schemas = 1         INSERT INTO @result (line) VALUES ('<a id="m06" href="' + @contents_url + '#schemas">'     + @word_schemas       + '</a>');
    IF @has_tables = 1          INSERT INTO @result (line) VALUES ('<a id="m07" href="' + @contents_url + '#tables">'      + @word_tables        + '</a>');
    IF @has_views = 1           INSERT INTO @result (line) VALUES ('<a id="m08" href="' + @contents_url + '#views">'       + @word_views         + '</a>');
    IF @has_procedures = 1      INSERT INTO @result (line) VALUES ('<a id="m09" href="' + @contents_url + '#procedures">'  + @word_procedures    + '</a>');
    IF @has_functions = 1       INSERT INTO @result (line) VALUES ('<a id="m10" href="' + @contents_url + '#functions">'   + @word_functions     + '</a>');
    IF @has_conclusion = 1      INSERT INTO @result (line) VALUES ('<a id="m11" href="' + @contents_url + '#conclusion">'  + @word_conclusion    + '</a>');

    INSERT INTO @result (line) VALUES
        ('</div>');

    INSERT INTO @result (line) VALUES
        (''),
        ('<div id="content">'),
        ('<h1>' + REPLACE(@h1, @lf, @crlf + '<br>') + '</h1>'),
        ('');

    IF @subtitle IS NOT NULL
        INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@subtitle, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)

    END

IF (@part IN (0, 1, 11))
    BEGIN
    INSERT INTO @result (line) VALUES
        (@h2o + ' id="contents">' + @word_contents + @h2c),
        (''),
        ('<ul class="contents">');

    IF @has_introduction = 1    INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#introduction">'+ @word_introduction   + '</a></li>')
    IF @has_history = 1         INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#history">'     + @word_change_history + '</a></li>')
    IF @has_diagrams = 1        INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#diagrams">'    + @word_diagrams       + '</a></li>')
    IF @has_roles = 1           INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#roles">'       + @word_roles          + '</a></li>')
    IF @has_schemas = 1         INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#schemas">'     + @word_schemas        + '</a></li>')
    IF @has_tables = 1          INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#tables">'      + @word_tables         + '</a></li>')
    IF @has_views = 1           INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#views">'       + @word_views          + '</a></li>')
    IF @has_procedures = 1      INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#procedures">'  + @word_procedures     + '</a></li>')
    IF @has_functions = 1       INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#functions">'   + @word_functions      + '</a></li>')
    IF @has_conclusion = 1      INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#conclusion">'  + @word_conclusion     + '</a></li>')


    INSERT INTO @result (line) VALUES
        ('</ul>'),
        ('');
    END

END

BEGIN -- INTRODUCTION --

IF @has_introduction = 1 AND @part IN (0, 1, 12)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="introduction">' + @header_prefix + @word_introduction + @header_suffix + @h2c),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.COMMENT, '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '''', '&#39;'), '"', '&quot;'), '  ', ' &nbsp;'),
                @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'introduction'
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    END

END

BEGIN -- CHANGE HISTORY --

IF @has_history = 1 AND @part IN (0, 1, 13)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="history">' + @header_prefix + @word_change_history + @header_suffix + @h2c),
        ('');

    -- History

    SELECT @pages = (
        SELECT
            CASE SECTION_ID
                WHEN 1 THEN
                    @h3o + ' class="history_title" id="' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + REPLACE(t.VERSION, ' ', '_') + '">' + t.DESCRIPTION + @h3c + @crlf + @crlf
                WHEN 2 THEN
                    COALESCE('<p>' + REPLACE(REPLACE(t.DESCRIPTION, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>') + '</p>' + @crlf, '')
                    + COALESCE('<p>' + REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>') + '</p>' + @crlf, '')
                ELSE
                    CASE WHEN t1.ID IS NOT NULL THEN
                        '<p class="history_section">' + COALESCE(tr.TRANSLATED_NAME, s.SECTION) + ':</p>' + @crlf + @crlf
                        + '<ul>' + @crlf
                        ELSE '' END
                    + '<li>'
                    + COALESCE(REPLACE(t.DESCRIPTION, @lf, @crlf + '<br>')
                        + CASE WHEN t.COMMENT IS NULL THEN '' ELSE '<br>' END, '')
                    + COALESCE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), '')
                    + '</li>' + @crlf
                    + CASE WHEN t2.ID IS NOT NULL THEN
                        '</ul>' + @crlf + @crlf
                        ELSE '' END
                END
        FROM
            doc.history t

            INNER JOIN doc.history_sections s ON s.ID = t.SECTION_ID

            LEFT OUTER JOIN doc.translations tr ON tr.TABLE_SCHEMA = 'doc' AND tr.TABLE_NAME = 'history_sections'
                AND tr.COLUMN_NAME = s.SECTION AND tr.LANGUAGE_NAME = t.LANGUAGE_NAME

            LEFT OUTER JOIN (
                SELECT
                    ID, ROW_NUMBER() OVER (PARTITION BY TABLE_SCHEMA, VERSION, SECTION_ID ORDER BY SORT_ORDER, ID) AS r
                FROM
                    doc.history
            ) t1 ON t1.ID = t.ID AND t1.r = 1

            LEFT OUTER JOIN (
                SELECT
                    ID, ROW_NUMBER() OVER (PARTITION BY TABLE_SCHEMA, VERSION, SECTION_ID ORDER BY SORT_ORDER DESC, ID DESC) AS r
                FROM
                    doc.history
            ) t2 ON t2.ID = t.ID AND t2.r = 1
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.DESCRIPTION IS NOT NULL
            AND t.VERSION IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.VERSION DESC
            , t.SECTION_ID
            , t.SORT_ORDER
            , t.ID
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    END

END

BEGIN -- DIAGRAMS --

IF @has_diagrams = 1 AND @part IN (0, 1, 14)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="diagrams">' + @header_prefix + @word_diagrams + @header_suffix + @h2c),
        ('');

    -- Diagrams

    INSERT INTO @result (line) VALUES
        ('<div class="table_wrapper"><table class="diagrams">'),
        ('<tr><th class="name">' + @word_diagram + '</th><th class="description">' + @word_description + '</th></tr>')

    SELECT @diagrams = (
        SELECT
            '<tr><td><a href="#diagram.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + REPLACE(t.TABLE_NAME, ' ', '_') + '">' + t.TABLE_NAME + '</a></td><td>'
                + COALESCE(t.DESCRIPTION, '') +'</td></tr>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.SECTION_ID = 4
            AND t.LANGUAGE_NAME = @language
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (LEFT(@diagrams, LEN(@diagrams) - 2))

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'diagrams'
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    -- Details

    SELECT @diagrams = (
        SELECT
            @h3o + ' class="diagram_title" id="diagram.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + REPLACE(t.TABLE_NAME, ' ', '_') + '">' + t.TABLE_NAME + COALESCE('. ' + t.DESCRIPTION, '') + @h3c + @crlf + @crlf
            + COALESCE('<p><img src="' + t.COLUMN_NAME + '" alt="' + COALESCE(t.DESCRIPTION, t.TABLE_NAME, '') + '" title="' + COALESCE(t.DESCRIPTION, t.TABLE_NAME, '') + '"/></p>' + @crlf + @crlf, '')
            + '<p>' + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.SECTION_ID = 4
            AND t.LANGUAGE_NAME = @language
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)') + @crlf

    INSERT INTO @result (line) VALUES (@diagrams)

    END

END

BEGIN -- ROLES --

IF @has_roles = 1 AND @part IN (0, 1, 15)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="roles">' + @header_prefix + @word_roles + @header_suffix + @h2c),
        ('');

    -- Roles

    DECLARE role_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            p.name AS TABLE_NAME
            , tr.DESCRIPTION
            , tr.COMMENT
        FROM
            (
                SELECT
                    r.name
                FROM
                    sys.database_permissions p
                    INNER JOIN sys.database_principals r ON r.principal_id = p.grantee_principal_id
                    INNER JOIN sys.objects o ON o.object_id = p.major_id
                    INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
                WHERE
                    p.class = 1
                    AND r.is_fixed_role = 0
                    AND NOT r.sid IS NULL
                    AND r.[type] = 'R'
                    AND NOT r.name IN ('dbo', 'guest', 'public')
                    AND s.name LIKE COALESCE(@schema, s.name)
                    AND (@app_schema_only = 0 OR NOT s.name IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
                    AND NOT r.name IN (
                        SELECT
                            t.name
                        FROM
                            (VALUES
                                ('doc', 'doc_readers'),
                                ('doc', 'doc_writers'),
                                ('logs', 'log_admins'),
                                ('logs', 'log_users'),
                                ('xls', 'xls_admins'),
                                ('xls', 'xls_developers'),
                                ('xls', 'xls_formats'),
                                ('xls', 'xls_users')
                                ) t(schema_name, name)
                        WHERE
                            t.schema_name IN (
                                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
                            )
                        )
                UNION
                SELECT
                    r.name
                FROM
                    sys.database_permissions p
                    INNER JOIN sys.database_principals r ON r.principal_id = p.grantee_principal_id
                    INNER JOIN sys.schemas s ON s.schema_id = p.major_id
                WHERE
                    p.class = 3
                    AND r.is_fixed_role = 0
                    AND NOT r.sid IS NULL
                    AND r.[type] = 'R'
                    AND NOT r.name IN ('dbo', 'guest', 'public')
                    AND s.name LIKE COALESCE(@schema, s.name)
                    AND (@app_schema_only = 0 OR NOT s.name IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
                    AND NOT r.name IN (
                        SELECT
                            t.name
                        FROM
                            (VALUES
                                ('doc', 'doc_readers'),
                                ('doc', 'doc_writers'),
                                ('logs', 'log_admins'),
                                ('logs', 'log_users'),
                                ('xls', 'xls_admins'),
                                ('xls', 'xls_developers'),
                                ('xls', 'xls_formats'),
                                ('xls', 'xls_users')
                                ) t(schema_name, name)
                        WHERE
                            t.schema_name IN (
                                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
                            )
                        )
            ) p
            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = 'roles' AND tr.TABLE_NAME = p.name AND tr.LANGUAGE_NAME = @language
        WHERE
            p.name LIKE @include_names
            AND NOT p.name LIKE @exclude_names
        ORDER BY
            p.name

    INSERT INTO @result (line) VALUES
        ('<div class="table_wrapper"><table class="roles">'),
        ('<tr><th class="name">' + @word_role + '</th><th class="description">' + @word_description + '</th></tr>')

    OPEN role_cursor
    FETCH NEXT FROM role_cursor
    INTO
        @TABLE_NAME
        , @DESCRIPTION
        , @COMMENT

    WHILE @@FETCH_STATUS = 0
        BEGIN

        INSERT INTO @result (line) VALUES('<tr><td>'
            + CASE WHEN @DESCRIPTION IS NULL AND @COMMENT IS NULL THEN @TABLE_NAME ELSE '<a href="#role.' + @TABLE_NAME + '">' + @TABLE_NAME + '</a>' END
            + '</td><td>' + COALESCE(@DESCRIPTION, '') + '</td></tr>')

        FETCH NEXT FROM role_cursor
        INTO
            @TABLE_NAME
            , @DESCRIPTION
            , @COMMENT
        END

    CLOSE role_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'roles'
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    -- Details

    OPEN role_cursor
    FETCH NEXT FROM role_cursor
    INTO
        @TABLE_NAME
        , @DESCRIPTION
        , @COMMENT

    WHILE @@FETCH_STATUS = 0
        BEGIN

        IF @DESCRIPTION IS NOT NULL OR @COMMENT IS NOT NULL
            BEGIN
            INSERT INTO @result (line) VALUES
                (@h3o + ' id="role.' + @TABLE_NAME + '">' + @TABLE_NAME + @h3c),
                ('');

            IF @DESCRIPTION IS NOT NULL
                INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@DESCRIPTION, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)

            IF @COMMENT IS NOT NULL
                INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)
            END

        FETCH NEXT FROM role_cursor
        INTO
            @TABLE_NAME
            , @DESCRIPTION
            , @COMMENT
        END

    CLOSE role_cursor

    DEALLOCATE role_cursor

    END

END

BEGIN -- SCHEMAS --

IF @has_schemas = 1 AND @part IN (0, 1, 16)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="schemas">' + @header_prefix + @word_schemas + @header_suffix + @h2c),
        ('');

    -- Schemas

    DECLARE schema_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            DISTINCT
            t.TABLE_SCHEMA
            , tr.DESCRIPTION
            , tr.COMMENT
        FROM
            (
                SELECT
                    t.TABLE_SCHEMA
                FROM
                    INFORMATION_SCHEMA.TABLES t
                WHERE
                    t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
                    AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
                    AND NOT t.TABLE_NAME IN ('sysdiagrams')
                    AND NOT t.TABLE_SCHEMA IN ('sys')
                    AND NOT t.TABLE_SCHEMA IN (
                        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
                    )
                UNION
                SELECT
                    t.ROUTINE_SCHEMA
                FROM
                    INFORMATION_SCHEMA.ROUTINES t
                WHERE
                    t.ROUTINE_SCHEMA LIKE COALESCE(@schema, t.ROUTINE_SCHEMA)
                    AND (@app_schema_only = 0 OR NOT t.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
                    AND NOT t.ROUTINE_NAME LIKE 'sp_%'
                    AND NOT t.ROUTINE_NAME LIKE 'fn_%'
                    AND NOT t.ROUTINE_SCHEMA IN ('sys')
                    AND NOT t.ROUTINE_SCHEMA IN (
                        SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
                    )
            ) t
            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = 'schemas' AND tr.TABLE_NAME = t.TABLE_SCHEMA AND tr.LANGUAGE_NAME = @language
        WHERE
            t.TABLE_SCHEMA LIKE @include_names
            AND NOT t.TABLE_SCHEMA LIKE @exclude_names
        ORDER BY
            t.TABLE_SCHEMA

    INSERT INTO @result (line) VALUES
        ('<div class="table_wrapper"><table class="schemas">'),
        ('<tr><th class="name">' + @word_schema + '</th><th class="description">' + @word_description + '</th></tr>')

    OPEN schema_cursor
    FETCH NEXT FROM schema_cursor
    INTO
        @TABLE_SCHEMA
        , @DESCRIPTION
        , @COMMENT

    WHILE @@FETCH_STATUS = 0
        BEGIN

        INSERT INTO @result (line) VALUES('<tr><td>'
            + CASE WHEN @DESCRIPTION IS NULL AND @COMMENT IS NULL THEN @TABLE_SCHEMA ELSE '<a href="#schema.' + @TABLE_SCHEMA + '">' + @TABLE_SCHEMA + '</a>' END
            + '</td><td>' + COALESCE(@DESCRIPTION, '') + '</td></tr>')

        FETCH NEXT FROM schema_cursor
        INTO
            @TABLE_SCHEMA
            , @DESCRIPTION
            , @COMMENT
        END

    CLOSE schema_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'schemas'
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    -- Details

    OPEN schema_cursor
    FETCH NEXT FROM schema_cursor
    INTO
        @TABLE_SCHEMA
        , @DESCRIPTION
        , @COMMENT

    WHILE @@FETCH_STATUS = 0
        BEGIN

        IF @DESCRIPTION IS NOT NULL OR @COMMENT IS NOT NULL
            BEGIN
            INSERT INTO @result (line) VALUES
                (@h3o + ' id="schema.' + @TABLE_SCHEMA + '">' + @TABLE_SCHEMA + @h3c),
                ('');

            IF @DESCRIPTION IS NOT NULL
                INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@DESCRIPTION, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)

            IF @COMMENT IS NOT NULL
                INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)
            END

        FETCH NEXT FROM schema_cursor
        INTO
            @TABLE_SCHEMA
            , @DESCRIPTION
            , @COMMENT
        END

    CLOSE schema_cursor

    DEALLOCATE schema_cursor

    END

END

BEGIN -- TABLES --

IF @has_tables = 1 AND @part IN (0, 2)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="tables">' + @header_prefix + @word_tables + @header_suffix + @h2c),
        ('');

    -- Tables

    DECLARE table_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            t.TABLE_SCHEMA
            , t.TABLE_NAME
            , tr.DESCRIPTION
        FROM
            INFORMATION_SCHEMA.TABLES t
            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = t.TABLE_SCHEMA AND tr.TABLE_NAME = t.TABLE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.TABLE_TYPE = 'BASE TABLE'
            AND NOT t.TABLE_NAME IN ('sysdiagrams')
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
            AND t.TABLE_SCHEMA LIKE @include_names
            AND NOT t.TABLE_SCHEMA LIKE @exclude_names
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME

    INSERT INTO @result (line) VALUES
        ('<div class="table_wrapper"><table class="objects">'),
        ('<tr><th class="name">' + @word_table + '</th><th class="description">' + @word_description + '</th></tr>');

    OPEN table_cursor
    FETCH NEXT FROM table_cursor
    INTO
        @TABLE_SCHEMA
        , @TABLE_NAME
        , @DESCRIPTION

    WHILE @@FETCH_STATUS = 0
        BEGIN

        INSERT INTO @result (line) VALUES('<tr><td><a href="#'
            + REPLACE(@TABLE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@TABLE_NAME) + '">'
            + @TABLE_SCHEMA + '.' + @TABLE_NAME + '</a></td><td>' + COALESCE(@DESCRIPTION, '') + '</td></tr>')

        FETCH NEXT FROM table_cursor
        INTO
            @TABLE_SCHEMA
            , @TABLE_NAME
            , @DESCRIPTION
        END

    CLOSE table_cursor
    DEALLOCATE table_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'tables'
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    -- Details

    DECLARE table_field_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            t.TABLE_SCHEMA
            , t.TABLE_NAME
            , c.COLUMN_NAME
            , CASE
                WHEN RIGHT(c.DATA_TYPE, 4) = 'char' AND c.CHARACTER_MAXIMUM_LENGTH = -1 THEN c.DATA_TYPE + '(max)'
                WHEN RIGHT(c.DATA_TYPE, 4) = 'char' THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN c.DATA_TYPE IN ('binary', 'varbinary') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN c.DATA_TYPE IN ('decimal', 'numeric') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ',' +  CAST(c.NUMERIC_SCALE AS varchar) + ')'
                WHEN c.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN c.DATA_TYPE + '(' + CAST(c.DATETIME_PRECISION AS varchar) + ')'
                ELSE c.DATA_TYPE END AS DATA_TYPE
            , CASE WHEN c.IS_NULLABLE = 'NO' THEN NULL ELSE '<i class="check">&#x2713;</i>' END AS IS_NULLABLE
            , CASE WHEN ccu1.COLUMN_NAME IS NULL THEN '' ELSE '<i class="check">&#x2713;</i>' END AS IS_PK
            , CASE WHEN sc.is_identity = 1 THEN 'Identity' ELSE NULL END AS IS_IDENTITY
            , ccu2.REFERENTIAL_TABLE_SCHEMA
            , ccu2.REFERENTIAL_TABLE_NAME
            , ccu2.REFERENTIAL_COLUMN_NAME
            , trc.DESCRIPTION
            , tr.DESCRIPTION AS TABLE_DESCRIPTION
            , tr.COMMENT AS TABLE_COMMENT
        FROM
            INFORMATION_SCHEMA.COLUMNS c
            INNER JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME

            INNER JOIN sys.columns sc
                ON sc.[object_id] = OBJECT_ID(QUOTENAME(c.TABLE_SCHEMA) + '.' + QUOTENAME(c.TABLE_NAME)) AND sc.name = c.COLUMN_NAME

            LEFT OUTER JOIN (
                SELECT
                    ccu.TABLE_SCHEMA
                    , ccu.TABLE_NAME
                    , ccu.COLUMN_NAME
                FROM
                    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
                    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
                        ON tc.TABLE_SCHEMA = ccu.TABLE_SCHEMA AND tc.TABLE_NAME = ccu.TABLE_NAME
                            AND tc.CONSTRAINT_SCHEMA = ccu.CONSTRAINT_SCHEMA AND tc.CONSTRAINT_NAME = ccu.CONSTRAINT_NAME
                            AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
                ) ccu1 ON ccu1.TABLE_SCHEMA = c.TABLE_SCHEMA AND ccu1.TABLE_NAME = c.TABLE_NAME AND ccu1.COLUMN_NAME = c.COLUMN_NAME

            LEFT OUTER JOIN (
                SELECT
                    kcc.TABLE_SCHEMA
                    , kcc.TABLE_NAME
                    , kcc.COLUMN_NAME
                    , kcu.TABLE_SCHEMA AS REFERENTIAL_TABLE_SCHEMA
                    , kcu.TABLE_NAME AS REFERENTIAL_TABLE_NAME
                    , kcu.COLUMN_NAME AS REFERENTIAL_COLUMN_NAME
                FROM
                    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
                    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcc ON
                        kcc.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA AND kcc.CONSTRAINT_NAME = rc.CONSTRAINT_NAME
                    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu ON
                        kcu.CONSTRAINT_SCHEMA = rc.UNIQUE_CONSTRAINT_SCHEMA AND kcu.CONSTRAINT_NAME = rc.UNIQUE_CONSTRAINT_NAME
                        AND kcu.ORDINAL_POSITION = kcc.ORDINAL_POSITION
                ) ccu2 ON ccu2.TABLE_SCHEMA = c.TABLE_SCHEMA AND ccu2.TABLE_NAME = c.TABLE_NAME AND ccu2.COLUMN_NAME = c.COLUMN_NAME

            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = t.TABLE_SCHEMA AND tr.TABLE_NAME = t.TABLE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language

            LEFT OUTER JOIN doc.help trc
                ON trc.TABLE_SCHEMA = t.TABLE_SCHEMA AND trc.TABLE_NAME = t.TABLE_NAME AND trc.COLUMN_NAME = c.COLUMN_NAME AND trc.LANGUAGE_NAME = @language

        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.TABLE_TYPE = 'BASE TABLE'
            AND NOT t.TABLE_NAME IN ('sysdiagrams')
            AND NOT t.TABLE_SCHEMA IN ('s+s')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
            AND t.TABLE_SCHEMA LIKE @include_names
            AND NOT t.TABLE_SCHEMA LIKE @exclude_names
        ORDER BY
            c.TABLE_SCHEMA
            , c.TABLE_NAME
            , c.ORDINAL_POSITION

    SET @PREV_SCHEMA = ''
    SET @PREV_NAME = ''
    SET @PREV_COMMENT = ''
    SET @TABLE_VALUES = NULL

    OPEN table_field_cursor
    FETCH NEXT FROM table_field_cursor
    INTO
        @TABLE_SCHEMA
        , @TABLE_NAME
        , @COLUMN_NAME
        , @DATA_TYPE
        , @IS_NULLABLE
        , @IS_PK
        , @IS_IDENTITY
        , @REFERENTIAL_TABLE_SCHEMA
        , @REFERENTIAL_TABLE_NAME
        , @REFERENTIAL_COLUMN_NAME
        , @DESCRIPTION
        , @TABLE_DESCRIPTION
        , @TABLE_COMMENT

    WHILE @@FETCH_STATUS = 0
        BEGIN

        IF @PREV_SCHEMA <> @TABLE_SCHEMA OR @PREV_NAME <> @TABLE_NAME
            BEGIN
            IF @PREV_NAME > ''
                BEGIN
                INSERT INTO @result (line) VALUES
                    ('</table></div>'),
                    ('');

                IF @TABLE_VALUES IS NOT NULL
                INSERT INTO @result (line) VALUES
                    ('<p>' + @word_values + ':</p>'),
                    (@TABLE_VALUES);

                INSERT INTO @result (line) VALUES
                    ('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);
                END

            SET @PREV_SCHEMA = @TABLE_SCHEMA
            SET @PREV_NAME = @TABLE_NAME
            SET @PREV_COMMENT = @TABLE_COMMENT

            INSERT INTO @result (line) VALUES
                (@h3o + ' id="'
                    + REPLACE(@TABLE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@TABLE_NAME) + '">'
                    + @TABLE_SCHEMA + '.' + @TABLE_NAME + @h3c),
                ('');

            IF @TABLE_DESCRIPTION IS NOT NULL
            INSERT INTO @result (line) VALUES
                ('<p>' + COALESCE(REPLACE(REPLACE(@TABLE_DESCRIPTION, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);

            SELECT @triggers = (
                SELECT
                    '<tr><td>' + t.name
                    + '</td><td>' + e.type_desc
                    + '</td><td>' + COALESCE(tr.DESCRIPTION, '')
                    + '</td></tr>' + @crlf
                FROM
                    sys.triggers t
                    INNER JOIN sys.objects o ON o.[object_id] = t.parent_id
                    INNER JOIN sys.schemas s ON s.[schema_id] = o.[schema_id]
                    INNER JOIN sys.trigger_events e ON e.[object_id] = t.[object_id]
                    LEFT OUTER JOIN doc.help tr
                        ON tr.TABLE_SCHEMA = s.name AND tr.TABLE_NAME = t.name AND tr.LANGUAGE_NAME = @language
                WHERE
                    s.name = @TABLE_SCHEMA
                    AND o.name = @TABLE_NAME
                ORDER BY
                    e.[type]
                    , t.name
                FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

            IF @triggers IS NOT NULL
                BEGIN
                INSERT INTO @result (line) VALUES
                    ('<div class="table_wrapper"><table class="triggers">'),
                    ('<tr><th class="trigger">' + @word_trigger + '</th><th class="trigger_type">' + @word_type
                        + '</th><th class="comment">' + @word_comment + '</th></tr>'),
                    (LEFT(@triggers, LEN(@triggers) - 2)),
                    ('</table></div>'),
                    ('');
                END

            INSERT INTO @result (line) VALUES
                ('<div class="table_wrapper"><table class="table_fields">'),
                ('<tr><th class="pk">'
                + '</th><th class="column">' + @word_column
                + '</th><th class="datatype">' + @word_datatype
                + '</th><th class="nullable">' + @word_nullable
                + '</th><th class="comment">' + @word_comment
                + '</th></tr>');

            -- Table values

            SELECT @SQL = 'SELECT @result = ''<div class="table_wrapper"><table class="values">'' + CHAR(13) + CHAR(10)' + @crlf
                + '    + ''<tr>' + (
                SELECT
                    '<th>' + c.COLUMN_NAME + '</th>'
                FROM
                    INFORMATION_SCHEMA.COLUMNS c
                WHERE
                    c.TABLE_SCHEMA = @TABLE_SCHEMA
                    AND c.TABLE_NAME = @TABLE_NAME
                    AND CHARINDEX(' ' + c.COLUMN_NAME + ' ', @exclude_columns) = 0
                    AND (
                            SELECT
                                COUNT(*)
                            FROM
                                INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
                                INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
                                    ON tc.TABLE_SCHEMA = ccu.TABLE_SCHEMA AND tc.TABLE_NAME = ccu.TABLE_NAME
                                        AND tc.CONSTRAINT_SCHEMA = ccu.CONSTRAINT_SCHEMA AND tc.CONSTRAINT_NAME = ccu.CONSTRAINT_NAME
                                        AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
                            WHERE
                                ccu.TABLE_SCHEMA = c.TABLE_SCHEMA
                                AND ccu.TABLE_NAME = c.TABLE_NAME
                    ) = 1
                    AND (
                            SELECT
                                COUNT(*)
                            FROM
                                sys.columns sc
                            WHERE
                                sc.[object_id] = OBJECT_ID(QUOTENAME(c.TABLE_SCHEMA) + '.' + QUOTENAME(c.TABLE_NAME))
                                AND sc.is_identity = 1
                    ) = 0
                    AND (
                            SELECT
                                MAX(s.rows)
                            FROM
                                sys.partitions s
                            WHERE
                                s.object_id = OBJECT_ID(QUOTENAME(c.TABLE_SCHEMA) + '.' + QUOTENAME(c.TABLE_NAME))
                                AND s.index_id IN (0, 1)
                    ) <= @value_output_limit
                ORDER BY
                    c.ORDINAL_POSITION
                FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')
                + '</tr>'' + CHAR(13) + CHAR(10)' + @crlf
                + '    + (' + @crlf
                + '    SELECT' + @crlf
                + '        ''<tr>' + (
                SELECT
                    '<td>'' + COALESCE(' + CASE
                        WHEN c.DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar') THEN QUOTENAME(c.COLUMN_NAME)
                        ELSE 'CAST('+ QUOTENAME(c.COLUMN_NAME) + ' AS nvarchar)'
                        END
                        + ', '''')' + @crlf
                        + '        + ''</td>'
                FROM
                    INFORMATION_SCHEMA.COLUMNS c
                WHERE
                    c.TABLE_SCHEMA = @TABLE_SCHEMA
                    AND c.TABLE_NAME = @TABLE_NAME
                    AND CHARINDEX(' ' + c.COLUMN_NAME + ' ', @exclude_columns) = 0
                ORDER BY
                    c.ORDINAL_POSITION
                FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')
                + '</tr>'' + CHAR(13) + CHAR(10)' + @crlf
                + '    FROM' + @crlf
                + '        ' + QUOTENAME(@TABLE_SCHEMA) + '.' +  QUOTENAME(@TABLE_NAME) + @crlf
                + '    ORDER BY' + @crlf
                + '        ' + STUFF((
                SELECT
                    ', ' + ccu.COLUMN_NAME
                FROM
                    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
                    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
                        ON tc.TABLE_SCHEMA = ccu.TABLE_SCHEMA AND tc.TABLE_NAME = ccu.TABLE_NAME
                            AND tc.CONSTRAINT_SCHEMA = ccu.CONSTRAINT_SCHEMA AND tc.CONSTRAINT_NAME = ccu.CONSTRAINT_NAME
                            AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
                WHERE
                    ccu.TABLE_SCHEMA = @TABLE_SCHEMA
                    AND ccu.TABLE_NAME = @TABLE_NAME
                FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)'), 1, 2, '')
                + @crlf +
                '    FOR XML PATH(''''), TYPE).value(''.'', ''nvarchar(MAX)'')' + @crlf
                + '    + ''</table></div>'' + CHAR(13) + CHAR(10)'

                SET @TABLE_VALUES = NULL
                IF @SQL IS NOT NULL
                EXEC sp_executesql @SQL, N'@result nvarchar(max) out', @TABLE_VALUES out

            END

        INSERT INTO @result (line) VALUES('<tr>'
            + '<td>' + COALESCE(@IS_PK, '') + '</td>'
            + '<td>' + @COLUMN_NAME + '</td>'
            + '<td>' + COALESCE(@DATA_TYPE, '') + '</td>'
            + '<td>' + COALESCE(@IS_NULLABLE, '') + '</td>'
            + '<td>' + COALESCE(@IS_IDENTITY + '<br>', '')
                     + COALESCE('<a href="#' + REPLACE(@REFERENTIAL_TABLE_SCHEMA, ' ', '') + '.' + REPLACE(@REFERENTIAL_TABLE_NAME, ' ', '') + '">'
                        + @REFERENTIAL_TABLE_SCHEMA + '.' + @REFERENTIAL_TABLE_NAME + '</a>' + '.' + @REFERENTIAL_COLUMN_NAME
                        + CASE WHEN @DESCRIPTION IS NOT NULL THEN @crlf + '<br>' + @crlf + '<br>' ELSE '' END, '')
                     + COALESCE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@DESCRIPTION, '&', '&amp;'), '"', '&quot;'), '''', '&#39;'), '<', '&lt;'), '>', '&gt;'), @lf, @crlf + '<br>'), '') + '</td>'
            + '</tr>')

        FETCH NEXT FROM table_field_cursor
        INTO
            @TABLE_SCHEMA
            , @TABLE_NAME
            , @COLUMN_NAME
            , @DATA_TYPE
            , @IS_NULLABLE
            , @IS_PK
            , @IS_IDENTITY
            , @REFERENTIAL_TABLE_SCHEMA
            , @REFERENTIAL_TABLE_NAME
            , @REFERENTIAL_COLUMN_NAME
            , @DESCRIPTION
            , @TABLE_DESCRIPTION
            , @TABLE_COMMENT
        END

    CLOSE table_field_cursor
    DEALLOCATE table_field_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    IF @TABLE_VALUES IS NOT NULL
    INSERT INTO @result (line) VALUES
        ('<p>' + @word_values + ':</p>'),
        (@TABLE_VALUES);

    INSERT INTO @result (line) VALUES
        ('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);

    END

END

BEGIN -- VIEWS --

IF @has_views = 1 AND @part IN (0, 3)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="views">' + @header_prefix + @word_views + @header_suffix + @h2c),
        ('');

    -- Views

    DECLARE view_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            t.TABLE_SCHEMA
            , t.TABLE_NAME
            , tr.DESCRIPTION
        FROM
            INFORMATION_SCHEMA.TABLES t
            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = t.TABLE_SCHEMA AND tr.TABLE_NAME = t.TABLE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.TABLE_TYPE = 'VIEW'
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
            AND t.TABLE_SCHEMA LIKE @include_names
            AND NOT t.TABLE_SCHEMA LIKE @exclude_names
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME

    INSERT INTO @result (line) VALUES
        ('<div class="table_wrapper"><table class="objects">'),
        ('<tr><th class="name">' + @word_view + '</th><th class="description">' + @word_description + '</th></tr>');

    OPEN view_cursor
    FETCH NEXT FROM view_cursor
    INTO
        @TABLE_SCHEMA
        , @TABLE_NAME
        , @DESCRIPTION

    WHILE @@FETCH_STATUS = 0
        BEGIN

        INSERT INTO @result (line) VALUES(+ '<tr><td><a href="#'
            + REPLACE(@TABLE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@TABLE_NAME) + '">'
            + @TABLE_SCHEMA + '.' + @TABLE_NAME + '</a></td><td>' + COALESCE(@DESCRIPTION, '') + '</td></tr>')

        FETCH NEXT FROM view_cursor
        INTO
            @TABLE_SCHEMA
            , @TABLE_NAME
            , @DESCRIPTION
        END

    CLOSE view_cursor
    DEALLOCATE view_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'views'
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    -- Details

    DECLARE view_field_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            t.TABLE_SCHEMA
            , t.TABLE_NAME
            , c.COLUMN_NAME
            , CASE
                WHEN RIGHT(c.DATA_TYPE, 4) = 'char' AND c.CHARACTER_MAXIMUM_LENGTH = -1 THEN c.DATA_TYPE + '(max)'
                WHEN RIGHT(c.DATA_TYPE, 4) = 'char' THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN c.DATA_TYPE IN ('binary', 'varbinary') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN c.DATA_TYPE IN ('decimal', 'numeric') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ',' +  CAST(c.NUMERIC_SCALE AS varchar) + ')'
                WHEN c.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN c.DATA_TYPE + '(' + CAST(c.DATETIME_PRECISION AS varchar) + ')'
                ELSE c.DATA_TYPE END AS DATA_TYPE
            , trc.DESCRIPTION
            , tr.DESCRIPTION AS TABLE_DESCRIPTION
            , tr.COMMENT AS TABLE_COMMENT
            , tc.TABLE_SCHEMA AS REFERENTIAL_TABLE_SCHEMA
            , tc.TABLE_NAME AS REFERENTIAL_TABLE_NAME
        FROM
            INFORMATION_SCHEMA.COLUMNS c
            INNER JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME

            LEFT OUTER JOIN (
                SELECT
                    t.VIEW_SCHEMA
                    , t.VIEW_NAME
                    , t.COLUMN_NAME
                    , MAX(t.TABLE_SCHEMA) AS TABLE_SCHEMA
                    , MAX(t.TABLE_NAME) AS TABLE_NAME
                FROM
                    INFORMATION_SCHEMA.VIEW_COLUMN_USAGE t
                GROUP BY
                    t.VIEW_SCHEMA
                    , t.VIEW_NAME
                    , t.COLUMN_NAME
                HAVING
                    COUNT(*) = 1
            ) tc ON tc.VIEW_SCHEMA = c.TABLE_SCHEMA AND tc.VIEW_NAME = c.TABLE_NAME AND tc.COLUMN_NAME = c.COLUMN_NAME

            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = t.TABLE_SCHEMA AND tr.TABLE_NAME = t.TABLE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language

            LEFT OUTER JOIN doc.help trc
                ON trc.TABLE_SCHEMA = t.TABLE_SCHEMA AND trc.TABLE_NAME = t.TABLE_NAME AND trc.COLUMN_NAME = c.COLUMN_NAME AND trc.LANGUAGE_NAME = @language

        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.TABLE_TYPE = 'VIEW'
            AND t.TABLE_SCHEMA LIKE @include_names
            AND NOT t.TABLE_SCHEMA LIKE @exclude_names
        ORDER BY
            c.TABLE_SCHEMA
            , c.TABLE_NAME
            , c.ORDINAL_POSITION

    SET @PREV_SCHEMA = ''
    SET @PREV_NAME = ''
    SET @PREV_COMMENT = ''

    OPEN view_field_cursor
    FETCH NEXT FROM view_field_cursor
    INTO
        @TABLE_SCHEMA
        , @TABLE_NAME
        , @COLUMN_NAME
        , @DATA_TYPE
        , @DESCRIPTION
        , @TABLE_DESCRIPTION
        , @TABLE_COMMENT
        , @REFERENTIAL_TABLE_SCHEMA
        , @REFERENTIAL_TABLE_NAME

    WHILE @@FETCH_STATUS = 0
        BEGIN

        IF @PREV_SCHEMA <> @TABLE_SCHEMA OR @PREV_NAME <> @TABLE_NAME
            BEGIN
            IF @PREV_NAME > ''
                BEGIN
                INSERT INTO @result (line) VALUES
                    ('</table></div>'),
                    (''),
                    ('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);
                END

            SET @PREV_SCHEMA = @TABLE_SCHEMA
            SET @PREV_NAME = @TABLE_NAME
            SET @PREV_COMMENT = @TABLE_COMMENT

            INSERT INTO @result (line) VALUES
                (@h3o + ' id="'
                    + REPLACE(@TABLE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@TABLE_NAME) + '">'
                    + @TABLE_SCHEMA + '.' + @TABLE_NAME + @h3c),
                ('');

            IF @TABLE_DESCRIPTION IS NOT NULL
            INSERT INTO @result (line) VALUES
                ('<p>' + COALESCE(REPLACE(REPLACE(@TABLE_DESCRIPTION, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);

            SELECT @COMMENT = STUFF((
                SELECT
                    ', <a href="#' + REPLACE(t.TABLE_SCHEMA, ' ', '') + '.' + REPLACE(t.TABLE_NAME, ' ', '')
                    + '">' + t.TABLE_SCHEMA + '.' + t.TABLE_NAME + '</a>'
                FROM
                    INFORMATION_SCHEMA.VIEW_TABLE_USAGE t
                WHERE
                    t.VIEW_SCHEMA = @TABLE_SCHEMA
                    AND t.VIEW_NAME = @TABLE_NAME
                ORDER BY
                    t.TABLE_SCHEMA
                    , t.TABLE_NAME
                FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)'), 1, 2, '')

            IF @COMMENT IS NOT NULL
            INSERT INTO @result (line) VALUES
                ('<p class="source_tables">' + COALESCE(@word_source_tables + ': ', '') + @COMMENT + '</p>' + @crlf);

            INSERT INTO @result (line) VALUES
                ('<div class="table_wrapper"><table class="view_fields">'),
                ('<tr><th class="column">' + @word_column + '</th><th class="datatype">' + @word_datatype + '</th><th class="comment">' + @word_comment + '</th></tr>');
            END

        INSERT INTO @result (line) VALUES('<tr><td>' + @COLUMN_NAME + '</td>'
            + '<td>' + COALESCE(@DATA_TYPE, '') + '</td>'
            + '<td>' + CASE WHEN @DESCRIPTION IS NULL THEN COALESCE('<a href="#' + REPLACE(@REFERENTIAL_TABLE_SCHEMA, ' ', '') + '.' + REPLACE(@REFERENTIAL_TABLE_NAME, ' ', '') + '">'
                        + @REFERENTIAL_TABLE_SCHEMA + '.' + @REFERENTIAL_TABLE_NAME + '</a>' + '.' + @COLUMN_NAME, '') ELSE '' END
                     + COALESCE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@DESCRIPTION, '&', '&amp;'), '"', '&quot;'), '''', '&#39;'), '<', '&lt;'), '>', '&gt;'), @lf, @crlf + '<br>'), '') + '</td>'
            + '</tr>')

        FETCH NEXT FROM view_field_cursor
        INTO
            @TABLE_SCHEMA
            , @TABLE_NAME
            , @COLUMN_NAME
            , @DATA_TYPE
            , @DESCRIPTION
            , @TABLE_DESCRIPTION
            , @TABLE_COMMENT
            , @REFERENTIAL_TABLE_SCHEMA
            , @REFERENTIAL_TABLE_NAME
        END

    CLOSE view_field_cursor
    DEALLOCATE view_field_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        (''),
        ('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);

    END

END

BEGIN -- PROCEDURES --

IF @has_procedures = 1 AND @part IN (0, 4)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="procedures">' + @header_prefix + @word_procedures + @header_suffix + @h2c),
        ('');

    -- Procedures

    DECLARE procedure_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            t.ROUTINE_SCHEMA
            , t.ROUTINE_NAME
            , tr.DESCRIPTION
        FROM
            INFORMATION_SCHEMA.ROUTINES t
            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = t.ROUTINE_SCHEMA AND tr.TABLE_NAME = t.ROUTINE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language
        WHERE
            t.ROUTINE_SCHEMA LIKE COALESCE(@schema, t.ROUTINE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.ROUTINE_TYPE = 'PROCEDURE'
            AND NOT t.ROUTINE_NAME LIKE 'sp_%'
            AND NOT t.ROUTINE_SCHEMA IN ('sys')
            AND NOT t.ROUTINE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
            AND t.ROUTINE_NAME LIKE @include_names
            AND NOT t.ROUTINE_NAME LIKE @exclude_names
        ORDER BY
            t.ROUTINE_SCHEMA
            , t.ROUTINE_NAME

    INSERT INTO @result (line) VALUES
        ('<div class="table_wrapper"><table class="objects">'),
        ('<tr><th class="name">' + @word_procedure + '</th><th class="description">' + @word_description + '</th></tr>');

    OPEN procedure_cursor
    FETCH NEXT FROM procedure_cursor
    INTO
        @ROUTINE_SCHEMA
        , @ROUTINE_NAME
        , @DESCRIPTION

    WHILE @@FETCH_STATUS = 0
        BEGIN

        INSERT INTO @result (line) VALUES(+ '<tr><td><a href="#'
            + REPLACE(@ROUTINE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@ROUTINE_NAME) + '">'
            + @ROUTINE_SCHEMA + '.' + @ROUTINE_NAME + '</a></td><td>' + COALESCE(@DESCRIPTION, '') + '</td></tr>')

        FETCH NEXT FROM procedure_cursor
        INTO
            @ROUTINE_SCHEMA
            , @ROUTINE_NAME
            , @DESCRIPTION
        END

    CLOSE procedure_cursor
    DEALLOCATE procedure_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'procedures'
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    -- Details

    DECLARE procedure_parameter_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            r.ROUTINE_SCHEMA
            , r.ROUTINE_NAME
            , p.PARAMETER_NAME
            , CASE
                WHEN RIGHT(p.DATA_TYPE, 4) = 'char' AND p.CHARACTER_MAXIMUM_LENGTH = -1 THEN p.DATA_TYPE + '(max)'
                WHEN RIGHT(p.DATA_TYPE, 4) = 'char' THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('binary', 'varbinary') THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('decimal', 'numeric') THEN p.DATA_TYPE + '(' + CAST(p.NUMERIC_PRECISION AS varchar) + ',' +  CAST(p.NUMERIC_SCALE AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN p.DATA_TYPE + '(' + CAST(p.DATETIME_PRECISION AS varchar) + ')'
                ELSE p.DATA_TYPE END AS DATA_TYPE
            , p.PARAMETER_MODE
            , trc.DESCRIPTION
            , tr.DESCRIPTION AS TABLE_DESCRIPTION
            , tr.COMMENT AS TABLE_COMMENT
        FROM
            INFORMATION_SCHEMA.ROUTINES r
            LEFT OUTER JOIN INFORMATION_SCHEMA.PARAMETERS p ON p.SPECIFIC_SCHEMA = r.SPECIFIC_SCHEMA AND p.SPECIFIC_NAME = r.SPECIFIC_NAME

            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = r.ROUTINE_SCHEMA AND tr.TABLE_NAME = r.ROUTINE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language

            LEFT OUTER JOIN doc.help trc
                ON trc.TABLE_SCHEMA = r.ROUTINE_SCHEMA AND trc.TABLE_NAME = r.ROUTINE_NAME AND trc.COLUMN_NAME = p.PARAMETER_NAME AND trc.LANGUAGE_NAME = @language
        WHERE
            r.ROUTINE_SCHEMA LIKE COALESCE(@schema, r.ROUTINE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT r.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND r.ROUTINE_TYPE = 'PROCEDURE'
            AND NOT r.ROUTINE_NAME LIKE 'sp_%'
            AND NOT r.ROUTINE_SCHEMA IN ('sys')
            AND NOT r.ROUTINE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
            AND r.ROUTINE_NAME LIKE @include_names
            AND NOT r.ROUTINE_NAME LIKE @exclude_names
        ORDER BY
            r.ROUTINE_SCHEMA
            , r.ROUTINE_NAME
            , p.ORDINAL_POSITION

    SET @PREV_SCHEMA = ''
    SET @PREV_NAME = ''
    SET @PREV_COMMENT = ''
    SET @HAS_PARAMETERS = 0

    OPEN procedure_parameter_cursor
    FETCH NEXT FROM procedure_parameter_cursor
    INTO
        @ROUTINE_SCHEMA
        , @ROUTINE_NAME
        , @PARAMETER_NAME
        , @DATA_TYPE
        , @PARAMETER_MODE
        , @DESCRIPTION
        , @TABLE_DESCRIPTION
        , @TABLE_COMMENT

    WHILE @@FETCH_STATUS = 0
        BEGIN

        IF @PREV_SCHEMA <> @ROUTINE_SCHEMA OR @PREV_NAME <> @ROUTINE_NAME
            BEGIN
            IF @HAS_PARAMETERS = 1
                BEGIN
                INSERT INTO @result (line) VALUES
                    ('</table></div>'),
                    ('');
                END

            INSERT INTO @result (line) VALUES ('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);

            SET @PREV_SCHEMA = @ROUTINE_SCHEMA
            SET @PREV_NAME = @ROUTINE_NAME
            SET @PREV_COMMENT = @TABLE_COMMENT

            SET @HAS_PARAMETERS = CASE WHEN @PARAMETER_NAME IS NULL THEN 0 ELSE 1 END

            INSERT INTO @result (line) VALUES
                (@h3o + ' id="'
                    + REPLACE(@ROUTINE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@ROUTINE_NAME)
                    + '">' + @ROUTINE_SCHEMA + '.' + @ROUTINE_NAME + @h3c),
                ('');

            IF @TABLE_DESCRIPTION IS NOT NULL
            INSERT INTO @result (line) VALUES
                ('<p>' + COALESCE(REPLACE(REPLACE(@TABLE_DESCRIPTION, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);

            IF @HAS_PARAMETERS = 1
                BEGIN
                INSERT INTO @result (line) VALUES
                    ('<div class="table_wrapper"><table class="parameters">'),
                    ('<tr><th class="parameter">' + @word_parameter + '</th><th class="datatype">' + @word_datatype + '</th><th class="mode">' + @word_mode + '</th><th class="comment">' + @word_comment + '</th></tr>');
                END
            END

        IF @HAS_PARAMETERS = 1
            INSERT INTO @result (line) VALUES('<tr><td>' + @PARAMETER_NAME + '</td>'
                + '<td>' + COALESCE(@DATA_TYPE, '') + '</td>'

                + '<td>' + COALESCE(@PARAMETER_MODE, '') + '</td>'
                + '<td>' + COALESCE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@DESCRIPTION, '&', '&amp;'), '"', '&quot;'), '''', '&#39;'), '<', '&lt;'), '>', '&gt;'), @lf, @crlf + '<br>'), '') + '</td>'
                + '</tr>')

        FETCH NEXT FROM procedure_parameter_cursor
        INTO
            @ROUTINE_SCHEMA
            , @ROUTINE_NAME
            , @PARAMETER_NAME
            , @DATA_TYPE
            , @PARAMETER_MODE
            , @DESCRIPTION
            , @TABLE_DESCRIPTION
            , @TABLE_COMMENT
        END

    CLOSE procedure_parameter_cursor
    DEALLOCATE procedure_parameter_cursor

    IF @HAS_PARAMETERS = 1
        BEGIN
        INSERT INTO @result (line) VALUES
            ('</table></div>'),
            ('');
        END

    INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)

    END

END

BEGIN -- FUNCTIONS --

IF @has_functions = 1 AND @part IN (0, 5)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="functions">' + @header_prefix + @word_functions + @header_suffix + @h2c),
        ('');

    -- Functions

    DECLARE function_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
        SELECT
            t.ROUTINE_SCHEMA
            , t.ROUTINE_NAME
            , tr.DESCRIPTION
        FROM
            INFORMATION_SCHEMA.ROUTINES t
            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = t.ROUTINE_SCHEMA AND tr.TABLE_NAME = t.ROUTINE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language
        WHERE
            t.ROUTINE_SCHEMA LIKE COALESCE(@schema, t.ROUTINE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.ROUTINE_TYPE = 'FUNCTION'
            AND NOT t.ROUTINE_NAME LIKE 'fn_%'
            AND NOT t.ROUTINE_SCHEMA IN ('sys')
            AND NOT t.ROUTINE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
            AND t.ROUTINE_NAME LIKE @include_names
            AND NOT t.ROUTINE_NAME LIKE @exclude_names
        ORDER BY
            t.ROUTINE_SCHEMA
            , t.ROUTINE_NAME

    INSERT INTO @result (line) VALUES
        ('<div class="table_wrapper"><table class="objects">'),
        ('<tr><th class="name">' + @word_function + '</th><th class="description">' + @word_description + '</th></tr>');

    OPEN function_cursor
    FETCH NEXT FROM function_cursor
    INTO
        @ROUTINE_SCHEMA
        , @ROUTINE_NAME
        , @DESCRIPTION

    WHILE @@FETCH_STATUS = 0
        BEGIN

        INSERT INTO @result (line) VALUES(+ '<tr><td><a href="#'
            + REPLACE(@ROUTINE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@ROUTINE_NAME) + '">'
            + @ROUTINE_SCHEMA + '.' + @ROUTINE_NAME + '</a></td><td>' + COALESCE(@DESCRIPTION, '') + '</td></tr>')

        FETCH NEXT FROM function_cursor
        INTO
            @ROUTINE_SCHEMA
            , @ROUTINE_NAME
            , @DESCRIPTION
        END

    CLOSE function_cursor
    DEALLOCATE function_cursor

    INSERT INTO @result (line) VALUES
        ('</table></div>'),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'functions'
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    -- Details

    DECLARE function_parameter_cursor CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
       SELECT
            r.ROUTINE_SCHEMA
            , r.ROUTINE_NAME
            , CASE WHEN p.ORDINAL_POSITION = 0 THEN 'Result' ELSE p.PARAMETER_NAME END AS PARAMETER_NAME
            , CASE
                WHEN RIGHT(p.DATA_TYPE, 4) = 'char' AND p.CHARACTER_MAXIMUM_LENGTH = -1 THEN p.DATA_TYPE + '(max)'
                WHEN RIGHT(p.DATA_TYPE, 4) = 'char' THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('binary', 'varbinary') THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('decimal', 'numeric') THEN p.DATA_TYPE + '(' + CAST(p.NUMERIC_PRECISION AS varchar) + ',' +  CAST(p.NUMERIC_SCALE AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN p.DATA_TYPE + '(' + CAST(p.DATETIME_PRECISION AS varchar) + ')'
                ELSE p.DATA_TYPE END AS DATA_TYPE
            , p.PARAMETER_MODE
            , trc.DESCRIPTION
            , tr.DESCRIPTION AS TABLE_DESCRIPTION
            , tr.COMMENT AS TABLE_COMMENT
            , p.ORDINAL_POSITION
            , 1 AS SECTION
        FROM
            INFORMATION_SCHEMA.ROUTINES r
            LEFT OUTER JOIN INFORMATION_SCHEMA.PARAMETERS p ON p.SPECIFIC_SCHEMA = r.SPECIFIC_SCHEMA AND p.SPECIFIC_NAME = r.SPECIFIC_NAME

            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = r.ROUTINE_SCHEMA AND tr.TABLE_NAME = r.ROUTINE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language

            LEFT OUTER JOIN doc.help trc
                ON trc.TABLE_SCHEMA = r.ROUTINE_SCHEMA AND trc.TABLE_NAME = r.ROUTINE_NAME
                    AND trc.COLUMN_NAME = CASE WHEN p.ORDINAL_POSITION = 0 THEN 'Result' ELSE p.PARAMETER_NAME END
                    AND trc.LANGUAGE_NAME = @language
        WHERE
            r.ROUTINE_SCHEMA LIKE COALESCE(@schema, r.ROUTINE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT r.ROUTINE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND r.ROUTINE_TYPE = 'FUNCTION'
            AND NOT r.ROUTINE_NAME LIKE 'fn_%'
            AND r.ROUTINE_NAME LIKE @include_names
            AND NOT r.ROUTINE_NAME LIKE @exclude_names
        UNION ALL
        SELECT
            p.TABLE_SCHEMA AS ROUTINE_SCHEMA
            , p.TABLE_NAME AS ROUTINE_NAME
            , p.COLUMN_NAME AS PARAMETER_NAME
            , CASE
                WHEN RIGHT(p.DATA_TYPE, 4) = 'char' AND p.CHARACTER_MAXIMUM_LENGTH = -1 THEN p.DATA_TYPE + '(max)'
                WHEN RIGHT(p.DATA_TYPE, 4) = 'char' THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('binary', 'varbinary') THEN p.DATA_TYPE + '(' + CAST(p.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('decimal', 'numeric') THEN p.DATA_TYPE + '(' + CAST(p.NUMERIC_PRECISION AS varchar) + ',' +  CAST(p.NUMERIC_SCALE AS varchar) + ')'
                WHEN p.DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time') THEN p.DATA_TYPE + '(' + CAST(p.DATETIME_PRECISION AS varchar) + ')'
                ELSE p.DATA_TYPE END AS DATA_TYPE
            , NULL AS PARAMETER_MODE
            , trc.DESCRIPTION
            , tr.DESCRIPTION AS TABLE_DESCRIPTION
            , tr.COMMENT AS TABLE_COMMENT
            , p.ORDINAL_POSITION
            , 2 AS SECTION
        FROM
            INFORMATION_SCHEMA.ROUTINE_COLUMNS p
            LEFT OUTER JOIN doc.help tr
                ON tr.TABLE_SCHEMA = p.TABLE_SCHEMA AND tr.TABLE_NAME = p.TABLE_NAME AND tr.COLUMN_NAME IS NULL AND tr.LANGUAGE_NAME = @language
            LEFT OUTER JOIN doc.help trc
                ON trc.TABLE_SCHEMA = p.TABLE_SCHEMA AND trc.TABLE_NAME = p.TABLE_NAME AND trc.COLUMN_NAME = p.COLUMN_NAME AND trc.LANGUAGE_NAME = @language
        WHERE
            p.TABLE_SCHEMA LIKE COALESCE(@schema, p.TABLE_SCHEMA)
            AND p.TABLE_NAME LIKE @include_names
            AND NOT p.TABLE_NAME LIKE @exclude_names
        ORDER BY
            ROUTINE_SCHEMA
            , ROUTINE_NAME
            , SECTION
            , ORDINAL_POSITION

    SET @PREV_SCHEMA = ''
    SET @PREV_NAME = ''
    SET @PREV_COMMENT = ''
    SET @PREV_SECTION = 1
    SET @HAS_PARAMETERS = 0

    OPEN function_parameter_cursor
    FETCH NEXT FROM function_parameter_cursor
    INTO
        @ROUTINE_SCHEMA
        , @ROUTINE_NAME
        , @PARAMETER_NAME
        , @DATA_TYPE
        , @PARAMETER_MODE
        , @DESCRIPTION
        , @TABLE_DESCRIPTION
        , @TABLE_COMMENT
        , @ORDINAL_POSITION
        , @SECTION

    WHILE @@FETCH_STATUS = 0
        BEGIN

        IF @PREV_SCHEMA <> @ROUTINE_SCHEMA OR @PREV_NAME <> @ROUTINE_NAME
            BEGIN
            IF @HAS_PARAMETERS = 1 OR @PREV_SECTION = 2
                BEGIN
                INSERT INTO @result (line) VALUES
                    ('</table></div>'),
                    ('');
                END

            INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)

            SET @PREV_SCHEMA = @ROUTINE_SCHEMA
            SET @PREV_NAME = @ROUTINE_NAME
            SET @PREV_COMMENT = @TABLE_COMMENT
            SET @PREV_SECTION = @SECTION

            SET @HAS_PARAMETERS = CASE WHEN @PARAMETER_NAME IS NULL THEN 0 ELSE 1 END

            INSERT INTO @result (line) VALUES
                (@h3o + ' id="'
                    + REPLACE(@ROUTINE_SCHEMA, ' ', '') + '.' + doc.get_escaped_parameter_name(@ROUTINE_NAME)
                    + '">' + @ROUTINE_SCHEMA + '.' + @ROUTINE_NAME + @h3c),
                ('');

            IF @TABLE_DESCRIPTION IS NOT NULL
            INSERT INTO @result (line) VALUES
                ('<p>' + COALESCE(REPLACE(REPLACE(@TABLE_DESCRIPTION, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf);

            IF @HAS_PARAMETERS = 1
                BEGIN
                INSERT INTO @result (line) VALUES
                    ('<div class="table_wrapper"><table class="parameters">'),
                    ('<tr><th class="parameter">' + @word_parameter + '</th><th class="datatype">' + @word_datatype + '</th><th class="comment">' + @word_comment + '</th></tr>');
                END
            END

        IF NOT @PREV_SECTION = @SECTION
            BEGIN

            IF @HAS_PARAMETERS = 1
                INSERT INTO @result (line) VALUES
                    ('</table></div>'),
                    ('');

            INSERT INTO @result (line) VALUES
                ('<div class="table_wrapper"><table class="function_fields">'),
                ('<tr><th class="parameter">' + @word_column + '</th><th class="datatype">' + @word_datatype + '</th><th class="comment">' + @word_comment + '</th></tr>');

            SET @PREV_SECTION = @SECTION
            END

        IF @HAS_PARAMETERS = 1 OR @SECTION = 2
            INSERT INTO @result (line) VALUES('<tr><td>' + COALESCE(@PARAMETER_NAME, 'Result') + '</td>'
                + '<td>' + COALESCE(@DATA_TYPE, '') + '</td>'
                + '<td>' + COALESCE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@DESCRIPTION, '&', '&amp;'), '"', '&quot;'), '''', '&#39;'), '<', '&lt;'), '>', '&gt;'), @lf, @crlf + '<br>'), '') + '</td>'
                + '</tr>')

        FETCH NEXT FROM function_parameter_cursor
        INTO
            @ROUTINE_SCHEMA
            , @ROUTINE_NAME
            , @PARAMETER_NAME
            , @DATA_TYPE
            , @PARAMETER_MODE
            , @DESCRIPTION
            , @TABLE_DESCRIPTION
            , @TABLE_COMMENT
            , @ORDINAL_POSITION
            , @SECTION
        END

    CLOSE function_parameter_cursor
    DEALLOCATE function_parameter_cursor

    IF @HAS_PARAMETERS = 1 OR @PREV_SECTION = 2
        BEGIN
        INSERT INTO @result (line) VALUES
            ('</table></div>'),
            ('');
        END

    INSERT INTO @result (line) VALUES('<p>' + COALESCE(REPLACE(REPLACE(@PREV_COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf)

    END

END

BEGIN -- CONCLUSION --

IF @has_conclusion = 1 AND @part IN (0, 1, 17)
    BEGIN

    INSERT INTO @result (line) VALUES
        (@h2o + ' id="conclusion">' + @header_prefix + @word_conclusion + @header_suffix + @h2c),
        ('');

    -- Pages

    SELECT @pages = (
        SELECT
            CASE WHEN t.DESCRIPTION IS NOT NULL THEN @h3o ELSE '<p' END
            + ' id="page.' + REPLACE(t.TABLE_SCHEMA, ' ', '_') + '.' + t.TABLE_NAME + '">'
            + CASE WHEN t.DESCRIPTION IS NOT NULL THEN t.DESCRIPTION + @h3c + @crlf + '<p>' ELSE '' END
            + COALESCE(REPLACE(REPLACE(t.COMMENT, @lf, @crlf + '<br>'), @crlf + '<br>' + @crlf + '<br>', '</p>' + @crlf + @crlf + '<p>'), '') + '</p>' + @crlf
        FROM
            doc.help t
        WHERE
            t.TABLE_SCHEMA LIKE COALESCE(@schema, t.TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT t.TABLE_SCHEMA IN ('xls', 'doc', 'logs', 'savetodb_dev', 'savetodb_xls', 'etl01', 'dbo01', 'xls01', 'etl02', 'dbo02', 'xls02', 'etl03', 'dbo03', 'xls03'))
            AND t.COMMENT IS NOT NULL
            AND t.LANGUAGE_NAME = @language
            AND t.SECTION_ID = 5
            AND t.TABLE_NAME = 'conclusion'
            AND NOT t.TABLE_SCHEMA IN ('sys')
            AND NOT t.TABLE_SCHEMA IN (
                SELECT TABLE_SCHEMA FROM doc.help WHERE TABLE_NAME = 'disabled' AND COMMENT IS NOT NULL AND NOT TABLE_SCHEMA = COALESCE(@schema, '')
            )
        ORDER BY
            t.TABLE_SCHEMA
            , t.TABLE_NAME
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)')

    INSERT INTO @result (line) VALUES (@pages)

    END

END

BEGIN -- BOTTOM CONTENTS --

IF (NOT @part IN (0) AND @bottom_toc = 1)
    BEGIN
    INSERT INTO @result (line) VALUES
        (@h2o + '>' + @word_contents + @h2c),
        (''),
        ('<ul class="contents">');

    IF @has_introduction = 1    INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#introduction">'+ @word_introduction   + '</a></li>')
    IF @has_history = 1         INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#history">'     + @word_change_history + '</a></li>')
    IF @has_diagrams = 1        INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#diagrams">'    + @word_diagrams       + '</a></li>')
    IF @has_roles = 1           INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#roles">'       + @word_roles          + '</a></li>')
    IF @has_schemas = 1         INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#schemas">'     + @word_schemas        + '</a></li>')
    IF @has_tables = 1          INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#tables">'      + @word_tables         + '</a></li>')
    IF @has_views = 1           INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#views">'       + @word_views          + '</a></li>')
    IF @has_procedures = 1      INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#procedures">'  + @word_procedures     + '</a></li>')
    IF @has_functions = 1       INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#functions">'   + @word_functions      + '</a></li>')
    IF @has_conclusion = 1      INSERT INTO @result (line) VALUES ('<li><a href="' + @contents_url + '#conclusion">'  + @word_conclusion     + '</a></li>')

    INSERT INTO @result (line) VALUES
        ('</ul>'),
        ('');
    END
END

BEGIN -- FINISH --

    IF @content_only = 0
        BEGIN

        INSERT INTO @result (line) VALUES
            ('</div>'),
            ('');

        INSERT INTO @result (line) VALUES
            ('<div id="t"><a href="#" title="' + @word_backtotop + '"><i>^</i></a></div>'),
            (''),
            ('</body>'),
            ('</html>');

        END

    -- SELECT * FROM @result

    DECLARE @html nvarchar(max) = ''

    SELECT @html = (
        SELECT CAST(line AS nvarchar(max)) + @crlf FROM @result ORDER BY id
            FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)'
        )

    SELECT @html

END

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The procedure refreshes modules
-- =============================================

CREATE PROCEDURE [doc].[xl_actions_refresh_modules]
AS
BEGIN

DECLARE @sql nvarchar(max)

DECLARE refresh_cursor CURSOR FOR
    SELECT
        'EXEC sys.sp_refreshsqlmodule '''
            + QUOTENAME(s.name) + '.' + QUOTENAME(REPLACE(o.name, '''', '''''')) + '''' AS command
    FROM
        sys.sql_modules m
        INNER JOIN sys.objects o ON o.[object_id] = m.[object_id]
        INNER JOIN sys.schemas s ON s.[schema_id] = o.[schema_id]
    WHERE
        o.is_ms_shipped = 0
        AND NOT (s.name = 'dbo' AND (o.name LIKE 'sp_%' OR o.name LIKE 'fn_%' OR o.name LIKE 'sys%'))
    ORDER BY
        o.[type]
        , s.name
        , o.name

OPEN refresh_cursor

FETCH NEXT FROM refresh_cursor INTO @sql
WHILE @@FETCH_STATUS = 0
    BEGIN
    -- PRINT @sql
    EXEC sys.sp_executesql @sql
    FETCH NEXT FROM refresh_cursor INTO @sql
    END

CLOSE refresh_cursor

DEALLOCATE refresh_cursor

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The procedure sets permissions of the application roles
-- =============================================

CREATE PROCEDURE [doc].[xl_actions_set_role_permissions]
AS
BEGIN

SET NOCOUNT ON

GRANT SELECT  ON doc.view_diagrams              TO doc_readers;
GRANT SELECT  ON doc.view_history               TO doc_readers;
GRANT SELECT  ON doc.view_objects               TO doc_readers;
GRANT SELECT  ON doc.view_orphan_rows           TO doc_readers;
GRANT SELECT  ON doc.view_query_list            TO doc_readers;
GRANT SELECT  ON doc.view_routine_columns       TO doc_readers;
GRANT SELECT  ON doc.view_routine_parameters    TO doc_readers;
GRANT SELECT  ON doc.view_table_columns         TO doc_readers;
GRANT SELECT  ON doc.view_view_columns          TO doc_readers;
GRANT SELECT  ON doc.view_online_help_handlers  TO doc_readers;

GRANT EXECUTE ON doc.xl_actions_database_documentation        TO doc_readers;
GRANT EXECUTE ON doc.xl_validation_list_history_section_id    TO doc_readers;

GRANT SELECT, EXECUTE, INSERT, UPDATE, DELETE, VIEW DEFINITION ON SCHEMA::doc TO doc_writers;

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Deletes the column help row
-- =============================================

CREATE PROCEDURE [doc].[xl_delete_help_column]
    @TABLE_SCHEMA nvarchar(128) = NULL
    , @TABLE_NAME nvarchar(128) = NULL
    , @COLUMN_NAME nvarchar(255) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
AS
BEGIN

DELETE FROM doc.help
WHERE
    SECTION_ID = 1
    AND TABLE_SCHEMA = @TABLE_SCHEMA
    AND TABLE_NAME = @TABLE_NAME
    AND COLUMN_NAME = COALESCE(@COLUMN_NAME, '')
    AND LANGUAGE_NAME = @LANGUAGE_NAME

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Deletes the table help row
-- =============================================

CREATE PROCEDURE [doc].[xl_delete_help_object]
    @SECTION_ID tinyint = NULL
    , @TABLE_SCHEMA nvarchar(128) = NULL
    , @TABLE_NAME nvarchar(128) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
AS
BEGIN

DELETE FROM doc.help
WHERE
    SECTION_ID = @SECTION_ID
    AND TABLE_SCHEMA = @TABLE_SCHEMA
    AND TABLE_NAME = @TABLE_NAME
    AND COLUMN_NAME IS NULL
    AND LANGUAGE_NAME = @LANGUAGE_NAME

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Deletes the routine parameter help row
-- =============================================

CREATE PROCEDURE [doc].[xl_delete_help_parameter]
    @ROUTINE_SCHEMA nvarchar(128) = NULL
    , @ROUTINE_NAME nvarchar(128) = NULL
    , @PARAMETER_NAME nvarchar(255) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
AS
BEGIN

DELETE FROM doc.help
WHERE
    SECTION_ID = 1
    AND TABLE_SCHEMA = @ROUTINE_SCHEMA
    AND TABLE_NAME = @ROUTINE_NAME
    AND COLUMN_NAME = COALESCE(@PARAMETER_NAME, '')
    AND LANGUAGE_NAME = @LANGUAGE_NAME

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Deletes help row
-- =============================================

CREATE PROCEDURE [doc].[xl_delete_help_row]
    @ID INT = NULL
AS
BEGIN

DELETE FROM doc.help
WHERE
    ID = @ID

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Exports Database Help Framework data
-- =============================================

CREATE PROCEDURE [doc].[xl_export_help]
    @language varchar(10) = 'en'
    , @schema nvarchar(128) = NULL
    , @version nvarchar(50) = NULL
AS
BEGIN

SET NOCOUNT ON;

DECLARE @app_schema_only bit = 0

IF @schema = 'x'
    BEGIN
    SET @schema = NULL
    SET @app_schema_only = 1
    END

SELECT
    t.command
FROM
    (
SELECT
    1 AS section, ID,
    'EXEC doc.xl_import_help '
           + CASE WHEN SECTION_ID                IS NULL THEN 'NULL' ELSE CAST(SECTION_ID AS nvarchar(128)) END
    + ', ' + CASE WHEN TABLE_SCHEMA              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_SCHEMA, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_NAME                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN COLUMN_NAME               IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(COLUMN_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN LANGUAGE_NAME             IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(LANGUAGE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN VERSION                   IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(VERSION, '''', '''''') + '''' END
    + ', ' + CASE WHEN DESCRIPTION               IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(DESCRIPTION, '''', '''''') + '''' END
    + ', ' + CASE WHEN COMMENT                   IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(COMMENT, '''', '''''') + '''' END
    + ';' AS command
FROM
    doc.help
WHERE
    LANGUAGE_NAME = COALESCE(@language, LANGUAGE_NAME)
    AND COALESCE(VERSION, '') = COALESCE(@version, VERSION, '')
    AND (
        (TABLE_SCHEMA LIKE COALESCE(@schema, TABLE_SCHEMA)
            AND (@app_schema_only = 0 OR NOT TABLE_SCHEMA IN ('xls', 'doc', 'logs'))
        )
        OR (TABLE_SCHEMA = 'schemas'
            AND TABLE_NAME LIKE COALESCE(@schema, TABLE_NAME)
            AND (@app_schema_only = 0 OR NOT TABLE_NAME IN ('xls', 'doc', 'logs'))
        )
        OR TABLE_SCHEMA = 'roles' AND TABLE_NAME IN
            (
                SELECT
                    r.name
                FROM
                    sys.database_permissions p
                    INNER JOIN sys.database_principals r ON r.principal_id = p.grantee_principal_id
                    INNER JOIN sys.objects o ON o.[object_id] = p.major_id
                    INNER JOIN sys.schemas s ON s.[schema_id] = o.[schema_id]
                WHERE
                    p.class = 1
                    AND r.is_fixed_role = 0
                    AND NOT r.sid IS NULL
                    AND r.[type] = 'R'
                    AND NOT r.name IN ('dbo', 'guest', 'public')
                    AND s.name LIKE COALESCE(@schema, s.name)
                    AND (@app_schema_only = 0 OR NOT r.name IN (
                        'xls_users', 'xls_developers', 'xls_formats', 'xls_admins',
                        'doc_readers', 'doc_writers',
                        'log_app', 'log_admins', 'log_users'))
                UNION
                SELECT
                    r.name
                FROM
                    sys.database_permissions p
                    INNER JOIN sys.database_principals r ON r.principal_id = p.grantee_principal_id
                    INNER JOIN sys.schemas s ON s.[schema_id] = p.major_id
                WHERE
                    p.class = 3
                    AND r.is_fixed_role = 0
                    AND NOT r.sid IS NULL
                    AND r.[type] = 'R'
                    AND NOT r.name IN ('dbo', 'guest', 'public')
                    AND s.name LIKE COALESCE(@schema, s.name)
                    AND (@app_schema_only = 0 OR NOT r.name IN (
                        'xls_users', 'xls_developers', 'xls_formats', 'xls_admins',
                        'doc_readers', 'doc_writers',
                        'log_app', 'log_admins', 'log_users'))
            )
        )

UNION ALL SELECT 2 AS section, -1 AS ID, '' AS command

UNION ALL
SELECT
    2 AS section, ID,
    'EXEC doc.xl_import_history '
           + CASE WHEN TABLE_SCHEMA              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_SCHEMA, '''', '''''') + '''' END
    + ', ' + CASE WHEN LANGUAGE_NAME             IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(LANGUAGE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN VERSION                   IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(VERSION, '''', '''''') + '''' END
    + ', ' + CASE WHEN SECTION_ID                IS NULL THEN 'NULL' ELSE CAST(SECTION_ID AS nvarchar(128))  END
    + ', ' + CASE WHEN SORT_ORDER                IS NULL THEN 'NULL' ELSE CAST(SORT_ORDER AS nvarchar(128))  END
    + ', ' + CASE WHEN DESCRIPTION               IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(DESCRIPTION, '''', '''''') + '''' END
    + ', ' + CASE WHEN COMMENT                   IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(COMMENT, '''', '''''') + '''' END
    + ';' AS command
FROM
    doc.history
WHERE
    TABLE_SCHEMA LIKE COALESCE(@schema, TABLE_SCHEMA)
    AND LANGUAGE_NAME = COALESCE(@language, LANGUAGE_NAME)
    AND (@app_schema_only = 0 OR NOT TABLE_SCHEMA IN ('xls', 'doc', 'logs'))
    AND COALESCE(VERSION, '') = COALESCE(@version, VERSION, '')

    ) t
ORDER BY
    t.section
    , t.ID

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Exports Database Help Framework settings
-- =============================================

CREATE PROCEDURE [doc].[xl_export_settings]
    @part tinyint = NULL
    , @sort_by_names bit = 0
    , @language varchar(10) = NULL
AS
BEGIN

SET NOCOUNT ON;

SELECT
    t.command
FROM
    (
SELECT
    1 AS part
    , CASE WHEN @sort_by_names = 1 THEN ROW_NUMBER() OVER(ORDER BY TABLE_SCHEMA, TABLE_NAME) ELSE ID END AS ID
    , 'INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES ('
            + CASE WHEN TABLE_SCHEMA              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_SCHEMA, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_NAME                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_TYPE                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_TYPE, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_CODE                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_CODE, '''', '''''') + '''' END
    + ', ' + CASE WHEN INSERT_OBJECT             IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(INSERT_OBJECT, '''', '''''') + '''' END
    + ', ' + CASE WHEN UPDATE_OBJECT             IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(UPDATE_OBJECT, '''', '''''') + '''' END
    + ', ' + CASE WHEN DELETE_OBJECT             IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(DELETE_OBJECT, '''', '''''') + '''' END
    + ');' AS command
FROM
    doc.objects

UNION ALL SELECT 2 AS part, -1 AS ID, '' AS command

UNION ALL
SELECT
    2 AS part
    , CASE WHEN @sort_by_names = 1 THEN ROW_NUMBER() OVER(ORDER BY TABLE_SCHEMA, TABLE_NAME, EVENT_NAME, CASE WHEN COLUMN_NAME IS NULL THEN 0 ELSE 1 END, COLUMN_NAME, HANDLER_SCHEMA, HANDLER_NAME, MENU_ORDER) ELSE ID END AS ID
    , 'INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES ('
           + CASE WHEN TABLE_SCHEMA              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_SCHEMA, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_NAME                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN COLUMN_NAME               IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(COLUMN_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN EVENT_NAME                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(EVENT_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN HANDLER_SCHEMA            IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(HANDLER_SCHEMA, '''', '''''') + '''' END
    + ', ' + CASE WHEN HANDLER_NAME              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(HANDLER_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN HANDLER_TYPE              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(HANDLER_TYPE, '''', '''''') + '''' END
    + ', ' + CASE WHEN HANDLER_CODE              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(HANDLER_CODE, '''', '''''') + '''' END
    + ', ' + CASE WHEN TARGET_WORKSHEET          IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TARGET_WORKSHEET, '''', '''''') + '''' END
    + ', ' + CASE WHEN MENU_ORDER                IS NULL THEN 'NULL' ELSE CAST(MENU_ORDER AS nvarchar(128))  END
    + ', ' + CASE WHEN EDIT_PARAMETERS           IS NULL THEN 'NULL' ELSE CAST(EDIT_PARAMETERS AS nvarchar(128))  END
    + ');' AS command
FROM
    doc.handlers

UNION ALL SELECT 3 AS part, -1 AS ID, '' AS command

UNION ALL
SELECT
    3 AS part
    , CASE WHEN @sort_by_names = 1 THEN ROW_NUMBER() OVER(ORDER BY LANGUAGE_NAME, CASE WHEN COLUMN_NAME IS NULL THEN 0 ELSE 1 END, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME) ELSE ID END AS ID
    , 'INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES ('
           + CASE WHEN TABLE_SCHEMA              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_SCHEMA, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_NAME                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN COLUMN_NAME               IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(COLUMN_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN LANGUAGE_NAME             IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(LANGUAGE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN TRANSLATED_NAME           IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TRANSLATED_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN TRANSLATED_DESC           IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TRANSLATED_DESC, '''', '''''') + '''' END
    + ', ' + CASE WHEN TRANSLATED_COMMENT        IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TRANSLATED_COMMENT, '''', '''''') + '''' END
    + ');' AS command
FROM
    doc.translations
WHERE
    COALESCE(LANGUAGE_NAME, '') = COALESCE(@language, LANGUAGE_NAME, '')

UNION ALL SELECT 4 AS part, -1 AS ID, '' AS command

UNION ALL
SELECT
    4 AS part
    , CASE WHEN @sort_by_names = 1 THEN ROW_NUMBER() OVER(ORDER BY TABLE_SCHEMA, TABLE_NAME) ELSE ID END AS ID
    , 'INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('
           + CASE WHEN TABLE_SCHEMA              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_SCHEMA, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_NAME                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_EXCEL_FORMAT_XML    IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(CAST(TABLE_EXCEL_FORMAT_XML AS nvarchar(max)), '''', '''''') + '''' END
    + ');' AS command
FROM
    doc.formats

UNION ALL SELECT 5 AS part, -1 AS ID, '' AS command

UNION ALL
SELECT
    5 AS part
    , CASE WHEN @sort_by_names = 1 THEN ROW_NUMBER() OVER(ORDER BY NAME) ELSE ID END AS ID
    , 'INSERT INTO doc.workbooks (NAME, TEMPLATE, DEFINITION, TABLE_SCHEMA) VALUES ('
           + CASE WHEN NAME                      IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(NAME, '''', '''''') + '''' END
    + ', ' + CASE WHEN TEMPLATE                  IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TEMPLATE, '''', '''''') + '''' END
    + ', ' + CASE WHEN DEFINITION                IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(DEFINITION, '''', '''''') + '''' END
    + ', ' + CASE WHEN TABLE_SCHEMA              IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(TABLE_SCHEMA, '''', '''''') + '''' END
    + ');' AS command
FROM
    doc.workbooks

UNION ALL SELECT 6 AS part, -1 AS ID, '' AS command

UNION ALL
SELECT
    6 AS part
    , ID
    , 'INSERT INTO doc.help_sections (ID, SECTION) VALUES ('
           + CASE WHEN ID                        IS NULL THEN 'NULL' ELSE CAST(ID AS nvarchar(128))  END
    + ', ' + CASE WHEN SECTION                   IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(SECTION, '''', '''''') + '''' END
    + ');' AS command
FROM
    doc.help_sections

UNION ALL SELECT 7 AS part, -1 AS ID, '' AS command

UNION ALL
SELECT
    7 AS part
    , ID
    , 'INSERT INTO doc.history_sections (ID, SECTION) VALUES ('
           + CASE WHEN ID                        IS NULL THEN 'NULL' ELSE CAST(ID AS nvarchar(128))  END
    + ', ' + CASE WHEN SECTION                   IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(SECTION, '''', '''''') + '''' END
    + ');' AS command
FROM
    doc.history_sections

UNION ALL SELECT 8 AS part, -1 AS ID, '' AS command

    ) t
WHERE
    t.part = COALESCE(@part, t.part)
    AND (@part IS NULL OR NOT t.command = '')
ORDER BY
    t.part
    , t.ID

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Imports a help row
-- =============================================

CREATE PROCEDURE [doc].[xl_import_help]
    @SECTION_ID tinyint = NULL
    , @TABLE_SCHEMA nvarchar(128) = NULL
    , @TABLE_NAME nvarchar(128) = NULL
    , @COLUMN_NAME nvarchar(255) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @DESCRIPTION nvarchar(1024) = NULL
    , @COMMENT nvarchar(max) = NULL
AS
BEGIN

SET NOCOUNT ON

IF @LANGUAGE_NAME IS NULL
    BEGIN
    DECLARE @message nvarchar(max)

    SET @message = 'LANGUAGE_NAME IS NULL'

    RAISERROR (@message, 11, 0)
    RETURN
    END

IF @TABLE_SCHEMA IS NULL OR @TABLE_NAME IS NULL OR @LANGUAGE_NAME IS NULL
    RETURN

IF @VERSION IS NULL AND @DESCRIPTION IS NULL AND @COMMENT IS NULL
    BEGIN
    DELETE FROM doc.help
    WHERE
        SECTION_ID = @SECTION_ID
        AND TABLE_SCHEMA = @TABLE_SCHEMA
        AND TABLE_NAME = @TABLE_NAME
        AND COALESCE(COLUMN_NAME, '') = COALESCE(@COLUMN_NAME, '')
        AND LANGUAGE_NAME = @LANGUAGE_NAME
    RETURN
    END

UPDATE doc.help
SET
    VERSION = @VERSION
    , DESCRIPTION = @DESCRIPTION
    , COMMENT = @COMMENT
WHERE
    SECTION_ID = @SECTION_ID
    AND TABLE_SCHEMA = @TABLE_SCHEMA
    AND TABLE_NAME = @TABLE_NAME
    AND COALESCE(COLUMN_NAME, '') = COALESCE(@COLUMN_NAME, '')
    AND LANGUAGE_NAME = @LANGUAGE_NAME

IF @@ROWCOUNT = 0
    BEGIN
    INSERT INTO doc.help
        (SECTION_ID, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, VERSION, DESCRIPTION, COMMENT)
    VALUES
        (@SECTION_ID, @TABLE_SCHEMA, @TABLE_NAME, @COLUMN_NAME, @LANGUAGE_NAME, @VERSION, @DESCRIPTION, @COMMENT)
    END

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Imports a help history row
-- =============================================

CREATE PROCEDURE [doc].[xl_import_history]
    @TABLE_SCHEMA nvarchar(20) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @SECTION_ID tinyint = NULL
    , @SORT_ORDER tinyint = NULL
    , @DESCRIPTION nvarchar(1024) = NULL
    , @COMMENT nvarchar = NULL
AS
BEGIN

SET NOCOUNT ON

UPDATE doc.history
SET
    DESCRIPTION = @DESCRIPTION
    , COMMENT = @COMMENT
WHERE
    TABLE_SCHEMA = @TABLE_SCHEMA
    AND LANGUAGE_NAME = @LANGUAGE_NAME
    AND [VERSION] = @VERSION
    AND SECTION_ID = @SECTION_ID
    AND SORT_ORDER = @SORT_ORDER

IF @@ROWCOUNT = 0
    INSERT INTO doc.history
        ( TABLE_SCHEMA, LANGUAGE_NAME, [VERSION], SECTION_ID, SORT_ORDER, DESCRIPTION, COMMENT )
    VALUES
        ( @TABLE_SCHEMA, @LANGUAGE_NAME, @VERSION, @SECTION_ID, @SORT_ORDER, @DESCRIPTION, @COMMENT)

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Inserts diagram help
-- =============================================

CREATE PROCEDURE [doc].[xl_insert_help_diagram]
    @DIAGRAM_SCHEMA nvarchar(128) = NULL
    , @DIAGRAM_NAME nvarchar(128) = NULL
    , @DIAGRAM_URL nvarchar(255) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @TITLE nvarchar(1024) = NULL
    , @COMMENT nvarchar(max) = NULL
AS
BEGIN

INSERT INTO doc.help
    (SECTION_ID, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, VERSION, DESCRIPTION, COMMENT)
VALUES
    (4, @DIAGRAM_SCHEMA, @DIAGRAM_NAME, @DIAGRAM_URL, @LANGUAGE_NAME, @VERSION, @TITLE, @COMMENT)

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Updates a column help row
-- =============================================

CREATE PROCEDURE [doc].[xl_update_help_column]
    @TABLE_SCHEMA nvarchar(128) = NULL
    , @TABLE_NAME nvarchar(128) = NULL
    , @COLUMN_NAME nvarchar(255) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @DESCRIPTION nvarchar(1024) = NULL
    , @COMMENT nvarchar(max) = NULL
AS
BEGIN

EXEC doc.xl_import_help 1, @TABLE_SCHEMA, @TABLE_NAME, @COLUMN_NAME, @LANGUAGE_NAME, @VERSION, @DESCRIPTION, @COMMENT

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Updates diagram help
-- =============================================

CREATE PROCEDURE [doc].[xl_update_help_diagram]
    @ID int = NULL
    , @DIAGRAM_SCHEMA nvarchar(128) = NULL
    , @DIAGRAM_NAME nvarchar(128) = NULL
    , @DIAGRAM_URL nvarchar(255) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @TITLE nvarchar(1024) = NULL
    , @COMMENT nvarchar(max) = NULL
AS
BEGIN

UPDATE doc.help
SET
    SECTION_ID = 4
    , TABLE_SCHEMA = @DIAGRAM_SCHEMA
    , TABLE_NAME = @DIAGRAM_NAME
    , COLUMN_NAME = @DIAGRAM_URL
    , LANGUAGE_NAME = @LANGUAGE_NAME
    , VERSION = @VERSION
    , DESCRIPTION = @TITLE
    , COMMENT = @COMMENT
WHERE
    ID = @ID

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Updates an object help row
-- =============================================

CREATE PROCEDURE [doc].[xl_update_help_object]
    @SECTION_ID tinyint = NULL
    , @TABLE_SCHEMA nvarchar(128) = NULL
    , @TABLE_NAME nvarchar(128) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @DESCRIPTION nvarchar(1024) = NULL
    , @COMMENT nvarchar(max) = NULL
AS
BEGIN

EXEC doc.xl_import_help @SECTION_ID, @TABLE_SCHEMA, @TABLE_NAME, NULL, @LANGUAGE_NAME, @VERSION, @DESCRIPTION, @COMMENT

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Updates a page help row
-- =============================================

CREATE PROCEDURE [doc].[xl_update_help_page]
    @TABLE_SCHEMA nvarchar(128) = NULL
    , @TABLE_NAME nvarchar(128) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @DESCRIPTION nvarchar(1024) = NULL
    , @COMMENT nvarchar(max) = NULL
AS
BEGIN

EXEC doc.xl_import_help 5, @TABLE_SCHEMA, @TABLE_NAME, NULL, @LANGUAGE_NAME, @VERSION, @DESCRIPTION, @COMMENT

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: Updates a parameter help row
-- =============================================

CREATE PROCEDURE [doc].[xl_update_help_parameter]
    @ROUTINE_SCHEMA nvarchar(128) = NULL
    , @ROUTINE_NAME nvarchar(128) = NULL
    , @PARAMETER_NAME nvarchar(255) = NULL
    , @LANGUAGE_NAME varchar(10) = NULL
    , @VERSION nvarchar(50) = NULL
    , @DESCRIPTION nvarchar(1024) = NULL
    , @COMMENT nvarchar(max) = NULL
AS
BEGIN

EXEC doc.xl_import_help 1, @ROUTINE_SCHEMA, @ROUTINE_NAME, @PARAMETER_NAME, @LANGUAGE_NAME, @VERSION, @DESCRIPTION, @COMMENT

END


GO

-- =============================================
-- Author:      Gartle LLC
-- Release:     3.0, 2022-07-05
-- Description: The procedure selects a validation list of history sections
--
-- @data_language is the predefined SaveToDB parameter
-- that gives the Data Language value of SaveToDB Options.
-- =============================================

CREATE PROCEDURE [doc].[xl_validation_list_history_section_id]
    @data_language varchar(10) = NULL
AS
BEGIN

SET NOCOUNT ON

SELECT
    s.ID
    , COALESCE(s.SECTION, tr.TRANSLATED_NAME) AS SECTION
FROM
    doc.history_sections s

    LEFT OUTER JOIN doc.translations tr ON tr.TABLE_SCHEMA = 'doc' AND tr.TABLE_NAME = 'history_sections'
        AND tr.COLUMN_NAME = s.SECTION AND tr.LANGUAGE_NAME = @data_language
ORDER BY
    s.ID

END


GO

INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_objects', N'VIEW', NULL, N'doc.xl_update_help_object', N'doc.xl_update_help_object', N'doc.xl_delete_help_object');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_table_columns', N'VIEW', NULL, N'doc.xl_update_help_column', N'doc.xl_update_help_column', N'doc.xl_delete_help_column');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_view_columns', N'VIEW', NULL, N'doc.xl_update_help_column', N'doc.xl_update_help_column', N'doc.xl_delete_help_column');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_routine_parameters', N'VIEW', NULL, N'doc.xl_update_help_parameter', N'doc.xl_update_help_parameter', N'doc.xl_delete_help_parameter');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_routine_columns', N'VIEW', NULL, N'doc.xl_update_help_column', N'doc.xl_update_help_column', N'doc.xl_delete_help_column');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_diagrams', N'VIEW', NULL, N'doc.xl_insert_help_diagram', N'doc.xl_update_help_diagram', N'doc.xl_delete_help_row');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_history', N'VIEW', NULL, N'doc.history', N'doc.history', N'doc.history');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_pages', N'VIEW', NULL, N'doc.xl_update_help_page', N'doc.xl_update_help_page', N'doc.xl_delete_help_column');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_orphan_rows', N'VIEW', NULL, N'doc.help', N'doc.help', N'doc.help');
INSERT INTO doc.objects (TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_CODE, INSERT_OBJECT, UPDATE_OBJECT, DELETE_OBJECT) VALUES (N'doc', N'view_properties', N'VIEW', NULL, N'doc.xl_update_help_object', N'doc.xl_update_help_object', N'doc.xl_delete_help_object');

INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_history', N'SECTION_ID', N'ValidationList', N'doc', N'xl_validation_list_history_section_id', N'PROCEDURE', NULL, NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_diagrams', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_history', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_objects', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_routine_columns', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_routine_parameters', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_table_columns', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_view_columns', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_pages', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_orphan_rows', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'usp_translations', N'field', N'ParameterValues', NULL, NULL, N'VALUES', N'TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'objects', N'TABLE_TYPE', N'ValidationList', NULL, NULL, N'VALUES', N'TABLE, VIEW, PROCEDURE, FUNCTION, CODE, HTTP, TEXT, HIDDEN', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'handlers', N'EVENT_NAME', N'ValidationList', NULL, NULL, N'VALUES', N'Actions, AddHyperlinks, AddStateColumn, BitColumn, Change, ContextMenu, ConvertFormulas, DataTypeBit, DataTypeBoolean, DataTypeDate, DataTypeDateTime, DataTypeDateTimeOffset, DataTypeDouble, DataTypeInt, DataTypeGuid, DataTypeString, DataTypeTime, DataTypeTimeSpan, DefaultListObject, DefaultValue, DependsOn, DoNotAddChangeHandler, DoNotAddDependsOn, DoNotAddManyToMany, DoNotAddValidation, DoNotChange, DoNotConvertFormulas, DoNotKeepComments, DoNotKeepFormulas, DoNotSave, DoNotSelect, DoNotSort, DoNotTranslate, DoubleClick, DynamicColumns, Format, Formula, FormulaValue, Information, JsonForm, KeepFormulas, KeepComments, License, ManyToMany, ParameterValues, ProtectRows, RegEx, SelectionChange, SelectionList, SelectPeriod, SyncParameter, UpdateChangedCellsOnly, UpdateEntireRow, ValidationList', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'handlers', N'HANDLER_TYPE', N'ValidationList', NULL, NULL, N'VALUES', N'TABLE, VIEW, PROCEDURE, FUNCTION, CODE, HTTP, TEXT, MACRO, CMD, VALUES, RANGE, REFRESH, MENUSEPARATOR, PDF, REPORT, SHOWSHEETS, HIDESHEETS, SELECTSHEET, ATTRIBUTE', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'handlers', N'HANDLER_CODE', N'DoNotConvertFormulas', NULL, NULL, N'ATTRIBUTE', NULL, NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_properties', NULL, N'Actions', N'doc', N'xl_actions_database_documentation', N'PROCEDURE', NULL, NULL, 11, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_index', N'object', N'AddHyperlinks', NULL, NULL, N'ATTRIBUTE', NULL, NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'xl_actions_database_documentation', NULL, N'RegEx', NULL, NULL, N'ATTRIBUTE', N'''( |td>|<br>|<p>)(https?://[^ \r\n]*[A-Za-z_1-9\/])([ \r\n\.])''     , ''$1<a href="$2" class="external">$2</a>$3''

''( |td>|<br>|<p>)((dbo[1-9]*|xls[1-9]*|doc|logs)\.[A-Za-z_1-9]+)''   , ''$1<a href="#$2">$2</a>''

''( )(dbo[1-9]*|xls[1-9]*|doc|logs)([ \r\n])''                        , ''$1<a href="#schema.$2">$2</a>$3''

''( )(xls_users|xls_developers|xls_formats|xls_admins|doc_readers|doc_writers|log_admins|log_users)'' , ''$1<a href="#role.$2">$2</a>''
''( )(planning_app_admins|planning_app_analysts|planning_app_developers|planning_app_users)''         , ''$1<a href="#role.$2">$2</a>''

''("#)(xls\.queries)"''                               , ''"https://www.savetodb.com/help/savetodb-framework-views.htm#$2"''
''("#)(xls\.view_[a-z_1-9]+)"''                       , ''"https://www.savetodb.com/help/savetodb-framework-views.htm#$2"''
''("#)(xls\.(usp|xl_)[a-z_1-9]+)"''                   , ''"https://www.savetodb.com/help/savetodb-framework-procedures.htm#$2"''
''("#)(xls\.get_[a-z_1-9]+)"''                        , ''"https://www.savetodb.com/help/savetodb-framework-functions.htm#$2"''
''("#)(xls\.[a-z_1-9]+)"''                            , ''"https://www.savetodb.com/help/savetodb-framework-tables.htm#$2"''
''("#)(doc\.view_[a-z_1-9]+)"''                       , ''"https://www.savetodb.com/help/database-help-framework-views.htm#$2"''
''("#)(doc\.(usp|xl)_[a-z_1-9]+)"''                   , ''"https://www.savetodb.com/help/database-help-framework-procedures.htm#$2"''
''("#)(doc\.get_[a-z_1-9]+)"''                        , ''"https://www.savetodb.com/help/database-help-framework-functions.htm#$2"''
''("#)(doc\.[a-z_1-9]+)"''                            , ''"https://www.savetodb.com/help/database-help-framework-tables.htm#$2"''
''("#)(logs\.view_[a-z_1-9]+)"''                      , ''"https://www.savetodb.com/help/change-tracking-framework-views.htm#$2"''
''("#)(logs\.(usp|xl)_[a-z_1-9]+)"''                  , ''"https://www.savetodb.com/help/change-tracking-framework-procedures.htm#$2"''
''("#)(logs\.get_[a-z_1-9]+)"''                       , ''"https://www.savetodb.com/help/change-tracking-framework-functions.htm#$2"''
''("#)(logs\.[a-z_1-9]+)"''                           , ''"https://www.savetodb.com/help/change-tracking-framework-tables.htm#$2"''

''("#)(schema\.xls|role\.xls_[a-z]+)"''               , ''"https://www.savetodb.com/help/savetodb-framework.htm#$2"''
''("#)(schema\.doc|role\.doc_[a-z]+)"''               , ''"https://www.savetodb.com/help/database-help-framework.htm#$2"''
''("#)(schema\.logs|role\.logs_[a-z]+)"''             , ''"https://www.savetodb.com/help/change-tracking-framework.htm#$2"''

''\*\*([A-Za-z1-9_ ]+)\*\*''                                  , ''<b>$1</b>''

''<p>#### *([^ \r\n]*)( *)([^ \r\n]*)( *)([^\r\n]*?)</p>''    , ''<h4 id="$1$3"><a name="$1$3"></a>$1$2$3$4$5</h4>''
''<p>### *([^ \r\n]*)( *)([^ \r\n]*)( *)([^\r\n]*?)</p>''     , ''<h3 id="$1$3"><a name="$1$3"></a>$1$2$3$4$5</h3>''

''<p>```(\r\n)<br>''                                          , ''<p><code>$1''
''<br>```(\r\n<br>)*</p>''                                    , ''</code></p>''

''(<p>)*!\[(.*)\]\(([A-Za-z_\-1-9\\/:\.]*\.(png|jpg|gif))\)(</p>)*'', ''<img src="$3" title="$2" alt="$2" />''

''\[([^\]\r\n]*)\]\((https?://[^ \)\r\n]*)\)''                , ''<a href="$2" class="external">$1</a>''
', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'database_help_framework', N'version', N'Information', NULL, NULL, N'ATTRIBUTE', N'3.2', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'handlers', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'hzpKpSwDsxsNFhhE3tDwoDTfBHXygOZgVSjxbjaLECfdrcbUgEoQNiPOHSuP/8++FRTcYQ6WlRmRU0LVgQSlP4o6vJv7P9vU8gehdR14vIE+7h5xbUoj+TF4fC1cp26NDGB+Xs+EvOvDfoQO7A8eBKA0I/pDKHe5EAWlBb6tDP0=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'objects', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'PIhoZkzqJDDP0bAPmAZQV2w2cgwr2EnO1LhzswBSANY2nm4HONnuBBrM21Va7V+R4gO11FkooDJk7+CFG2r1eT2c9JyR02HRbmiv2st7bePs+KObZgSOX+BTCp1bWH8OvLkQbuLCISfFjAa/LbQFY0UyMN/obCrYwNvFM/yyfHE=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'translations', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'waSLzMxsUz9v1jiAozXbVGWdgGQWgdbiSun5XTU9odw9Iy8Y+vKTKk/xHJ0mD9YbKZ+u88JHw3xO5zHcyWea+McWk7bFafUqVskzdh2A6E24OFoE6lnXcSblyQ2XUp5078Kblo9MxCUmi4XE2E93Rip/zihzRz93JOfB03kFfZs=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'usp_translations', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'G1MBvK5SyiC0wBQ6K5Z01+zpmGNaN+MRUronmfy6KY1yb/f8kjJ+rACLrOUgchWFdJFPialUlvsQMzYHpBx3pn5ZxvEu6hovpVDvxvu5J7E5b+siv/NY3PBrgY2Vm17xx4JXVLgZ+uNRscRsuHrKgGcsMpx8WVvQqQFEc3Toys4=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_diagrams', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'JXvspOLCk4iQUbFbA8lMzpXKC+STRw4UqmHCEJZDu/mtrsPPB7SzCZYDq2/U6MPOIgxa17cAeq5NlHWsvzxfItvzbAZQLBvZD5M9yBxWSyZcBq4l74JmNIQMjVnJwT/u+aS6AwrkvKqGvY3tJ9g/c0ZbIGVibKpR6aYfN/HZWIw=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_history', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'YPqzzivWGp+JRyNiR0FPs30jJ9OP0BWg/UAC8CWYtZZAIAKsNy0y34K775U1wezMJUS3TPSN62VzV5LhoqclclOAtynTGN75ox880WFjlmMQtN9hUbHUfYqNUKDL2e2cVrN1q0+3iGoGbux3PjDpGtb+yM8h93uqwxMDuZCQCOQ=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_objects', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'oaWzKiHdea+GWOE9uXQuJA15bresIGI+Wq9KZnQkk7+UJqQcPrK3Rcf5Sns5t20Bke0gja92xk3QR/RJMxZNH7Pmjku9qfgWAeJVU7nF1cNHLCtol/H/A0SOd+ZExDhtCAdWvp+a6H5HnZfARW0ryI+zQjHMVpZKByGi98WMva4=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_orphan_rows', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'f2NtK7RGsYYpS6fNFyoIAb4Ueq2VRWz3IdwqyALzVBuHVsu+ocotxivZJQh2QS4hF01BLfnBMM1QxCf/GrQQ7DhP2j6HIrgw4Qv8ZAGywtRDbEmWy7GnDP875mGWjstg82QctBAALhyfVbbsCjHiyET/Pp/zMYD0xFzI7dzHGNw=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_pages', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'WMR0hiAqplkv//ESDKH2YnqrGwHOCPxDo1et1UytKDK7A6uLjCGvWBYUwZVmjEzq6JMC1B6U/qE62j6C3FuaQEMvbcL7sQb9+Rji7Y6M5GCupCpWI3tNTHoAiSadNVuLAltTusQDufEBBXTagz0MKHu0YyPCQI/6wIG1hX/HKj0=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_properties', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'pTZqKRbdv5Uz+WNSm+6907fdzb+dmQc4buxNufPIpvvFfVzwDFo1umy77HFmzoKJLQzgTiWDEp/VUWa5Xot3wXCq361Ab5tEhz2cWfoSRprciTHj36bSeWJHfshVbAmKgarOVwZOHYL71o/bvikGuLm9WG7lFy/UQ8AtG4qRmiA=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_routine_columns', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'QuuWZ/gF4uJqzICBJsLiljv+5xPEcevxg9Pf4lwGRE7YDq65GzSth/qs5TB06VtVzmNdY9w4BxKRv+XUAASlpzyp85PZuJ6jbmTFhmYZuOc8E6j7ov4i0Q1mcUk+44SgnUJ7n6Fjb4wy4sR/ds5mKoZvryKxikw7QQjB6u4Jr5A=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_routine_parameters', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'RV/i09H3q6p7neLs5RLy0nEKt54qEBj5YREOBo6IojnC3KEGsWg+iFgNUIGM8qWlcrGhgM7j1JlP/K/j98DiN2Msm+IzPFc6CgnHCPYHBpjaZSr+lnqx1+Ij87EhYZIMXVrm79OkMRtl9H1xk1+12SsXV9gcTGKen9svKxzqEG4=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_table_columns', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'ptw26G4Nj3czTKRKnmJF4+LIrkEZabWHNDkYFt2y01pA25FwEjJdpKrPN9sixWlzGJvzoaoKT8cr16puIfGLQM638viJbwuZOzIKXvFj7lEUh2Ore3SRMTy28jYvJfbBtkdnFWkHY9OD1Q1OCW3kdr3YJJqTYKq7h495dT4jwdI=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_translations', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'eQWLnLHQ58kIWG9jrdI2EnG8J+lAnPCWZScN1q/opiJhMT9z2PEOdMG4c5NO+MSlJhuPtd6NHxULJkKuka9fq1v5TRDJJXmS92p57W+rLx/T4qAFwYtMd3ChX7s49ExdBvIzLEESoOdxDggh8i5kG7X/qpYrP96JdDdwvthtuQI=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'view_view_columns', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'k/DbnKVLxUIDF+vMrADHkc95yJwBqyJrZLm7pyRIzesy1SFKbiu6NVE6h9AEpA+JCFD8QeceYPeII9vd2yl29s8vDBUOJiCnv0jnviAamyYCvbZhe6SeaeQ5ZJJY4IkjLGDl8mGyK43SoUyCw+zpEpZHEsXDBmhRdFfbuG7gK90=', NULL, NULL, NULL);
INSERT INTO doc.handlers (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_SCHEMA, HANDLER_NAME, HANDLER_TYPE, HANDLER_CODE, TARGET_WORKSHEET, MENU_ORDER, EDIT_PARAMETERS) VALUES (N'doc', N'workbooks', NULL, N'License', NULL, NULL, N'ATTRIBUTE', N'WYkTqExVwds45WVWlX9dTWNCPT6l4Xtcl4eNElky6eR73pwF3h6C1wy+qwgkk2rDm8r03CAPA2oLhSVnwyBo2LtOArdiK3GFiksiAHN5jpC8jTzcTJ8JknhyPSAGi8T6ZRFvUyiAPkItkaUWDmsLaCh1hqqGear97kba3BTFeXM=', NULL, NULL, NULL);

INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COLUMN_NAME', N'en', N'Column Name', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COMMENT', N'en', N'Comment', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATA_TYPE', N'en', N'Data Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_OBJECT', N'en', N'Delete Object', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_PROCEDURE', N'en', N'Delete Procedure', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DESCRIPTION', N'en', N'Description', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_NAME', N'en', N'Name', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_SCHEMA', N'en', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_URL', N'en', N'URL', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EDIT_PARAMETERS', N'en', N'Edit Parameters', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EVENT_NAME', N'en', N'Event Name', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_CODE', N'en', N'Handler Code', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_NAME', N'en', N'Handler Name', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_SCHEMA', N'en', N'Handler Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_TYPE', N'en', N'Handler Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ID', N'en', N'ID', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_OBJECT', N'en', N'Insert Object', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_PROCEDURE', N'en', N'Insert Procedure', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_IDENTITY', N'en', N'Is Identity', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_NULLABLE', N'en', N'Is Nullable', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_PK', N'en', N'Is Primary Key', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE', N'en', N'Language', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE_NAME', N'en', N'Language', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'MENU_ORDER', N'en', N'Menu Order', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ORDINAL_POSITION', N'en', N'Ordinal Position', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_MODE', N'en', N'Mode', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_NAME', N'en', N'Parameter', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PROCEDURE_TYPE', N'en', N'Procedure Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'REFERENTIAL_COLUMN', N'en', N'Referential Column', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_NAME', N'en', N'Name', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_SCHEMA', N'en', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SCHEMA', N'en', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION', N'en', N'Section', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_ID', N'en', N'Section', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SORT_ORDER', N'en', N'Sort Order', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_CODE', N'en', N'Table Code', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_EXCEL_FORMAT_XML', N'en', N'Table Excel Format XML', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_NAME', N'en', N'Name', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_SCHEMA', N'en', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_TYPE', N'en', N'Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TARGET_WORKSHEET', N'en', N'Target Worksheet', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_COMMENT', N'en', N'Comment', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_DESC', N'en', N'Description', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_NAME', N'en', N'Translated Name', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TYPE', N'en', N'Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_OBJECT', N'en', N'Update Object', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_PROCEDURE', N'en', N'Update Procedure', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'VERSION', N'en', N'Version', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATE', N'en', N'Date', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TITLE', N'en', N'Title', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Version Title', N'en', N'Version Title', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Announcements', N'en', N'Announcements', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'New Features', N'en', N'New Features', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Improvements', N'en', N'Impovements', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Bug Fixes', N'en', N'Bug Fixes', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Contents', N'en', N'Contents', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Introduction', N'en', N'Introduction', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Conclusion', N'en', N'Conclusion', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'History', N'en', N'History', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Change History', N'en', N'Change History', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagrams', N'en', N'Diagrams', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Roles', N'en', N'Roles', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schemas', N'en', N'Schemas', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Tables', N'en', N'Tables', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Views', N'en', N'Views', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedures', N'en', N'Procedures', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Functions', N'en', N'Functions', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Triggers', N'en', N'Triggers', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagram', N'en', N'Diagram', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Role', N'en', N'Role', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schema', N'en', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Table', N'en', N'Table', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'View', N'en', N'View', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedure', N'en', N'Procedure', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Function', N'en', N'Function', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Trigger', N'en', N'Trigger', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Description', N'en', N'Description', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Column', N'en', N'Column', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Parameter', N'en', N'Parameter', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'DataType', N'en', N'DataType', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Null', N'en', N'Null', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'PK', N'en', N'PK', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Identity', N'en', N'Identity', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Key', N'en', N'Key', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Mode', N'en', N'Mode', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Type', N'en', N'Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Comment', N'en', N'Comment', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Values', N'en', N'Values', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Source tables', N'en', N'Source tables', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Back to top', N'en', N'Back to top', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COLUMN_NAME', N'fr', N'Nom de colonne', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COMMENT', N'fr', N'Commentaire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATA_TYPE', N'fr', N'Type de données', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_OBJECT', N'fr', N'Objet de suppression', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_PROCEDURE', N'fr', N'Procédure de suppression', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DESCRIPTION', N'fr', N'Description', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_NAME', N'fr', N'Prénom', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_SCHEMA', N'fr', N'Schéma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_URL', N'fr', N'URL', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EDIT_PARAMETERS', N'fr', N'Paramètres de demande', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EVENT_NAME', N'fr', N'Nom de l''événement', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_CODE', N'fr', N'Code du conducteur', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_NAME', N'fr', N'Nom du gestionnaire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_SCHEMA', N'fr', N'Schéma du gestionnaire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_TYPE', N'fr', N'Type de manipulateur', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ID', N'fr', N'ID', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_OBJECT', N'fr', N'Objet d''insertion', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_PROCEDURE', N'fr', N'Procédure d''insertion', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_IDENTITY', N'fr', N'Est l''identité', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_NULLABLE', N'fr', N'Est Nullable', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_PK', N'fr', N'Est la clé primaire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE', N'fr', N'Langue', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE_NAME', N'fr', N'Langue', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'MENU_ORDER', N'fr', N'Commander dans le menu', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ORDINAL_POSITION', N'fr', N'Position ordinale', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_MODE', N'fr', N'Mode', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_NAME', N'fr', N'Paramètre', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PROCEDURE_TYPE', N'fr', N'Type de procédure', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'REFERENTIAL_COLUMN', N'fr', N'Colonne référentielle', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_NAME', N'fr', N'Prénom', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_SCHEMA', N'fr', N'Schéma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SCHEMA', N'fr', N'Schéma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION', N'fr', N'Section', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_ID', N'fr', N'Section', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SORT_ORDER', N'fr', N'Ordre de tri', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_CODE', N'fr', N'Code de table', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_EXCEL_FORMAT_XML', N'fr', N'Tableau Excel Format XML', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_NAME', N'fr', N'Prénom', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_SCHEMA', N'fr', N'Schéma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_TYPE', N'fr', N'Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TARGET_WORKSHEET', N'fr', N'Feuille de travail cible', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_COMMENT', N'fr', N'Commentaire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_DESC', N'fr', N'La description', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_NAME', N'fr', N'Nom Traduit', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TYPE', N'fr', N'Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_OBJECT', N'fr', N'Objet de mise à jour', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_PROCEDURE', N'fr', N'Procédure de mise à jour', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'VERSION', N'fr', N'Version', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATE', N'fr', N'Date', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TITLE', N'fr', N'Titre', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Version Title', N'fr', N'Titre de la version', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Announcements', N'fr', N'Annonces', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'New Features', N'fr', N'Nouvelles fonctionnalités', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Improvements', N'fr', N'Améliorations', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Bug Fixes', N'fr', N'Correction de bugs', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Contents', N'fr', N'Contenu', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Introduction', N'fr', N'Introduction', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Conclusion', N'fr', N'Conclusion', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'History', N'fr', N'Histoire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Change History', N'fr', N'Histoire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagrams', N'fr', N'Diagrammes', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Roles', N'fr', N'Rôles', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schemas', N'fr', N'Schémas', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Tables', N'fr', N'Tables', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Views', N'fr', N'Vues', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedures', N'fr', N'Procédures', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Functions', N'fr', N'Fonctions', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Triggers', N'fr', N'Déclencheurs', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagram', N'fr', N'Diagramme', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Role', N'fr', N'Rôle', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schema', N'fr', N'Schéma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Table', N'fr', N'Table', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'View', N'fr', N'Vue', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedure', N'fr', N'Procédure', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Function', N'fr', N'Fonction', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Trigger', N'fr', N'Déclencheur', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Description', N'fr', N'Description', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Column', N'fr', N'Colonne', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Parameter', N'fr', N'Paramètre', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'DataType', N'fr', N'Type de données', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Null', N'fr', N'Nul', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'PK', N'fr', N'PK', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Identity', N'fr', N'Identité', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Key', N'fr', N'Clé', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Mode', N'fr', N'Mode', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Type', N'fr', N'Type', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Comment', N'fr', N'Commentaire', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Values', N'fr', N'Valeurs', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Source tables', N'fr', N'Tables source', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Back to top', N'fr', N'En haut', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COLUMN_NAME', N'it', N'Nome colonna', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COMMENT', N'it', N'Commento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATA_TYPE', N'it', N'Tipo di dati', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_OBJECT', N'it', N'Oggetto da rimuovere', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_PROCEDURE', N'it', N'procedura da rimuovere', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DESCRIPTION', N'it', N'Descrizione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_NAME', N'it', N'Nome', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_SCHEMA', N'it', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_URL', N'it', N'URL', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EDIT_PARAMETERS', N'it', N'Richiedi i parametri', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EVENT_NAME', N'it', N'Nome dell''evento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_CODE', N'it', N'Codice del gestore', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_NAME', N'it', N'Nome del gestore', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_SCHEMA', N'it', N'Schema del gestore', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_TYPE', N'it', N'Tipo di gestore', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ID', N'it', N'ID', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_OBJECT', N'it', N'Oggetto di inserimento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_PROCEDURE', N'it', N'Procedura di inserimento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_IDENTITY', N'it', N'Identità', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_NULLABLE', N'it', N'È Nullable', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_PK', N'it', N'È la chiave primaria', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE', N'it', N'Linguaggio', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE_NAME', N'it', N'Linguaggio', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'MENU_ORDER', N'it', N'Ordine nel menu', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ORDINAL_POSITION', N'it', N'Posizione ordinale', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_MODE', N'it', N'Modalità', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_NAME', N'it', N'Parametro', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PROCEDURE_TYPE', N'it', N'Tipo di procedura', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'REFERENTIAL_COLUMN', N'it', N'Colonna referenziale', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_NAME', N'it', N'Nome', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_SCHEMA', N'it', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SCHEMA', N'it', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION', N'it', N'Sezione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_ID', N'it', N'Sezione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SORT_ORDER', N'it', N'Ordinamento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_CODE', N'it', N'Codice tabella', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_EXCEL_FORMAT_XML', N'it', N'Tabella Excel Formato XML', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_NAME', N'it', N'Nome', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_SCHEMA', N'it', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_TYPE', N'it', N'Tipo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TARGET_WORKSHEET', N'it', N'Foglio di lavoro di destinazione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_COMMENT', N'it', N'Commento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_DESC', N'it', N'Descrizione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_NAME', N'it', N'Nome tradotto', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TYPE', N'it', N'Tipo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_OBJECT', N'it', N'Oggetto di aggiornamento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_PROCEDURE', N'it', N'Procedura di aggiornamento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'VERSION', N'it', N'Versione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATE', N'it', N'Data', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TITLE', N'it', N'Titolo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Version Title', N'it', N'Titolo della versione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Announcements', N'it', N'Annunci', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'New Features', N'it', N'Nuove caratteristiche', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Improvements', N'it', N'Miglioramenti', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Bug Fixes', N'it', N'Correzioni di bug', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Contents', N'it', N'Contenuto', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Introduction', N'it', N'Introduzione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Conclusion', N'it', N'Conclusione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'History', N'it', N'Storia', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Change History', N'it', N'Storia', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagrams', N'it', N'Diagrammi', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Roles', N'it', N'Ruoli', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schemas', N'it', N'Schemi', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Tables', N'it', N'Tabelle', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Views', N'it', N'Viste', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedures', N'it', N'Procedure', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Functions', N'it', N'Funzioni', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Triggers', N'it', N'Trigger', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagram', N'it', N'Diagramma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Role', N'it', N'Ruolo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schema', N'it', N'Schema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Table', N'it', N'Tabella', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'View', N'it', N'Vista', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedure', N'it', N'Procedura', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Function', N'it', N'Funzione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Trigger', N'it', N'Trigger', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Description', N'it', N'Descrizione', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Column', N'it', N'Colonna', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Parameter', N'it', N'Parametro', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'DataType', N'it', N'Tipo di dati', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Null', N'it', N'Nullo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'PK', N'it', N'PK', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Identity', N'it', N'Identità', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Key', N'it', N'Chiave', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Mode', N'it', N'Modalità', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Type', N'it', N'Tipo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Comment', N'it', N'Commento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Values', N'it', N'Valori', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Source tables', N'it', N'Tabelle di origine', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Back to top', N'it', N'In cima', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COLUMN_NAME', N'es', N'Nombre de columna', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COMMENT', N'es', N'Comentario', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATA_TYPE', N'es', N'Tipo de datos', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_OBJECT', N'es', N'Objeto de eliminación', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_PROCEDURE', N'es', N'Procedimiento de eliminación', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DESCRIPTION', N'es', N'Descripción', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_NAME', N'es', N'Nombre', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_SCHEMA', N'es', N'Esquema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_URL', N'es', N'URL', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EDIT_PARAMETERS', N'es', N'Parámetros de solicitud', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EVENT_NAME', N'es', N'Nombre del evento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_CODE', N'es', N'Código de manejador', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_NAME', N'es', N'Nombre del manejador', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_SCHEMA', N'es', N'Esquema del manejador', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_TYPE', N'es', N'Tipo de controlador', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ID', N'es', N'ID', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_OBJECT', N'es', N'Objeto de inserción', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_PROCEDURE', N'es', N'Procedimiento de inserción', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_IDENTITY', N'es', N'Es identidad', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_NULLABLE', N'es', N'Es nulable', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_PK', N'es', N'Es clave principal', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE', N'es', N'Idioma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE_NAME', N'es', N'Idioma', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'MENU_ORDER', N'es', N'Ordenar en el menú', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ORDINAL_POSITION', N'es', N'Posición ordinal', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_MODE', N'es', N'Modo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_NAME', N'es', N'Parámetro', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PROCEDURE_TYPE', N'es', N'Tipo de procedimiento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'REFERENTIAL_COLUMN', N'es', N'Columna referencial', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_NAME', N'es', N'Nombre', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_SCHEMA', N'es', N'Esquema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SCHEMA', N'es', N'Esquema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION', N'es', N'Sección', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_ID', N'es', N'Sección', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SORT_ORDER', N'es', N'Orden de clasificación', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_CODE', N'es', N'Código de tabla', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_EXCEL_FORMAT_XML', N'es', N'Tabla Excel Formato XML', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_NAME', N'es', N'Nombre', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_SCHEMA', N'es', N'Esquema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_TYPE', N'es', N'Tipo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TARGET_WORKSHEET', N'es', N'Hoja de trabajo de destino', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_COMMENT', N'es', N'Comentario', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_DESC', N'es', N'Descripción', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_NAME', N'es', N'Nombre traducido', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TYPE', N'es', N'Tipo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_OBJECT', N'es', N'Objeto de actualización', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_PROCEDURE', N'es', N'Procedimiento de actualización', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'VERSION', N'es', N'Versión', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATE', N'es', N'Fecha', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TITLE', N'es', N'Título', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Version Title', N'es', N'Título de la versión', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Announcements', N'es', N'Anuncios', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'New Features', N'es', N'Nuevas características', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Improvements', N'es', N'Mejoras', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Bug Fixes', N'es', N'Corrección de errores', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Contents', N'es', N'Contenido', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Introduction', N'es', N'Introducción', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Conclusion', N'es', N'Conclusión', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'History', N'es', N'Historia', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Change History', N'es', N'Historia', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagrams', N'es', N'Diagramas', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Roles', N'es', N'Roles', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schemas', N'es', N'Schemas', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Tables', N'es', N'Tablas', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Views', N'es', N'Vistas', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedures', N'es', N'Procedimientos', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Functions', N'es', N'Funciones', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Triggers', N'es', N'Disparadores', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagram', N'es', N'Diagrama', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Role', N'es', N'Rol', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schema', N'es', N'Esquema', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Table', N'es', N'Tabla', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'View', N'es', N'Vista', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedure', N'es', N'Procedimiento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Function', N'es', N'Función', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Trigger', N'es', N'Disparador', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Description', N'es', N'Descripción', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Column', N'es', N'Columna', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Parameter', N'es', N'Parámetro', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'DataType', N'es', N'Tipo de datos', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Null', N'es', N'Nulo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'PK', N'es', N'PK', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Identity', N'es', N'Identidad', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Key', N'es', N'Llave', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Mode', N'es', N'Modo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Type', N'es', N'Tipo', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Comment', N'es', N'Comentario', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Values', N'es', N'Valores', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Source tables', N'es', N'Tablas fuente', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Back to top', N'es', N'Hasta arriba', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COLUMN_NAME', N'ru', N'Наименование колонки', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'COMMENT', N'ru', N'Комментарий', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATA_TYPE', N'ru', N'Тип данных', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_OBJECT', N'ru', N'Процедура удаления', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DELETE_PROCEDURE', N'ru', N'Процедура удаления', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DESCRIPTION', N'ru', N'Описание', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_NAME', N'ru', N'Имя', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_SCHEMA', N'ru', N'Схема', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DIAGRAM_URL', N'ru', N'URL', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EDIT_PARAMETERS', N'ru', N'Запрос параметров', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EVENT_NAME', N'ru', N'Тип события', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_CODE', N'ru', N'Код обработчика', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_NAME', N'ru', N'Имя обработчика', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_SCHEMA', N'ru', N'Схема обработчика', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HANDLER_TYPE', N'ru', N'Тип обработчика', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ID', N'ru', N'ID', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_OBJECT', N'ru', N'Процедура вставки', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'INSERT_PROCEDURE', N'ru', N'Процедура вставки', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_IDENTITY', N'ru', N'IDENTITY', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_NULLABLE', N'ru', N'NULL', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'IS_PK', N'ru', N'Первичный ключ', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE', N'ru', N'Язык', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'LANGUAGE_NAME', N'ru', N'Язык', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'MENU_ORDER', N'ru', N'Порядок в меню', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ORDINAL_POSITION', N'ru', N'Порядковый номер', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_MODE', N'ru', N'Режим', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PARAMETER_NAME', N'ru', N'Параметр', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'PROCEDURE_TYPE', N'ru', N'Тип процедуры', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'REFERENTIAL_COLUMN', N'ru', N'Исходная колонка', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_NAME', N'ru', N'Имя', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'ROUTINE_SCHEMA', N'ru', N'Схема', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SCHEMA', N'ru', N'Схема', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION', N'ru', N'Раздел', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_ID', N'ru', N'Раздел', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SORT_ORDER', N'ru', N'Порядок сортировки', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_CODE', N'ru', N'Код таблицы', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_EXCEL_FORMAT_XML', N'ru', N'Формат таблицы Excel', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_NAME', N'ru', N'Имя', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_SCHEMA', N'ru', N'Схема', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TABLE_TYPE', N'ru', N'Тип', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TARGET_WORKSHEET', N'ru', N'Целевой лист', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_COMMENT', N'ru', N'Комментарий', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_DESC', N'ru', N'Описание', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TRANSLATED_NAME', N'ru', N'Перевод', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TYPE', N'ru', N'Тип', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_OBJECT', N'ru', N'Процедура обновления', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'UPDATE_PROCEDURE', N'ru', N'Процедура обновления', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'VERSION', N'ru', N'Версия', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'DATE', N'ru', N'Дата', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'TITLE', N'ru', N'Заголовок', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Version Title', N'ru', N'Наименование версии', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Announcements', N'ru', N'Объявления', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'New Features', N'ru', N'Новые возможности', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Improvements', N'ru', N'Улучшения', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'history_sections', N'Bug Fixes', N'ru', N'Исправление ошибок', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Contents', N'ru', N'Содержание', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Introduction', N'ru', N'Введение', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Conclusion', N'ru', N'Заключение', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'History', N'ru', N'История', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Change History', N'ru', N'История изменений', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagrams', N'ru', N'Диаграммы', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Roles', N'ru', N'Роли', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schemas', N'ru', N'Схемы', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Tables', N'ru', N'Таблицы', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Views', N'ru', N'Представления', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedures', N'ru', N'Процедуры', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Functions', N'ru', N'Функции', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Triggers', N'ru', N'Триггеры', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Diagram', N'ru', N'Диаграмма', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Role', N'ru', N'Роль', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Schema', N'ru', N'Схема', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Table', N'ru', N'Таблица', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'View', N'ru', N'Представление', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Procedure', N'ru', N'Процедура', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Function', N'ru', N'Функция', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Trigger', N'ru', N'Триггер', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Description', N'ru', N'Описание', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Column', N'ru', N'Колонка', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Parameter', N'ru', N'Параметр', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'DataType', N'ru', N'Тип данных', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Null', N'ru', N'NULL', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'PK', N'ru', N'ПК', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Identity', N'ru', N'IDENTITY', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Key', N'ru', N'Ключ', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Mode', N'ru', N'Режим', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Type', N'ru', N'Тип', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Comment', N'ru', N'Комментарий', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Values', N'ru', N'Значения', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Source tables', N'ru', N'Исходные таблицы', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', N'uspDatabaseDocumentation', N'Back to top', N'ru', N'В начало', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HAS_COMMENTS', N'en', N'Has Comments', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HAS_COMMENTS', N'ru', N'Есть комментарий', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HAS_COMMENTS', N'es', N'Tiene comentarios', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HAS_COMMENTS', N'it', N'Ha commenti', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'HAS_COMMENTS', N'fr', N'A des commentaires', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EXCEL_SORT_ORDER', N'en', N'Excel Sort Order', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_SORT_ORDER', N'en', N'Section Sort Order', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_SORT_ORDER', N'ru', N'Номер секции', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_SORT_ORDER', N'fr', N'Section ordre de tri', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_SORT_ORDER', N'it', N'Sezione ordinamento', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'SECTION_SORT_ORDER', N'es', N'Numero de sección', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EXCEL_SORT_ORDER', N'fr', N'Ordre de tri Excel', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EXCEL_SORT_ORDER', N'it', N'Ordinamento Excel', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EXCEL_SORT_ORDER', N'ru', N'Порядок сортировки в Excel', NULL, NULL);
INSERT INTO doc.translations (TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, LANGUAGE_NAME, TRANSLATED_NAME, TRANSLATED_DESC, TRANSLATED_COMMENT) VALUES (N'doc', NULL, N'EXCEL_SORT_ORDER', N'es', N'Orden de Excel', NULL, NULL);

INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_table_columns', N'<table name="doc.view_table_columns"><columnFormats><column name="" property="ListObjectName" value="view_table_columns" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$C$4" type="String"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="Validation.Type" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Operator" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Formula1" value="-9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.Formula2" value="9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.AlertStyle" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowInput" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="20.14" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ORDINAL_POSITION" property="Address" value="$F$4" type="String"/><column name="ORDINAL_POSITION" property="ColumnWidth" value="2.86" type="Double"/><column name="ORDINAL_POSITION" property="NumberFormat" value="General" type="String"/><column name="ORDINAL_POSITION" property="VerticalAlignment" value="-4160" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Type" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Operator" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ORDINAL_POSITION" property="Validation.Formula2" value="2147483647" type="String"/><column name="ORDINAL_POSITION" property="Validation.AlertStyle" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowError" value="True" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="Address" value="$G$4" type="String"/><column name="COLUMN_NAME" property="ColumnWidth" value="25.57" type="Double"/><column name="COLUMN_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="COLUMN_NAME" property="Validation.Type" value="6" type="Double"/><column name="COLUMN_NAME" property="Validation.Operator" value="8" type="Double"/><column name="COLUMN_NAME" property="Validation.Formula1" value="128" type="String"/><column name="COLUMN_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="COLUMN_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DATA_TYPE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DATA_TYPE" property="Address" value="$H$4" type="String"/><column name="DATA_TYPE" property="ColumnWidth" value="13.43" type="Double"/><column name="DATA_TYPE" property="NumberFormat" value="General" type="String"/><column name="DATA_TYPE" property="VerticalAlignment" value="-4160" type="Double"/><column name="DATA_TYPE" property="Validation.Type" value="6" type="Double"/><column name="DATA_TYPE" property="Validation.Operator" value="8" type="Double"/><column name="DATA_TYPE" property="Validation.Formula1" value="191" type="String"/><column name="DATA_TYPE" property="Validation.AlertStyle" value="1" type="Double"/><column name="DATA_TYPE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowError" value="True" type="Boolean"/><column name="IS_PK" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="IS_PK" property="Address" value="$I$4" type="String"/><column name="IS_PK" property="ColumnWidth" value="2.86" type="Double"/><column name="IS_PK" property="NumberFormat" value="General" type="String"/><column name="IS_PK" property="HorizontalAlignment" value="-4108" type="Double"/><column name="IS_PK" property="VerticalAlignment" value="-4160" type="Double"/><column name="IS_PK" property="Font.Size" value="10" type="Double"/><column name="IS_PK" property="Validation.Type" value="1" type="Double"/><column name="IS_PK" property="Validation.Operator" value="1" type="Double"/><column name="IS_PK" property="Validation.Formula1" value="-2147483648" type="String"/><column name="IS_PK" property="Validation.Formula2" value="2147483647" type="String"/><column name="IS_PK" property="Validation.AlertStyle" value="1" type="Double"/><column name="IS_PK" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="IS_PK" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="IS_PK" property="Validation.ShowInput" value="True" type="Boolean"/><column name="IS_PK" property="Validation.ShowError" value="True" type="Boolean"/><column name="IS_IDENTITY" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="IS_IDENTITY" property="Address" value="$J$4" type="String"/><column name="IS_IDENTITY" property="ColumnWidth" value="2.86" type="Double"/><column name="IS_IDENTITY" property="NumberFormat" value="General" type="String"/><column name="IS_IDENTITY" property="HorizontalAlignment" value="-4108" type="Double"/><column name="IS_IDENTITY" property="VerticalAlignment" value="-4160" type="Double"/><column name="IS_IDENTITY" property="Font.Size" value="10" type="Double"/><column name="IS_IDENTITY" property="Validation.Type" value="1" type="Double"/><column name="IS_IDENTITY" property="Validation.Operator" value="1" type="Double"/><column name="IS_IDENTITY" property="Validation.Formula1" value="-2147483648" type="String"/><column name="IS_IDENTITY" property="Validation.Formula2" value="2147483647" type="String"/><column name="IS_IDENTITY" property="Validation.AlertStyle" value="1" type="Double"/><column name="IS_IDENTITY" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="IS_IDENTITY" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="IS_IDENTITY" property="Validation.ShowInput" value="True" type="Boolean"/><column name="IS_IDENTITY" property="Validation.ShowError" value="True" type="Boolean"/><column name="IS_NULLABLE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="IS_NULLABLE" property="Address" value="$K$4" type="String"/><column name="IS_NULLABLE" property="ColumnWidth" value="2.86" type="Double"/><column name="IS_NULLABLE" property="NumberFormat" value="General" type="String"/><column name="IS_NULLABLE" property="HorizontalAlignment" value="-4108" type="Double"/><column name="IS_NULLABLE" property="VerticalAlignment" value="-4160" type="Double"/><column name="IS_NULLABLE" property="Font.Size" value="10" type="Double"/><column name="IS_NULLABLE" property="Validation.Type" value="1" type="Double"/><column name="IS_NULLABLE" property="Validation.Operator" value="1" type="Double"/><column name="IS_NULLABLE" property="Validation.Formula1" value="-2147483648" type="String"/><column name="IS_NULLABLE" property="Validation.Formula2" value="2147483647" type="String"/><column name="IS_NULLABLE" property="Validation.AlertStyle" value="1" type="Double"/><column name="IS_NULLABLE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="IS_NULLABLE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="IS_NULLABLE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="IS_NULLABLE" property="Validation.ShowError" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Address" value="$L$4" type="String"/><column name="REFERENTIAL_COLUMN" property="ColumnWidth" value="21.86" type="Double"/><column name="REFERENTIAL_COLUMN" property="NumberFormat" value="General" type="String"/><column name="REFERENTIAL_COLUMN" property="VerticalAlignment" value="-4160" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.Type" value="6" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.Operator" value="8" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.Formula1" value="386" type="String"/><column name="REFERENTIAL_COLUMN" property="Validation.AlertStyle" value="1" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Validation.ShowInput" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$M$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$N$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="70.71" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="Validation.Type" value="6" type="Double"/><column name="DESCRIPTION" property="Validation.Operator" value="8" type="Double"/><column name="DESCRIPTION" property="Validation.Formula1" value="1024" type="String"/><column name="DESCRIPTION" property="Validation.AlertStyle" value="1" type="Double"/><column name="DESCRIPTION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowError" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HAS_COMMENTS" property="Address" value="$O$4" type="String"/><column name="HAS_COMMENTS" property="ColumnWidth" value="2.86" type="Double"/><column name="HAS_COMMENTS" property="NumberFormat" value="General" type="String"/><column name="HAS_COMMENTS" property="HorizontalAlignment" value="-4108" type="Double"/><column name="HAS_COMMENTS" property="VerticalAlignment" value="-4160" type="Double"/><column name="HAS_COMMENTS" property="Font.Size" value="10" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).AppliesTo.Address" value="$E$4:$E$289" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Type" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Priority" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Formula1" value="=ISBLANK(E4)" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="IS_PK" property="FormatConditions(1).AppliesTo.Address" value="$I$4:$I$289" type="String"/><column name="IS_PK" property="FormatConditions(1).Type" value="6" type="Double"/><column name="IS_PK" property="FormatConditions(1).Priority" value="301" type="Double"/><column name="IS_PK" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="IS_PK" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="IS_PK" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).AppliesTo.Address" value="$J$4:$J$289" type="String"/><column name="IS_IDENTITY" property="FormatConditions(1).Type" value="6" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).Priority" value="303" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="IS_IDENTITY" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="IS_IDENTITY" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).AppliesTo.Address" value="$K$4:$K$289" type="String"/><column name="IS_NULLABLE" property="FormatConditions(1).Type" value="6" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).Priority" value="305" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="IS_NULLABLE" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="IS_NULLABLE" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).AppliesTo.Address" value="$O$4:$O$289" type="String"/><column name="HAS_COMMENTS" property="FormatConditions(1).Type" value="6" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).Priority" value="307" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="" property="Tab.Color" value="5296274" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_history', N'<table name="doc.view_history"><columnFormats><column name="" property="ListObjectName" value="view_history" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="EXCEL_SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="EXCEL_SORT_ORDER" property="Address" value="$D$4" type="String"/><column name="EXCEL_SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SECTION_SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SECTION_SORT_ORDER" property="Address" value="$E$4" type="String"/><column name="SECTION_SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$F$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="6.57" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="SECTION_ID" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="SECTION_ID" property="Address" value="$G$4" type="String"/><column name="SECTION_ID" property="ColumnWidth" value="15" type="Double"/><column name="SECTION_ID" property="NumberFormat" value="@" type="String"/><column name="SECTION_ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$H$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="VERSION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="VERSION" property="Address" value="$I$4" type="String"/><column name="VERSION" property="ColumnWidth" value="4" type="Double"/><column name="VERSION" property="NumberFormat" value="@" type="String"/><column name="VERSION" property="VerticalAlignment" value="-4160" type="Double"/><column name="VERSION" property="Validation.Type" value="6" type="Double"/><column name="VERSION" property="Validation.Operator" value="8" type="Double"/><column name="VERSION" property="Validation.Formula1" value="50" type="String"/><column name="VERSION" property="Validation.AlertStyle" value="1" type="Double"/><column name="VERSION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="VERSION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="VERSION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="VERSION" property="Validation.ShowError" value="True" type="Boolean"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$J$4" type="String"/><column name="SORT_ORDER" property="ColumnWidth" value="11.71" type="Double"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$K$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="70.71" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="VerticalAlignment" value="-4160" type="Double"/><column name="COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COMMENT" property="Address" value="$L$4" type="String"/><column name="COMMENT" property="ColumnWidth" value="70.71" type="Double"/><column name="COMMENT" property="NumberFormat" value="@" type="String"/><column name="COMMENT" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="FormatConditions(1).AppliesTo.Address" value="$K$4:$K$79" type="String"/><column name="DESCRIPTION" property="FormatConditions(1).Type" value="2" type="Double"/><column name="DESCRIPTION" property="FormatConditions(1).Priority" value="1" type="Double"/><column name="DESCRIPTION" property="FormatConditions(1).Formula1" value="=$E4=1" type="String"/><column name="DESCRIPTION" property="FormatConditions(1).Font.Bold" value="True" type="Boolean"/><column name="SortFields(1)" property="KeyfieldName" value="EXCEL_SORT_ORDER" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="" property="Tab.Color" value="10498160" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_pages', N'<table name="doc.view_pages"><columnFormats><column name="" property="ListObjectName" value="view_pages" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$C$4" type="String"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="31.29" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$F$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="VERSION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="VERSION" property="Address" value="$G$4" type="String"/><column name="VERSION" property="ColumnWidth" value="3.57" type="Double"/><column name="VERSION" property="NumberFormat" value="General" type="String"/><column name="VERSION" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$H$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="42.14" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="VerticalAlignment" value="-4160" type="Double"/><column name="COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COMMENT" property="Address" value="$I$4" type="String"/><column name="COMMENT" property="ColumnWidth" value="113.57" type="Double"/><column name="COMMENT" property="NumberFormat" value="@" type="String"/><column name="COMMENT" property="VerticalAlignment" value="-4160" type="Double"/><column name="" property="Tab.Color" value="5287936" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_diagrams', N'<table name="doc.view_diagrams"><columnFormats><column name="" property="ListObjectName" value="view_diagrams" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="DIAGRAM_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DIAGRAM_SCHEMA" property="Address" value="$D$4" type="String"/><column name="DIAGRAM_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="DIAGRAM_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="DIAGRAM_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="DIAGRAM_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="DIAGRAM_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="DIAGRAM_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="DIAGRAM_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="DIAGRAM_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DIAGRAM_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DIAGRAM_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DIAGRAM_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="DIAGRAM_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DIAGRAM_NAME" property="Address" value="$E$4" type="String"/><column name="DIAGRAM_NAME" property="ColumnWidth" value="13.57" type="Double"/><column name="DIAGRAM_NAME" property="NumberFormat" value="General" type="String"/><column name="DIAGRAM_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="DIAGRAM_NAME" property="Validation.Type" value="6" type="Double"/><column name="DIAGRAM_NAME" property="Validation.Operator" value="8" type="Double"/><column name="DIAGRAM_NAME" property="Validation.Formula1" value="128" type="String"/><column name="DIAGRAM_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="DIAGRAM_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DIAGRAM_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DIAGRAM_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DIAGRAM_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DIAGRAM_URL" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DIAGRAM_URL" property="Address" value="$F$4" type="String"/><column name="DIAGRAM_URL" property="ColumnWidth" value="25.14" type="Double"/><column name="DIAGRAM_URL" property="NumberFormat" value="General" type="String"/><column name="DIAGRAM_URL" property="VerticalAlignment" value="-4160" type="Double"/><column name="DIAGRAM_URL" property="Validation.Type" value="6" type="Double"/><column name="DIAGRAM_URL" property="Validation.Operator" value="8" type="Double"/><column name="DIAGRAM_URL" property="Validation.Formula1" value="255" type="String"/><column name="DIAGRAM_URL" property="Validation.AlertStyle" value="1" type="Double"/><column name="DIAGRAM_URL" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DIAGRAM_URL" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DIAGRAM_URL" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DIAGRAM_URL" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$G$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="VERSION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="VERSION" property="Address" value="$H$4" type="String"/><column name="VERSION" property="ColumnWidth" value="3.57" type="Double"/><column name="VERSION" property="NumberFormat" value="@" type="String"/><column name="VERSION" property="VerticalAlignment" value="-4160" type="Double"/><column name="VERSION" property="Validation.Type" value="6" type="Double"/><column name="VERSION" property="Validation.Operator" value="8" type="Double"/><column name="VERSION" property="Validation.Formula1" value="50" type="String"/><column name="VERSION" property="Validation.AlertStyle" value="1" type="Double"/><column name="VERSION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="VERSION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="VERSION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="VERSION" property="Validation.ShowError" value="True" type="Boolean"/><column name="TITLE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TITLE" property="Address" value="$I$4" type="String"/><column name="TITLE" property="ColumnWidth" value="44.86" type="Double"/><column name="TITLE" property="NumberFormat" value="@" type="String"/><column name="TITLE" property="VerticalAlignment" value="-4160" type="Double"/><column name="COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COMMENT" property="Address" value="$J$4" type="String"/><column name="COMMENT" property="ColumnWidth" value="70.71" type="Double"/><column name="COMMENT" property="NumberFormat" value="@" type="String"/><column name="COMMENT" property="VerticalAlignment" value="-4160" type="Double"/><column name="" property="Tab.Color" value="5287936" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_objects', N'<table name="doc.view_objects"><columnFormats><column name="" property="ListObjectName" value="view_objects" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$C$4" type="String"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="SECTION_ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SECTION_ID" property="Address" value="$D$4" type="String"/><column name="SECTION_ID" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$E$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$F$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="51.43" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="TYPE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TYPE" property="Address" value="$G$4" type="String"/><column name="TYPE" property="ColumnWidth" value="9.43" type="Double"/><column name="TYPE" property="NumberFormat" value="General" type="String"/><column name="TYPE" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$H$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="VERSION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="VERSION" property="Address" value="$I$4" type="String"/><column name="VERSION" property="ColumnWidth" value="4" type="Double"/><column name="VERSION" property="NumberFormat" value="@" type="String"/><column name="VERSION" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$J$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="70.71" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="VerticalAlignment" value="-4160" type="Double"/><column name="COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COMMENT" property="Address" value="$K$4" type="String"/><column name="COMMENT" property="ColumnWidth" value="70.71" type="Double"/><column name="COMMENT" property="NumberFormat" value="@" type="String"/><column name="COMMENT" property="VerticalAlignment" value="-4160" type="Double"/><column name="HAS_COMMENTS" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HAS_COMMENTS" property="Address" value="$L$4" type="String"/><column name="HAS_COMMENTS" property="ColumnWidth" value="2.86" type="Double"/><column name="HAS_COMMENTS" property="NumberFormat" value="General" type="String"/><column name="HAS_COMMENTS" property="HorizontalAlignment" value="-4108" type="Double"/><column name="HAS_COMMENTS" property="VerticalAlignment" value="-4160" type="Double"/><column name="HAS_COMMENTS" property="Font.Size" value="10" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).AppliesTo.Address" value="$L$4:$L$306" type="String"/><column name="HAS_COMMENTS" property="FormatConditions(1).Type" value="6" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).Priority" value="298" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="" property="Tab.Color" value="5287936" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_view_columns', N'<table name="doc.view_view_columns"><columnFormats><column name="" property="ListObjectName" value="view_view_columns" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$C$4" type="String"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="Validation.Type" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Operator" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Formula1" value="-9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.Formula2" value="9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.AlertStyle" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowInput" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="28.14" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ORDINAL_POSITION" property="Address" value="$F$4" type="String"/><column name="ORDINAL_POSITION" property="ColumnWidth" value="2.86" type="Double"/><column name="ORDINAL_POSITION" property="NumberFormat" value="General" type="String"/><column name="ORDINAL_POSITION" property="VerticalAlignment" value="-4160" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Type" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Operator" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ORDINAL_POSITION" property="Validation.Formula2" value="2147483647" type="String"/><column name="ORDINAL_POSITION" property="Validation.AlertStyle" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowError" value="True" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="Address" value="$G$4" type="String"/><column name="COLUMN_NAME" property="ColumnWidth" value="25.57" type="Double"/><column name="COLUMN_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="COLUMN_NAME" property="Validation.Type" value="6" type="Double"/><column name="COLUMN_NAME" property="Validation.Operator" value="8" type="Double"/><column name="COLUMN_NAME" property="Validation.Formula1" value="128" type="String"/><column name="COLUMN_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="COLUMN_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DATA_TYPE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DATA_TYPE" property="Address" value="$H$4" type="String"/><column name="DATA_TYPE" property="ColumnWidth" value="13.43" type="Double"/><column name="DATA_TYPE" property="NumberFormat" value="General" type="String"/><column name="DATA_TYPE" property="VerticalAlignment" value="-4160" type="Double"/><column name="DATA_TYPE" property="Validation.Type" value="6" type="Double"/><column name="DATA_TYPE" property="Validation.Operator" value="8" type="Double"/><column name="DATA_TYPE" property="Validation.Formula1" value="191" type="String"/><column name="DATA_TYPE" property="Validation.AlertStyle" value="1" type="Double"/><column name="DATA_TYPE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowError" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Address" value="$I$4" type="String"/><column name="REFERENTIAL_COLUMN" property="ColumnWidth" value="36.86" type="Double"/><column name="REFERENTIAL_COLUMN" property="NumberFormat" value="General" type="String"/><column name="REFERENTIAL_COLUMN" property="VerticalAlignment" value="-4160" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.Type" value="6" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.Operator" value="8" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.Formula1" value="386" type="String"/><column name="REFERENTIAL_COLUMN" property="Validation.AlertStyle" value="1" type="Double"/><column name="REFERENTIAL_COLUMN" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Validation.ShowInput" value="True" type="Boolean"/><column name="REFERENTIAL_COLUMN" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$J$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$K$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="70.71" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="Validation.Type" value="6" type="Double"/><column name="DESCRIPTION" property="Validation.Operator" value="8" type="Double"/><column name="DESCRIPTION" property="Validation.Formula1" value="1024" type="String"/><column name="DESCRIPTION" property="Validation.AlertStyle" value="1" type="Double"/><column name="DESCRIPTION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowError" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HAS_COMMENTS" property="Address" value="$L$4" type="String"/><column name="HAS_COMMENTS" property="ColumnWidth" value="2.86" type="Double"/><column name="HAS_COMMENTS" property="NumberFormat" value="General" type="String"/><column name="HAS_COMMENTS" property="HorizontalAlignment" value="-4108" type="Double"/><column name="HAS_COMMENTS" property="VerticalAlignment" value="-4160" type="Double"/><column name="HAS_COMMENTS" property="Font.Size" value="10" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).AppliesTo.Address" value="$E$4:$E$372" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Type" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Priority" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Formula1" value="=ISBLANK(E4)" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).AppliesTo.Address" value="$L$4:$L$372" type="String"/><column name="HAS_COMMENTS" property="FormatConditions(1).Type" value="6" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).Priority" value="277" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="" property="Tab.Color" value="5296274" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_routine_parameters', N'<table name="doc.view_routine_parameters"><columnFormats><column name="" property="ListObjectName" value="view_routine_parameters" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$C$4" type="String"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="Validation.Type" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Operator" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Formula1" value="-9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.Formula2" value="9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.AlertStyle" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowInput" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowError" value="True" type="Boolean"/><column name="ROUTINE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ROUTINE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="ROUTINE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="ROUTINE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="ROUTINE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="ROUTINE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="ROUTINE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="ROUTINE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="ROUTINE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="ROUTINE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ROUTINE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ROUTINE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ROUTINE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="ROUTINE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ROUTINE_NAME" property="Address" value="$E$4" type="String"/><column name="ROUTINE_NAME" property="ColumnWidth" value="51.43" type="Double"/><column name="ROUTINE_NAME" property="NumberFormat" value="General" type="String"/><column name="ROUTINE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="ROUTINE_NAME" property="Validation.Type" value="6" type="Double"/><column name="ROUTINE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="ROUTINE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="ROUTINE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="ROUTINE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ROUTINE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ROUTINE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ROUTINE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ORDINAL_POSITION" property="Address" value="$F$4" type="String"/><column name="ORDINAL_POSITION" property="ColumnWidth" value="2.86" type="Double"/><column name="ORDINAL_POSITION" property="NumberFormat" value="General" type="String"/><column name="ORDINAL_POSITION" property="VerticalAlignment" value="-4160" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Type" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Operator" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ORDINAL_POSITION" property="Validation.Formula2" value="2147483647" type="String"/><column name="ORDINAL_POSITION" property="Validation.AlertStyle" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowError" value="True" type="Boolean"/><column name="PARAMETER_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="PARAMETER_NAME" property="Address" value="$G$4" type="String"/><column name="PARAMETER_NAME" property="ColumnWidth" value="27.29" type="Double"/><column name="PARAMETER_NAME" property="NumberFormat" value="General" type="String"/><column name="PARAMETER_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="PARAMETER_NAME" property="Validation.Type" value="6" type="Double"/><column name="PARAMETER_NAME" property="Validation.Operator" value="8" type="Double"/><column name="PARAMETER_NAME" property="Validation.Formula1" value="128" type="String"/><column name="PARAMETER_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="PARAMETER_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="PARAMETER_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="PARAMETER_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="PARAMETER_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DATA_TYPE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DATA_TYPE" property="Address" value="$H$4" type="String"/><column name="DATA_TYPE" property="ColumnWidth" value="13.43" type="Double"/><column name="DATA_TYPE" property="NumberFormat" value="General" type="String"/><column name="DATA_TYPE" property="VerticalAlignment" value="-4160" type="Double"/><column name="DATA_TYPE" property="Validation.Type" value="6" type="Double"/><column name="DATA_TYPE" property="Validation.Operator" value="8" type="Double"/><column name="DATA_TYPE" property="Validation.Formula1" value="191" type="String"/><column name="DATA_TYPE" property="Validation.AlertStyle" value="1" type="Double"/><column name="DATA_TYPE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowError" value="True" type="Boolean"/><column name="PARAMETER_MODE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="PARAMETER_MODE" property="Address" value="$I$4" type="String"/><column name="PARAMETER_MODE" property="ColumnWidth" value="7.86" type="Double"/><column name="PARAMETER_MODE" property="NumberFormat" value="General" type="String"/><column name="PARAMETER_MODE" property="VerticalAlignment" value="-4160" type="Double"/><column name="PARAMETER_MODE" property="Validation.Type" value="6" type="Double"/><column name="PARAMETER_MODE" property="Validation.Operator" value="8" type="Double"/><column name="PARAMETER_MODE" property="Validation.Formula1" value="10" type="String"/><column name="PARAMETER_MODE" property="Validation.AlertStyle" value="1" type="Double"/><column name="PARAMETER_MODE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="PARAMETER_MODE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="PARAMETER_MODE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="PARAMETER_MODE" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$J$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$K$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="77.86" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="Validation.Type" value="6" type="Double"/><column name="DESCRIPTION" property="Validation.Operator" value="8" type="Double"/><column name="DESCRIPTION" property="Validation.Formula1" value="1024" type="String"/><column name="DESCRIPTION" property="Validation.AlertStyle" value="1" type="Double"/><column name="DESCRIPTION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowError" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HAS_COMMENTS" property="Address" value="$L$4" type="String"/><column name="HAS_COMMENTS" property="ColumnWidth" value="2.86" type="Double"/><column name="HAS_COMMENTS" property="NumberFormat" value="General" type="String"/><column name="HAS_COMMENTS" property="HorizontalAlignment" value="-4108" type="Double"/><column name="HAS_COMMENTS" property="VerticalAlignment" value="-4160" type="Double"/><column name="HAS_COMMENTS" property="Font.Size" value="10" type="Double"/><column name="ROUTINE_NAME" property="FormatConditions(1).ColumnsCount" value="2" type="Double"/><column name="ROUTINE_NAME" property="FormatConditions(1).AppliesTo.Address" value="$E$4:$F$701" type="String"/><column name="ROUTINE_NAME" property="FormatConditions(1).Type" value="2" type="Double"/><column name="ROUTINE_NAME" property="FormatConditions(1).Priority" value="2" type="Double"/><column name="ROUTINE_NAME" property="FormatConditions(1).Formula1" value="=ISBLANK(E4)" type="String"/><column name="ROUTINE_NAME" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).AppliesTo.Address" value="$L$4:$L$701" type="String"/><column name="HAS_COMMENTS" property="FormatConditions(1).Type" value="6" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).Priority" value="310" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="" property="Tab.Color" value="5296274" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_routine_columns', N'<table name="doc.view_routine_columns"><columnFormats><column name="" property="ListObjectName" value="view_routine_columns" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$C$4" type="String"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="Validation.Type" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Operator" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Formula1" value="-9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.Formula2" value="9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.AlertStyle" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowInput" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="21.71" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ORDINAL_POSITION" property="Address" value="$F$4" type="String"/><column name="ORDINAL_POSITION" property="ColumnWidth" value="2.57" type="Double"/><column name="ORDINAL_POSITION" property="NumberFormat" value="General" type="String"/><column name="ORDINAL_POSITION" property="Validation.Type" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Operator" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ORDINAL_POSITION" property="Validation.Formula2" value="2147483647" type="String"/><column name="ORDINAL_POSITION" property="Validation.AlertStyle" value="1" type="Double"/><column name="ORDINAL_POSITION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ORDINAL_POSITION" property="Validation.ShowError" value="True" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="Address" value="$G$4" type="String"/><column name="COLUMN_NAME" property="ColumnWidth" value="15.29" type="Double"/><column name="COLUMN_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN_NAME" property="Validation.Type" value="6" type="Double"/><column name="COLUMN_NAME" property="Validation.Operator" value="8" type="Double"/><column name="COLUMN_NAME" property="Validation.Formula1" value="128" type="String"/><column name="COLUMN_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="COLUMN_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DATA_TYPE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DATA_TYPE" property="Address" value="$H$4" type="String"/><column name="DATA_TYPE" property="ColumnWidth" value="13.14" type="Double"/><column name="DATA_TYPE" property="NumberFormat" value="General" type="String"/><column name="DATA_TYPE" property="Validation.Type" value="6" type="Double"/><column name="DATA_TYPE" property="Validation.Operator" value="8" type="Double"/><column name="DATA_TYPE" property="Validation.Formula1" value="191" type="String"/><column name="DATA_TYPE" property="Validation.AlertStyle" value="1" type="Double"/><column name="DATA_TYPE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DATA_TYPE" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$I$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$J$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="70.71" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="Validation.Type" value="6" type="Double"/><column name="DESCRIPTION" property="Validation.Operator" value="8" type="Double"/><column name="DESCRIPTION" property="Validation.Formula1" value="1024" type="String"/><column name="DESCRIPTION" property="Validation.AlertStyle" value="1" type="Double"/><column name="DESCRIPTION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowError" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HAS_COMMENTS" property="Address" value="$K$4" type="String"/><column name="HAS_COMMENTS" property="ColumnWidth" value="2.86" type="Double"/><column name="HAS_COMMENTS" property="NumberFormat" value="General" type="String"/><column name="HAS_COMMENTS" property="HorizontalAlignment" value="-4108" type="Double"/><column name="HAS_COMMENTS" property="VerticalAlignment" value="-4160" type="Double"/><column name="HAS_COMMENTS" property="Font.Size" value="10" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).AppliesTo.Address" value="$E$4:$E$39" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Type" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Priority" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Formula1" value="=ISBLANK(E4)" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="ORDINAL_POSITION" property="FormatConditions(1).AppliesTo.Address" value="$F$4:$F$39" type="String"/><column name="ORDINAL_POSITION" property="FormatConditions(1).Type" value="2" type="Double"/><column name="ORDINAL_POSITION" property="FormatConditions(1).Priority" value="3" type="Double"/><column name="ORDINAL_POSITION" property="FormatConditions(1).Formula1" value="=ISBLANK(F4)" type="String"/><column name="ORDINAL_POSITION" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).AppliesTo.Address" value="$K$4:$K$39" type="String"/><column name="HAS_COMMENTS" property="FormatConditions(1).Type" value="6" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).Priority" value="245" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="HAS_COMMENTS" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="" property="Tab.Color" value="5296274" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_orphan_rows', N'<table name="doc.view_orphan_rows"><columnFormats><column name="" property="ListObjectName" value="view_orphan_rows" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="ID" property="Validation.ErrorMessage" value="The column requires values of the int datatype." type="String"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="SECTION_ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SECTION_ID" property="Address" value="$D$4" type="String"/><column name="SECTION_ID" property="NumberFormat" value="General" type="String"/><column name="SECTION_ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$E$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_SCHEMA" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$F$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="44.14" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="Address" value="$G$4" type="String"/><column name="COLUMN_NAME" property="ColumnWidth" value="15.29" type="Double"/><column name="COLUMN_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="COLUMN_NAME" property="Validation.Type" value="6" type="Double"/><column name="COLUMN_NAME" property="Validation.Operator" value="8" type="Double"/><column name="COLUMN_NAME" property="Validation.Formula1" value="128" type="String"/><column name="COLUMN_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="COLUMN_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="COLUMN_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="COLUMN_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$H$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="LANGUAGE_NAME" property="Validation.ErrorMessage" value="The column requires values of the char(2) datatype." type="String"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="VERSION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="VERSION" property="Address" value="$I$4" type="String"/><column name="VERSION" property="ColumnWidth" value="3.57" type="Double"/><column name="VERSION" property="NumberFormat" value="@" type="String"/><column name="VERSION" property="VerticalAlignment" value="-4160" type="Double"/><column name="VERSION" property="Validation.Type" value="6" type="Double"/><column name="VERSION" property="Validation.Operator" value="8" type="Double"/><column name="VERSION" property="Validation.Formula1" value="50" type="String"/><column name="VERSION" property="Validation.AlertStyle" value="1" type="Double"/><column name="VERSION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="VERSION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="VERSION" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="VERSION" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(50) datatype." type="String"/><column name="VERSION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="VERSION" property="Validation.ShowError" value="True" type="Boolean"/><column name="DESCRIPTION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DESCRIPTION" property="Address" value="$J$4" type="String"/><column name="DESCRIPTION" property="ColumnWidth" value="70.71" type="Double"/><column name="DESCRIPTION" property="NumberFormat" value="@" type="String"/><column name="DESCRIPTION" property="VerticalAlignment" value="-4160" type="Double"/><column name="DESCRIPTION" property="Validation.Type" value="6" type="Double"/><column name="DESCRIPTION" property="Validation.Operator" value="8" type="Double"/><column name="DESCRIPTION" property="Validation.Formula1" value="1024" type="String"/><column name="DESCRIPTION" property="Validation.AlertStyle" value="1" type="Double"/><column name="DESCRIPTION" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="DESCRIPTION" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(1024) datatype." type="String"/><column name="DESCRIPTION" property="Validation.ShowInput" value="True" type="Boolean"/><column name="DESCRIPTION" property="Validation.ShowError" value="True" type="Boolean"/><column name="COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COMMENT" property="Address" value="$K$4" type="String"/><column name="COMMENT" property="ColumnWidth" value="70.71" type="Double"/><column name="COMMENT" property="NumberFormat" value="@" type="String"/><column name="COMMENT" property="VerticalAlignment" value="-4160" type="Double"/><column name="" property="Tab.Color" value="5287936" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'translations', N'<table name="doc.translations"><columnFormats><column name="" property="ListObjectName" value="translations" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="25.86" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="Address" value="$F$4" type="String"/><column name="COLUMN_NAME" property="ColumnWidth" value="25.57" type="Double"/><column name="COLUMN_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN_NAME" property="Validation.Type" value="6" type="Double"/><column name="COLUMN_NAME" property="Validation.Operator" value="8" type="Double"/><column name="COLUMN_NAME" property="Validation.Formula1" value="128" type="String"/><column name="COLUMN_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="COLUMN_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$G$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="19.57" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_NAME" property="Address" value="$H$4" type="String"/><column name="TRANSLATED_NAME" property="ColumnWidth" value="28.43" type="Double"/><column name="TRANSLATED_NAME" property="NumberFormat" value="@" type="String"/><column name="TRANSLATED_NAME" property="Validation.Type" value="6" type="Double"/><column name="TRANSLATED_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TRANSLATED_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TRANSLATED_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TRANSLATED_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_DESC" property="Address" value="$I$4" type="String"/><column name="TRANSLATED_DESC" property="ColumnWidth" value="19.57" type="Double"/><column name="TRANSLATED_DESC" property="NumberFormat" value="@" type="String"/><column name="TRANSLATED_DESC" property="Validation.Type" value="6" type="Double"/><column name="TRANSLATED_DESC" property="Validation.Operator" value="8" type="Double"/><column name="TRANSLATED_DESC" property="Validation.Formula1" value="1024" type="String"/><column name="TRANSLATED_DESC" property="Validation.AlertStyle" value="1" type="Double"/><column name="TRANSLATED_DESC" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="Validation.ShowError" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Address" value="$J$4" type="String"/><column name="TRANSLATED_COMMENT" property="ColumnWidth" value="25" type="Double"/><column name="TRANSLATED_COMMENT" property="NumberFormat" value="@" type="String"/><column name="TRANSLATED_COMMENT" property="Validation.Type" value="6" type="Double"/><column name="TRANSLATED_COMMENT" property="Validation.Operator" value="8" type="Double"/><column name="TRANSLATED_COMMENT" property="Validation.Formula1" value="2000" type="String"/><column name="TRANSLATED_COMMENT" property="Validation.AlertStyle" value="1" type="Double"/><column name="TRANSLATED_COMMENT" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Validation.ShowError" value="True" type="Boolean"/><column name="SortFields(1)" property="KeyfieldName" value="COLUMN_NAME" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="SortFields(2)" property="KeyfieldName" value="LANGUAGE_NAME" type="String"/><column name="SortFields(2)" property="SortOn" value="0" type="Double"/><column name="SortFields(2)" property="Order" value="1" type="Double"/><column name="SortFields(2)" property="DataOption" value="0" type="Double"/><column name="SortFields(3)" property="KeyfieldName" value="TABLE_SCHEMA" type="String"/><column name="SortFields(3)" property="SortOn" value="0" type="Double"/><column name="SortFields(3)" property="Order" value="1" type="Double"/><column name="SortFields(3)" property="DataOption" value="0" type="Double"/><column name="SortFields(4)" property="KeyfieldName" value="TABLE_NAME" type="String"/><column name="SortFields(4)" property="SortOn" value="0" type="Double"/><column name="SortFields(4)" property="Order" value="1" type="Double"/><column name="SortFields(4)" property="DataOption" value="0" type="Double"/><column name="" property="Tab.Color" value="6299648" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats><views><view name="By ID"><column name="" property="ListObjectName" value="translations" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_DESC" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="SortFields(1)" property="KeyfieldName" value="ID" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/></view><view name="By Object"><column name="" property="ListObjectName" value="translations" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_DESC" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="SortFields(1)" property="KeyfieldName" value="LANGUAGE_NAME" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="SortFields(2)" property="KeyfieldName" value="TABLE_SCHEMA" type="String"/><column name="SortFields(2)" property="SortOn" value="0" type="Double"/><column name="SortFields(2)" property="Order" value="1" type="Double"/><column name="SortFields(2)" property="DataOption" value="0" type="Double"/><column name="SortFields(3)" property="KeyfieldName" value="TABLE_NAME" type="String"/><column name="SortFields(3)" property="SortOn" value="0" type="Double"/><column name="SortFields(3)" property="Order" value="1" type="Double"/><column name="SortFields(3)" property="DataOption" value="0" type="Double"/><column name="SortFields(4)" property="KeyfieldName" value="COLUMN_NAME" type="String"/><column name="SortFields(4)" property="SortOn" value="0" type="Double"/><column name="SortFields(4)" property="Order" value="1" type="Double"/><column name="SortFields(4)" property="DataOption" value="0" type="Double"/></view><view name="By Column"><column name="" property="ListObjectName" value="translations" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_DESC" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="SortFields(1)" property="KeyfieldName" value="LANGUAGE_NAME" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="SortFields(2)" property="KeyfieldName" value="COLUMN_NAME" type="String"/><column name="SortFields(2)" property="SortOn" value="0" type="Double"/><column name="SortFields(2)" property="Order" value="1" type="Double"/><column name="SortFields(2)" property="DataOption" value="0" type="Double"/><column name="SortFields(3)" property="KeyfieldName" value="TABLE_SCHEMA" type="String"/><column name="SortFields(3)" property="SortOn" value="0" type="Double"/><column name="SortFields(3)" property="Order" value="1" type="Double"/><column name="SortFields(3)" property="DataOption" value="0" type="Double"/><column name="SortFields(4)" property="KeyfieldName" value="TABLE_NAME" type="String"/><column name="SortFields(4)" property="SortOn" value="0" type="Double"/><column name="SortFields(4)" property="Order" value="1" type="Double"/><column name="SortFields(4)" property="DataOption" value="0" type="Double"/></view><view name="By Column + Language"><column name="" property="ListObjectName" value="translations" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_DESC" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="SortFields(1)" property="KeyfieldName" value="COLUMN_NAME" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="SortFields(2)" property="KeyfieldName" value="LANGUAGE_NAME" type="String"/><column name="SortFields(2)" property="SortOn" value="0" type="Double"/><column name="SortFields(2)" property="Order" value="1" type="Double"/><column name="SortFields(2)" property="DataOption" value="0" type="Double"/><column name="SortFields(3)" property="KeyfieldName" value="TABLE_SCHEMA" type="String"/><column name="SortFields(3)" property="SortOn" value="0" type="Double"/><column name="SortFields(3)" property="Order" value="1" type="Double"/><column name="SortFields(3)" property="DataOption" value="0" type="Double"/><column name="SortFields(4)" property="KeyfieldName" value="TABLE_NAME" type="String"/><column name="SortFields(4)" property="SortOn" value="0" type="Double"/><column name="SortFields(4)" property="Order" value="1" type="Double"/><column name="SortFields(4)" property="DataOption" value="0" type="Double"/></view></views></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'usp_translations', N'<table name="doc.usp_translations"><columnFormats><column name="" property="ListObjectName" value="translation_pivot" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$C$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$D$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="25.86" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN" property="Address" value="$E$4" type="String"/><column name="COLUMN" property="ColumnWidth" value="25.57" type="Double"/><column name="COLUMN" property="NumberFormat" value="General" type="String"/><column name="en" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="en" property="Address" value="$F$4" type="String"/><column name="en" property="ColumnWidth" value="21.43" type="Double"/><column name="en" property="NumberFormat" value="@" type="String"/><column name="fr" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="fr" property="Address" value="$G$4" type="String"/><column name="fr" property="ColumnWidth" value="23.86" type="Double"/><column name="fr" property="NumberFormat" value="@" type="String"/><column name="it" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="it" property="Address" value="$H$4" type="String"/><column name="it" property="ColumnWidth" value="28.43" type="Double"/><column name="it" property="NumberFormat" value="@" type="String"/><column name="es" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="es" property="Address" value="$I$4" type="String"/><column name="es" property="ColumnWidth" value="28.57" type="Double"/><column name="es" property="NumberFormat" value="@" type="String"/><column name="ru" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ru" property="Address" value="$J$4" type="String"/><column name="ru" property="ColumnWidth" value="26.14" type="Double"/><column name="ru" property="NumberFormat" value="@" type="String"/><column name="" property="Tab.Color" value="6299648" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'workbooks', N'<table name="doc.workbooks"><columnFormats><column name="" property="ListObjectName" value="workbooks" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="ID" property="Validation.ErrorMessage" value="The column requires values of the int datatype." type="String"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="NAME" property="Address" value="$D$4" type="String"/><column name="NAME" property="ColumnWidth" value="30.86" type="Double"/><column name="NAME" property="NumberFormat" value="General" type="String"/><column name="NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="NAME" property="Validation.Type" value="6" type="Double"/><column name="NAME" property="Validation.Operator" value="8" type="Double"/><column name="NAME" property="Validation.Formula1" value="128" type="String"/><column name="NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="TEMPLATE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TEMPLATE" property="Address" value="$E$4" type="String"/><column name="TEMPLATE" property="ColumnWidth" value="27.86" type="Double"/><column name="TEMPLATE" property="NumberFormat" value="General" type="String"/><column name="TEMPLATE" property="VerticalAlignment" value="-4160" type="Double"/><column name="TEMPLATE" property="Validation.Type" value="6" type="Double"/><column name="TEMPLATE" property="Validation.Operator" value="8" type="Double"/><column name="TEMPLATE" property="Validation.Formula1" value="255" type="String"/><column name="TEMPLATE" property="Validation.AlertStyle" value="1" type="Double"/><column name="TEMPLATE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TEMPLATE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TEMPLATE" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TEMPLATE" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(255) datatype." type="String"/><column name="TEMPLATE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TEMPLATE" property="Validation.ShowError" value="True" type="Boolean"/><column name="DEFINITION" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DEFINITION" property="Address" value="$F$4" type="String"/><column name="DEFINITION" property="ColumnWidth" value="135" type="Double"/><column name="DEFINITION" property="NumberFormat" value="General" type="String"/><column name="DEFINITION" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$G$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="135" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="m/d/yyyy" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="" property="Tab.Color" value="6299648" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'objects', N'<table name="doc.objects"><columnFormats><column name="" property="ListObjectName" value="objects" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="ID" property="Validation.ErrorMessage" value="The column requires values of the int datatype." type="String"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="4.29" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="20" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_SCHEMA" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(20) datatype." type="String"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="23.71" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_TYPE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_TYPE" property="Address" value="$F$4" type="String"/><column name="TABLE_TYPE" property="ColumnWidth" value="13.14" type="Double"/><column name="TABLE_TYPE" property="NumberFormat" value="General" type="String"/><column name="TABLE_TYPE" property="Validation.Type" value="3" type="Double"/><column name="TABLE_TYPE" property="Validation.Operator" value="1" type="Double"/><column name="TABLE_TYPE" property="Validation.Formula1" value="TABLE; VIEW; PROCEDURE; CODE; HTTP; TEXT; HIDDEN" type="String"/><column name="TABLE_TYPE" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_TYPE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_TYPE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_TYPE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_TYPE" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_CODE" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="TABLE_CODE" property="Address" value="$G$4" type="String"/><column name="TABLE_CODE" property="NumberFormat" value="General" type="String"/><column name="INSERT_OBJECT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="INSERT_OBJECT" property="Address" value="$H$4" type="String"/><column name="INSERT_OBJECT" property="ColumnWidth" value="28.71" type="Double"/><column name="INSERT_OBJECT" property="NumberFormat" value="General" type="String"/><column name="UPDATE_OBJECT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="UPDATE_OBJECT" property="Address" value="$I$4" type="String"/><column name="UPDATE_OBJECT" property="ColumnWidth" value="28.71" type="Double"/><column name="UPDATE_OBJECT" property="NumberFormat" value="General" type="String"/><column name="DELETE_OBJECT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="DELETE_OBJECT" property="Address" value="$J$4" type="String"/><column name="DELETE_OBJECT" property="ColumnWidth" value="28.29" type="Double"/><column name="DELETE_OBJECT" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="FormatConditions(1).AppliesTo.Address" value="$D$4:$D$13" type="String"/><column name="TABLE_SCHEMA" property="FormatConditions(1).Type" value="2" type="Double"/><column name="TABLE_SCHEMA" property="FormatConditions(1).Priority" value="1" type="Double"/><column name="TABLE_SCHEMA" property="FormatConditions(1).Formula1" value="=ISBLANK(D4)" type="String"/><column name="TABLE_SCHEMA" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).AppliesTo.Address" value="$E$4:$E$13" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Type" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Priority" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Formula1" value="=ISBLANK(E4)" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="TABLE_TYPE" property="FormatConditions(1).AppliesTo.Address" value="$F$4:$F$13" type="String"/><column name="TABLE_TYPE" property="FormatConditions(1).Type" value="2" type="Double"/><column name="TABLE_TYPE" property="FormatConditions(1).Priority" value="3" type="Double"/><column name="TABLE_TYPE" property="FormatConditions(1).Formula1" value="=ISBLANK(F4)" type="String"/><column name="TABLE_TYPE" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="SortFields(1)" property="KeyfieldName" value="TABLE_TYPE" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="SortFields(2)" property="KeyfieldName" value="TABLE_SCHEMA" type="String"/><column name="SortFields(2)" property="SortOn" value="0" type="Double"/><column name="SortFields(2)" property="Order" value="1" type="Double"/><column name="SortFields(2)" property="DataOption" value="0" type="Double"/><column name="SortFields(3)" property="KeyfieldName" value="TABLE_NAME" type="String"/><column name="SortFields(3)" property="SortOn" value="0" type="Double"/><column name="SortFields(3)" property="Order" value="1" type="Double"/><column name="SortFields(3)" property="DataOption" value="0" type="Double"/><column name="" property="Tab.Color" value="6299648" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_properties', N'<table name="doc.view_properties"><columnFormats><column name="" property="ListObjectName" value="view_properties" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SORT_ORDER" property="Address" value="$C$4" type="String"/><column name="SORT_ORDER" property="NumberFormat" value="General" type="String"/><column name="SORT_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="SORT_ORDER" property="Validation.Type" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Operator" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.Formula1" value="-9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.Formula2" value="9223372036854770000" type="String"/><column name="SORT_ORDER" property="Validation.AlertStyle" value="1" type="Double"/><column name="SORT_ORDER" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="SORT_ORDER" property="Validation.ErrorMessage" value="The column requires values of the bigint datatype." type="String"/><column name="SORT_ORDER" property="Validation.ShowInput" value="True" type="Boolean"/><column name="SORT_ORDER" property="Validation.ShowError" value="True" type="Boolean"/><column name="SECTION_ID" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="SECTION_ID" property="Address" value="$D$4" type="String"/><column name="SECTION_ID" property="NumberFormat" value="General" type="String"/><column name="SECTION_ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="SECTION_ID" property="Validation.Type" value="1" type="Double"/><column name="SECTION_ID" property="Validation.Operator" value="1" type="Double"/><column name="SECTION_ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="SECTION_ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="SECTION_ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="SECTION_ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="SECTION_ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="SECTION_ID" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="SECTION_ID" property="Validation.ErrorMessage" value="The column requires values of the int datatype." type="String"/><column name="SECTION_ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="SECTION_ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$E$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_SCHEMA" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$F$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="20.57" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="15" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_NAME" property="Validation.ErrorMessage" value="The column requires values of the varchar(15) datatype." type="String"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$G$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="2.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="LANGUAGE_NAME" property="Validation.ErrorMessage" value="The column requires values of the varchar(2) datatype." type="String"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COMMENT" property="Address" value="$H$4" type="String"/><column name="COMMENT" property="ColumnWidth" value="70.71" type="Double"/><column name="COMMENT" property="NumberFormat" value="General" type="String"/><column name="COMMENT" property="VerticalAlignment" value="-4160" type="Double"/><column name="COMMENT" property="WrapText" value="True" type="Boolean"/><column name="SECTION_ID" property="FormatConditions(1).AppliesTo.Address" value="$D$4:$D$80,$F$4:$G$80" type="String"/><column name="SECTION_ID" property="FormatConditions(1).Type" value="2" type="Double"/><column name="SECTION_ID" property="FormatConditions(1).Priority" value="1" type="Double"/><column name="SECTION_ID" property="FormatConditions(1).Formula1" value="=ISBLANK(D4)" type="String"/><column name="SECTION_ID" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="SortFields(1)" property="KeyfieldName" value="SORT_ORDER" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="" property="Tab.Color" value="15773696" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'handlers', N'<table name="doc.handlers"><columnFormats><column name="" property="ListObjectName" value="handlers" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="_RowNum" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="ColumnWidth" value="4.43" type="Double"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="VerticalAlignment" value="-4160" type="Double"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="ID" property="Validation.ErrorMessage" value="The column requires values of the int datatype." type="String"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="4.29" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="20" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_SCHEMA" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(20) datatype." type="String"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="33.14" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="Address" value="$F$4" type="String"/><column name="COLUMN_NAME" property="ColumnWidth" value="16.14" type="Double"/><column name="COLUMN_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="COLUMN_NAME" property="Validation.Type" value="6" type="Double"/><column name="COLUMN_NAME" property="Validation.Operator" value="8" type="Double"/><column name="COLUMN_NAME" property="Validation.Formula1" value="128" type="String"/><column name="COLUMN_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="COLUMN_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="COLUMN_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="COLUMN_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="EVENT_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="EVENT_NAME" property="Address" value="$G$4" type="String"/><column name="EVENT_NAME" property="ColumnWidth" value="21.57" type="Double"/><column name="EVENT_NAME" property="NumberFormat" value="General" type="String"/><column name="EVENT_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="HANDLER_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HANDLER_SCHEMA" property="Address" value="$H$4" type="String"/><column name="HANDLER_SCHEMA" property="ColumnWidth" value="4.29" type="Double"/><column name="HANDLER_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="HANDLER_SCHEMA" property="VerticalAlignment" value="-4160" type="Double"/><column name="HANDLER_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="HANDLER_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="HANDLER_SCHEMA" property="Validation.Formula1" value="20" type="String"/><column name="HANDLER_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="HANDLER_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="HANDLER_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="HANDLER_SCHEMA" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="HANDLER_SCHEMA" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(20) datatype." type="String"/><column name="HANDLER_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="HANDLER_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="HANDLER_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HANDLER_NAME" property="Address" value="$I$4" type="String"/><column name="HANDLER_NAME" property="ColumnWidth" value="36.71" type="Double"/><column name="HANDLER_NAME" property="NumberFormat" value="General" type="String"/><column name="HANDLER_NAME" property="VerticalAlignment" value="-4160" type="Double"/><column name="HANDLER_NAME" property="Validation.Type" value="6" type="Double"/><column name="HANDLER_NAME" property="Validation.Operator" value="8" type="Double"/><column name="HANDLER_NAME" property="Validation.Formula1" value="128" type="String"/><column name="HANDLER_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="HANDLER_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="HANDLER_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="HANDLER_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="HANDLER_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="HANDLER_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="HANDLER_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="HANDLER_TYPE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HANDLER_TYPE" property="Address" value="$J$4" type="String"/><column name="HANDLER_TYPE" property="ColumnWidth" value="14.29" type="Double"/><column name="HANDLER_TYPE" property="NumberFormat" value="General" type="String"/><column name="HANDLER_TYPE" property="VerticalAlignment" value="-4160" type="Double"/><column name="HANDLER_TYPE" property="Validation.Type" value="3" type="Double"/><column name="HANDLER_TYPE" property="Validation.Operator" value="1" type="Double"/><column name="HANDLER_TYPE" property="Validation.Formula1" value="TABLE; VIEW; PROCEDURE; FUNCTION; CODE; HTTP; TEXT; MACRO; CMD; VALUES; RANGE; REFRESH; MENUSEPARATOR; PDF; REPORT; SHOWSHEETS; HIDESHEETS; SELECTSHEET; ATTRIBUTE" type="String"/><column name="HANDLER_TYPE" property="Validation.AlertStyle" value="1" type="Double"/><column name="HANDLER_TYPE" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="HANDLER_TYPE" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="HANDLER_TYPE" property="Validation.ShowInput" value="True" type="Boolean"/><column name="HANDLER_TYPE" property="Validation.ShowError" value="True" type="Boolean"/><column name="HANDLER_CODE" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="HANDLER_CODE" property="Address" value="$K$4" type="String"/><column name="HANDLER_CODE" property="ColumnWidth" value="67.86" type="Double"/><column name="HANDLER_CODE" property="NumberFormat" value="General" type="String"/><column name="HANDLER_CODE" property="VerticalAlignment" value="-4160" type="Double"/><column name="TARGET_WORKSHEET" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TARGET_WORKSHEET" property="Address" value="$L$4" type="String"/><column name="TARGET_WORKSHEET" property="ColumnWidth" value="18.57" type="Double"/><column name="TARGET_WORKSHEET" property="NumberFormat" value="General" type="String"/><column name="TARGET_WORKSHEET" property="VerticalAlignment" value="-4160" type="Double"/><column name="TARGET_WORKSHEET" property="Validation.Type" value="6" type="Double"/><column name="TARGET_WORKSHEET" property="Validation.Operator" value="8" type="Double"/><column name="TARGET_WORKSHEET" property="Validation.Formula1" value="128" type="String"/><column name="TARGET_WORKSHEET" property="Validation.AlertStyle" value="1" type="Double"/><column name="TARGET_WORKSHEET" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TARGET_WORKSHEET" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TARGET_WORKSHEET" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TARGET_WORKSHEET" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TARGET_WORKSHEET" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TARGET_WORKSHEET" property="Validation.ShowError" value="True" type="Boolean"/><column name="MENU_ORDER" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="MENU_ORDER" property="Address" value="$M$4" type="String"/><column name="MENU_ORDER" property="ColumnWidth" value="13.43" type="Double"/><column name="MENU_ORDER" property="NumberFormat" value="General" type="String"/><column name="MENU_ORDER" property="VerticalAlignment" value="-4160" type="Double"/><column name="MENU_ORDER" property="Validation.Type" value="1" type="Double"/><column name="MENU_ORDER" property="Validation.Operator" value="1" type="Double"/><column name="MENU_ORDER" property="Validation.Formula1" value="-2147483648" type="String"/><column name="MENU_ORDER" property="Validation.Formula2" value="2147483647" type="String"/><column name="MENU_ORDER" property="Validation.AlertStyle" value="1" type="Double"/><column name="MENU_ORDER" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="MENU_ORDER" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="MENU_ORDER" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="MENU_ORDER" property="Validation.ErrorMessage" value="The column requires values of the int datatype." type="String"/><column name="MENU_ORDER" property="Validation.ShowInput" value="True" type="Boolean"/><column name="MENU_ORDER" property="Validation.ShowError" value="True" type="Boolean"/><column name="EDIT_PARAMETERS" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="EDIT_PARAMETERS" property="Address" value="$N$4" type="String"/><column name="EDIT_PARAMETERS" property="ColumnWidth" value="16.71" type="Double"/><column name="EDIT_PARAMETERS" property="NumberFormat" value="General" type="String"/><column name="EDIT_PARAMETERS" property="HorizontalAlignment" value="-4108" type="Double"/><column name="EDIT_PARAMETERS" property="VerticalAlignment" value="-4160" type="Double"/><column name="EDIT_PARAMETERS" property="Font.Size" value="10" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).AppliesTo.Address" value="$E$4:$E$39" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Type" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Priority" value="2" type="Double"/><column name="TABLE_NAME" property="FormatConditions(1).Formula1" value="=ISBLANK(E4)" type="String"/><column name="TABLE_NAME" property="FormatConditions(1).Interior.Color" value="65535" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).AppliesTo.Address" value="$N$4:$N$39" type="String"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).Type" value="6" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).Priority" value="297" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).ShowIconOnly" value="True" type="Boolean"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconSet.ID" value="8" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(1).Type" value="3" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(1).Operator" value="7" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(2).Type" value="0" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(2).Value" value="0.5" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(2).Operator" value="7" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(3).Type" value="0" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(3).Value" value="1" type="Double"/><column name="EDIT_PARAMETERS" property="FormatConditions(1).IconCriteria(3).Operator" value="7" type="Double"/><column name="SortFields(1)" property="KeyfieldName" value="EVENT_NAME" type="String"/><column name="SortFields(1)" property="SortOn" value="0" type="Double"/><column name="SortFields(1)" property="Order" value="1" type="Double"/><column name="SortFields(1)" property="DataOption" value="0" type="Double"/><column name="SortFields(2)" property="KeyfieldName" value="TABLE_SCHEMA" type="String"/><column name="SortFields(2)" property="SortOn" value="0" type="Double"/><column name="SortFields(2)" property="Order" value="1" type="Double"/><column name="SortFields(2)" property="DataOption" value="0" type="Double"/><column name="SortFields(3)" property="KeyfieldName" value="TABLE_NAME" type="String"/><column name="SortFields(3)" property="SortOn" value="0" type="Double"/><column name="SortFields(3)" property="Order" value="1" type="Double"/><column name="SortFields(3)" property="DataOption" value="0" type="Double"/><column name="SortFields(4)" property="KeyfieldName" value="COLUMN_NAME" type="String"/><column name="SortFields(4)" property="SortOn" value="0" type="Double"/><column name="SortFields(4)" property="Order" value="1" type="Double"/><column name="SortFields(4)" property="DataOption" value="0" type="Double"/><column name="SortFields(5)" property="KeyfieldName" value="MENU_ORDER" type="String"/><column name="SortFields(5)" property="SortOn" value="0" type="Double"/><column name="SortFields(5)" property="Order" value="1" type="Double"/><column name="SortFields(5)" property="DataOption" value="0" type="Double"/><column name="SortFields(6)" property="KeyfieldName" value="HANDLER_SCHEMA" type="String"/><column name="SortFields(6)" property="SortOn" value="0" type="Double"/><column name="SortFields(6)" property="Order" value="1" type="Double"/><column name="SortFields(6)" property="DataOption" value="0" type="Double"/><column name="SortFields(7)" property="KeyfieldName" value="HANDLER_NAME" type="String"/><column name="SortFields(7)" property="SortOn" value="0" type="Double"/><column name="SortFields(7)" property="Order" value="1" type="Double"/><column name="SortFields(7)" property="DataOption" value="0" type="Double"/><column name="" property="Tab.Color" value="6299648" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_index', N'<table name="doc.view_index"><columnFormats><column name="" property="ListObjectName" value="index" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="#" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="#" property="Address" value="$C$4" type="String"/><column name="#" property="ColumnWidth" value="3.57" type="Double"/><column name="#" property="NumberFormat" value="General" type="String"/><column name="object" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="object" property="Address" value="$D$4" type="String"/><column name="object" property="ColumnWidth" value="29.43" type="Double"/><column name="object" property="NumberFormat" value="General" type="String"/><column name="object" property="Font.Underline" value="2" type="Double"/><column name="object" property="Font.Color" value="16711680" type="Double"/><column name="object" property="Font.ThemeColor" value="11" type="Double"/><column name="object" property="Font.TintAndShade" value="0" type="Double"/><column name="" property="Tab.Color" value="5287936" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');
INSERT INTO doc.formats (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES (N'doc', N'view_translations', N'<table name="doc.view_translations"><columnFormats><column name="" property="ListObjectName" value="translations" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="ID" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="ID" property="Address" value="$C$4" type="String"/><column name="ID" property="ColumnWidth" value="4.43" type="Double"/><column name="ID" property="NumberFormat" value="General" type="String"/><column name="ID" property="Validation.Type" value="1" type="Double"/><column name="ID" property="Validation.Operator" value="1" type="Double"/><column name="ID" property="Validation.Formula1" value="-2147483648" type="String"/><column name="ID" property="Validation.Formula2" value="2147483647" type="String"/><column name="ID" property="Validation.AlertStyle" value="1" type="Double"/><column name="ID" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="ID" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="ID" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="ID" property="Validation.ErrorMessage" value="The column requires values of the int datatype." type="String"/><column name="ID" property="Validation.ShowInput" value="True" type="Boolean"/><column name="ID" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_SCHEMA" property="Address" value="$D$4" type="String"/><column name="TABLE_SCHEMA" property="ColumnWidth" value="9.43" type="Double"/><column name="TABLE_SCHEMA" property="NumberFormat" value="General" type="String"/><column name="TABLE_SCHEMA" property="Validation.Type" value="6" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_SCHEMA" property="Validation.Formula1" value="20" type="String"/><column name="TABLE_SCHEMA" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_SCHEMA" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_SCHEMA" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(20) datatype." type="String"/><column name="TABLE_SCHEMA" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_SCHEMA" property="Validation.ShowError" value="True" type="Boolean"/><column name="TABLE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TABLE_NAME" property="Address" value="$E$4" type="String"/><column name="TABLE_NAME" property="ColumnWidth" value="25.86" type="Double"/><column name="TABLE_NAME" property="NumberFormat" value="General" type="String"/><column name="TABLE_NAME" property="Validation.Type" value="6" type="Double"/><column name="TABLE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TABLE_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TABLE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TABLE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TABLE_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TABLE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TABLE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="COLUMN_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="COLUMN_NAME" property="Address" value="$F$4" type="String"/><column name="COLUMN_NAME" property="ColumnWidth" value="25.57" type="Double"/><column name="COLUMN_NAME" property="NumberFormat" value="General" type="String"/><column name="COLUMN_NAME" property="Validation.Type" value="6" type="Double"/><column name="COLUMN_NAME" property="Validation.Operator" value="8" type="Double"/><column name="COLUMN_NAME" property="Validation.Formula1" value="255" type="String"/><column name="COLUMN_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="COLUMN_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="COLUMN_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(255) datatype." type="String"/><column name="COLUMN_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="COLUMN_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="LANGUAGE_NAME" property="Address" value="$G$4" type="String"/><column name="LANGUAGE_NAME" property="ColumnWidth" value="10.86" type="Double"/><column name="LANGUAGE_NAME" property="NumberFormat" value="General" type="String"/><column name="LANGUAGE_NAME" property="Validation.Type" value="6" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Operator" value="8" type="Double"/><column name="LANGUAGE_NAME" property="Validation.Formula1" value="2" type="String"/><column name="LANGUAGE_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="LANGUAGE_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="LANGUAGE_NAME" property="Validation.ErrorMessage" value="The column requires values of the char(2) datatype." type="String"/><column name="LANGUAGE_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="LANGUAGE_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_NAME" property="Address" value="$H$4" type="String"/><column name="TRANSLATED_NAME" property="ColumnWidth" value="28.57" type="Double"/><column name="TRANSLATED_NAME" property="NumberFormat" value="General" type="String"/><column name="TRANSLATED_NAME" property="Validation.Type" value="6" type="Double"/><column name="TRANSLATED_NAME" property="Validation.Operator" value="8" type="Double"/><column name="TRANSLATED_NAME" property="Validation.Formula1" value="128" type="String"/><column name="TRANSLATED_NAME" property="Validation.AlertStyle" value="1" type="Double"/><column name="TRANSLATED_NAME" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TRANSLATED_NAME" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(128) datatype." type="String"/><column name="TRANSLATED_NAME" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TRANSLATED_NAME" property="Validation.ShowError" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_DESC" property="Address" value="$I$4" type="String"/><column name="TRANSLATED_DESC" property="ColumnWidth" value="12.71" type="Double"/><column name="TRANSLATED_DESC" property="NumberFormat" value="General" type="String"/><column name="TRANSLATED_DESC" property="Validation.Type" value="6" type="Double"/><column name="TRANSLATED_DESC" property="Validation.Operator" value="8" type="Double"/><column name="TRANSLATED_DESC" property="Validation.Formula1" value="1024" type="String"/><column name="TRANSLATED_DESC" property="Validation.AlertStyle" value="1" type="Double"/><column name="TRANSLATED_DESC" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TRANSLATED_DESC" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(1024) datatype." type="String"/><column name="TRANSLATED_DESC" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TRANSLATED_DESC" property="Validation.ShowError" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Address" value="$J$4" type="String"/><column name="TRANSLATED_COMMENT" property="ColumnWidth" value="11.29" type="Double"/><column name="TRANSLATED_COMMENT" property="NumberFormat" value="General" type="String"/><column name="TRANSLATED_COMMENT" property="Validation.Type" value="6" type="Double"/><column name="TRANSLATED_COMMENT" property="Validation.Operator" value="8" type="Double"/><column name="TRANSLATED_COMMENT" property="Validation.Formula1" value="2000" type="String"/><column name="TRANSLATED_COMMENT" property="Validation.AlertStyle" value="1" type="Double"/><column name="TRANSLATED_COMMENT" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Validation.ErrorTitle" value="Datatype Control" type="String"/><column name="TRANSLATED_COMMENT" property="Validation.ErrorMessage" value="The column requires values of the nvarchar(2000) datatype." type="String"/><column name="TRANSLATED_COMMENT" property="Validation.ShowInput" value="True" type="Boolean"/><column name="TRANSLATED_COMMENT" property="Validation.ShowError" value="True" type="Boolean"/><column name="" property="Tab.Color" value="6299648" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/><column name="" property="PageSetup.PaperSize" value="9" type="Double"/></columnFormats></table>');

INSERT INTO doc.workbooks (NAME, TEMPLATE, DEFINITION, TABLE_SCHEMA) VALUES (N'database_help.xlsx', NULL, N'index=doc.view_index,doc.view_query_list,False,$B$3,,{"Parameters":{},"ListObjectName":"index","WorkbookLanguage":"en"}
properties=doc.view_properties,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_properties","WorkbookLanguage":"en"}
pages=doc.view_pages,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_pages","WorkbookLanguage":"en"}
whatsnew=doc.view_history,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null,"VERSION":null},"ListObjectName":"view_history","WorkbookLanguage":"en"}
diagrams=doc.view_diagrams,doc.view_query_list,False,$B$3,,{"Parameters":{"DIAGRAM_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_diagrams","WorkbookLanguage":"en"}
database_objects=doc.view_objects,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null,"VERSION":null},"ListObjectName":"view_objects","WorkbookLanguage":"en"}
table_columns=doc.view_table_columns,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_table_columns","WorkbookLanguage":"en"}
view_columns=doc.view_view_columns,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_view_columns","WorkbookLanguage":"en"}
routine_parameters=doc.view_routine_parameters,doc.view_query_list,False,$B$3,,{"Parameters":{"ROUTINE_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_routine_parameters","WorkbookLanguage":"en"}
routine_columns=doc.view_routine_columns,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_routine_columns","WorkbookLanguage":"en"}
orphan_rows=doc.view_orphan_rows,doc.view_query_list,False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"LANGUAGE_NAME":null},"ListObjectName":"view_orphan_rows","WorkbookLanguage":"en"}
translations=doc.view_translations,(Default),False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"COLUMN_NAME":null,"LANGUAGE_NAME":null},"ListObjectName":"translations","WorkbookLanguage":"en"}
translation_pivot=doc.usp_translations,(Default),False,$B$3,,{"Parameters":{"field":"TRANSLATED_NAME"},"ListObjectName":"translation_pivot","WorkbookLanguage":"en"}
objects=doc.objects,(Default),False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null},"ListObjectName":"objects","WorkbookLanguage":"en"}
handlers=doc.handlers,(Default),False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null,"EVENT_NAME":null},"ListObjectName":"handlers","WorkbookLanguage":"en"}
workbooks=doc.workbooks,(Default),False,$B$3,,{"Parameters":{"TABLE_SCHEMA":null},"ListObjectName":"workbooks","WorkbookLanguage":"en"}', N'doc');

INSERT INTO doc.help_sections (ID, SECTION) VALUES (1, N'Objects');
INSERT INTO doc.help_sections (ID, SECTION) VALUES (2, N'Schemas');
INSERT INTO doc.help_sections (ID, SECTION) VALUES (3, N'Roles');
INSERT INTO doc.help_sections (ID, SECTION) VALUES (4, N'Diagrams');
INSERT INTO doc.help_sections (ID, SECTION) VALUES (5, N'Pages');
INSERT INTO doc.help_sections (ID, SECTION) VALUES (6, N'Properties');

INSERT INTO doc.history_sections (ID, SECTION) VALUES (1, N'Version Title');
INSERT INTO doc.history_sections (ID, SECTION) VALUES (2, N'Announcements');
INSERT INTO doc.history_sections (ID, SECTION) VALUES (3, N'New Features');
INSERT INTO doc.history_sections (ID, SECTION) VALUES (4, N'Improvements');
INSERT INTO doc.history_sections (ID, SECTION) VALUES (5, N'Bug Fixes');

GO

EXEC doc.xl_import_help 6, N'logs', N'disabled', NULL, N'en', NULL, NULL, N'yes';
EXEC doc.xl_import_help 6, N'doc',  N'disabled', NULL, N'en', NULL, NULL, N'yes';
EXEC doc.xl_import_help 6, N'xls',  N'disabled', NULL, N'en', NULL, NULL, N'yes';
GO

CREATE ROLE doc_readers;
GO
CREATE ROLE doc_writers;
GO

EXEC doc.xl_actions_set_role_permissions;
GO

print 'Database Help Framework installed'

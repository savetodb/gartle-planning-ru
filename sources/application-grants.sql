-- The example workbooks use these usernames
-- We recommend leaving the test usernames as is

CREATE USER pa_admin_01 FOR LOGIN pa_admin_01 WITH DEFAULT_SCHEMA=xls25;
GO

CREATE USER pa_analyst_01 FOR LOGIN pa_analyst_01 WITH DEFAULT_SCHEMA=xls25;
GO

CREATE USER pa_developer_01 FOR LOGIN pa_developer_01 WITH DEFAULT_SCHEMA=dbo25;
GO

CREATE USER pa_user_01 FOR LOGIN pa_user_01 WITH DEFAULT_SCHEMA=xls25;
GO

CREATE USER pa_user_101 FOR LOGIN pa_user_101 WITH DEFAULT_SCHEMA=xls25;
GO

CREATE USER pa_user_201 FOR LOGIN pa_user_201 WITH DEFAULT_SCHEMA=xls25;
GO

CREATE USER pa_user_301 FOR LOGIN pa_user_301 WITH DEFAULT_SCHEMA=xls25;
GO

CREATE USER pa_user_401 FOR LOGIN pa_user_401 WITH DEFAULT_SCHEMA=xls25;
GO


IF DATABASE_PRINCIPAL_ID('planning_app_admins') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_admins', N'pa_admin_01';

IF DATABASE_PRINCIPAL_ID('planning_app_analysts') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_analysts', N'pa_analyst_01';

IF DATABASE_PRINCIPAL_ID('planning_app_developers') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_developers', N'pa_developer_01';

IF DATABASE_PRINCIPAL_ID('planning_app_users') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_users', N'pa_user_01';

IF DATABASE_PRINCIPAL_ID('planning_app_users') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_users', N'pa_user_101';

IF DATABASE_PRINCIPAL_ID('planning_app_users') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_users', N'pa_user_201';

IF DATABASE_PRINCIPAL_ID('planning_app_users') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_users', N'pa_user_301';

IF DATABASE_PRINCIPAL_ID('planning_app_users') IS NOT NULL
    EXEC sp_addrolemember N'planning_app_users', N'pa_user_401';


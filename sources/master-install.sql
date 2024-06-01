USE master;
GO

CREATE LOGIN pa_admin_01 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO

CREATE LOGIN pa_analyst_01 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO

CREATE LOGIN pa_developer_01 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO

CREATE LOGIN pa_user_01 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO

CREATE LOGIN pa_user_101 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO

CREATE LOGIN pa_user_201 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO

CREATE LOGIN pa_user_301 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO

CREATE LOGIN pa_user_401 WITH PASSWORD=N'Usr_2011#_Xls4168';
GO


CREATE USER pa_admin_01 FOR LOGIN pa_admin_01 WITH DEFAULT_SCHEMA=dbo;
GO

CREATE USER pa_analyst_01 FOR LOGIN pa_analyst_01 WITH DEFAULT_SCHEMA=dbo;
GO

CREATE USER pa_developer_01 FOR LOGIN pa_developer_01 WITH DEFAULT_SCHEMA=dbo;
GO

CREATE USER pa_user_01 FOR LOGIN pa_user_01 WITH DEFAULT_SCHEMA=dbo;
GO

CREATE USER pa_user_101 FOR LOGIN pa_user_101 WITH DEFAULT_SCHEMA=dbo;
GO

CREATE USER pa_user_201 FOR LOGIN pa_user_201 WITH DEFAULT_SCHEMA=dbo;
GO

CREATE USER pa_user_301 FOR LOGIN pa_user_301 WITH DEFAULT_SCHEMA=dbo;
GO

CREATE USER pa_user_401 FOR LOGIN pa_user_401 WITH DEFAULT_SCHEMA=dbo;
GO


-- The example workbooks use these logins and passwords
-- We recommend leaving the logins and passwords as is

-- Use this code to disable logins later

ALTER LOGIN pa_admin_01       DISABLE;
ALTER LOGIN pa_analyst_01     DISABLE;
ALTER LOGIN pa_developer_01   DISABLE;
ALTER LOGIN pa_user_01        DISABLE;
ALTER LOGIN pa_user_101       DISABLE;
ALTER LOGIN pa_user_201       DISABLE;
ALTER LOGIN pa_user_301       DISABLE;
ALTER LOGIN pa_user_401       DISABLE;

-- Use this code to enable logins

ALTER LOGIN pa_admin_01       ENABLE;
ALTER LOGIN pa_analyst_01     ENABLE;
ALTER LOGIN pa_developer_01   ENABLE;
ALTER LOGIN pa_user_01        ENABLE;
ALTER LOGIN pa_user_101       ENABLE;
ALTER LOGIN pa_user_201       ENABLE;
ALTER LOGIN pa_user_301       ENABLE;
ALTER LOGIN pa_user_401       ENABLE;

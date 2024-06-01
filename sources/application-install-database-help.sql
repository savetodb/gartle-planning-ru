EXEC doc.xl_import_help 2, N'schemas', N'doc', NULL, N'en', N'2.1', N'The schema contains Database Help Framework tables, views, and procedures.', N'Database Help Framework has two roles, doc_readers and doc_writers, which include required permission on object levels.';
EXEC doc.xl_import_help 3, N'roles', N'doc_readers', NULL, N'en', N'2.1', N'The role includes permissions to read the database documentation.', N'Assign this role to users who can read the documentation.

See actual database permissions in the doc.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 3, N'roles', N'doc_writers', NULL, N'en', N'2.1', N'The role includes permissions to read and write the database documentation.', N'Assign this role to users who can write the documentation.

See actual database permissions in the doc.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 2, N'schemas', N'xls', NULL, N'en', N'9.5', N'The schema contains SaveToDB Framework tables, views, and procedures.', N'Members of the xls_users role have permissions to select the configuration.

Members of the xls_developers role have permissions to update the configuration.

Members of the xls_admins role have permissions to check and update the permissions of other users.';
EXEC doc.xl_import_help 3, N'roles', N'xls_developers', NULL, N'en', N'9.5', N'The role includes permissions for Excel application developers.', N'Assign this role to developers and advanced users who can customize Excel applications.

Members of this role have permissions to read and write the configuration of the SaveToDB Framework used to configure SaveToDB add-in features.

See actual database permissions in the xls.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 3, N'roles', N'xls_users', NULL, N'en', N'9.5', N'The role includes permissions for Excel application users.', N'Assign this role to end-users of Excel applications.

Members of this role have permissions to read the configuration of the SaveToDB Framework used to configure SaveToDB add-in features.

See actual database permissions in the xls.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 3, N'roles', N'xls_formats', NULL, N'en', N'9.5', N'The role includes permissions for saving Excel table formats.', N'Assign this role to end-users of Excel applications to allow saving Excel table formats into the xls.formats table.

Users may use SaveToDB Table Format Wizard or the Save Table Format menu item to save formats.

Members of the xls_developers role have this permission by default.
See actual database permissions in the xls.xl_actions_set_role_permissions procedure.

This role was added in SaveToDB Framework 8.11.';
EXEC doc.xl_import_help 3, N'roles', N'log_administrators', NULL, N'en', N'2.0', N'The role includes permissions to use customize tracking features.', N'Assign this role to users who can create and drop triggers and clear change tracking logs.

See actual database permissions in the logs.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 3, N'roles', N'log_users', NULL, N'en', N'3.1', N'The role includes permissions to use change tracking features.', N'Assign this role to business users who use the change tracking functions.

See actual database permissions in the logs.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 2, N'schemas', N'logs', NULL, N'en', N'3.1', N'The schema contains Change Tracking Framework tables, views, and procedures.', N'The schema contains objects used by the application, users, and administrators.

See actual permissions in the logs.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 01', N'https://static.savetodb.com/images/help/planning-app/diagram-01-application-architecture.png', N'en', N'4.0', N'Application Architecture', N'The application has the following logic blocks:

- Master data
- Calculation rules
- Source cube
- String values
- Calculated cube
- Form settings
- Forms
- User permissions
- Tracking changes

Master data include dimensions, dimension members and its properties.

The application creates calculation rules to calculate aggregates based on master data and source cube.

The source cube contains number data entered by users or loaded from external systems.

The block of string values contains string values entered by users. The application does not aggregate such values.

The calculated cube allows getting the source and aggregated data in forms.

Form settings define available forms including their layouts, rows, columns, page data, and parameters.

The Forms block is an engine that executes configured forms to allow getting data and saving data back to a database.

User permissions is a block that allows managing user permissions on forms and dimension members.

Tracking changes is an optional block implemented with the Change Tracking Framework.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 02', N'https://static.savetodb.com/images/help/planning-app/diagram-02-master-data.png', N'en', N'4.0', N'Master Data', N'The master data includes:

- Currencies and units in the dbo25.units table;
- Tax rates in the dbo25.tax_rates table;
- Dimensions in the dbo25.dimensions table;
- Dimension members in the dbo25.members table;
- Dimension member parents in the dbo25.parents table.

Use the following procedures to edit master data:
xls25.usp_units, xls25.usp_tax_rates, xls25.usp_dimensions, xls25.usp_members.

The dbo25.calc_types and dbo25.name_formats table contains application defined values.

The dbo25.dimensions table contains seven dimensions.
The first four (Accounts, Times, Categories, and Entities) have specific built-in support and must be active.
Analysts may activate or deactivate the last three dimensions, and change their meaning.

Adding additional dimensions requires changes in the application code.

The dbo25.members table contains members of all dimensions.
It contains columns of the member calculation and display properties.

The application supports multiple hierarchies. Each member can have multiple parents.
The dbo25.parents table contains such relations.
The application allows editing parents and its factors using the xls25.usp_members procedure.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 03', N'https://static.savetodb.com/images/help/planning-app/diagram-03-calculation-rules.png', N'en', N'4.0', N'Calculation Rules', N'Based on child-parent relations, calculation type, and previous periods,
the xls25.xl_actions_update_hierarchies procedure updates the dbo25.factors table.

This table is used to calculate aggregates and balances.

For example, for member parents A1 - A2 and A2 - A3 the factor table contains  A1 - A2, A2 - A3, and A1 - A3.

Use the xls25.view_hierarchies view to check the generated rules.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 04', N'https://static.savetodb.com/images/help/planning-app/diagram-04-member-hierarhies.png', N'en', N'4.0', N'Member Hierarchies', N'Based on child-parent relations, the xls25.xl_actions_update_hierarchies procedure also updates the dbo25.hierarchies table.

This table is used to select members of the specified parent in forms.

For example, for member parents A1 - A2 and A2 - A3 the hierarchy table contains  A1 - A1, A2 - A2, A3 - A3, A1 - A2, A2 - A3, and A1 - A3.

Use the xls25.view_hierarchies view to check the generated rules.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 05', N'https://static.savetodb.com/images/help/planning-app/diagram-05-string-values.png', N'en', N'4.0', N'String Values', N'The application stores string values in the dbo25.strings table.

The application does not aggregate such values.
So, it stores values for members at any hierarchy level.

The dbo25.strings table contains member id values in columns id1-id7.

If the dimension is not active, its column contains the dbo25.dimensions.default_member_id value.

To store string values, specify the string calculation type of the target account (dimension 1).';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 06', N'https://static.savetodb.com/images/help/planning-app/diagram-06-source-cube.png', N'en', N'4.0', N'Source Cube', N'The application stores number values in the dbo25.facts table.

The dbo25.facts table contains member id values in columns id1-id7.

If the dimension is not active, its column contains the dbo25.dimensions.default_member_id value.

The table contains source values of the user input, in the account currency or unit, in the source_value column.

The application calculates the cube values, in the system currency or base unit, and updates the value column  immediately on input.

It uses the dbo25.currency_rates table values for currency accounts and just a dbo25.units.factor value for other accounts.

Use the xls25.xl_actions_update_facts procedure to update cube values after currency rate changes.

Note that the application uses hard-coded dimension id values:

1 - Accounts
2 - Times
3 - Categories
4 - Entities';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 07', N'https://static.savetodb.com/images/help/planning-app/diagram-07-calculated-cube.png', N'en', N'4.0', N'Calculated Cube', N'The application calculates aggregates and balances on the fly.

It uses the source and calculated cube values of the dbo25.facts table and calculation relations and factors from the dbo25.factors table.

You may use the code of the dbo25.view_facts view to learn the calculation rules.

The application uses the dbo25.members.previous_period_id and dbo25.member.same_period_id fields to select values of the referred periods.

Also, the forms output Excel formulas as is. Such values are calculated in Microsoft Excel.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 08', N'https://static.savetodb.com/images/help/planning-app/diagram-08-form-layouts.png', N'en', N'4.0', N'Form Layouts', N'The application allows creating any number of forms in the dbo25.forms table.

Analysts have to define the form layouts including:

- the dimension axis (row, column, page),
- the dimension order in the axis (header_order),
- and the parameter order at the ribbon (parameter_index).

Analysts may test any form using the xls25.usp_run_form and xls25.usp_run_offline_form procedures.

End users use the inherited forms with the predefined sets of the parameters.

They have to use the xls25.view_query_list_forms and xls25.view_query_list_offline_forms views in the SaveToDB Connection Wizard.

By default, the application shows child members of the dbo25.dimensions.root_member_id member in the parameters and axes.

Analysts may configure member lists using the feature described below.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 09', N'https://static.savetodb.com/images/help/planning-app/diagram-09-form-rowsets-and-parameters.png', N'en', N'4.0', N'Form Rowsets and Parameters', N'Analysts may customize member lists for parameters, rows, and columns.

The fist option is to redefine dbo25.form_dimensions.root_member_id.

For example, you may set the "Sales" account as a parent for the "Sales" form.

The second option is to limit a member list in parameters by levels using the parameter_start_level and parameter_end_level parameters.

For example, the time dimension has a hierarchy: Times - Years - Year - Month.
If you need to show only years in the parameter, set Years as a root_member_id and 1 as parameter_start_level and parameter_end_level.

You may use the same technique for rows and columns.
Just use the form_start_level and form_end_level parameters instead.

For example, to show years only in columns, set Years as a root_member_id and 1 as form_start_level and form_end_level parameters.

And the final option is to define a member list completely manually.

Use it, for example, if you need to have selected rows from multiple hierarchies, add empty lines, or change codes, names, or Excel look of members.

To do this, create a member with calc_type_id = 9 (rowset) and add rows into the dbo25.form_rows table (you copy and paste rows in Excel).
Then rewrite any property of the underlying member in the row.

The application shows rowsets in the ribbon parameters automatically.
If you need to use the rowset only and to disable other options, set the rowset as the root_member_id value and clear the parameter_index value.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 10', N'https://static.savetodb.com/images/help/planning-app/diagram-10-member-relations.png', N'en', N'4.0', N'Member Relations', N'The dbo25.member_relations table contains relations between members of different dimensions.

The first use case is eliminating rows in forms.

For example, the "Sales" account is not applicable for all entities.
So, you may set the select_permission to 0 for such pairs of the account and the required entities.

The second case is disabling data changes, for example,  for closed periods.

In this case, you may set the update_permission to 0 for the pair of time and category members.

These settings are common for all users of the application.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 11', N'https://static.savetodb.com/images/help/planning-app/diagram-11-member-permissions.png', N'en', N'4.0', N'Member Permissions', N'The dbo25.member_permissions table contains user permissions for dimension members.

Administrators (members of the planning_app_administrators role) may allow:
- reading (select_permission = 1, update_permission = 0),
- reading and writing (select_permission = 1, update_permission = 1),
or deny reading and writing (select_permission = 0, update_permission = 0).

These modes have mnemonic letters R, W, and D accordingly.

When an administrator sets the permission, the application applies it to children also with the is_inherited = 1 flag.

For example, if the administrator disables the "Sales" account, the user will not have access to the child members of the "Sales" account also.

The administrator can set different permissions for children in this case.
Such direct child permissions have a higher priority.

Analysts and developers may enable or disable verifying permissions using the dbo25.dimensions.is_protected field.

Also, analysts may define the default permissions for dimension members in the dbo25.dimensions table.

The application uses the USER_NAME() function to get the username.

The application checks the permissions for members of the planning_app_users role only.
So, the developers and analysts always see the complete sets of members.

The application does not implement permission management by roles.';
EXEC doc.xl_import_help 4, N'dbo25', N'Diagram 12', N'https://static.savetodb.com/images/help/planning-app/diagram-12-form-permissions.png', N'en', N'4.0', N'Form Permissions', N'The dbo25.form_permissions table contains user permissions on forms.

The application does not allow executing disabled forms and does not show such forms
in the xls25.view_query_list_forms and xls25.view_query_list_offline_forms views used in the SaveToDB Connection Wizard.

The application uses the USER_NAME() function to get the username.

The application checks the permissions for members of the planning_app_users role only.
So, the developers and analysts always see the complete sets of forms.

The application does not implement permission management by roles.';
EXEC doc.xl_import_help 5, N'dbo25', N'introduction', NULL, N'en', NULL, N'Introduction to Gartle Planning', N'Gartle Planning is a ready-to-use planning application.

It uses Microsoft SQL Server as a back-end and allows using Microsoft Excel with the SaveToDB add-in, DBEdit desktop application, and DBGate and ODataDB web applications as clients.

Key features:

- Multiple companies or separate departments in a single database.
- Customizable dimensions and dimension members;
- Customizable calculation rules with multiple hierarchies;
- Customizable input forms and reports;
- Built-in permission management;
- Built-in change tracking.

Here is an example of a customizable form:

![Planning Application - Form Example](https://static.savetodb.com/images/help/planning-app/gartle-planning-railway-corp-reports.png)

You may download sample workbooks at [www.savetodb.com](https://www.savetodb.com/download.htm) and try the application hosted online.

Also, you may try Gartle Planning with the DBGate and ODataDB web applications:

- https://dbgate.savetodb.com/en-us/planning-app.htm
- https://odatadb.savetodb.com/en-us/planning-app.htm

Feel free to contact us.
We can deploy a copy for you in the cloud to test and configure the app.
Later we can export your data to deploy it in your environment.
';
EXEC doc.xl_import_help 3, N'roles', N'planning_app_administrators', NULL, N'en', N'1.0', N'The role includes permissions for planning application administrators.', N'Assign this role to users who manage business user permissions.

This role members have permissions to execute permission management forms and procedures and do not have permissions to execute business reports.

See actual database permissions in the dbo25.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 3, N'roles', N'planning_app_analysts', NULL, N'en', N'4.0', N'The role includes permissions for planning application analysts.', N'Assign this role to users who configure dimensions, members, reports, and other business-related objects.

This role members have full control over any business-related objects and do not have permissions to manage user permissions and change the application configuration.

See actual database permissions in the dbo25.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 3, N'roles', N'planning_app_developers', NULL, N'en', N'4.0', N'The role includes permissions for planning application developers.', N'Assign this role to users who configure or develop the application.

This role members have full read and write permissions on any object in the dbo25 and xls25 schemas.

See actual database permissions in the dbo25.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 3, N'roles', N'planning_app_users', NULL, N'en', N'4.0', N'The role includes permissions for planning application users.', N'Assign this role to business users who work with configured forms only.

This role members may have additional restrictions configured at the application level.

Do not assign this role to users that are members of the roles listed above.

See actual database permissions in the dbo25.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 2, N'schemas', N'dbo25', NULL, N'en', N'4.0', N'The schema contains data tables and technical views and procedures of the planning application.', N'Administrators and developers have select permissions on views and execute permissions on stored procedures.

There is no direct access to application tables.';
EXEC doc.xl_import_help 2, N'schemas', N'xls25', NULL, N'en', N'4.0', N'The schema contains end-user views and stored procedures used in the Excel planning application.', N'Business users have access to a limited set of schema objects.

See default permissions in the dbo25.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', NULL, N'en', N'2.0', N'This system table contains axis types.', N'Do not add or delete rows. Do not change the id values.';
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', NULL, N'en', N'2.0', N'This system table contains calculation types.', N'Do not add or delete rows. Do not change the id values.';
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', NULL, N'en', N'2.5', N'This user table contains currency rates.', N'The application calculates dbo25.facts.value values using the dbo25.facts.source_value values and currency rates.

Use the xls25.usp_rates procedure to select and edit currency rates.

Use the xls25.xl_actions_update_facts procedure to recalculate facts after  currency rate changes.';
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_calc_types', NULL, N'en', N'2.0', N'This system table contains available dimension calculation types.', N'Do not add or delete rows. The table contains all the available settings.

Change is_active to activate or deactivate calculation types.';
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', NULL, N'en', N'4.0', N'This system table contains dimensions.', N'This table contains default settings of dimensions.
The company-related settings are stored in dbo25.dimension_properties.

The application has seven built-in dimensions. Adding more dimensions requires application changes.

The first four dimensions (Accounts, Times, Categories, and Entities) have built-in business logic. Do not deactivate them and keep their meaning.';
EXEC doc.xl_import_help 1, N'dbo25', N'factors', NULL, N'en', N'2.0', N'This application table contains calculation factors for child-parent relations.', N'The application uses this table to calculate aggregated cube values.

Use the xls25.xl_actions_update_hierarchies procedure to update this table.
Do not change the table data manually.

Use the xls25.view_hierarchies view to select factors.';
EXEC doc.xl_import_help 1, N'dbo25', N'facts', NULL, N'en', N'2.0', N'This application table contains source cube number values.', N'Fields id1-id7 must have member id values. The application uses the dbo25.dimensions.default_member_id field value for inactive dimensions.

The application keeps the uniqueness of id1-id7 key values programmatically.

Use the dbo25.view_data view to select the table data.
Use the dbo25.view_facts view to select the calculated cube data.

Use the xls25.xl_actions_update_facts procedure to recalculate cube values after currency rate changes.';
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', NULL, N'en', N'2.0', N'This user table contains form dimension properties.', N'This table contains dimension settings for forms executed with the xls25.usp_run_form and xls25.usp_run_offline_form procedures.

Use the xls25.usp_form_dimensions procedure to select and edit settings in Microsoft Excel.';
EXEC doc.xl_import_help 1, N'dbo25', N'form_permissions', NULL, N'en', N'2.0', N'This user table contains form select permissions by users.', N'The application applies these form permissions for users of the planning_app_users role only.

Use the xls25.usp_form_permissions procedure to select and edit permissions in Microsoft Excel.';
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', NULL, N'en', N'2.0', N'This user table contains rows of the custom form rowsets.', N'You may create custom form rowsets for any dimension.

Just add a new member to the dbo25.members table and specify the Rowset calculation type. Then specify form rows in this table.

You may specify a member and replace its values to change the member row look in Microsoft Excel.

The application selects the decimal_places, is_percent, row_color, row_bold, and row_indent fields as is.
So, you may customize the form look in Excel using the conditional formatting.

Use the xls25.usp_form_rows procedure to select and edit rows in Microsoft Excel.';
EXEC doc.xl_import_help 1, N'dbo25', N'form_subtotals', NULL, N'en', N'2.2', N'This user table contains form subtotal settings.', N'The forms may have up to three dimensions in rows.

The application shows subtotals for every dimension automatically.
Using this table, you may hide subtotals that you do not need.

For example, the form shows accounts ("Sales"), customers, and products. To disable all subtotals, specify the account, customer, and product dimensions in the columns.

To disable specific member subtotals, specify the dimension member.
You may create several rows to combine conditions.

Use the xls25.usp_form_subtotals procedure to select and edit subtotal settings in Microsoft Excel.';
EXEC doc.xl_import_help 1, N'dbo25', N'forms', NULL, N'en', N'4.0', N'This user table contains a list of forms.', N'You may create and customize any number of editable forms with zero coding.

The SaveToDB add-in shows such forms in the ribbon Query List when you select the xls25.view_query_list_forms or xls25.view_query_list_offline_forms views in the Connection Wizard.

Analysts may add new forms anytime. Users should just update the ribbon Query List.

The application uses the xls25.usp_run_form and xls25.usp_run_offline_form procedures to run forms.';
EXEC doc.xl_import_help 1, N'dbo25', N'hierarchies', NULL, N'en', N'2.0', N'This application table contains child-parent relations.', N'The application uses this table to select hierarchies and detect levels between related members.

Use the xls25.xl_actions_update_hierarchies procedure to update this table. Do not change the table data manually.

Use the xls25.view_hierarchies view to select the table data.';
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', NULL, N'en', N'2.0', N'This application table contains member permissions by users.', N'The application applies these member permissions for users of the planning_app_users role only.

The application updates this table programmatically. Do not edit it manually.

Use the xls25.usp_member_permissions procedure to select and edit permissions in Microsoft Excel.';
EXEC doc.xl_import_help 1, N'dbo25', N'member_relations', NULL, N'en', N'2.0', N'This application table contains select and update permissions for cross-dimension members.', N'This table allows eliminating form rows for pairs of different dimension members.
For example, you may exclude certain accounts for certain entities.

Use the xls25.usp_member_relations procedure to edit relation permissions.

Also, this table allows disabling updating data for the desired pairs.
The most common case is closing the period for changes for the specified category.
To close periods, use the xls25.usp_closed_periods procedure.';
EXEC doc.xl_import_help 1, N'dbo25', N'members', NULL, N'en', N'4.0', N'This user table contains dimension members.', N'Use the xls25.usp_members procedure to select and edit dimension members in Microsoft Excel.

Do not use spaces in member codes.';
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', NULL, N'en', N'2.0', N'This system table contains variants of displaying members.', N'You may change the display format at any time.
Reload data and configuration in Microsoft Excel to reload ribbon parameters and validation lists with new values.

Do not add or delete rows. Do not change the id values.';
EXEC doc.xl_import_help 1, N'dbo25', N'parents', NULL, N'en', N'2.0', N'This application table contains source factors for child-parent relations.', N'This table contains source input values.

The xls25.xl_actions_update_hierarchies procedure updates the dbo25.hierarchies table used in forms. Execute it after each change to update related factors and hierarchies.

Use the xls25.usp_members form to set member parents.
You may check child-parent pairs using the xls25.view_hierarchies view.';
EXEC doc.xl_import_help 1, N'dbo25', N'strings', NULL, N'en', N'2.0', N'This application table contains source string values.', N'To allow input string values, set the account member calculation type as String.

The application does not "aggregate" string values for parents.
So, the table may contain source values for any level of the hierarchy, unlike the dbo25.facts table that contains values for children only.

Fields id1-id7 must have member id values. The application uses the dbo25.dimensions.default_member_id field value for inactive dimensions.

The application keeps the uniqueness of id1-id7 key values programmatically.

Use the dbo25.view_strings view to select the table data.';
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', NULL, N'en', N'2.0', N'This user table contains tax rates.', N'The application shows tax rates for informational purposes only and does not use the values for calculation.

Use separate accounts with appropriate parent factors to calculate taxes.

You may add the required tax rate members in this table directly.';
EXEC doc.xl_import_help 1, N'dbo25', N'units', NULL, N'en', N'2.0', N'This user table contains units.', N'This table is an important part of the calculations.
Add and configure its members in the first steps.

The member with id 0 is the system currency used to calculate values of the dbo25.facts.value column.

You may change the system currency using the xls25.xl_actions_set_system_currency procedure (from the context menu in Excel).

Use the xls25.usp_units form to edit and customize units.';
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', NULL, N'en', N'4.0', N'This view selects the calculated facts.', N'This is a system view used by xls25.usp_facts.';
EXEC doc.xl_import_help 1, N'dbo25', N'view_query_list', NULL, N'en', N'4.0', N'This view selects developer objects for the SaveToDB Connection Wizard and SaveToDB Query List.', N'The view filters output of the SaveToDB Framework xls.queries view to show planning application objects only.

See also [Configuring Query Lists](https://www.savetodb.com/dev-guide/query-lists.htm).';
EXEC doc.xl_import_help 1, N'xls25', N'xl_formats', NULL, N'en', N'4.0', N'This view selects table formats of the forms configured in dbo25.forms.', N'This view selects table formats of the configured forms for the SaveToDB add-in.

It uses the format of xls25.usp_run_form for every form that has no format.

Use the SaveToDB [Table Format Wizard](https://www.savetodb.com/savetodb/wizard-table-format.htm) to save table formats.

See also [Configuring Table Formats](https://www.savetodb.com/dev-guide/table-formats.htm).';
EXEC doc.xl_import_help 1, N'xls25', N'xl_handlers', NULL, N'en', N'4.0', N'This view selects the handler configuration of the forms configured in dbo25.forms.', N'This view selects event handler configurations of the configured forms for the SaveToDB add-in.

See also [Configuring Event Handlers](https://www.savetodb.com/dev-guide/xls-handlers.htm).';
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', NULL, N'en', N'4.0', N'This view selects member parents, factors, and hierarchies.', N'Use this view to check member relation properties generated by the application.';
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list', NULL, N'en', N'4.0', N'This view selects user objects for the SaveToDB Connection Wizard and SaveToDB Query List.', N'The view filters output of the SaveToDB Framework xls.queries view.

See also [Configuring Query Lists](https://www.savetodb.com/dev-guide/query-lists.htm).';
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', NULL, N'en', N'4.0', N'This view selects user forms for the SaveToDB Connection Wizard and SaveToDB Query List.', N'Use this view to connect to configured forms in the SaveToDB Data Connection Wizard in the business user workbooks.

The forms of this list use cell change event handlers to update the underlying cube values. So, this feature requires the SaveToDB Enterprise edition.

This view shows configured forms with actual select permissions.

See also [Configuring Query Lists](https://www.savetodb.com/dev-guide/query-lists.htm).';
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', NULL, N'en', N'4.0', N'This view selects offline user forms for the SaveToDB Connection Wizard and SaveToDB Query List.', N'Use this view to connect to configured forms in the SaveToDB Data Connection Wizard in the business user workbooks.

The forms of this list use edit procedures to update the underlying cube values. Users must click the Save button to save changes.

This feature works with the SaveToDB Standard edition.

This view shows configured forms with actual select permissions.

See also [Configuring Query Lists](https://www.savetodb.com/dev-guide/query-lists.htm).';
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', NULL, N'en', N'4.0', N'This view selects translations of the forms configured in dbo25.forms.', N'This view selects translations of the configured forms for the SaveToDB add-in.

See also [Configuring Data Translation](https://www.savetodb.com/dev-guide/translating-data-and-ui.htm).';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_all', NULL, N'en', N'4.0', N'This procedure exports all data.', N'It calls other export procedures in the right order to prepare the complete import SQL script.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_currency_rates', NULL, N'en', N'4.0', N'This procedure exports currency rates.', N'Source table: dbo25.currency_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_dimensions', NULL, N'en', N'4.0', N'This procedure exports dimensions.', N'Source table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_facts', NULL, N'en', N'4.0', N'This procedure exports source numbers.', N'Source table: dbo25.facts';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_forms', NULL, N'en', N'4.0', N'This procedure exports forms and form settings.', N'Source table: dbo25.forms';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_members', NULL, N'en', N'4.0', N'This procedure exports members.', N'Source tables: dbo25.members, dbo25.parents, dbo25.member_relations, dbo25.member_permissions.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_strings', NULL, N'en', N'4.0', N'This procedure exports source strings.', N'Source table: dbo25.strings';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_tax_rates', NULL, N'en', N'4.0', N'This procedure exports tax rates.', N'Source table: dbo25.tax_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_units', NULL, N'en', N'4.0', N'This procedure exports units.', N'Source table: dbo25.units';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_clear_all_data', NULL, N'en', N'4.0', N'This procedure clears all data before importing data.', N'You may clear all the data to create a complete copy of the exported application.

The procedure does not delete dimensions.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_currency_rates', NULL, N'en', N'4.0', N'This procedure imports currency rates.', N'Target table: dbo25.currency_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', NULL, N'en', N'4.0', N'This procedure imports dimensions.', N'Target table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_calc_types', NULL, N'en', N'4.0', N'This procedure imports calculation types by dimensions.', N'Target table: dbo25.dimension_calc_types';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', NULL, N'en', N'4.0', N'This procedure imports dimension properties.', N'Target table: dbo25.dimensions

Call this procedure after importing dimension members.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', NULL, N'en', N'4.0', N'This procedure imports source numbers.', N'Target table: dbo25.facts

The procedure sets the same value into the value and source_value fields.
Use the xls25.xl_actions_update_facts procedure to calculate values that depend on unit factors and currency rates.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_forms', NULL, N'en', N'4.0', N'This procedure imports forms.', N'Target table: dbo25.forms';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', NULL, N'en', N'4.0', N'This procedure imports form dimension properties.', N'Target table: dbo25.form_dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_permissions', NULL, N'en', N'4.0', N'This procedure imports form permissions.', N'Target table: dbo25.form_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', NULL, N'en', N'4.0', N'This procedure imports custom form rowsets.', N'Target table: dbo25.form_rows';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', NULL, N'en', N'4.0', N'This procedure imports form subtotal settings.', N'Target table: dbo25.form_subtotals';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', NULL, N'en', N'4.0', N'This procedure imports dimension members.', N'Target table: dbo25.members';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_parents', NULL, N'en', N'4.0', N'This procedure imports member parents.', N'Target table: dbo25.parents';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_permissions', NULL, N'en', N'4.0', N'This procedure imports member permissions.', N'Target table: dbo25.member_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_properties', NULL, N'en', N'4.0', N'This procedure imports member properties.', N'Target table: dbo25.members';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_relations', NULL, N'en', N'4.0', N'This procedure imports member relations.', N'Target table: dbo25.member_relations';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', NULL, N'en', N'4.0', N'This procedure imports source strings.', N'Target table: dbo25.strings';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_tax_rates', NULL, N'en', N'4.0', N'This procedure imports tax rates.', N'Target table: dbo25.tax_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', NULL, N'en', N'4.0', N'This procedure imports units.', N'Target table: dbo25.units';
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_members', NULL, N'en', N'4.0', N'This procedure creates standard dimension members.', N'Use it to initialize the empty cube.

The procedure uses the dbo25.get_standard_members function to select standard members.';
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_set_role_permissions', NULL, N'en', N'4.0', N'This procedure grants permissions to the planning application roles.', N'Execute this procedure if you recreated any table of the dbo25 schema.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_calc_types', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing calculation types.', N'Underlying table: dbo25.calc_types';
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing closed periods.', N'Underlying table: dbo25.member_relations

Editing data requires the SaveToDB Enterprise edition.

Example:

![Planning Application - Closed Periods](https://static.savetodb.com/images/planning-app/excel-admin-closed-periods.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods_change', NULL, N'en', N'4.0', N'This procedure updates a database on cell changes of xls25.usp_closed_periods.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing currency rates.', N'Use the xls25.xl_actions_update_facts procedure to recalculate facts after  currency rate changes.

Underlying table: dbo25.rates

Editing data requires the SaveToDB Enterprise edition.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates_change', NULL, N'en', N'4.0', N'This procedure updates a database on cell changes of xls25.usp_rates.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_data_management', NULL, N'en', N'4.0', N'This procedure is an Excel form for data management.', N'Use the Excel context menu to delete and copy data.

Underlying table: dbo25.facts

Actions: xls25.xl_actions_copy_data, xls25.xl_actions_delete_data

Example:

![Planning Application - Data Management](https://static.savetodb.com/images/planning-app/excel-data-management-context-menu.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing dimensions.', N'Underlying table: dbo25.dimensions

Example:

![Planning Application -Dimensions](https://static.savetodb.com/images/planning-app/dimensions-initial.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', NULL, N'en', N'4.0', N'This procedure checks user input on cell changes of xls25.usp_dimensions.', N'The procedure just checks the changes. It does not save any data.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_dimensions.', N'The procedure blocks deleting dimensions and raises an exception.
Use an SQL command to delete a dimension.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_dimensions.', N'The procedure blocks inserting dimensions and raises an exception.

Use an SQL command to insert a dimension.
However, note that you have to modify the application code also.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_dimensions.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing form dimension properties.', N'The form selects dbo25.forms cross dbo25.dimensions.

Underlying tables: dbo25.forms, dbo25.dimensions, dbo25.form_dimensions

Example:

![Planning Application - Form Dimensions](https://static.savetodb.com/images/planning-app/excel-forms-drop-down-lists.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_form_dimensions.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_form_dimensions.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_form_dimensions.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_permissions', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing form permissions.', N'Underlying table: dbo25.form_permisssions

Editing data requires the SaveToDB Enterprise edition.

Example:

![Planning Application - Form Permissions](https://static.savetodb.com/images/planning-app/excel-admin-form-permission.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_permissions_change', NULL, N'en', N'4.0', N'This procedure updates a database on cell changes of xls25.usp_form_permissions.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing form rowsets.', N'Note that you may create rowsets to use in rows and columns.

Underlying table: dbo25.form_rows

The following example shows configuring columns to compare budget vs. actuals:

![Planning Application - Form Rows](https://static.savetodb.com/images/planning-app/excel-rowsets-categories-all-fields.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_form_rows.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_form_rows.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_form_rows.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing a list of forms.', N'Underlying table: dbo25.forms

Example:

![Planning Application - Forms](https://static.savetodb.com/images/planning-app/excel-forms.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_forms.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_forms.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_forms.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing member permissions.', N'Underlying table: dbo25.member_permissions

Editing data requires the SaveToDB Enterprise edition.

Example:

![Planning Application - Member Permissions](https://static.savetodb.com/images/planning-app/excel-admin-member-permissions-drop-down.png)

Type "r", "w", or "d" to change permissions.

The application applies new permissions immediately after changes.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions_change', NULL, N'en', N'4.0', N'This procedure updates a database on cell changes of xls25.usp_member_permissions.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing member relations.', N'Underlying table: dbo25.member_relations

Editing data requires the SaveToDB Enterprise edition.

The example below shows the relations between accounts and regions:

![Planning Application - Member Relations](https://static.savetodb.com/images/planning-app/excel-relations-regions.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations_change', NULL, N'en', N'4.0', N'This procedure updates a database on cell changes of xls25.usp_member_relations.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing dimension members.', N'Use the Actions menu to add typical members.

After saving data click Actions, Update Hierarchies, then Reload, Reload Data and Configuration.
These actions update member hierarchies and reload new members into Microsoft Excel.

Underlying tables: dbo25.members, dbo25.parents

Actions: xls25.xl_actions_update_hierarchies

Example:

![Planning Application - Dimension Members](https://static.savetodb.com/images/planning-app/excel-accounts-update-hierarchies.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_members.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_members.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_members.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing rowset members.', N'The form shows members of the dbo25.members table with calc_type_id = 9 (rowset).

You may add new rowsets here.

Use the xls25.usp_form_rows procedure to edit rowset rows.

Underlying table: dbo25.members

The example below shows the rowsets of the time dimension that contains years only and quarters only:

![Planning Application - Rowsets](https://static.savetodb.com/images/planning-app/excel-rowsets.png)

We recommend adding the asterisk at the end of codes and names to distinguish rowsets from regular hierarchy members.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_rowsets.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_rowsets.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_rowsets.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', NULL, N'en', N'4.0', N'This procedure executes forms configured using dbo25.forms and dbo25.form_dimensions.', N'This procedure is a form engine.

It returns the form layout configured using the dbo25.forms, dbo25.form_dimenstions, dbo25.form_rows, and dbo25.form_subtotals tables.

The form may have up to three dimensions in rows and up to three in columns.
Other dimensions must have member id values at the ribbon.

Ribbon parameters are dynamic and configured using dbo25.form_dimensions.

The Excel form has the cell change handler, xls25.usp_run_form_change, that updates underlying data.

This form requires the SaveToDB Enterprise edition.

You may use the offline form, xls25.usp_run_offline_form, with the SaveToDB Standard edition.

This is the most complicated procedure. If you need new features, you may contact us.

Example:

![Planning Application - Budget Form](https://static.savetodb.com/images/planning-app/excel-user-forms-after-reload.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', NULL, N'en', N'4.0', N'This procedure updates a database on cell changes of xls25.usp_run_form.', N'Note that this feature is available in the SaveToDB Enterprise edition only.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_json_form', NULL, N'en', N'4.0', N'This procedure returns calculated cube data requested with JSON parameters.', N'You may use this procedure to create web forms.

See usage examples in the procedure code.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', NULL, N'en', N'4.0', N'This procedure executes forms configured using dbo25.forms and dbo25.form_dimensions.', N'This procedure is an offline form engine.

It calls xls25.usp_run_form internally and has the same output features.

However, it has a different saving configuration.

A user must click the Save button to save changes.
So, the user may edit data offline and save the changes when required.

Example:

![Planning Application - Offline Budget Form](https://static.savetodb.com/images/planning-app/excel-offline-user-forms.png)';
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_run_offline_form.', N'The procedure does nothing as users cannot delete the form rows.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_run_offline_form.', N'The procedure does nothing as users cannot add form rows.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_run_offline_form.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing units.', N'Use the Excel context menu to change the system currency (the unit with id 0).

Underlying table: dbo25.units

Example:

![Planning Application - Units](https://static.savetodb.com/images/planning-app/excel-units.png)';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_quarters', NULL, N'en', N'4.0', N'This procedure adds quarter members.', N'Use this procedure if you need only years and quarters but not months.

Target tables: dbo25.members, dbo25.parents';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_year', NULL, N'en', N'4.0', N'This procedure adds year members.', N'Use this procedure if you need years, quarters, and months.

Target tables: dbo25.members, dbo25.parents';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_copy_data', NULL, N'en', N'4.0', N'This procedure copies data from a category to category.', N'For example, you may use this procedure to copy BUDGET data to FORECAST, or just create a copy of the budget data.

The procedure does not copy string data.

Target table: dbo25.facts';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_data', NULL, N'en', N'4.0', N'This procedure deletes source cube data from a category.', N'Target tables: dbo25.facts, dbo25.strings';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_year', NULL, N'en', N'4.0', N'This procedure deletes year members.', N'Delete the cube data of the required year before deleting the members.

Target tables: dbo25.members, dbo25.parents';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', NULL, N'en', N'4.0', N'This procedure selects underlying cube data for a reporting cell.', N'This procedure is used in the Excel context menu to drill-down cell values.

Underlying table: dbo25.facts

Output example:

![Planning Application - Cell Drill-Down](https://static.savetodb.com/images/planning-app/dialog-drill-down.png)';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_set_functional_currency', NULL, N'en', N'4.0', N'This procedure changes the system currency of the application.', N'Target table: dbo25.units';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_update_facts', NULL, N'en', N'4.0', N'This procedure updates cube values after the currency rate changes.', N'Target table: dbo25.facts';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_update_hierarchies', NULL, N'en', N'4.0', N'This procedure updates the required tables after member changes.', N'Target tables: dbo25.hierarchies, dbo25.factors';
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_update_member_permissions', NULL, N'en', N'4.0', N'This procedure updates member permissions after member changes.', N'Target table: dbo25.member_permissions';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_0_or_1', NULL, N'en', N'4.0', N'This procedure selects 0 or 1 for Excel ribbon parameters.', N'Use this procedure in the xls.handlers table for parameters that accept 0 or 1 only.

You do not need to use for parameters with the bit datatype.
The SaveToDB add-in suggests 1 (yes) and 0 (no) values by default.';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_calc_type_id', NULL, N'en', N'4.0', N'This procedure selects calculation types for Excel ribbon parameters.', N'Underlying table: dbo25.calc_types';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_calc_type_id_or_null', NULL, N'en', N'4.0', N'This procedure selects calculation types for Excel ribbon parameters.', N'Underlying table: dbo25.calc_types';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_currency_id', NULL, N'en', N'4.0', N'This procedure selects currencies for Excel ribbon parameters.', N'Underlying table: dbo25.units';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_dimension_id', NULL, N'en', N'4.0', N'This procedure selects dimensions for Excel ribbon parameters.', N'Underlying table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_dimension_id_or_null', NULL, N'en', N'4.0', N'This procedure selects dimensions for Excel ribbon parameters.', N'Underlying table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_form_id', NULL, N'en', N'4.0', N'This procedure selects forms for Excel ribbon parameters.', N'Underlying table: dbo25.forms';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_form_id_or_null', NULL, N'en', N'4.0', N'This procedure selects forms for Excel ribbon parameters.', N'Underlying table: dbo25.forms';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_by_dimension_id', NULL, N'en', N'4.0', N'This procedure selects members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim1', NULL, N'en', N'4.0', N'This procedure selects 1st dimension members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim2', NULL, N'en', N'4.0', N'This procedure selects 2nd dimension members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim3', NULL, N'en', N'4.0', N'This procedure selects 3rd dimension members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim4', NULL, N'en', N'4.0', N'This procedure selects 4th dimension members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim5', NULL, N'en', N'4.0', N'This procedure selects 5th dimension members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim6', NULL, N'en', N'4.0', N'This procedure selects 6th dimension members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim7', NULL, N'en', N'4.0', N'This procedure selects 7th dimension members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_relation_dimension_id', NULL, N'en', N'4.0', N'This procedure selects dimensions for Excel ribbon parameters.', N'Underlying table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_relation_partner_id', NULL, N'en', N'4.0', N'This procedure selects members for Excel ribbon parameters.', N'Underlying table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_root_member_id_code', NULL, N'en', N'4.0', N'This procedure selects possible root members for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_rowset_id', NULL, N'en', N'4.0', N'This procedure selects rowsets for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_rowset_id_or_null', NULL, N'en', N'4.0', N'This procedure selects rowsets for Excel ribbon parameters.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p', NULL, N'en', N'4.0', N'This procedure selects values for the ribbon parameters of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p1', NULL, N'en', N'4.0', N'This procedure selects values for the 1st ribbon parameter of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p2', NULL, N'en', N'4.0', N'This procedure selects values for the 2nd ribbon parameter of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p3', NULL, N'en', N'4.0', N'This procedure selects values for the 3rd ribbon parameter of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p4', NULL, N'en', N'4.0', N'This procedure selects values for the 4th ribbon parameter of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p5', NULL, N'en', N'4.0', N'This procedure selects values for the 5th ribbon parameter of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p6', NULL, N'en', N'4.0', N'This procedure selects values for the 6th ribbon parameter of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p7', NULL, N'en', N'4.0', N'This procedure selects values for the 7th ribbon parameter of the configured forms.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_unit_id', NULL, N'en', N'4.0', N'This procedure selects units for Excel ribbon parameters.', N'Underlying table: dbo25.units';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_username', NULL, N'en', N'4.0', N'This procedure selects usernames for Excel ribbon parameters.', N'The procedure selects usernames of members of the planning_app_users role only.

To manage users, grant the VIEW DEFINITION permission. Other permissions are not required.

Underlying tables: sys.database_principals, sys.database_role_members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_axis_type_id', NULL, N'en', N'4.0', N'This procedure selects axis types to use as an Excel validation list source.', N'Underlying table: dbo25.axis_types';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_calc_type_id_by_dimension_id', NULL, N'en', N'4.0', N'This procedure selects calculation types to use as an Excel validation list source.', N'Underlying table: dbo25.calc_types';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_default_member_id_code', NULL, N'en', N'4.0', N'This procedure selects possible default members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_dimension_id', NULL, N'en', N'4.0', N'This procedure selects dimensions to use as an Excel validation list source.', N'Underlying table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id', NULL, N'en', N'4.0', N'This procedure selects members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id_code_by_dimension_id', NULL, N'en', N'4.0', N'This procedure selects members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id_code_by_rowset_id', NULL, N'en', N'4.0', N'This procedure selects members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_name_format_id', NULL, N'en', N'4.0', N'This procedure selects name formats to use as an Excel validation list source.', N'Underlying table: dbo25.name_formats';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_previous_period_id_by_dimension_id', NULL, N'en', N'4.0', N'This procedure selects previous period members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_root_member_id_code', NULL, N'en', N'4.0', N'This procedure selects possible root members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_root_member_or_rowset_id_code', NULL, N'en', N'4.0', N'This procedure selects possible root members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_rowset_id', NULL, N'en', N'4.0', N'This procedure selects rowsets to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_same_period_id_by_dimension_id', NULL, N'en', N'4.0', N'This procedure selects the same period members to use as an Excel validation list source.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_tax_rate_id_by_dimension_id', NULL, N'en', N'4.0', N'This procedure selects tax rates to use as an Excel validation list source.', N'Underlying table: dbo25.tax_rates';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_unit_id_by_dimension_id', NULL, N'en', N'4.0', N'This procedure selects units to use as an Excel validation list source.', N'Underlying table: dbo25.units';
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_array_values', NULL, N'en', N'4.0', N'This function returns a table of array values from the JSON string.', N'You may use this function to parse the @json_columns and @json_values parameters of stored procedures.

The SaveToDB add-in passes table headers and row values into these parameters in the JSON format.

You may use the native JSON functions of SQL Server instead.';
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_object_values', NULL, N'en', N'4.0', N'This function returns a table of name-value pairs from the JSON string.', N'You may use the native JSON functions of SQL Server instead.';
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', NULL, N'en', N'4.0', N'This function returns a table of quarter members for the specified year.', N'The function is used in the xls25.xl_actions_add_quarters procedure.';
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', NULL, N'en', N'4.0', N'This function returns a table of standard members to initialize the application.', N'The function is used in the dbo25.xl_actions_create_standard_members procedure.';
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', NULL, N'en', N'4.0', N'This function returns a table of time members for the specified year.', N'The function is used in the xls25.xl_actions_add_year and xls25.xl_actions_delete_year procedures.';
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', N'id', N'en', NULL, N'The application uses id values directly. Do not change the id values.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', N'code', N'en', NULL, N'You may change the code. However, keep the axis meaning.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', N'name', N'en', NULL, N'You may change the name. However, keep the axis meaning.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'id', N'en', NULL, N'The application uses id values directly. Do not change the id values.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'code', N'en', NULL, N'You may change the code. However, keep the calculation type meaning.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'name', N'en', NULL, N'You may change the name. However, keep the calculation type meaning.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'sort_order', N'en', NULL, N'You may change the sort order to select rows in the required order in Excel.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', N'time_id', N'en', NULL, N'This is a time member.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', N'category_id', N'en', NULL, N'This is a category member.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', N'currency_rate', N'en', NULL, N'Currency rate', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_calc_types', N'is_active', N'en', NULL, N'Set 1 to activate and 0 to deactivate the calculation type for the dimension.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'id', N'en', NULL, N'The application uses dimension id values directly. Do not change the id values.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'code', N'en', NULL, N'You may change the dimension code. However, do not change the meaning of the first four dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'name', N'en', NULL, N'You may change the dimension name. However, do not change the meaning of the first four dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'parameter_name', N'en', NULL, N'Use this field to set the name of the ribbon parameter name for the dimension members.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'sort_order', N'en', NULL, N'You may change the sort order to select dimensions in the required order in Excel.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'join_order', N'en', NULL, N'This field defines the JOIN order in the dynamic procedures. Do not change it.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'name_format_id', N'en', NULL, N'This field defines the name format used in the ribbon parameters and validation lists for dimension members.
For example, you may select id, code, name, or their pairs.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'root_member_id', N'en', NULL, N'Set this member to the root member of the dimension members.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'default_member_id', N'en', NULL, N'Set this member to the member used as the default value in the cube.
The default member must not contain children.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'is_protected', N'en', NULL, N'Set 1 to activate checking SELECT AND UPDATE permissions for dimension members.
Note that in this case, you have to set member permissions directly.
Otherwise, users may not see new members.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'default_select_permission', N'en', NULL, N'Set 0 to hide and 1 to show the cube values of the dimension members by default.
Keep 1 at least for the Times and Categories dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'default_update_permission', N'en', NULL, N'Set 0 to disable and 1 to enable updating cube values of the dimension members by default.
Keep 1 at least for the Times and Categories dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'is_active', N'en', NULL, N'Set 1 to activate or 0 to deactivate dimensions 5-7.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'external_id', N'en', NULL, N'Use it with custom import-export procedures.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'external_code', N'en', NULL, N'Use it with custom import-export procedures.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'factors', N'factor', N'en', NULL, N'Factor to calculate the parent value', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'id1', N'en', NULL, N'Accounts', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'id2', N'en', NULL, N'Times', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'id3', N'en', NULL, N'Categories', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'id4', N'en', NULL, N'Entities', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'id5', N'en', NULL, N'Dimension 5', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'id6', N'en', NULL, N'Dimension 6', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'id7', N'en', NULL, N'Dimension 7', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'value', N'en', NULL, N'This field contains calculated values that depend on unit factors and currency rates.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'source_value', N'en', NULL, N'This field contains user input values as is.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'parameter_index', N'en', NULL, N'Use this field to set the order of the parameter at the ribbon.
The index must be unique within the form scope and have values between 1 and 7.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'header_order', N'en', NULL, N'Use this field to set the order of the dimension in the form rows and columns.
The index must be unique within the form axis scope and have values between 1 and 3.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'root_member_id', N'en', NULL, N'Set this member to replace the dbo25.dimensions.root_member_id value for the form.
For example, if you create a form like "Sales", then you may set the root account member as "Sales".
The application uses this member as a base for the following fields.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'parameter_start_level', N'en', NULL, N'Set this optional value to show child members of the root member in the ribbon parameters starting at the specified level.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'parameter_end_level', N'en', NULL, N'Set this optional value to show child members of the root member in the ribbon parameters ending at the specified level.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'form_start_level', N'en', NULL, N'Set this optional value to show child members of the root member in the form rows and columns starting at the specified level.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'form_end_level', N'en', NULL, N'Set this optional value to show child members of the root member in the form rows and columns ending at the specified level.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_permissions', N'username', N'en', NULL, N'The application uses the USER_NAME() function to get the username.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_permissions', N'select_permission', N'en', NULL, N'Set 1 to allow the user to select the form.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'rowset_id', N'en', NULL, N'Rowset members must have the Rowset calculation type.
The application shows only such members.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'sort_order', N'en', NULL, N'Set the sort order to select rows in the required order in Microsoft Excel.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'member_id', N'en', NULL, N'You may omit the member to create a blank row.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'code', N'en', NULL, N'Set this value to replace the member code.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'name', N'en', NULL, N'Set this value to replace the member name.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'decimal_places', N'en', NULL, N'Set this value to replace the member decimal_places value.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'is_percent', N'en', NULL, N'Set this value to replace the member is_percent value.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'row_color', N'en', NULL, N'Set this value to replace the member row_color value.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'row_bold', N'en', NULL, N'Set this value to replace the member row_bold value.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'row_indent', N'en', NULL, N'Set this value to replace the member row_indent value.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_subtotals', N'show', N'en', NULL, N'Set 1 to show and 0 to hide subtotals.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'code', N'en', NULL, N'The code field values must not contain spaces.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'name', N'en', NULL, N'Try to keep names short.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'sort_order', N'en', NULL, N'Set the sort order to select forms in the required order in the ribbon Query List.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'is_active', N'en', NULL, N'Set 0 to exclude the form the ribbon Query List.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'hierarchies', N'level', N'en', NULL, N'The field contains a number of levels between members.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'username', N'en', NULL, N'The application uses the USER_NAME() function to get the username.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'select_permission', N'en', NULL, N'SELECT permission values: 1 - yes, 0 - no', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'update_permission', N'en', NULL, N'UPDATE permission values: 1 - yes, 0 - no', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'is_inherited', N'en', NULL, N'When you set the permission for the parent member, the application applies this permission to the children. This field contains 1 for such inherited permissions.
You may set the direct permission for any child to replace the inherited permissions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'permission', N'en', NULL, N'This field contains user input permission values (R - read, W - Read/Write, D - Deny) and inherited member permissions (r - read, w - read/write, d - deny).', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_relations', N'select_permission', N'en', NULL, N'SELECT permission values: 1 - yes, 0 - no', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_relations', N'update_permission', N'en', NULL, N'UPDATE permission values: 1 - yes, 0 - no', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'sort_order', N'en', NULL, N'Set the sort order to select members in the required order in Microsoft Excel.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'code', N'en', NULL, N'The code values are the most important.
The application uses codes in forms and import-export procedures to find member id values.
Try to keep the codes constant.

Do not use spaces in the codes.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'name', N'en', NULL, N'You may change member names anytime.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'comment', N'en', NULL, N'Use this field to add extended comments for business users.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'tax_rate_id', N'en', NULL, N'This field is for informational purposes only.

Use it to separate the same accounts with different tax rates.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'unit_id', N'en', NULL, N'The application uses the dbo25.units.factor value to calculate the dbo25.facts.value value based on dbo25.facts.source_value.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'calc_type_id', N'en', NULL, N'The application uses this field value to calculate member aggregates.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'previous_period_id', N'en', NULL, N'This field contains a member of the previous period for the Time dimension.
For example, the February member must contain the id of the January member.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'same_period_id', N'en', NULL, N'This field contains a member of the same period for the Time dimension.
For example, the February member must contain the id of the February member of the previous year.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'decimal_places', N'en', NULL, N'Use this field to customize form look in Microsoft Excel using conditional formatting.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'is_percent', N'en', NULL, N'Use this field to customize form look in Microsoft Excel using conditional formatting.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'row_color', N'en', NULL, N'Use this field to customize form look in Microsoft Excel using conditional formatting.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'row_bold', N'en', NULL, N'Use this field to customize form look in Microsoft Excel using conditional formatting.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'row_indent', N'en', NULL, N'Use this field to customize form look in Microsoft Excel using conditional formatting.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'is_active', N'en', NULL, N'Set 0 to hide the member.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'external_id', N'en', NULL, N'Use this field with custom import-export procedures.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'external_code', N'en', NULL, N'Use this field with custom import-export procedures.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'excel_formula', N'en', NULL, N'You may specify an Excel formula to calculate member aggregates in Microsoft Excel.

To use this feature, the form must select cells used as arguments in the correct order.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'cube_formula', N'en', NULL, N'This field is for informational purposes only.

The application updates formulas automatically with the xls25.xl_actions_update_hierarchies procedure.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', N'id', N'en', NULL, N'The application uses id values directly. Do not change the id values.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', N'code', N'en', NULL, N'You may change the code. However, keep the name format meaning.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', N'name', N'en', NULL, N'You may change the name. However, keep the name format meaning.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'parents', N'factor', N'en', NULL, N'The field contains source factors specified in the xls25.usp_members form.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'id1', N'en', NULL, N'Accounts', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'id2', N'en', NULL, N'Times', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'id3', N'en', NULL, N'Categories', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'id4', N'en', NULL, N'Entities', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'id5', N'en', NULL, N'Dimension 5', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'id6', N'en', NULL, N'Dimension 6', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'id7', N'en', NULL, N'Dimension 7', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'value', N'en', NULL, N'This field contains user input string values as is.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'id', N'en', NULL, N'Do not delete the default id 0.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'code', N'en', NULL, N'You may change codes.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'name', N'en', NULL, N'You may change names.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'sort_order', N'en', NULL, N'Set the sort order to select members in the required order in Microsoft Excel.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'is_active', N'en', NULL, N'Set 0 to hide the member.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'id', N'en', NULL, N'Do not delete the row with id 0 used as the system currency.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'code', N'en', NULL, N'Specify meaningful codes. For example, USD or ton. Do not use spaces in the codes.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'name', N'en', NULL, N'Specify meaningful names. For example, USD or ton.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'sort_order', N'en', NULL, N'Set the sort order to select members in the required order in Microsoft Excel.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'factor', N'en', NULL, N'Specify the factor to calculate dbo25.facts.value based on dbo25.facts.source_value.
So, the forms show source values while the cube contains both.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'is_currency', N'en', NULL, N'Set 1 for currency units and 0 for others.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'is_active', N'en', NULL, N'Set 0 to hide the member.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'id1', N'en', NULL, N'dbo25.facts.id1 - Accounts', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'id2', N'en', NULL, N'dbo25.facts.id2 - Times', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'id3', N'en', NULL, N'dbo25.facts.id3 - Categories', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'id4', N'en', NULL, N'dbo25.facts.id4 - Entities', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'id5', N'en', NULL, N'dbo25.facts.id5 - Dimension 5', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'id6', N'en', NULL, N'dbo25.facts.id6 - Dimension 6', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'id7', N'en', NULL, N'dbo25.facts.id7 - Dimension 7', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'unit_id', N'en', NULL, N'dbo25.members.unit_id value of the id1 member', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id value of the id1 member', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'dimension_name', N'en', NULL, N'dbo25.dimensions.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'table_name', N'en', NULL, N'The field shows the source table: dbo25.parents, dbo25.hierarchies, or dbo25.factors.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'member_id', N'en', NULL, N'Child member ID', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'parent_id', N'en', NULL, N'Parent member ID', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'calc_type_id', N'en', NULL, N'dbo25.factors.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'member', N'en', NULL, N'Child member display name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'parent', N'en', NULL, N'Parent member display name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'calc_type', N'en', NULL, N'dbo25.calc_types.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'factor', N'en', NULL, N'dbo25.parents.factor or dbo25.factors.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'TABLE_SCHEMA', N'en', NULL, N'Configured form schema: xls25a', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'TABLE_NAME', N'en', NULL, N'dbo25.forms.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'TABLE_TYPE', N'en', NULL, N'Type of the configured object: CODE', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'TABLE_CODE', N'en', NULL, N'SQL code to execute the xls25.run_form procedure with the form parameters', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'INSERT_PROCEDURE', N'en', NULL, N'NULL', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'UPDATE_PROCEDURE', N'en', NULL, N'NULL', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'DELETE_PROCEDURE', N'en', NULL, N'NULL', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_online_forms', N'PROCEDURE_TYPE', N'en', NULL, N'NULL', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'TABLE_SCHEMA', N'en', NULL, N'Configured form schema: xls25b', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'TABLE_NAME', N'en', NULL, N'dbo25.forms.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'TABLE_TYPE', N'en', NULL, N'Type of the configured object: CODE', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'TABLE_CODE', N'en', NULL, N'SQL code to execute the xls25.run_offline_form procedure with the form parameters', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'INSERT_PROCEDURE', N'en', NULL, N'xls25.usp_run_offline_form_insert', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'UPDATE_PROCEDURE', N'en', NULL, N'xls25.usp_run_offline_form_update', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'DELETE_PROCEDURE', N'en', NULL, N'xls25.usp_run_offline_form_delete', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_query_list_offline_forms', N'PROCEDURE_TYPE', N'en', NULL, N'Type of edit procedures for information purposes: PROCEDURE', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_array_values', N'@c', N'en', NULL, N'JSON array', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_object_values', N'@c', N'en', NULL, N'JSON object', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'@year', N'en', NULL, N'Year', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'@year', N'en', NULL, N'Year', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_clear_all_data', N'@confirm', N'en', NULL, N'yes - to confirm deleting data', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_currency_rates', N'@base_currency_code', N'en', NULL, N'dbo25.rates.base_currency_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_currency_rates', N'@quote_currency_code', N'en', NULL, N'dbo25.rates.quote_currency_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_currency_rates', N'@time_code', N'en', NULL, N'dbo25.rates.time_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_currency_rates', N'@category_code', N'en', NULL, N'dbo25.rates.category_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_currency_rates', N'@currency_rate', N'en', NULL, N'dbo25.rates.currency_rate', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@id', N'en', NULL, N'dbo25.dimension_properties.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@code', N'en', NULL, N'dbo25.dimension_properties.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@name', N'en', NULL, N'dbo25.dimension_properties.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@parameter_name', N'en', NULL, N'dbo25.dimension_properties.parameter_name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@sort_order', N'en', NULL, N'dbo25.dimension_properties.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@join_order', N'en', NULL, N'dbo25.dimension_properties.join_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@name_format_id', N'en', NULL, N'dbo25.dimension_properties.name_format_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@is_protected', N'en', NULL, N'dbo25.dimension_properties.is_protected', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@default_select_permission', N'en', NULL, N'dbo25.dimension_properties.default_select_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@default_update_permission', N'en', NULL, N'dbo25.dimension_properties.default_update_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@is_active', N'en', NULL, N'dbo25.dimension_properties.is_active', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@external_id', N'en', NULL, N'dbo25.dimension_properties.external_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@external_code', N'en', NULL, N'dbo25.dimension_properties.external_code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_calc_types', N'@dimension_id', N'en', NULL, N'dbo25.dimension_calc_types.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_calc_types', N'@calc_type_id', N'en', NULL, N'dbo25.dimension_calc_types.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_calc_types', N'@is_active', N'en', NULL, N'dbo25.dimension_calc_types.is_active', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@value', N'en', NULL, N'dbo25.facts.source_value, dbo25.facts.value', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@code1', N'en', NULL, N'dbo25.facts.id1', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@code2', N'en', NULL, N'dbo25.facts.id2', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@code3', N'en', NULL, N'dbo25.facts.id3', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@code4', N'en', NULL, N'dbo25.facts.id4', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@code5', N'en', NULL, N'dbo25.facts.id5', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@code6', N'en', NULL, N'dbo25.facts.id6', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@code7', N'en', NULL, N'dbo25.facts.id7', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_forms', N'@code', N'en', NULL, N'dbo25.forms.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_forms', N'@name', N'en', NULL, N'dbo25.forms.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_forms', N'@sort_order', N'en', NULL, N'dbo25.forms.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_forms', N'@is_active', N'en', NULL, N'dbo25.forms.is_active', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@form_code', N'en', NULL, N'dbo25.form_dimensions.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@dimension_id', N'en', NULL, N'dbo25.form_dimensions.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@axis_type_id', N'en', NULL, N'dbo25.form_dimensions.axis_type_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@parameter_index', N'en', NULL, N'dbo25.form_dimensions.parameter_index', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@header_order', N'en', NULL, N'dbo25.form_dimensions.header_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@root_member_code', N'en', NULL, N'dbo25.form_dimensions.root_member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@parameter_start_level', N'en', NULL, N'dbo25.form_dimensions.parameter_start_level', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@parameter_end_level', N'en', NULL, N'dbo25.form_dimensions.parameter_end_level', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@form_start_level', N'en', NULL, N'dbo25.form_dimensions.form_start_level', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@form_end_level', N'en', NULL, N'dbo25.form_dimensions.form_end_level', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_permissions', N'@form_code', N'en', NULL, N'dbo25.form_permissions.form_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_permissions', N'@username', N'en', NULL, N'dbo25.form_permissions.username', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_permissions', N'@select_permission', N'en', NULL, N'dbo25.form_permissions.select_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@rowset_code', N'en', NULL, N'dbo25.form_rows.rowset_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@sort_order', N'en', NULL, N'dbo25.form_rows.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@member_code', N'en', NULL, N'dbo25.form_rows.member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@code', N'en', NULL, N'dbo25.form_rows.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@name', N'en', NULL, N'dbo25.form_rows.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@decimal_places', N'en', NULL, N'dbo25.form_rows.decimal_places', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@is_percent', N'en', NULL, N'dbo25.form_rows.is_percent', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@row_color', N'en', NULL, N'dbo25.form_rows.row_color', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@row_bold', N'en', NULL, N'dbo25.form_rows.row_bold', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@row_indent', N'en', NULL, N'dbo25.form_rows.row_indent', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@form_code', N'en', NULL, N'dbo25.form_subtotals.form_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@show', N'en', NULL, N'dbo25.form_subtotals.show', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@dimension_id1', N'en', NULL, N'dbo25.form_subtotals.dimension_id1', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@dimension_id2', N'en', NULL, N'dbo25.form_subtotals.dimension_id2', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@dimension_id3', N'en', NULL, N'dbo25.form_subtotals.dimension_id3', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@member_code1', N'en', NULL, N'dbo25.form_subtotals.member_id1', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@member_code2', N'en', NULL, N'dbo25.form_subtotals.member_id2', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@member_code3', N'en', NULL, N'dbo25.form_subtotals.member_id3', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@decimal_places', N'en', NULL, N'dbo25.members.decimal_places', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@is_percent', N'en', NULL, N'dbo25.members.is_percent', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@row_color', N'en', NULL, N'dbo25.members.row_color', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@row_bold', N'en', NULL, N'dbo25.members.row_bold', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@row_indent', N'en', NULL, N'dbo25.members.row_indent', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@is_active', N'en', NULL, N'dbo25.members.is_active', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@external_id', N'en', NULL, N'dbo25.members.external_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@external_code', N'en', NULL, N'dbo25.members.external_code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@excel_formula', N'en', NULL, N'dbo25.members.excel_formula', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_parents', N'@member_code', N'en', NULL, N'dbo25.parents.member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_parents', N'@parent_code', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_parents', N'@factor', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_permissions', N'@member_code', N'en', NULL, N'dbo25.member_permissions.member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_permissions', N'@username', N'en', NULL, N'dbo25.member_permissions.username', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_permissions', N'@select_permission', N'en', NULL, N'dbo25.member_permissions.select_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_permissions', N'@update_permission', N'en', NULL, N'dbo25.member_permissions.update_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_properties', N'@member_code', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_properties', N'@previous_period_code', N'en', NULL, N'dbo25.members.previous_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_properties', N'@same_period_code', N'en', NULL, N'dbo25.members.same_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_properties', N'@tax_rate_code', N'en', NULL, N'dbo25.members.tax_rate_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_properties', N'@unit_code', N'en', NULL, N'dbo25.members.unit_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_relations', N'@member_code', N'en', NULL, N'dbo25.member_relations.member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_relations', N'@partner_code', N'en', NULL, N'dbo25.member_relations.partner_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_relations', N'@select_permission', N'en', NULL, N'dbo25.member_relations.select_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_relations', N'@update_permission', N'en', NULL, N'dbo25.member_relations.update_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@value', N'en', NULL, N'dbo25.strings.value', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@code1', N'en', NULL, N'dbo25.strings.id1', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@code2', N'en', NULL, N'dbo25.strings.id2', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@code3', N'en', NULL, N'dbo25.strings.id3', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@code4', N'en', NULL, N'dbo25.strings.id4', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@code5', N'en', NULL, N'dbo25.strings.id5', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@code6', N'en', NULL, N'dbo25.strings.id6', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@code7', N'en', NULL, N'dbo25.strings.id7', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_tax_rates', N'@code', N'en', NULL, N'dbo25.tax_rates.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_tax_rates', N'@name', N'en', NULL, N'dbo25.tax_rates.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_tax_rates', N'@sort_order', N'en', NULL, N'dbo25.tax_rates.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_tax_rates', N'@is_active', N'en', NULL, N'dbo25.tax_rates.is_active', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@code', N'en', NULL, N'dbo25.units.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@name', N'en', NULL, N'dbo25.units.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@sort_order', N'en', NULL, N'dbo25.units.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@factor', N'en', NULL, N'dbo25.units.factor', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@is_currency', N'en', NULL, N'dbo25.units.is_currency', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@is_active', N'en', NULL, N'dbo25.units.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods_change', N'@column_name', N'en', NULL, N'dbo25.member_relations.category_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods_change', N'@cell_number_value', N'en', NULL, N'dbo25.member_relations.update_permission', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods_change', N'@id', N'en', NULL, N'dbo25.member_relations.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates', N'@base_currency_id', N'en', NULL, N'dbo25.units.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates', N'@quote_currency_id', N'en', NULL, N'dbo25.units.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates_change', N'@column_name', N'en', NULL, N'dbo25.rates.category_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates_change', N'@cell_number_value', N'en', NULL, N'dbo25.rates.rate', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates_change', N'@id', N'en', NULL, N'dbo25.rates.time_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates_change', N'@base_currency_id', N'en', NULL, N'dbo25.rates.base_currency_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates_change', N'@quote_currency_id', N'en', NULL, N'dbo25.rates.quote_currency_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@column_name', N'en', NULL, N'Excel cell column name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@cell_value', N'en', NULL, N'Excel cell object value', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@cell_number_value', N'en', NULL, N'Excel cell number value', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@cell_address', N'en', NULL, N'Excel cell address', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@id', N'en', NULL, N'dbo25.dimension_properties.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@root_member_id', N'en', NULL, N'dbo25.dimension_properties.root_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@default_member_id', N'en', NULL, N'dbo25.dimension_properties.default_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_delete', N'@id', N'en', NULL, N'dbo25.dimension_properties.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@id', N'en', NULL, N'dbo25.dimension_properties.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@code', N'en', NULL, N'dbo25.dimension_properties.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@name', N'en', NULL, N'dbo25.dimension_properties.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@parameter_name', N'en', NULL, N'dbo25.dimension_properties.parameter_name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@sort_order', N'en', NULL, N'dbo25.dimension_properties.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@name_format_id', N'en', NULL, N'dbo25.dimension_properties.name_format_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@root_member_id', N'en', NULL, N'dbo25.dimension_properties.root_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@default_member_id', N'en', NULL, N'dbo25.dimension_properties.default_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@is_protected', N'en', NULL, N'dbo25.dimension_properties.is_protected', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@default_select_permission', N'en', NULL, N'dbo25.dimension_properties.default_select_permission', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@default_update_permission', N'en', NULL, N'dbo25.dimension_properties.default_update_permission', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@is_active', N'en', NULL, N'dbo25.dimension_properties.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@id', N'en', NULL, N'dbo25.dimension_properties.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@code', N'en', NULL, N'dbo25.dimension_properties.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@name', N'en', NULL, N'dbo25.dimension_properties.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@parameter_name', N'en', NULL, N'dbo25.dimension_properties.parameter_name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@sort_order', N'en', NULL, N'dbo25.dimension_properties.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@name_format_id', N'en', NULL, N'dbo25.dimension_properties.name_format_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@root_member_id', N'en', NULL, N'dbo25.dimension_properties.root_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@default_member_id', N'en', NULL, N'dbo25.dimension_properties.default_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@is_protected', N'en', NULL, N'dbo25.dimension_properties.is_protected', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@default_select_permission', N'en', NULL, N'dbo25.dimension_properties.default_select_permission', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@default_update_permission', N'en', NULL, N'dbo25.dimension_properties.default_update_permission', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@is_active', N'en', NULL, N'dbo25.dimension_properties.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_delete', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_delete', N'@dimension_id', N'en', NULL, N'dbo25.form_dimensions.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@dimension_id', N'en', NULL, N'dbo25.form_dimensions.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@axis_type_id', N'en', NULL, N'dbo25.form_dimensions.axis_type_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@parameter_index', N'en', NULL, N'dbo25.form_dimensions.parameter_index', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@header_order', N'en', NULL, N'dbo25.form_dimensions.header_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@root_member_id', N'en', NULL, N'dbo25.form_dimensions.root_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@parameter_start_level', N'en', NULL, N'dbo25.form_dimensions.parameter_start_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@parameter_end_level', N'en', NULL, N'dbo25.form_dimensions.parameter_end_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@form_start_level', N'en', NULL, N'dbo25.form_dimensions.form_start_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_insert', N'@form_end_level', N'en', NULL, N'dbo25.form_dimensions.form_end_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@dimension_id', N'en', NULL, N'dbo25.form_dimensions.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@axis_type_id', N'en', NULL, N'dbo25.form_dimensions.axis_type_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@parameter_index', N'en', NULL, N'dbo25.form_dimensions.parameter_index', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@header_order', N'en', NULL, N'dbo25.form_dimensions.header_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@root_member_id', N'en', NULL, N'dbo25.form_dimensions.root_member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@parameter_start_level', N'en', NULL, N'dbo25.form_dimensions.parameter_start_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@parameter_end_level', N'en', NULL, N'dbo25.form_dimensions.parameter_end_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@form_start_level', N'en', NULL, N'dbo25.form_dimensions.form_start_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions_update', N'@form_end_level', N'en', NULL, N'dbo25.form_dimensions.form_end_level', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_permissions_change', N'@column_name', N'en', NULL, N'dbo25.member_permissions.username', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_permissions_change', N'@cell_number_value', N'en', NULL, N'1 - select_permission = 1
0 - select_permission = 0', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_permissions_change', N'@id', N'en', NULL, N'dbo25.member_permissions.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows', N'@rowset_id', N'en', NULL, N'dbo25.form_rows.rowset_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_delete', N'@id', N'en', NULL, N'dbo25.form_rows.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@rowset_id', N'en', NULL, N'dbo25.form_rows.rowset_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@rownum', N'en', NULL, N'dbo25.form_rows.sort_order
@rownum is a predefined SaveToDB add-in parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@member_id', N'en', NULL, N'dbo25.form_rows.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@code', N'en', NULL, N'dbo25.form_rows.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@name', N'en', NULL, N'dbo25.form_rows.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@decimal_places', N'en', NULL, N'dbo25.form_rows.decimal_places', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@is_percent', N'en', NULL, N'dbo25.form_rows.is_percent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@row_color', N'en', NULL, N'dbo25.form_rows.row_color', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@row_bold', N'en', NULL, N'dbo25.form_rows.row_bold', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@row_indent', N'en', NULL, N'dbo25.form_rows.row_indent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@id', N'en', NULL, N'dbo25.form_rows.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@rowset_id', N'en', NULL, N'dbo25.form_rows.rowset_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@rownum', N'en', NULL, N'dbo25.form_rows.sort_order
@rownum is a predefined SaveToDB add-in parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@member_id', N'en', NULL, N'dbo25.form_rows.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@code', N'en', NULL, N'dbo25.form_rows.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@name', N'en', NULL, N'dbo25.form_rows.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@decimal_places', N'en', NULL, N'dbo25.form_rows.decimal_places', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@is_percent', N'en', NULL, N'dbo25.form_rows.is_percent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@row_color', N'en', NULL, N'dbo25.form_rows.row_color', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@row_bold', N'en', NULL, N'dbo25.form_rows.row_bold', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@row_indent', N'en', NULL, N'dbo25.form_rows.row_indent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_delete', N'@id', N'en', NULL, N'dbo25.forms.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', N'@code', N'en', NULL, N'dbo25.forms.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', N'@name', N'en', NULL, N'dbo25.forms.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', N'@sort_order', N'en', NULL, N'dbo25.forms.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', N'@is_active', N'en', NULL, N'dbo25.forms.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', N'@id', N'en', NULL, N'dbo25.forms.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', N'@code', N'en', NULL, N'dbo25.forms.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', N'@name', N'en', NULL, N'dbo25.forms.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', N'@sort_order', N'en', NULL, N'dbo25.forms.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', N'@is_active', N'en', NULL, N'dbo25.forms.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions', N'@dimension_id', N'en', NULL, N'Dimension filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions', N'@root_id', N'en', NULL, N'Root member filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions', N'@username', N'en', NULL, N'Username filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions_change', N'@column_name', N'en', NULL, N'dbo25.member_permissions.username', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions_change', N'@cell_value', N'en', NULL, N'D - deny (select_permission = 0, update_permission = 0)
R - read (select_permission = 1, update_permission = 0)
W - write (select_permission = 1, update_permission = 1)', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions_change', N'@id', N'en', NULL, N'dbo25.member_permissions.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations', N'@dimension_id', N'en', NULL, N'Dimension filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations', N'@root_id', N'en', NULL, N'Root member filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations', N'@partner_id', N'en', NULL, N'Partner dimension filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations', N'@field', N'en', NULL, N'update_permission, fixed value', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations_change', N'@column_name', N'en', NULL, N'dbo25.member_relations.partner_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations_change', N'@cell_number_value', N'en', NULL, N'dbo25.member_relations.update_permission

1 - update_permission = 1
0 - update_permission = 0', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations_change', N'@id', N'en', NULL, N'dbo25.member_relations.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations_change', N'@field', N'en', NULL, N'update_permission, fixed value', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members', N'@dimension_id', N'en', NULL, N'Dimension filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members', N'@root_id', N'en', NULL, N'Root member filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_delete', N'@id', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@comment', N'en', NULL, N'dbo25.members.comment', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@tax_rate_id', N'en', NULL, N'dbo25.members.tax_rate_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@unit_id', N'en', NULL, N'dbo25.members.unit_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@previous_period_id', N'en', NULL, N'dbo25.members.previous_period_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@same_period_id', N'en', NULL, N'dbo25.members.same_period_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@decimal_places', N'en', NULL, N'dbo25.members.decimal_places', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@is_percent', N'en', NULL, N'dbo25.members.is_percent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@row_color', N'en', NULL, N'dbo25.members.row_color', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@row_bold', N'en', NULL, N'dbo25.members.row_bold', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@row_indent', N'en', NULL, N'dbo25.members.row_indent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@is_active', N'en', NULL, N'dbo25.members.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@excel_formula', N'en', NULL, N'dbo25.members.excel_formula', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@parent1', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@parent2', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@parent3', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@parent4', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@parent5', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@parent6', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@parent7', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@factor1', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@factor2', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@factor3', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@factor4', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@factor5', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@factor6', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@factor7', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@id', N'en', NULL, N'dbo25.members.id, dbo25.parents.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@comment', N'en', NULL, N'dbo25.members.comment', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@tax_rate_id', N'en', NULL, N'dbo25.members.tax_rate_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@unit_id', N'en', NULL, N'dbo25.members.unit_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@previous_period_id', N'en', NULL, N'dbo25.members.previous_period_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@same_period_id', N'en', NULL, N'dbo25.members.same_period_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@decimal_places', N'en', NULL, N'dbo25.members.decimal_places', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@is_percent', N'en', NULL, N'dbo25.members.is_percent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@row_color', N'en', NULL, N'dbo25.members.row_color', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@row_bold', N'en', NULL, N'dbo25.members.row_bold', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@row_indent', N'en', NULL, N'dbo25.members.row_indent', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@is_active', N'en', NULL, N'dbo25.members.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@excel_formula', N'en', NULL, N'dbo25.members.excel_formula', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@parent1', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@parent2', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@parent3', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@parent4', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@parent5', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@parent6', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@parent7', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@factor1', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@factor2', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@factor3', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@factor4', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@factor5', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@factor6', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@factor7', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets', N'@dimension_id', N'en', NULL, N'Dimension filter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_delete', N'@id', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', N'@code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', N'@name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', N'@sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_update', N'@id', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_update', N'@code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_update', N'@name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_update', N'@sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_id', N'en', NULL, N'dbo25.forms.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_p1', N'en', NULL, N'dbo25.members.id of the 1st ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_p2', N'en', NULL, N'dbo25.members.id of the 2nd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_p3', N'en', NULL, N'dbo25.members.id of the 3rd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_p4', N'en', NULL, N'dbo25.members.id of the 4th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_p5', N'en', NULL, N'dbo25.members.id of the 5th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_p6', N'en', NULL, N'dbo25.members.id of the 6th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@form_p7', N'en', NULL, N'dbo25.members.id of the 7th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@column_name', N'en', NULL, N'Excel cell column name.
Data column names contain dimension member codes separated by spaces.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@table_name', N'en', NULL, N'Active form database object name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@cell_value', N'en', NULL, N'Excel cell object value', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@cell_number_value', N'en', NULL, N'Excel cell number value', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@cell_address', N'en', NULL, N'Excel cell address', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@changed_cell_count', N'en', NULL, N'Total number of changed cells', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@changed_cell_index', N'en', NULL, N'Cell index in the changed cells, starting 1.
The last cell has the index equal to @changed_cell_count.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@id', N'en', NULL, N'dbo25.form_rows.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@member_id', N'en', NULL, N'dbo25.members.id of the 1st row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@member_id2', N'en', NULL, N'dbo25.members.id of the 2nd row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@member_id3', N'en', NULL, N'dbo25.members.id of the 3rd row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_id', N'en', NULL, N'dbo25.forms.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_p1', N'en', NULL, N'dbo25.members.id of the 1st ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_p2', N'en', NULL, N'dbo25.members.id of the 2nd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_p3', N'en', NULL, N'dbo25.members.id of the 3rd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_p4', N'en', NULL, N'dbo25.members.id of the 4th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_p5', N'en', NULL, N'dbo25.members.id of the 5th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_p6', N'en', NULL, N'dbo25.members.id of the 6th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@form_p7', N'en', NULL, N'dbo25.members.id of the 7th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@quiet_mode', N'en', NULL, N'0 - raise exceptions on errors
1 - return on errors without exceptions', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_json_form', N'@request', N'en', NULL, N'Form parameters in the JSON format.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_id', N'en', NULL, N'dbo25.forms.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_p1', N'en', NULL, N'dbo25.members.id of the 1st ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_p2', N'en', NULL, N'dbo25.members.id of the 2nd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_p3', N'en', NULL, N'dbo25.members.id of the 3rd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_p4', N'en', NULL, N'dbo25.members.id of the 4th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_p5', N'en', NULL, N'dbo25.members.id of the 5th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_p6', N'en', NULL, N'dbo25.members.id of the 6th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@form_p7', N'en', NULL, N'dbo25.members.id of the 7th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_delete', N'@id', N'en', NULL, N'dbo25.form_rows.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_insert', N'@id', N'en', NULL, N'dbo25.form_rows.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@table_name', N'en', NULL, N'Active form database object name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_id', N'en', NULL, N'dbo25.forms.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_p1', N'en', NULL, N'dbo25.members.id of the 1st ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_p2', N'en', NULL, N'dbo25.members.id of the 2nd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_p3', N'en', NULL, N'dbo25.members.id of the 3rd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_p4', N'en', NULL, N'dbo25.members.id of the 4th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_p5', N'en', NULL, N'dbo25.members.id of the 5th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_p6', N'en', NULL, N'dbo25.members.id of the 6th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@form_p7', N'en', NULL, N'dbo25.members.id of the 7th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@member_id', N'en', NULL, N'dbo25.members.id of the 1st row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@member_id2', N'en', NULL, N'dbo25.members.id of the 2nd row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@member_id3', N'en', NULL, N'dbo25.members.id of the 3rd row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@json_columns', N'en', NULL, N'An array of column names in the JSON format', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@json_values', N'en', NULL, N'An array of row values in the JSON format', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_quarters', N'@year', N'en', NULL, N'Year', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_year', N'@year', N'en', NULL, N'Year', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_copy_data', N'@code', N'en', NULL, N'Time dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_copy_data', N'@source_category_code', N'en', NULL, N'Source category dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_copy_data', N'@target_category_code', N'en', NULL, N'Target category dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_copy_data', N'@set_1_to_copy', N'en', NULL, N'1 - to confirm copying data', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_data', N'@code', N'en', NULL, N'Time dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_data', N'@category_code', N'en', NULL, N'Category dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_data', N'@set_1_to_delete', N'en', NULL, N'1 - to confirm deleting data', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_year', N'@year', N'en', NULL, N'Year', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_year', N'@set_1_to_delete', N'en', NULL, N'1 - to confirm deleting data', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@column_name', N'en', NULL, N'Excel cell column name.
Data column names contain dimension member codes separated by spaces.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@table_name', N'en', NULL, N'Active form database object name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@member_id', N'en', NULL, N'dbo25.members.id of the 1st row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@member_id2', N'en', NULL, N'dbo25.members.id of the 2nd row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@member_id3', N'en', NULL, N'dbo25.members.id of the 3rd row dimension', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_id', N'en', NULL, N'dbo25.forms.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_p1', N'en', NULL, N'dbo25.members.id of the 1st ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_p2', N'en', NULL, N'dbo25.members.id of the 2nd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_p3', N'en', NULL, N'dbo25.members.id of the 3rd ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_p4', N'en', NULL, N'dbo25.members.id of the 4th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_p5', N'en', NULL, N'dbo25.members.id of the 5th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_p6', N'en', NULL, N'dbo25.members.id of the 6th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@form_p7', N'en', NULL, N'dbo25.members.id of the 7th ribbon parameter', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_set_functional_currency', N'@id', N'en', NULL, N'dbo25.units.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_by_dimension_id', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p', N'@parameter_index', N'en', NULL, N'dbo25.form_dimensions.parameter_index', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p1', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p2', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p3', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p4', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p5', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p6', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p7', N'@form_id', N'en', NULL, N'dbo25.form_dimensions.form_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_calc_type_id_by_dimension_id', N'@dimension_id', N'en', NULL, N'dbo25.dimension_calc_types.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_previous_period_id_by_dimension_id', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_same_period_id_by_dimension_id', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_tax_rate_id_by_dimension_id', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_unit_id_by_dimension_id', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_array_values', N'id', N'en', NULL, N'Value index', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_array_values', N'value', N'en', NULL, N'Value', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_object_values', N'name', N'en', NULL, N'Property name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_json_object_values', N'value', N'en', NULL, N'Property value', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'row_color', N'en', NULL, N'dbo25.members.row_color', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'previous_period', N'en', NULL, N'dbo25.members.previous_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'same_period', N'en', NULL, N'dbo25.members.same_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'parent1', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'parent2', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_quarter_members', N'parent3', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'row_color', N'en', NULL, N'dbo25.members.row_color', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'previous_period', N'en', NULL, N'dbo25.members.previous_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'same_period', N'en', NULL, N'dbo25.members.same_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'parent1', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_standard_members', N'factor1', N'en', NULL, N'dbo25.parents.factor', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'code', N'en', NULL, N'dbo25.members.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'name', N'en', NULL, N'dbo25.members.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'sort_order', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'row_color', N'en', NULL, N'dbo25.members.row_color', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'previous_period', N'en', NULL, N'dbo25.members.previous_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'same_period', N'en', NULL, N'dbo25.members.same_period_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'parent1', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'parent2', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_year_members', N'parent3', N'en', NULL, N'dbo25.parents.parent_id', NULL;
EXEC doc.xl_import_help 6, N'database', N'title', NULL, N'en', NULL, NULL, N'Gartle Planning | savetodb.com';
EXEC doc.xl_import_help 6, N'xls25', N'online_help_url', NULL, N'en', NULL, NULL, N'https://www.savetodb.com/help/planning-application.htm';
EXEC doc.xl_import_help 6, N'database', N'h1', NULL, N'en', NULL, NULL, N'Gartle Planning';
EXEC doc.xl_import_help 6, N'database', N'subtitle', NULL, N'en', NULL, NULL, N'Version 5.0, July 5, 2022';
EXEC doc.xl_import_help 6, N'database', N'online_help_url', NULL, N'en', NULL, NULL, N'https://www.savetodb.com/help/planning-application.htm';
EXEC doc.xl_import_help 6, N'database', N'manifest_url', NULL, N'en', NULL, NULL, N'https://www.savetodb.com/manifest.json';
EXEC doc.xl_import_help 6, N'database', N'description', NULL, N'en', NULL, NULL, N'This document describes the concepts and database objects of the Gartle Planning application for Microsoft Excel and SQL Server';
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates', NULL, N'en', N'4.0', N'This procedure is an Excel form for editing tax rates.', N'Underlying table: dbo25.tax_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'factor', N'en', NULL, N'The field is reserved for future use.', NULL;
EXEC doc.xl_import_help 6, N'dbo25', N'online_help_url', NULL, N'en', NULL, NULL, N'https://www.savetodb.com/help/planning-application.htm';
EXEC doc.xl_import_help 3, N'roles', N'xls_admins', NULL, N'en', N'9.5', N'The role includes permissions for Excel application administrators.', N'Assign this role to business users who can manage user permissions.

The role grants EXECUTE permissions on stored procedures used to manage and change permissions.
However, they execute the code under the actual user permissions.
So, a user can change permissions if he has permissions on such operations.

Members of the xls_developers role also have permissions to execute these procedures as they are in the xls schema.';
EXEC doc.xl_import_help 3, N'roles', N'planning_app_admins', NULL, N'en', N'4.0', N'The role includes permissions for planning application administrators.', N'Assign this role to users who manage business user permissions.

This role members have permission to execute permission management forms and procedures and do not have permission to execute business reports.

See actual database permissions in the dbo25.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 6, N'dbo25', N'multi_page', NULL, N'en', NULL, NULL, N'yes';
EXEC doc.xl_import_help 6, N'xls25', N'multi_page', NULL, N'en', NULL, NULL, N'yes';
EXEC doc.xl_import_help 3, N'roles', N'log_admins', NULL, N'en', N'3.1', N'The role includes permissions to use customize tracking features.', N'Assign this role to users who can create and drop triggers and clear change tracking logs.

See actual database permissions in the logs.xl_actions_set_role_permissions procedure.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_delete', N'@id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_insert', N'@code', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_insert', N'@name', N'en', NULL, N'dbo25.companies.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', N'@id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', N'@code', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', N'@name', N'en', NULL, N'dbo25.companies.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_translated_string', N'@data_language', N'en', NULL, N'xls.translations.LANGUAGE_NAME', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_delete', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_permissions_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_quarters', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_year', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_copy_data', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_data', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_year', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_run_form_cell_data', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_set_functional_currency', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_company_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_translated_string', N'Result', N'en', NULL, N'xls.translations.TRANSLATED_NAME', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'get_translated_string', N'@string', N'en', NULL, N'xls.translations.COLUMN_NAME', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_all', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_companies', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_currency_rates', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_dimension_members', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_dimension_properties', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_facts', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_dimensions', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_permissions', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_rows', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_subtotals', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_forms', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_parents', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_permissions', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_properties', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_relations', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_members', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_strings', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_tax_rates', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_translations', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_translations', N'@language', N'en', NULL, N'dbo25.translations.LANGUAGE_NAME', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_units', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_users', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_clear_all_data', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_currency_rates', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_members', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_properties', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_facts', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_finish', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_dimensions', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_permissions', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_rows', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_form_subtotals', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_forms', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_parents', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_permissions', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_properties', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_member_relations', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_strings', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_tax_rates', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_translations', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_users', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_data_management', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_change', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_permissions', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_form', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_json_form', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates', N'@company_id', N'en', NULL, N'dbo25.tax_rates.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations', N'@company_id', N'en', NULL, N'dbo25.translations.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units', N'@company_id', N'en', NULL, N'dbo25.units.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users', N'@company_id', N'en', NULL, N'dbo25.users.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_delete', N'@company_id', N'en', NULL, N'dbo25.users.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_insert', N'@company_id', N'en', NULL, N'dbo25.users.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_update', N'@company_id', N'en', NULL, N'dbo25.users.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_quarters', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_year', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_copy_data', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_data', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_delete_year', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_update_facts', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_update_hierarchies', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_update_member_permissions', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_currency_id', N'@company_id', N'en', NULL, N'dbo25.units.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_dimension_id', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_dimension_id_or_null', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_form_id', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_form_id_or_null', N'@company_id', N'en', NULL, N'dbo25.forms.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_by_dimension_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim1', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim2', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim3', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim4', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim5', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim6', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim7', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_relation_dimension_id', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_relation_partner_id', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_rowset_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_rowset_id_or_null', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_unit_id', N'@company_id', N'en', NULL, N'dbo25.units.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_username', N'@company_id', N'en', NULL, N'dbo25.users.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_dimension_id', N'@company_id', N'en', NULL, N'dbo25.dimension_properties.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_previous_period_id_by_dimension_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_rowset_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_same_period_id_by_dimension_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_tax_rate_id_by_dimension_id', N'@company_id', N'en', NULL, N'dbo25.tax_rates.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_unit_id_by_dimension_id', N'@company_id', N'en', NULL, N'dbo25.units.company_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_companies', N'@code', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_companies', N'@name', N'en', NULL, N'dbo25.companies.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_members', N'@dimension_id', N'en', NULL, N'dbo25.dimension_properties.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_members', N'@root_member_code', N'en', NULL, N'dbo25.members.code used to calculate dbo25.dimension_properties.root_member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_members', N'@default_member_code', N'en', NULL, N'dbo25.members.code used to calculate dbo25.dimension_properties.default_member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@id', N'en', NULL, N'dbo25.dimensions.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@code', N'en', NULL, N'dbo25.dimensions.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@name', N'en', NULL, N'dbo25.dimensions.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@parameter_name', N'en', NULL, N'dbo25.dimensions.parameter_name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@sort_order', N'en', NULL, N'dbo25.dimensions.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@join_order', N'en', NULL, N'dbo25.dimensions.join_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@name_format_id', N'en', NULL, N'dbo25.dimensions.name_format_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@is_protected', N'en', NULL, N'dbo25.dimensions.is_protected', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@default_select_permission', N'en', NULL, N'dbo25.dimensions.default_select_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@default_update_permission', N'en', NULL, N'dbo25.dimensions.default_update_permission', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimensions', N'@is_active', N'en', NULL, N'dbo25.dimensions.is_active', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@is_functional_currency', N'en', NULL, N'dbo25.units.is_functional_currency', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_users', N'@username', N'en', NULL, N'dbo25.users.username', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_users', N'@name', N'en', NULL, N'dbo25.users.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_users', N'@is_admin', N'en', NULL, N'dbo25.users.is_admin', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_users', N'@is_active', N'en', NULL, N'dbo25.users.is_active', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_users', N'@is_default', N'en', NULL, N'dbo25.users.is_default', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_insert', N'@username', N'en', NULL, N'dbo25.users.username', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_insert', N'@name', N'en', NULL, N'dbo25.users.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_insert', N'@is_admin', N'en', NULL, N'dbo25.users.is_admin', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_insert', N'@is_active', N'en', NULL, N'dbo25.users.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_insert', N'@is_default', N'en', NULL, N'dbo25.users.is_default', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_update', N'@username', N'en', NULL, N'dbo25.users.username', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_update', N'@name', N'en', NULL, N'dbo25.users.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_update', N'@is_admin', N'en', NULL, N'dbo25.users.is_admin', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_update', N'@is_active', N'en', NULL, N'dbo25.users.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_update', N'@is_default', N'en', NULL, N'dbo25.users.is_default', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_delete', N'@username', N'en', NULL, N'dbo25.users.username', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'dimension_id', N'en', NULL, N'dbo25.dimensions.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'axis_types', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'calc_types', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'currency_rates', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_calc_types', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_calc_types', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_calc_types', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_calc_types', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimensions', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'factors', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'factors', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'factors', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'factors', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'facts', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_dimensions', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_permissions', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_permissions', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_permissions', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_permissions', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_rows', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_subtotals', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_subtotals', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_subtotals', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'form_subtotals', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'forms', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'hierarchies', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'hierarchies', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'hierarchies', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'hierarchies', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_permissions', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_relations', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_relations', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_relations', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'member_relations', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'name_formats', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'parents', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'parents', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'parents', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'parents', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'strings', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translations', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translations', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translations', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translations', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'code', N'en', NULL, N'Company code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'name', N'en', NULL, N'Company name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'code', N'en', NULL, N'You may change the dimension code. However, do not change the meaning of the first four dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'name', N'en', NULL, N'You may change the dimension name. However, do not change the meaning of the first four dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'parameter_name', N'en', NULL, N'Use this field to set the name of the ribbon parameter name for the dimension members.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'sort_order', N'en', NULL, N'You may change the sort order to select dimensions in the required order in Excel.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'join_order', N'en', NULL, N'This field defines the JOIN order in the dynamic procedures. Do not change it.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'name_format_id', N'en', NULL, N'This field defines the name format used in the ribbon parameters and validation lists for dimension members.
For example, you may select id, code, name, or their pairs.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'is_protected', N'en', NULL, N'Set 1 to activate checking SELECT AND UPDATE permissions for dimension members.
Note that in this case, you have to set member permissions directly.
Otherwise, users may not see new members.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'default_select_permission', N'en', NULL, N'Set 0 to hide and 1 to show the cube values of the dimension members by default.
Keep 1 at least for the Times and Categories dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'default_update_permission', N'en', NULL, N'Set 0 to disable and 1 to enable updating cube values of the dimension members by default.
Keep 1 at least for the Times and Categories dimensions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', N'is_active', N'en', NULL, N'Set 1 to activate or 0 to deactivate dimensions 5-7.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'username', N'en', NULL, N'A database name of the user acquired using the USER_NAME() function.
The application uses this username to check user''s permissions.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'name', N'en', NULL, N'User name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'is_admin', N'en', NULL, N'1 - the user has administrator privileges
0 - the user has no administrator privileges', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'is_active', N'en', NULL, N'1 - the user can work with the company data
0 - the user cannot work with the company data', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'users', N'is_default', N'en', NULL, N'1 - use this company by default when @company_id is NULL
0 - do not use this company by default', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'is_functional_currency', N'en', NULL, N'1 - use this item as the functional currency (must be a single item)
0 - all others', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', NULL, N'en', N'4.0', N'This user table contains companies.', N'The application allows planning for multiple companies in the same database.

All user tables use direct or indirect company_id as a foreign key from this table.

Use xls25.usp_companies to check available companies and add new ones.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_dimensions', NULL, N'en', N'4.0', N'This procedure exports form dimension settings.', N'Source table: dbo25.forms, dbo25.form_dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_permissions', NULL, N'en', N'4.0', N'This procedure exports form permissions.', N'Source table: dbo25.forms, dbo25.form_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_rows', NULL, N'en', N'4.0', N'This procedure exports form row settings.', N'Source table: dbo25.forms, dbo25.form_rows';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_form_subtotals', NULL, N'en', N'4.0', N'This procedure exports form subtotal settings.', N'Source table: dbo25.forms, dbo25.form_subtotals';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_parents', NULL, N'en', N'4.0', N'This procedure exports member parents.', N'Source tables: dbo25.members, dbo25.parents';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_permissions', NULL, N'en', N'4.0', N'This procedure exports member permissions.', N'Source tables: dbo25.members, dbo25.member_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_properties', NULL, N'en', N'4.0', N'This procedure exports member properties.', N'Source tables: dbo25.members';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_member_relations', NULL, N'en', N'4.0', N'This procedure exports member relations.', N'Source tables: dbo25.members, dbo25.member_relations';
EXEC doc.xl_import_help 1, N'dbo25', N'users', NULL, N'en', N'4.0', N'This user table contains application users.', N'Use xls25.usp_users to select and edit data.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_companies', NULL, N'en', N'4.0', N'This procedure exports companies.', N'Source table: dbo25.companies';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_dimension_calc_types', NULL, N'en', N'4.0', N'This procedure exports dimension calculation types.', N'Source table: dbo25.dimension_calc_types';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_dimension_members', NULL, N'en', N'4.0', N'This procedure exports dimension members.', N'Source table: dbo25.dimension_properties, dbo25.members';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_dimension_properties', NULL, N'en', N'4.0', N'This procedure exports dimension properties.', N'Source table: dbo25.dimension_properties';
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies', NULL, N'en', N'4.0', N'This procedure is a form of editing companies.', N'Source table: dbo25.companies';
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_companies.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_companies.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_companies.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_axis_types', NULL, N'en', N'4.0', N'This procedure selects form axis types.', N'Underlying table: dbo25.axis_types';
EXEC doc.xl_import_help 1, N'xls25', N'usp_name_formats', NULL, N'en', N'4.0', N'This procedure selects name formats.', N'Underlying table: dbo25.name_formats';
EXEC doc.xl_import_help 1, N'xls25', N'usp_users', NULL, N'en', N'4.0', N'This procedure is a form of editing users.', N'Source table: dbo25.users';
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_users.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_users.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_users_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_users.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tr_axis_types_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.axis_types';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_axis_types_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.axis_types';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_calc_types_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.calc_types';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_calc_types_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.calc_types';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_companies_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.companies';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_companies_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.companies';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_currency_rates_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.currency_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_currency_rates_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.currency_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_dimension_calc_types_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.dimension_calc_types';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_dimension_calc_types_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.dimension_calc_types';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_dimension_properties_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.dimension_properties';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_dimension_properties_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.dimension_properties';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_dimensions_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_dimensions_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_factors_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.factors';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_factors_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.factors';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_form_dimensions_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.form_dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_form_dimensions_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.form_dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_form_permissions_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.form_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_form_permissions_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.form_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_form_rows_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.form_rows';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_form_rows_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.form_rows';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_forms_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.forms';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_forms_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.forms';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_hierarchies_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.hierarchies';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_hierarchies_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.hierarchies';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_member_permissions_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.member_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_member_permissions_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.member_permissions';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_member_relations_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.member_relations';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_member_relations_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.member_relations';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_members_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_members_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_name_formats_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.name_formats';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_name_formats_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.name_formats';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_parents_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.parents';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_parents_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.parents';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_tax_rates_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.tax_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_tax_rates_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.tax_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_translations_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.translations';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_translations_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.translations';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_units_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.units';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_units_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.units';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_users_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.users';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_users_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.users';
EXEC doc.xl_import_help 1, N'dbo25', N'get_translated_string', NULL, N'en', N'4.0', N'This function returns a company-related translated string.', N'Underlying table: dbo25.translations';
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_company_id', NULL, N'en', N'4.0', N'This procedure selects companies for Excel ribbon parameters.', N'Underlying table: dbo25.companies';
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations', NULL, N'en', N'4.0', N'This procedure is a form of editing company-related translations.', N'Source table: dbo25.translations';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_translations', NULL, N'en', N'4.0', N'This procedure imports company-related translations.', N'Target table: dbo25.translations';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_users', NULL, N'en', N'4.0', N'This procedure imports users.', N'Target table: dbo25.users';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_translations', NULL, N'en', N'4.0', N'This procedure exports company-related translations.', N'Source table: dbo25.translations';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_users', NULL, N'en', N'4.0', N'This procedure exports users.', N'Source table: dbo25.users';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_companies', NULL, N'en', N'4.0', N'This procedure imports companies.', N'Target table: dbo25.companies';
EXEC doc.xl_import_help 1, N'dbo25', N'translations', NULL, N'en', N'4.0', N'This user table contains company-related translations.', N'Use xls25.usp_translations to select and edit data.';
EXEC doc.xl_import_help 1, N'dbo25', N'dimension_properties', NULL, N'en', N'4.0', N'This user table contains company-related dimension properties.', N'This company contains company-related settings of the dimensions.

The application has seven built-in dimensions. Adding more dimensions requires application changes.

The first four dimensions (Accounts, Times, Categories, and Entities) have built-in business logic. Do not deactivate them and keep their meaning.

You may activate and deactivate dimensions 5-7, and change their meaning.

Use the xls25.usp_dimensions procedure to select and edit dimensions in Microsoft Excel.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_dimension_members', NULL, N'en', N'4.0', N'This procedure imports dimension members.', N'Target table: dbo25.dimensions';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_finish', NULL, N'en', N'4.0', N'This procedure executes the required actions after importing data.', N'This procedure calls other stored procedures to update member hierarchies and permissions, and recalculate facts.';
EXEC doc.xl_import_help 1, N'dbo25', N'formats', NULL, N'en', N'4.0', N'This user table contains company-related form formats.', N'The SaveToDB add-in uses xls25.usp_update_table_format to save formats.';
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'default_language', N'en', NULL, N'The language of company elements like accounts, members, etc.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'companies', N'sort_order', N'en', NULL, N'Sort order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'factors', N'is_calculated', N'en', NULL, N'1 - the value is calculated
0 - the value is loaded from the source', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'formats', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', N'created_by', N'en', NULL, N'Username of the user who created the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'formats', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'formats', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'formats', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', N'created_on', N'en', NULL, N'The creation time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', N'modified_by', N'en', NULL, N'Username of the last user who modified the record', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', N'modified_on', N'en', NULL, N'The last modification time', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'show_line', N'en', NULL, N'1 - show the row
0 - hide the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'show_line_before', N'en', NULL, N'1 - add a row before
0 - do not add a row before', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'show_line_after', N'en', NULL, N'1 - add a row after
0 - do not add a row after', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'is_translatable', N'en', NULL, N'The element supports translation', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'members', N'is_calculated', N'en', NULL, N'1 - the member is calculated
0 - the member is not calculated', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tax_rates', N'is_translatable', N'en', NULL, N'The element supports translation', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'units', N'is_translatable', N'en', NULL, N'The element supports translation', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'formats', N'TABLE_SCHEMA', N'en', NULL, N'Table schema', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'formats', N'TABLE_NAME', N'en', NULL, N'Table name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'formats', N'TABLE_EXCEL_FORMAT_XML', N'en', NULL, N'Excel table format in XML.

The SaveToDB add-in packs and unpacks this format internally.', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', N'id', N'en', NULL, N'Id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', N'code', N'en', NULL, N'Code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', N'name', N'en', NULL, N'Name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translations', N'member_id', N'en', NULL, N'Id of the translated element in its table', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translations', N'language', N'en', NULL, N'Language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'translations', N'name', N'en', NULL, N'Translated element name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts', N'company_id', N'en', NULL, N'dbo25.factors.company_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts_data', N'company_id', N'en', NULL, N'dbo25.factors.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts_data', N'id', N'en', NULL, N'dbo25.facts.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'view_hierarchies', N'company', N'en', NULL, N'dbo25.companies.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_formats', N'TABLE_SCHEMA', N'en', NULL, N'dbo25.formats.TABLE_SCHEMA', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_formats', N'TABLE_NAME', N'en', NULL, N'dbo25.formats.TABLE_NAME', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_formats', N'TABLE_EXCEL_FORMAT_XML', N'en', NULL, N'dbo25.formats.TABLE_EXCEL_FORMAT_XML', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'id', N'en', NULL, N'Rowset id of the first dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'id2', N'en', NULL, N'Rowset id of the second dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'id3', N'en', NULL, N'Rowset id of the third dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'sort_order2', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'sort_order3', N'en', NULL, N'dbo25.members.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'member_id', N'en', NULL, N'Member id of the first dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'member_id2', N'en', NULL, N'Member id of the second dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'member_id3', N'en', NULL, N'Member id of the third dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'is_editable', N'en', NULL, N'1 - the line is editable
0 - the line is readonly', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'decimal_places', N'en', NULL, N'Decimal places', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'is_percent', N'en', NULL, N'1 - format data values as percent', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'row_color', N'en', NULL, N'Row color index for conditional formatting', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'row_bold', N'en', NULL, N'1 - format the row as bold', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'row_indent', N'en', NULL, N'Row indent', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'code', N'en', NULL, N'Line code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'code1', N'en', NULL, N'Member code of the first dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'code2', N'en', NULL, N'Member code of the second dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'name2', N'en', NULL, N'Member name of the second dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'code3', N'en', NULL, N'Member code of the third dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'name3', N'en', NULL, N'Member name of the third dimension of the row', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'calc_type', N'en', NULL, N'dbo25.calc_types.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'name', N'en', NULL, N'Member name or rowset name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'tax_rate', N'en', NULL, N'dbo25.tax_rates.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'unit', N'en', NULL, N'dbo25.units.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', N'data_format', N'en', NULL, N'An empty column to store Excel format for data columns', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', N'TABLE_SCHEMA', N'en', NULL, N'xls25a or xls25b', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', N'TABLE_NAME', N'en', NULL, N'Dynamic form code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', N'COLUMN_NAME', N'en', NULL, N'Dynamic form column name or parameter name or NULL', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', N'LANGUAGE_NAME', N'en', NULL, N'dbo25.translations.language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', N'TRANSLATED_NAME', N'en', NULL, N'dbo25.translations.name or dbo25.dimension_properties.parameter_name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', N'TRANSLATED_DESC', N'en', NULL, N'NULL', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_translations', N'TRANSLATE_COMMENT', N'en', NULL, N'NULL', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_formats', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_clear_all_data', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_formats', N'@company', N'en', NULL, N'dbo25.companies.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_forms', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_members', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_tax_rates', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_units', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_axis_types', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_calc_types', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_closed_periods', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_currency_rates', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_data_management', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_dimensions', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_permissions', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_member_relations', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_role_members_change', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', N'@data_language', N'en', NULL, N'xls.translations.LANGUAGE_NAME', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_aliases_members', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_calc_type_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_calc_type_id_or_null', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_currency_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_dimension_id_or_null', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_form_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_form_id_or_null', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_by_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim1', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim2', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim3', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim4', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim5', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim6', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_member_id_dim7', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_relation_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_relation_partner_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_rowset_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_rowset_id_or_null', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p1', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p2', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p3', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p4', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p5', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p6', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_run_form_p7', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_unit_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_axis_type_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_calc_type_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_calc_type_id_by_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_name_format_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_previous_period_id_by_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_rowset_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_same_period_id_by_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_tax_rate_id_by_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_unit_id_by_dimension_id', N'@data_language', N'en', NULL, N'Context data language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_forms', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_members', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_tax_rates', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_units', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_run_offline_form_update', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_change', N'@company_id', N'en', NULL, N'dbo25.translations.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_language', N'@company_id', N'en', NULL, N'dbo25.companies.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_root_member_id_code', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_default_member_id_code', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id_code_by_dimension_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id_code_by_rowset_id', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_root_member_id_code', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_root_member_or_rowset_id_code', N'@company_id', N'en', NULL, N'dbo25.members.company_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@id1', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@id2', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@id3', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@id4', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@id5', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@id6', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@id7', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@unit_id', N'en', NULL, N'dbo25.members.unit_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', N'@calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@id1', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@id2', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@id3', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@id4', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@id5', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@id6', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@id7', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@unit_id', N'en', NULL, N'dbo25.members.unit_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', N'@calc_type_id', N'en', NULL, N'dbo25.members.calc_type_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@id1', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@id2', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@id3', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@id4', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@id5', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@id6', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', N'@id7', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_form_rows_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_forms_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_rowsets_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@translated_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_companies', N'@sort_order', N'en', NULL, N'dbo25.companies.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_insert', N'@sort_order', N'en', NULL, N'dbo25.companies.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', N'@sort_order', N'en', NULL, N'dbo25.companies.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@sort_order', N'en', NULL, N'dbo25.tax_rates.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@sort_order', N'en', NULL, N'dbo25.tax_rates.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@sort_order', N'en', NULL, N'dbo25.units.sort_order', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@sort_order', N'en', NULL, N'dbo25.units.sort_order', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_formats', N'@TABLE_SCHEMA', N'en', NULL, N'dbo25.formats.TABLE_SCHEMA', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_formats', N'@TABLE_NAME', N'en', NULL, N'dbo25.formats.TABLE_NAME', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_formats', N'@TABLE_EXCEL_FORMAT_XML', N'en', NULL, N'dbo25.formats.TABLE_EXCEL_FORMAT_XML', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@show_line', N'en', NULL, N'dbo25.members.show_line', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@show_line_before', N'en', NULL, N'dbo25.members.show_line_before', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@show_line_after', N'en', NULL, N'dbo25.members.show_line_after', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_members', N'@is_translatable', N'en', NULL, N'dbo25.members.is_translatable', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_tax_rates', N'@is_translatable', N'en', NULL, N'dbo25.tax_rates.is_translatable', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_translations', N'@table', N'en', NULL, N'dbo25.translated_tables.code', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_translations', N'@member', N'en', NULL, N'The member code used to find dbo25.translations.member_id', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_translations', N'@language', N'en', NULL, N'dbo25.translations.language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_translations', N'@name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@show_line', N'en', NULL, N'dbo25.members.show_line', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@show_line_before', N'en', NULL, N'dbo25.members.show_line_before', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_insert', N'@show_line_after', N'en', NULL, N'dbo25.members.show_line_after', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@show_line', N'en', NULL, N'dbo25.members.show_line', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@show_line_before', N'en', NULL, N'dbo25.members.show_line_before', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_members_update', N'@show_line_after', N'en', NULL, N'dbo25.members.show_line_after', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_role_members_change', N'@column_name', N'en', NULL, N'username', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_role_members_change', N'@cell_number_value', N'en', NULL, N'1 - include the user into a role
0 - exclude the user from the role', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_role_members_change', N'@name', N'en', NULL, N'role', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations', N'@is_translatable', N'en', NULL, N'1 - select translatable elements only
0 - select non-translatable elements', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations', N'@is_complete', N'en', NULL, N'1 - show values with complete translations
0 - show values with incomplete translations', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_change', N'@table_id', N'en', NULL, N'dbo25.translations.table_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_change', N'@member_id', N'en', NULL, N'dbo25.translations.member_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_change', N'@column_name', N'en', NULL, N'dbo25.translations.language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_change', N'@cell_value', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_change', N'@cell_number_value', N'en', NULL, N'The value for the is_translatable column in supported tables', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_common', N'@is_complete', N'en', NULL, N'1 - show values with complete translations
0 - show values with incomplete translations', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls', N'@field', N'en', NULL, N'TRANSLATED_NAME, TRANSLATED_DESC, or TRANSLATED_COMMENT', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls', N'@schema', N'en', NULL, N'xls.translations.TABLE_SCHEMA', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls', N'@is_complete', N'en', NULL, N'1 - show values with complete translations
0 - show values with incomplete translations', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', N'@column_name', N'en', NULL, N'xls.translations.LANGUAGE_NAME', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', N'@cell_value', N'en', NULL, N'A value for the specified field', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', N'@TABLE_SCHEMA', N'en', NULL, N'xls.translations.TABLE_SCHEMA', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', N'@TABLE_NAME', N'en', NULL, N'xls.translations.TABLE_NAME', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', N'@COLUMN', N'en', NULL, N'xls.translations.COLUMN_NAME', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', N'@field', N'en', NULL, N'TRANSLATED_NAME, TRANSLATED_DESC, or TRANSLATED_COMMENT', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_delete', N'@id', N'en', NULL, N'dbo25.tax_rates.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@code', N'en', NULL, N'dbo25.tax_rates.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@name', N'en', NULL, N'dbo25.tax_rates.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@factor', N'en', NULL, N'dbo25.tax_rates.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', N'@is_active', N'en', NULL, N'dbo25.tax_rates.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@id', N'en', NULL, N'dbo25.tax_rates.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@code', N'en', NULL, N'dbo25.tax_rates.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@name', N'en', NULL, N'dbo25.tax_rates.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@factor', N'en', NULL, N'dbo25.tax_rates.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', N'@is_active', N'en', NULL, N'dbo25.tax_rates.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_delete', N'@id', N'en', NULL, N'dbo25.units.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@code', N'en', NULL, N'dbo25.units.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@name', N'en', NULL, N'dbo25.units.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@factor', N'en', NULL, N'dbo25.units.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@is_currency', N'en', NULL, N'dbo25.units.is_currency', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@is_functional_currency', N'en', NULL, N'dbo25.units.is_functional_currency', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', N'@is_active', N'en', NULL, N'dbo25.units.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@id', N'en', NULL, N'dbo25.units.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@code', N'en', NULL, N'dbo25.units.code', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@name', N'en', NULL, N'dbo25.units.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@factor', N'en', NULL, N'dbo25.units.factor', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@is_currency', N'en', NULL, N'dbo25.units.is_currency', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@is_functional_currency', N'en', NULL, N'dbo25.units.is_functional_currency', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', N'@is_active', N'en', NULL, N'dbo25.units.is_active', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_language', N'@language', N'en', NULL, N'dbo25.translations.language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_aliases_members', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_parameter_values_root_member_id_code', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id_code_by_dimension_id', N'@dimension_id', N'en', NULL, N'dbo25.members.dimension_id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_member_id_code_by_rowset_id', N'@rowset_id', N'en', NULL, N'dbo25.members.id', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_insert', N'@translated_parameter_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_dimensions_update', N'@translated_parameter_name', N'en', NULL, N'dbo25.translations.name', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_insert', N'@default_language', N'en', NULL, N'dbo25.companies.default_language', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_companies_update', N'@default_language', N'en', NULL, N'dbo25.companies.default_language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_companies', N'@default_language', N'en', NULL, N'dbo25.companies.default_language', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_units', N'@is_translatable', N'en', NULL, N'dbo25.units.is_translatable', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_all', N'@print_go', N'en', NULL, N'1 to print GO commands', NULL;
EXEC doc.xl_import_help 1, N'dbo25', N'tr_dimension_properties_delete', NULL, N'en', N'4.0', N'This trigger sets NULL in related columns and removes the element translations.', N'Underlying table: dbo25.dimension_properties';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_form_rows_delete', NULL, N'en', N'4.0', N'This trigger removes the element translations from dbo25.translations.', N'Underlying table: dbo25.form_rows';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_formats_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.formats';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_formats_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.formats';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_forms_delete', NULL, N'en', N'4.0', N'This trigger removes the element translations from dbo25.translations.', N'Underlying table: dbo25.forms';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_members_delete', NULL, N'en', N'4.0', N'This trigger sets NULL in related columns and removes the element translations.', N'Underlying table: dbo25.members';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_tax_rates_delete', NULL, N'en', N'4.0', N'This trigger removes the element translations from dbo25.translations.', N'Underlying table: dbo25.tax_rates';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_translated_tables_insert', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after INSERT.', N'Underlying table: dbo25.translated_tables';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_translated_tables_update', NULL, N'en', N'4.0', N'This trigger updates created_by, created_on, modified_by, and modified_on after UPDATE and updates ids in related columns.', N'Underlying table: dbo25.translated_tables';
EXEC doc.xl_import_help 1, N'dbo25', N'tr_units_delete', NULL, N'en', N'4.0', N'This trigger removes the element translations from dbo25.translations.', N'Underlying table: dbo25.units';
EXEC doc.xl_import_help 1, N'xls25a', N'usp_update_table_format', NULL, N'en', N'4.0', N'This procedure updates Excel table formats of online dynamic forms.', N'Underlying table: dbo25.formats

Analysts and developers may use the Save Table Format menu item to save formats.
Users may use the Load Table Format menu item to load formats.';
EXEC doc.xl_import_help 1, N'xls25b', N'usp_update_table_format', NULL, N'en', N'4.0', N'This procedure updates Excel table formats of offline dynamic forms.', N'Underlying table: dbo25.formats

Analysts and developers may use the Save Table Format menu item to save formats.
Users may use the Load Table Format menu item to load formats.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_import_formats', NULL, N'en', N'4.0', N'This procedure imports Excel table formats.', N'Target table: dbo25.formats';
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_forms', NULL, N'en', N'4.0', N'This procedure creates a set of standard forms.', N'Use it to initialize settings for a new company.';
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_tax_rates', NULL, N'en', N'4.0', N'This procedure creates a set of standard tax rates.', N'Use it to initialize settings for a new company.';
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_create_standard_units', NULL, N'en', N'4.0', N'This procedure creates a set of standard units.', N'Use it to initialize settings for a new company.';
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_set_doc_role_permissions', NULL, N'en', N'4.0', N'This procedure sets the permissions of user roles for the Database Help Framework.', N'Execute this procedure after installation of the Database Help Framework.';
EXEC doc.xl_import_help 1, N'dbo25', N'xl_actions_set_log_role_permissions', NULL, N'en', N'4.0', N'This procedure sets the permissions of user roles for the Change Tracking Framework.', N'Execute this procedure after installation of the Change Tracking Framework.';
EXEC doc.xl_import_help 1, N'dbo25', N'view_facts_data', NULL, N'en', N'4.0', N'This view selects source cube data.', N'This is a system view used by xls25.usp_facts_data.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts', NULL, N'en', N'4.0', N'This procedure selects the calculated facts.', N'This procedure selects the calculated cube values.

You may load the data into your BI tool, for example, PowerPivot.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_data', NULL, N'en', N'4.0', N'This procedure selects source cube data.', N'Use this procedure to check and edit source cube values directly.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_facts_strings', NULL, N'en', N'4.0', N'This procedure selects source cube strings.', N'Use this procedure to check and edit source cube string values directly.';
EXEC doc.xl_import_help 1, N'dbo25', N'translated_tables', NULL, N'en', N'4.0', N'This system table contains tables that support the translation of elements.', N'Do not change this table.';
EXEC doc.xl_import_help 1, N'dbo25', N'view_dynamic_form_fields', NULL, N'en', N'4.0', N'This view selects empty data of dynamic forms.', N'The xls25.usp_run_form procedure uses this view to select empty data.';
EXEC doc.xl_import_help 1, N'dbo25', N'usp_export_formats', NULL, N'en', N'4.0', N'This procedure exports Excel table formats.', N'Source table: dbo25.formats';
EXEC doc.xl_import_help 1, N'xls25', N'usp_role_members', NULL, N'en', N'4.0', N'This procedure is a form for managing user roles.', N'A user must have VIEW DEFINITION permissions to see users.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_role_members_change', NULL, N'en', N'4.0', N'This procedure updates a role membership on cell changes of xls25.usp_role_members.', N'A user must have ALTER USER and ALTER ROLE permissions to change permissions.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_change', NULL, N'en', N'4.0', N'This procedure updates an element translation on cell changes of xls25.usp_translations.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_common', NULL, N'en', N'4.0', N'This procedure is a form of editing application-level element translations.', N'Source table: xls.translations

This procedure selects all elements available for translations.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls', NULL, N'en', N'4.0', N'This procedure is a form of editing actual application-level element translations.', N'Source table: xls.translations

This procedure selects existing elements.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_translations_xls_change', NULL, N'en', N'4.0', N'This procedure updates an application element translation on cell changes of xls25.usp_translations_xls.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_units.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_units.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_units_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_units.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'xl_actions_add_language', NULL, N'en', N'4.0', N'This procedure adds a new language for company-related elements.', N'Users may run this procedure from the Actions menu.';
EXEC doc.xl_import_help 1, N'xls25', N'xl_validation_list_calc_type_id', NULL, N'en', N'4.0', N'This procedure selects calculation types to use as an Excel validation list source.', N'Underlying table: dbo25.calc_types';
EXEC doc.xl_import_help 1, N'xls25', N'xl_aliases_members', NULL, N'en', N'4.0', N'This procedure configures column sets of xls25.usp_members procedure.', N'The SaveToDB add-in allows showing and hiding columns on ribbon parameter value changes.
This procedure selects column sets depending on dimension_id.';
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_delete', NULL, N'en', N'4.0', N'This procedure deletes rows of xls25.usp_tax_rates.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_insert', NULL, N'en', N'4.0', N'This procedure inserts rows of xls25.usp_tax_rates.', NULL;
EXEC doc.xl_import_help 1, N'xls25', N'usp_tax_rates_update', NULL, N'en', N'4.0', N'This procedure updates rows of xls25.usp_tax_rates.', NULL;
EXEC doc.xl_import_help 2, N'schemas', N'xls25a', NULL, N'en', N'4.0', N'The schema contains objects of dynamic online forms.', N'Do not add other objects to this schema.';
EXEC doc.xl_import_help 2, N'schemas', N'xls25b', NULL, N'en', N'4.0', N'The schema contains objects of dynamic offline forms.', N'Do not add other objects to this schema.';
EXEC doc.xl_import_help 6, N'database', N'exclude_columns', NULL, N'en', NULL, NULL, N'created_by, created_on, modified_by, modified_on';

EXEC doc.xl_import_history N'dbo25', N'en', N'2.5', 1, 1, N'Version 2.5, September 10, 2018', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.5', 3, 1, N'Complete database documentation', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.5', 3, 2, N'Integrated [Database Help Framework](https://www.savetodb.com/help/database-help-framework.htm) 1.0', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.5', 4, 1, N'Updated [SaveToDB Framework](https://www.savetodb.com/help/savetodb-framework.htm) 9.0', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.5', 4, 2, N'Updated [Change Tracking Framework](https://www.savetodb.com/help/change-tracking-framework.htm) 2.0', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.5', 4, 3, N'An updated set of application workbooks', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.5', 4, 4, N'Other minor improvements', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.6', 1, 1, N'Version 2.6, February 5, 2019', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.6', 4, 1, N'Removed dependency on the frameworks:
- Change Tracking Framework
- Database Help Framework
- SaveToDB Developer Framework
- SaveToDB Administrator Framework
You may install the application in a minimal configuration.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.6', 4, 2, N'Updated frameworks:
- SaveToDB Framework 9.0
- SaveToDB Developer Framework 9.0
- SaveToDB Administrator Framework 9.0
- Change Tracking Framework 2.1
- Database Help Framework 1.1', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.6', 4, 3, N'The planning_app_administrators role renamed to planning_app_admins.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.6', 4, 5, N'Updated sample dates', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'2.6', 4, 4, N'Renamed test users:
pa_admin_01 - planning_app_admin_01
pa_analyst_01 - planning_app_analyst_01
pa_developer_01 - planning_app_developer_01
pa_user_01 - planning_app_user_01', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.0', 1, 1, N'Version 3.0, October 17, 2019', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.0', 3, 1, N'SaveToDB Planning Application 3.0 has two packages: public and paid.
The public package contains basic functionality, which is the best to learn features.
It has several encrypted stored procedures.
The paid package contains all features, including complete source codes.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.0', 3, 2, N'The application does not require the following frameworks that become optional:
- SaveToDB Administrator Framework
- SaveToDB Developer Framework
- Database Help Framework
- Change Tracking Framework', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.0', 3, 3, N'The application allows using DBEdit 1.2 in addition to Microsoft Excel with SaveToDB to customize the app and input data.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.0', 3, 4, N'The application uses a new DBSetup.exe installer.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.1', 1, 1, N'Version 3.1, January 27, 2020', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.1', 2, 1, N'The copyright changed to Gartle LLC, former Gartle Technology Corporation.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'3.1', 4, 1, N'Updated sample dates', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 1, 1, N'Version 4.0, July 20, 2020', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 2, 1, N'The application has a new name, Gartle Planning.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 3, 1, N'The application allows using four clients:
- the SaveToDB add-in for Microsoft Excel,
- the DBEdit desktop application,
- and the DBGate and ODataDB web applications.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 3, 2, N'The application allows having multiple companies in a single database.
The direct access to the dbo25 schema is prohibited.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 3, 5, N'The application supports multiple languages in UI and user data.
It includes English, German, French, Italian, Spanish, and Russian translations by default.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 3, 10, N'All the tables have the created_by, created_on, modified_by, and modified_on columns and INSERT and UPDATE triggers to update the fields automatically.
Using the SaveToDB Change Framework to track changes is optional.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 3, 12, N'The application includes a new complete sample for a railway company.
The sample includes a complete set of Excel and DBEdit workbooks.
It has new application pages in the DBGate and ODataDB web applications.
The sample includes English, German, French, Italian, Spanish, and Russian translations. Users may change the language on-the-fly.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'4.0', 2, 2, N'The application becomes entirely commercial. We do not deliver free source code.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.0', 1, 1, N'Version 5.0, July 5, 2022', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.0', 4, 1, N'The application supports SaveToDB 10.0, DBEdit 2.0, DBGate 2.0, ODataDB 4.0.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.0', 4, 3, N'The application has updated procedures of validation lists and parameter values.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.0', 4, 4, N'The documentation integrated with new SaveToDB help and Developer Guide.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.0', 4, 5, N'The samples are updated to 2022.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.0', 4, 2, N'The application supports Chinese Simplified and Chinese Traditional.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.1', 1, 1, N'Version 5.1, October 14, 2022', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.1', 4, 1, N'The application includes updated SaveToDB Framework 10.4 and and new separate SaveToDB Framework Extension 10.4.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.1', 4, 2, N'The application includes updated update and delete triggers.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.1', 5, 1, N'Delete triggers do not allow deleting multiple rows.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.2', 1, 1, N'Version 5.2, January 9, 2023', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.2', 2, 1, N'The application is licensed under the MIT license.', NULL;
EXEC doc.xl_import_history N'dbo25', N'en', N'5.2', 2, 2, N'The samples are updated to 2023.', NULL;

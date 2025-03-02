/**************************************************************************
* NiSource NiPADS - Deployment Script
*
* Project: ProTool Enhancements - Table Changes
*
* Description: Changes to existing ProTool tables used for reporting and ProTool UI enhancements.
* By: Mike Card, Centric Consulting, 630-768-1986
* Date: 4/26/2013
*
* Table Objects:
* [ProTool].[ScopeChanges] - new columns
* [ProTool].[ScopeChangeEstimate] - new table
* [ProTool].[ScopeChangeDrivers] - new table
***************************************************************************/
--USE [ProTool]
--GO
SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO

BEGIN TRAN
GO

-- Drop Foreign Key [Estimates_ScopeChanges_FK1] from [ProTool].[ScopeChanges]
Print 'Drop Foreign Key [Estimates_ScopeChanges_FK1] from [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[Estimates_ScopeChanges_FK1]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges] DROP CONSTRAINT [Estimates_ScopeChanges_FK1]
GO
IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

Print 'Drop Foreign Key [ScopeChanges_ScopeAgreements_FK1] from [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeAgreements]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges_ScopeAgreements_FK1]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeAgreements]')))
ALTER TABLE [ProTool].[ScopeAgreements] DROP CONSTRAINT [ScopeChanges_ScopeAgreements_FK1]
GO
IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- Create Table [ProTool].[ScopeChangeDrivers]
Print 'Create Table [ProTool].[ScopeChangeDrivers]'
GO
IF NOT (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChangeDrivers]') AND [type]='U'))
CREATE TABLE [ProTool].[ScopeChangeDrivers] (
		[Driver_Cd]       [int] NOT NULL,
		[Description]     [varchar](100) NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key [PK_ScopeChangeDrivers] to [ProTool].[ScopeChangeDrivers]
Print 'Add Primary Key [PK_ScopeChangeDrivers] to [ProTool].[ScopeChangeDrivers]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChangeDrivers]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'PK_ScopeChangeDrivers' AND [object_id]=OBJECT_ID(N'[ProTool].[ScopeChangeDrivers]')))
ALTER TABLE [ProTool].[ScopeChangeDrivers]
	ADD
	CONSTRAINT [PK_ScopeChangeDrivers]
	PRIMARY KEY
	CLUSTERED
	([Driver_Cd])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [ProTool].[ScopeChangeDrivers] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- Preserve data from [ProTool].[ScopeChanges] into a temporary table temp2137058649
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U'))
 BEGIN
    PRINT 'Renaming old table [ProTool].[ScopeChanges] to preserve data.'
	EXEC sp_rename @objname = N'[ProTool].[ScopeChanges]', @newname = N'temp2137058649', @objtype = 'OBJECT'
 END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [ProTool].[ScopeChanges]
Print 'Create Table [ProTool].[ScopeChanges]'
GO
IF NOT (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U'))
CREATE TABLE [ProTool].[ScopeChanges] (
		[Company_Cd]                       [varchar](3) NOT NULL,
		[Project_No]                       [int] NOT NULL,
		[Version_No]                       [smallint] NOT NULL,
		[Scope_Version_No]                 [smallint] NOT NULL,
		[Change_Type]                      [varchar](20) NULL,
		[Change_Desc]                      [varchar](1500) NOT NULL,
		[Change_Status]                    [varchar](100) NULL,
		[Change_Type_Design]               [bit] NOT NULL,
		[Change_Type_Phy_Scope]            [bit] NOT NULL,
		[Change_Type_Wk_Scope]             [bit] NOT NULL,
		[Change_Type_Cost]                 [bit] NOT NULL,
		[Change_Type_Schedule]             [bit] NOT NULL,
		[Primary_Driver_CD]                [int] NULL,
		[Secondary_Driver_CD]              [int] NULL,
		[Material_Impact]                  [bit] NOT NULL,
		[Contractor_Impact]                [bit] NOT NULL,
		[Other_Impact]                     [bit] NOT NULL,
		[Change_Timing]                    [varchar](100) NULL,
		[Change_Timing_Reason]             [varchar](250) NULL,
		[PEIF_Updated]                     [bit] NOT NULL,
		[PO_Number]                        [varchar](8) NULL,
		[PO_Change]                        [int] NULL,
		[Year_Impacted]                    [int] NULL,
		[Initiated_By_ID]                  [varchar](10) NULL,
		[Last_Input_By_ID]                 [varchar](10) NULL,
		[Management_Decision]              [varchar](10) NULL,
		[Project_Impact]                   [varchar](1500) NULL,
		[Change_Justification]             [varchar](1500) NULL,
		[Gate_CD]                          [int] NULL,
		[Scope_Notes]                      [varchar](400) NULL,
		[Project_Manager_Comments]         [varchar](1500) NULL,
		[Project_Manager_Edited]           [bit] NOT NULL,
		[Management_Approval_Comments]     [varchar](1500) NULL,
		[Management_Edited]                [bit] NOT NULL,
		[Locked_Scope_Fl]                  [bit] NOT NULL,
		[Scope_Locked_By_ID]               [varchar](10) NULL,
		[Scope_Locked_Date]                [datetime] NULL,
		[Scope_Approval_Fl]                [bit] NULL,
		[Scope_Approval_Date]              [datetime] NULL,
		[CostEstimate_Version_No]          [smallint] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Change_Type_Cost] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Change_Type_Cost] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Change_Type_Cost]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Change_Type_Cost]
	DEFAULT ((0)) FOR [Change_Type_Cost]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Change_Type_Design] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Change_Type_Design] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Change_Type_Design]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Change_Type_Design]
	DEFAULT ((0)) FOR [Change_Type_Design]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Change_Type_Phy_Scope] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Change_Type_Phy_Scope] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Change_Type_Phy_Scope]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Change_Type_Phy_Scope]
	DEFAULT ((0)) FOR [Change_Type_Phy_Scope]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Change_Type_Schedule] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Change_Type_Schedule] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Change_Type_Schedule]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Change_Type_Schedule]
	DEFAULT ((0)) FOR [Change_Type_Schedule]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Change_Type_Wk_Scope] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Change_Type_Wk_Scope] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Change_Type_Wk_Scope]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Change_Type_Wk_Scope]
	DEFAULT ((0)) FOR [Change_Type_Wk_Scope]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Contractor_Impact] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Contractor_Impact] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Contractor_Impact]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Contractor_Impact]
	DEFAULT ((0)) FOR [Contractor_Impact]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Management_Edited] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Management_Edited] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Management_Edited]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Management_Edited]
	DEFAULT ((0)) FOR [Management_Edited]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Material_Impact] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Material_Impact] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Material_Impact]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Material_Impact]
	DEFAULT ((0)) FOR [Material_Impact]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Other_Impact] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Other_Impact] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Other_Impact]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Other_Impact]
	DEFAULT ((0)) FOR [Other_Impact]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_PEIF_Updated] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_PEIF_Updated] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_PEIF_Updated]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_PEIF_Updated]
	DEFAULT ((0)) FOR [PEIF_Updated]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_ScopeChanges_Project_Manager_Edited] to [ProTool].[ScopeChanges]
Print 'Add Default Constraint [DF_ScopeChanges_Project_Manager_Edited] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[DF_ScopeChanges_Project_Manager_Edited]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [DF_ScopeChanges_Project_Manager_Edited]
	DEFAULT ((0)) FOR [Project_Manager_Edited]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Disable constraints
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U'))
ALTER TABLE [ProTool].[ScopeChanges] NOCHECK CONSTRAINT ALL
GO

-- Restore data
IF OBJECT_ID('[ProTool].temp2137058649') IS NOT NULL AND EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')
 BEGIN
    PRINT 'Restoring data into new table [ProTool].[ScopeChanges].'
	EXEC sp_executesql N'
	INSERT INTO [ProTool].[ScopeChanges] ([Company_Cd], [Project_No], [Version_No], [Scope_Version_No], [Locked_Scope_Fl], [Change_Desc], [Change_Justification], [Project_Impact], [Scope_Notes], [Scope_Locked_By_ID], [Scope_Locked_Date], [Scope_Approval_Fl], [Scope_Approval_Date])
	SELECT [Company_Cd], [Project_No], [Version_No], [Scope_Version_No], [Locked_Scope_Fl], [Change_Desc], [Change_Justification], [Project_Impact], [Scope_Notes], [Scope_Locked_By_ID], [Scope_Locked_Date], [Scope_Approval_Fl], [Scope_Approval_Date] FROM [ProTool].temp2137058649
	'
 END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Enable backward constraints
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U'))
ALTER TABLE [ProTool].[ScopeChanges] CHECK CONSTRAINT ALL
GO

-- Add Primary Key [PK_ScopeChanges] to [ProTool].[ScopeChanges]
Print 'Add Primary Key [PK_ScopeChanges] to [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'PK_ScopeChanges' AND [object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
ALTER TABLE [ProTool].[ScopeChanges]
	ADD
	CONSTRAINT [PK_ScopeChanges]
	PRIMARY KEY
	NONCLUSTERED
	([Company_Cd], [Project_No], [Version_No], [Scope_Version_No])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [IX_ScopeChanges_PO_Number] on [ProTool].[ScopeChanges]
Print 'Create Index [IX_ScopeChanges_PO_Number] on [ProTool].[ScopeChanges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChanges]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'IX_ScopeChanges_PO_Number' AND [object_id]=OBJECT_ID(N'[ProTool].[ScopeChanges]')))
CREATE NONCLUSTERED INDEX [IX_ScopeChanges_PO_Number]
	ON [ProTool].[ScopeChanges] ([PO_Number])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop the temporary table temp2137058649
IF OBJECT_ID('[ProTool].temp2137058649') IS NOT NULL DROP TABLE [ProTool].temp2137058649
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [ProTool].[ScopeChangeEstimate]
Print 'Create Table [ProTool].[ScopeChangeEstimate]'
GO
IF NOT (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]') AND [type]='U'))
CREATE TABLE [ProTool].[ScopeChangeEstimate] (
		[ScopeChangeEstimate_Id]     [bigint] IDENTITY(1, 1) NOT NULL,
		[Company_Cd]                 [varchar](3) NOT NULL,
		[Project_No]                 [int] NOT NULL,
		[Version_No]                 [smallint] NOT NULL,
		[Scope_Version_No]           [smallint] NOT NULL,
		[Cost_Category_Cd]           [smallint] NOT NULL,
		[Amount]                     [int] NULL,
		CONSTRAINT [IX_ScopeChangeEstimate_Unique]
		UNIQUE
		NONCLUSTERED
		([Company_Cd], [Project_No], [Version_No], [Scope_Version_No], [Cost_Category_Cd])

)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key [PK_ScopeChangeEstimate] to [ProTool].[ScopeChangeEstimate]
Print 'Add Primary Key [PK_ScopeChangeEstimate] to [ProTool].[ScopeChangeEstimate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'PK_ScopeChangeEstimate' AND [object_id]=OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]')))
ALTER TABLE [ProTool].[ScopeChangeEstimate]
	ADD
	CONSTRAINT [PK_ScopeChangeEstimate]
	PRIMARY KEY
	CLUSTERED
	([ScopeChangeEstimate_Id])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [IX_ScopeChangeEstimate_Co_Proj_Ver_ScopeVer] on [ProTool].[ScopeChangeEstimate]
Print 'Create Index [IX_ScopeChangeEstimate_Co_Proj_Ver_ScopeVer] on [ProTool].[ScopeChangeEstimate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'IX_ScopeChangeEstimate_Co_Proj_Ver_ScopeVer' AND [object_id]=OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]')))
CREATE NONCLUSTERED INDEX [IX_ScopeChangeEstimate_Co_Proj_Ver_ScopeVer]
	ON [ProTool].[ScopeChangeEstimate] ([Company_Cd], [Project_No], [Version_No], [Scope_Version_No])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [IX_ScopeChangeEstimate_Cost_Category_Cd] on [ProTool].[ScopeChangeEstimate]
Print 'Create Index [IX_ScopeChangeEstimate_Cost_Category_Cd] on [ProTool].[ScopeChangeEstimate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'IX_ScopeChangeEstimate_Cost_Category_Cd' AND [object_id]=OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]')))
CREATE NONCLUSTERED INDEX [IX_ScopeChangeEstimate_Cost_Category_Cd]
	ON [ProTool].[ScopeChangeEstimate] ([Cost_Category_Cd])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [ProTool].[ScopeChangeEstimate] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key [FK_ScopeChangeEstimate_CostCategories] on [ProTool].[ScopeChangeEstimate]
Print 'Create Foreign Key [FK_ScopeChangeEstimate_CostCategories] on [ProTool].[ScopeChangeEstimate]'
GO
IF OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]') IS NOT NULL
	AND OBJECT_ID(N'[ProTool].[CostCategories]') IS NOT NULL
	AND NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[FK_ScopeChangeEstimate_CostCategories]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]'))
BEGIN
		ALTER TABLE [ProTool].[ScopeChangeEstimate]
			WITH CHECK
			ADD CONSTRAINT [FK_ScopeChangeEstimate_CostCategories]
			FOREIGN KEY ([Cost_Category_Cd]) REFERENCES [ProTool].[CostCategories] ([Cost_Category_Cd])
		ALTER TABLE [ProTool].[ScopeChangeEstimate]
			CHECK CONSTRAINT [FK_ScopeChangeEstimate_CostCategories]

END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Reference [FK_ScopeChangeEstimate_ScopeChanges] on [ProTool].[ScopeChanges]
Print 'Create Reference [FK_ScopeChangeEstimate_ScopeChanges] on [ProTool].[ScopeChanges]'
GO
IF OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]') IS NOT NULL
	AND OBJECT_ID(N'[ProTool].[ScopeChanges]') IS NOT NULL
	AND NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[FK_ScopeChangeEstimate_ScopeChanges]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeChangeEstimate]'))
BEGIN
		ALTER TABLE [ProTool].[ScopeChangeEstimate]
			ADD CONSTRAINT [FK_ScopeChangeEstimate_ScopeChanges]
			FOREIGN KEY ([Company_Cd], [Project_No], [Version_No], [Scope_Version_No]) REFERENCES [ProTool].[ScopeChanges] ([Company_Cd], [Project_No], [Version_No], [Scope_Version_No])
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Reference [FK_ScopeAgreements_ScopeChanges] on [ProTool].[ScopeChanges]
Print 'Create Reference [FK_ScopeAgreements_ScopeChanges] on [ProTool].[ScopeChanges]'
GO
IF OBJECT_ID(N'[ProTool].[ScopeAgreements]') IS NOT NULL
	AND OBJECT_ID(N'[ProTool].[ScopeChanges]') IS NOT NULL
	AND NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[ProTool].[FK_ScopeAgreements_ScopeChanges]') AND [parent_object_id]=OBJECT_ID(N'[ProTool].[ScopeAgreements]'))
BEGIN
		ALTER TABLE [ProTool].[ScopeAgreements]
			ADD CONSTRAINT [FK_ScopeAgreements_ScopeChanges]
			FOREIGN KEY ([Company_Cd], [Project_No], [Version_No], [Scope_Version_No]) REFERENCES [ProTool].[ScopeChanges] ([Company_Cd], [Project_No], [Version_No], [Scope_Version_No])
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF


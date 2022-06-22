USE [XsuntAdmin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT top 1 1 FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = '_Sys_Index_Maintenance_Log')
BEGIN
	CREATE TABLE [dbo].[_Sys_Index_Maintenance_Log](
	[ID] int IDENTITY(1,1) NOT NULL CONSTRAINT [PK_Sys_Index_Maintenance_Log_ID] PRIMARY KEY CLUSTERED,
	[DatabaseName] sysname NULL,
	[SchemaName] sysname NULL,
	[ObjectName] sysname NULL,
	[ObjectType] char(2) NULL,
	[IndexName] sysname NULL,
	[IndexType] tinyint NULL,
	[StatisticsName] sysname NULL,
	[PartitionNumber] int NULL,
	[ExtendedInfo] xml NULL,
	[Command] nvarchar(max) NOT NULL,
	[CommandType] nvarchar(60) NOT NULL,
	[StartTime] datetime NOT NULL,
	[EndTime] datetime NULL,
	[ErrorNumber] int NULL,
	[ErrorMessage] nvarchar(max) NULL
	)
END

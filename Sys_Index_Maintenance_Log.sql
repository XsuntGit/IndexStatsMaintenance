USE [XsuntAdmin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sys_Index_Maintenance_Log](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [sysname] NULL,
	[SchemaName] [sysname] NULL,
	[ObjectName] [sysname] NULL,
	[ObjectType] [char](2) NULL,
	[IndexName] [sysname] NULL,
	[IndexType] [tinyint] NULL,
	[StatisticsName] [sysname] NULL,
	[PartitionNumber] [int] NULL,
	[ExtendedInfo] [xml] NULL,
	[Command] [nvarchar](max) NOT NULL,
	[CommandType] [nvarchar](60) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[ErrorNumber] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [PK_Sys_Index_Maintenance_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


/*

--Migration between databases

INSERT INTO [XsuntAdmin].[dbo].[Sys_Index_Maintenance_Log]
	([DatabaseName]
	,[SchemaName]
	,[ObjectName]
	,[ObjectType]
	,[IndexName]
	,[IndexType]
	,[StatisticsName]
	,[PartitionNumber]
	,[ExtendedInfo]
	,[Command]
	,[CommandType]
	,[StartTime]
	,[EndTime]
	,[ErrorNumber]
	,[ErrorMessage])
SELECT [DatabaseName]
	,[SchemaName]
	,[ObjectName]
	,[ObjectType]
	,[IndexName]
	,[IndexType]
	,[StatisticsName]
	,[PartitionNumber]
	,[ExtendedInfo]
	,[Command]
	,[CommandType]
	,[StartTime]
	,[EndTime]
	,[ErrorNumber]
	,[ErrorMessage]
FROM [msdb].[dbo].[Sys_Index_Maintenance_Log]
ORDER BY [ID]
GO

DROP TABLE [msdb].[dbo].[Sys_Index_Maintenance_Log]
GO

USE [msdb]
GO
DROP PROCEDURE [dbo].[Sys_Index_Maintenance]
GO

USE [msdb]
GO
DROP PROCEDURE [dbo].[Sys_Index_Maintenance_Exec]
GO

*/
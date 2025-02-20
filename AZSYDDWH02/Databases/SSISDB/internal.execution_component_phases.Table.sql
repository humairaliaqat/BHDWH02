USE [SSISDB]
GO
/****** Object:  Table [internal].[execution_component_phases]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [internal].[execution_component_phases](
	[phase_stats_id] [bigint] IDENTITY(1,1) NOT NULL,
	[execution_id] [bigint] NOT NULL,
	[package_name] [nvarchar](260) NOT NULL,
	[package_location_type] [nvarchar](128) NULL,
	[package_path_full] [nvarchar](4000) NULL,
	[task_name] [nvarchar](4000) NOT NULL,
	[subcomponent_name] [nvarchar](4000) NULL,
	[phase] [sysname] NOT NULL,
	[is_start] [bit] NULL,
	[phase_time] [datetimeoffset](7) NULL,
	[execution_path] [nvarchar](max) NULL,
	[sequence_id] [int] NULL,
 CONSTRAINT [PK_Execution_component_phases] PRIMARY KEY CLUSTERED 
(
	[phase_stats_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [Unique_sequence_id]    Script Date: 20/02/2025 10:29:28 AM ******/
CREATE NONCLUSTERED INDEX [Unique_sequence_id] ON [internal].[execution_component_phases]
(
	[execution_id] ASC,
	[sequence_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [internal].[execution_component_phases]  WITH CHECK ADD  CONSTRAINT [FK_ExecCompPhases_ExecutionId_Executions] FOREIGN KEY([execution_id])
REFERENCES [internal].[executions] ([execution_id])
ON DELETE CASCADE
GO
ALTER TABLE [internal].[execution_component_phases] CHECK CONSTRAINT [FK_ExecCompPhases_ExecutionId_Executions]
GO

USE [SSISDB]
GO
/****** Object:  Table [internal].[customized_logging_levels]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [internal].[customized_logging_levels](
	[level_id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [sysname] NOT NULL,
	[description] [nvarchar](1024) NULL,
	[profile_value] [bigint] NOT NULL,
	[events_value] [bigint] NOT NULL,
	[created_by_sid] [varbinary](85) NOT NULL,
	[created_by_name] [nvarchar](128) NOT NULL,
	[created_time] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_Levels] PRIMARY KEY CLUSTERED 
(
	[level_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Unique_level_name]    Script Date: 20/02/2025 10:29:28 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Unique_level_name] ON [internal].[customized_logging_levels]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

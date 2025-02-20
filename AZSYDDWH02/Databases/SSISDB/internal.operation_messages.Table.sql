USE [SSISDB]
GO
/****** Object:  Table [internal].[operation_messages]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [internal].[operation_messages](
	[operation_message_id] [bigint] IDENTITY(1,1) NOT NULL,
	[operation_id] [bigint] NOT NULL,
	[message_time] [datetimeoffset](7) NOT NULL,
	[message_type] [smallint] NOT NULL,
	[message_source_type] [smallint] NULL,
	[message] [nvarchar](max) NULL,
	[extended_info_id] [bigint] NULL,
 CONSTRAINT [PK_Operation_Messages] PRIMARY KEY CLUSTERED 
(
	[operation_message_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_OperationMessages_Operation_id]    Script Date: 20/02/2025 10:29:28 AM ******/
CREATE NONCLUSTERED INDEX [IX_OperationMessages_Operation_id] ON [internal].[operation_messages]
(
	[operation_id] ASC
)
INCLUDE([operation_message_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [internal].[operation_messages]  WITH CHECK ADD  CONSTRAINT [FK_OperationMessages_OperationId_Operations] FOREIGN KEY([operation_id])
REFERENCES [internal].[operations] ([operation_id])
ON DELETE CASCADE
GO
ALTER TABLE [internal].[operation_messages] CHECK CONSTRAINT [FK_OperationMessages_OperationId_Operations]
GO

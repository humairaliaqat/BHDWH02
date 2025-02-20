USE [db-au-log]
GO
/****** Object:  DdlTrigger [NO_DROP_VIEW]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [NO_DROP_VIEW]
ON DATABASE
FOR DROP_VIEW
AS
PRINT 'Dropping views are not allowed'
ROLLBACK

GO
DISABLE TRIGGER [NO_DROP_VIEW] ON DATABASE
GO

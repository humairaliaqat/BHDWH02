USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_CAD_ADDRESS_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_CAD_ADDRESS_aucm](
	[CASE_NO] [varchar](14) NULL,
	[TYPE] [varchar](5) NULL,
	[OVERWRITE] [varchar](1) NULL,
	[CONSENT] [varchar](1) NULL,
	[ROWID] [int] NOT NULL,
	[CREATED_DT] [datetime] NULL,
	[EncryptCompany] [varbinary](500) NULL,
	[EncryptStreet] [varbinary](500) NULL,
	[EncryptTown] [varbinary](500) NULL,
	[EncryptCountry] [varbinary](500) NULL,
	[EncryptPostCode] [varbinary](500) NULL,
	[EncryptPhone] [varbinary](500) NULL,
	[EncryptMobile] [varbinary](500) NULL,
	[EncryptFax] [varbinary](500) NULL,
	[EncryptTelex] [varbinary](500) NULL,
	[EncryptEmail] [varbinary](500) NULL,
	[EncryptDOB] [varbinary](200) NULL,
	[EncryptSurname] [varbinary](500) NULL,
	[EncryptFirstName] [varbinary](500) NULL,
	[CREATED_BY] [varchar](30) NULL,
	[MODIFIED_BY] [varchar](30) NULL,
	[MODIFIED_DT] [datetime] NULL,
	[IsCurrentLocation] [bit] NULL,
	[ArrivedDate] [date] NULL,
	[CNTRY_CODE] [varchar](3) NULL
) ON [PRIMARY]
GO

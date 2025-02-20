USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimEmployee]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimEmployee](
	[EmployeeSK] [int] IDENTITY(1,1) NOT NULL,
	[ManagerSK] [int] NULL,
	[EmployeeID] [nvarchar](320) NULL,
	[ManagerID] [nvarchar](320) NULL,
	[EmailAddress] [nvarchar](320) NULL,
	[EmployeeName] [nvarchar](640) NULL,
	[FirstName] [nvarchar](320) NULL,
	[LastName] [nvarchar](320) NULL,
	[Department] [nvarchar](255) NULL,
	[Company] [nvarchar](255) NULL,
	[JobTitle] [nvarchar](255) NULL,
	[isCSRAgent] [bit] NULL,
	[isActive] [bit] NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimEmployee_EmployeeSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [idx_dimEmployee_EmployeeSK] ON [dbo].[dimEmployee]
(
	[EmployeeSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimEmployee_EmployeeID]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimEmployee_EmployeeID] ON [dbo].[dimEmployee]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

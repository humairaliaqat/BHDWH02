USE [db-au-stage]
GO
/****** Object:  Table [dbo].[web_GigyaAccounts]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_GigyaAccounts](
	[UID] [nvarchar](255) NULL,
	[LoginProvider] [nvarchar](255) NULL,
	[isRegistered] [bit] NULL,
	[isVerified] [bit] NULL,
	[isActive] [bit] NULL,
	[socialProviders] [nvarchar](255) NULL,
	[firstName] [nvarchar](255) NULL,
	[lastName] [nvarchar](255) NULL,
	[email] [nvarchar](255) NULL,
	[lastUpdated] [nvarchar](255) NULL,
	[lastUpdatedTimestamp] [nvarchar](255) NULL,
	[created] [nvarchar](255) NULL,
	[createdTimestamp] [nvarchar](255) NULL,
	[lastLogin] [nvarchar](255) NULL,
	[LastLoginTimestamp] [nvarchar](255) NULL,
	[lastLoginLocationCountry] [nvarchar](255) NULL,
	[phoneNumber] [nvarchar](50) NULL,
	[address] [nvarchar](50) NULL,
	[birthYear] [nvarchar](50) NULL,
	[birthMonth] [nvarchar](50) NULL,
	[birthDay] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[state] [nvarchar](50) NULL,
	[city] [nvarchar](50) NULL,
	[zip] [nvarchar](50) NULL,
	[gender] [nvarchar](50) NULL,
	[age] [int] NULL,
	[profileURL] [nvarchar](255) NULL,
	[photoURL] [nvarchar](255) NULL,
	[thumbnailURL] [nvarchar](255) NULL,
	[company] [nvarchar](255) NULL,
	[workStartDate] [nvarchar](255) NULL,
	[workIsCurrent] [bit] NULL,
	[school] [nvarchar](255) NULL,
	[educationEndYear] [nvarchar](255) NULL,
	[educationIsCurrent] [bit] NULL,
	[followersCount] [int] NULL,
	[followingCount] [int] NULL
) ON [PRIMARY]
GO

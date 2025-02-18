USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spClaimsTurnAroundTime]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spClaimsTurnAroundTime]
as

SET NOCOUNT ON

declare @tableName varchar(200)
select @tablename = 'dataout.out_ClaimTAT_' + convert(varchar(8),getdate(),112)

if object_id('tempdb..##ClaimsTAT') is not null drop table ##ClaimsTAT

create table ##ClaimsTAT
(
	[JVCode] [nvarchar](10) NULL,
	[Reference] [int] NULL,
	[ClaimKey] [varchar](40) NULL,
	[Company] [varchar](11) NOT NULL,
	[ClaimType] [varchar](6) NOT NULL,
	[MoreDocumentChecked] [varchar](3) NOT NULL,
	[WorkType] [nvarchar](100) NULL,
	[ReceiptDate] [datetime] NULL,
	[RegisterDate] [datetime] NULL,
	[CreationDate] [datetime] NOT NULL,
	[FirstActiveDate] [datetime] NULL,
	[FirstEventDate] [datetime] NULL,
	[TurnAroundDate] [datetime] NULL,
	[TAT on First Active] [numeric](14, 1) NULL,
	[TAT on Receipt] [numeric](14, 1) NULL,
	[TAT on Work Creation] [numeric](14, 1) NULL,
	[TAT on Earliest Date] [numeric](14, 1) NULL
)

insert ##ClaimsTAT
(
	[JVCode],
	[Reference],
	[ClaimKey],
	[Company],
	[ClaimType],
	[MoreDocumentChecked],
	[WorkType],
	[ReceiptDate],
	[RegisterDate],
	[CreationDate],
	[FirstActiveDate],
	[FirstEventDate],
	[TurnAroundDate],
	[TAT on First Active],
	[TAT on Receipt],
	[TAT on Work Creation],
	[TAT on Earliest Date]
)
select
	[JVCode],
	[Reference],
	[ClaimKey],
	[Company],
	[ClaimType],
	[MoreDocumentChecked],
	[WorkType],
	[ReceiptDate],
	[RegisterDate],
	[CreationDate],
	[FirstActiveDate],
	[FirstEventDate],
	[TurnAroundDate],
	[TAT on First Active],
	[TAT on Receipt],
	[TAT on Work Creation],
	[TAT on Earliest Date]
from openquery(ULDWH02,
'
	select
		o.JVCode,
		w.Reference,
		w.ClaimKey,
		case
			when w.Country = ''NZ'' then ''New Zealand''
			else ''Australia''
		end Company,
		case
			when cl.OnlineClaim = 1 then ''Online''
			else ''Paper''
		end ClaimType,
		case
			when 
				cl.OnlineClaim = 1 and
				exists
				(
					select
						null
					from
						[db-au-cmdwh].dbo.clmOnlineClaim ocl with(nolock)
					where 
						ocl.ClaimKey = cl.ClaimKey and
						isnull(ocl.MoreDocument, 0) = 1
				)
			then ''Yes'' 
			else ''No''
		end MoreDocumentChecked,
				   w.WorkType,
		crd.ReceiptDate,
		cl.CreateDate RegisterDate,
		w.CreationDate,
		FirstActiveDate,
		FirstEventDate,
		TurnAroundDate,
		datediff(day, isnull(FirstActiveDate, w.CreationDate), TurnAroundDate) * 1.0 -
		(
			select
				count(d.[Date])
			from
				[db-au-cmdwh].dbo.Calendar d
			where
				d.[Date] >= isnull(FirstActiveDate, w.CreationDate)and
				d.[Date] <  dateadd(day, 1, convert(date, TurnAroundDate)) and
				(
					d.isHoliday = 1 or
					d.isWeekEnd = 1
				)
		) [TAT on First Active],
		datediff(day, crd.ReceiptDate, TurnAroundDate) * 1.0 -
		(
			select
				count(d.[Date])
			from
				[db-au-cmdwh].dbo.Calendar d
			where
				d.[Date] >= crd.ReceiptDate and
				d.[Date] <  dateadd(day, 1, convert(date, TurnAroundDate)) and
				(
					d.isHoliday = 1 or
					d.isWeekEnd = 1
				)
		) [TAT on Receipt],
		datediff(day, w.CreationDate, TurnAroundDate) * 1.0 -
		(
			select
				count(d.[Date])
			from
				[db-au-cmdwh].dbo.Calendar d
			where
				d.[Date] >= w.CreationDate and
				d.[Date] <  dateadd(day, 1, convert(date, TurnAroundDate)) and
				(
					d.isHoliday = 1 or
					d.isWeekEnd = 1
				)
		) [TAT on Work Creation],
		datediff(day, ed.EarliestDate, TurnAroundDate) * 1.0 -
		(
			select
				count(d.[Date])
			from
				[db-au-cmdwh].dbo.Calendar d
			where
				d.[Date] >= ed.EarliestDate and
				d.[Date] <  dateadd(day, 1, convert(date, TurnAroundDate)) and
				(
					d.isHoliday = 1 or
					d.isWeekEnd = 1
				)
		) [TAT on Earliest Date]
	from
		[db-au-cmdwh].dbo.e5Work w with(nolock)
		inner join [db-au-cmdwh].dbo.clmClaim cl with(nolock) on
			cl.ClaimKey = w.ClaimKey
		cross apply
		(
			select
				case
					when cl.ReceivedDate is null then cl.CreateDate
					when cl.ReceivedDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
					else cl.ReceivedDate
				end ReceiptDate
		) crd
		outer apply
		(
			--check for e5 Launch Service straight to Diarised (onlince claim bug)
			select top 1 
				els.StatusName,
			   els.EventDate
			from
				[db-au-cmdwh].dbo.e5WorkEvent els  with(nolock)
			where
				els.Work_Id = w.Work_ID
			order by
				els.EventDate
		) els
		outer apply
		(
			select top 1 
				EventDate FirstEventDate
			from
				[db-au-cmdwh].dbo.e5WorkEvent fa with(nolock)
			where
				fa.Work_Id = w.Work_ID 
			order by
				fa.EventDate
		) fe
		outer apply
		(
			select top 1 
				EventDate FirstActiveDate
			from
				[db-au-cmdwh].dbo.e5WorkEvent fa with(nolock)
			where
				fa.Work_Id = w.Work_ID and
				fa.EventName in (''Changed Work Status'', ''Merged Work'', ''Saved Work'') and
				fa.StatusName = ''Active'' and
				(
					fa.EventUser <> ''e5 Launch Service'' or
					fa.EventDate >= dateadd(day, 1, convert(date, els.EventDate))
				) and
				els.StatusName = ''Diarised''
			order by
				fa.EventDate
		) fa
		outer apply
		(
			select top 1 
				we.EventDate TurnAroundDate
			from
				[db-au-cmdwh].dbo.e5WorkEvent we with(nolock)
			where
				we.Work_Id = w.Work_ID and
				we.EventDate > isnull(FirstActiveDate, w.CreationDate) and
				we.EventUser <> ''e5 Launch Service'' and
				we.EventName = ''Changed Work Status'' and
				we.StatusName <> ''Active''
			order by
				we.EventDate
		) we
		outer apply
		(
			select top 1
				Company
			from
				[db-au-cmdwh].dbo.usrLDAP with(nolock)
			where
				DisplayName = w.AssignedUser
		) Company
				   cross apply
				   (
								  select
												 min(EarliestDate) EarliestDate
								  from
												 (
																select FirstActiveDate EarliestDate
																union all
																select w.CreationDate
																union all
																select crd.ReceiptDate
												 ) d
				   ) ed
		inner join [db-au-cmdwh].dbo.penOutlet o with(nolock) on o.OutletKey = cl.OutletKey and o.outletstatus = ''current''
	where
		(
			w.WorkType like ''%claim%'' or
			w.WorkType in (''Complaints'')
		) and
		w.WorkType not in (''Claims Audit'', ''New Claim'') and
		crd.ReceiptDate >= ''2017-01-01'' and
		crd.ReceiptDate <  convert(date, getdate())
')


GO

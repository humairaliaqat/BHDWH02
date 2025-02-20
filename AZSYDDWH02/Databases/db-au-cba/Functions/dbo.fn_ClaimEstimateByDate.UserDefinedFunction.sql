USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ClaimEstimateByDate]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[fn_ClaimEstimateByDate] (@ClaimKey varchar(9), @ReferenceDate date) returns float
as
begin

	declare @estimate float

	;with cte_estimates as
	(
		select 
			SectionKey,
			isnull(
				(
					select top 1 eh.EHEstimateValue
					from dbo.clmEstimateHistory eh
					where 
						eh.EHSectionID = cs.SectionID and 
						eh.CountryKey = cs.CountryKey and
						eh.EHCreateDate < dateadd(day, 1, @ReferenceDate)
					order by eh.EHCreateDate desc
				),
				0
			) EstimateValue
		from dbo.clmSection cs
		where cs.ClaimKey = @ClaimKey	
	)
	select @estimate = sum(EstimateValue)
	from cte_estimates

	return @estimate

end

GO

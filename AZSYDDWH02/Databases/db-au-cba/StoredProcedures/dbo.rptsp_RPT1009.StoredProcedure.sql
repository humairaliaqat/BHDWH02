USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_RPT1009]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[rptsp_RPT1009]		@ReportingPeriod VARCHAR(30),
											@StartDate DATE,
											@EndDate DATE,
											@Country NVARCHAR(10),
											@SuperGroup NVARCHAR(MAX)
as

SET NOCOUNT ON

										
/****************************************************************************************************/
--  Name:           RPT1009 - CBA - Large Claims - Test
--  Author:         ME
--  Date Created:   20180726
--  Description:    Customer level claims submissions >$50k including claim information and policy claimed against  
--
--  Parameters:     @ReportingPeriod: standard date range or _User Defined
--					@StartDate: if _User Defined. Format: YYYY-MM-DD eg. 2015-01-01
--					@EndDate: if_User Defined. Format: YYYY-MM-DD eg. 2015-01-01
--   
--  Change History: 20180523 - ME - Created 
--                  
/****************************************************************************************************/

--uncomment to debug
	--DECLARE @ReportingPeriod VARCHAR(30)
	--SELECT  @ReportingPeriod = '_User Defined'
	--DECLARE @StartDate DATE = '20181001'
	--DECLARE @EndDate DATE = '20181015'
	--DECLARE @Country NVARCHAR(10) = 'AU'
	--DECLARE @SuperGroup NVARCHAR(MAX) = 'Medibank'





--get reporting dates
DECLARE @rptStartDate DATE, @rptEndDate DATE
IF @ReportingPeriod = '_User Defined'
	SELECT @rptStartDate = @StartDate, @rptEndDate = @EndDate
ELSE
    SELECT @rptStartDate = StartDate, @rptEndDate = EndDate
    FROM [db-au-cba].dbo.vDateRange
    where DateRange = @ReportingPeriod


	SELECT  			 
			 c.ReceivedDate
			,cn.Claimant
			,c.ClaimNo
			,ce.EventCountryName
			,ce.EventDate			
			,cv.ClaimValue
			,cv.SectionCount
			,c.FirstNilDate
			,c.StatusDesc				
			,p.PolicyNumber	
			,p.IssueDate	
			,o.Channel 
			,pt.MemberNumber		
			,pt.firstname
			,pt.LastName
			,pt.DOB			
			,pt.PostCode
			,p.TripStart
			,p.TripEnd			

	FROM clmClaim c
	INNER JOIN penOutlet o
		ON	c.OutletKey = o.OutletKey
	OUTER APPLY
    (
        SELECT TOP 1 
            RTRIM(LTRIM(cn.Firstname + ' ' + cn.Surname)) Claimant,
            cn.DOB,
            cn.NameKey
        FROM
            clmName cn
        WHERE 
            cn.ClaimKey = c.ClaimKey and
            cn.isPrimary = 1
    ) cn
	OUTER APPLY 
	(
		SELECT SUM(clm.ClaimValue)	AS ClaimValue
			  ,COUNT(DISTINCT clm.SectionKey)	AS SectionCount
		FROM clmclaimSummary clm
		WHERE clm.ClaimKey = c.ClaimKey
	) cv
	OUTER APPLY
	(
		SELECT TOP 1 *
		FROM clmEvent e
		WHERE e.ClaimKey = c.ClaimKey
	) ce
	OUTER APPLY
	(
		SELECT p.*
		FROM penPolicy p
		WHERE p.PolicyNumber = c.PolicyNo
			AND p.CountryKey = c.CountryKey
	) p
	OUTER APPLY 
	(
		SELECT *
		FROM penPolicyTraveller t
		WHERE p.PolicyKey = t.PolicyKey
			AND t.isPrimary = 1
	) pt
	WHERE o.CountryKey = @Country
		AND o.SuperGroupName = @SuperGroup
		AND o.OutletStatus = 'current'
		AND cv.ClaimValue > 50000
		AND CAST(c.ReceivedDate AS DATE) >= @StartDate
		AND CAST(c.ReceivedDate AS DATE) <= @EndDate

	
GO

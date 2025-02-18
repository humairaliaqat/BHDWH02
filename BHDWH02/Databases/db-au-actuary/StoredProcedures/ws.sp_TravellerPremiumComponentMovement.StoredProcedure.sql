USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [ws].[sp_TravellerPremiumComponentMovement]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Create 
CREATE
PROCEDURE [ws].[sp_TravellerPremiumComponentMovement] @StartDate date,
@EndDate date

AS
BEGIN

  IF OBJECT_ID('ws.TravellerPremiumComponentMovemen') IS NULL
  BEGIN
    CREATE TABLE [db-au-actuary].[ws].[TravellerPremiumComponentMovemen] (
      [PolicyKey] [varchar](41) NULL,
      [PolicyStart] [datetime] NOT NULL,
      [PolicyEnd] [datetime] NOT NULL,
	  [MaxDuration] [Int] NULL,
	  Destination nvarchar(max),
      [PolicyTransactionKey] [varchar](41) NULL,
      [TripCost] [varchar](50) NULL,
      [RunningTotalTripCost] [int] NULL,
	  GrossPremium money null,
      [IssueDate] [datetime] NULL,
      [AutoComments] [nvarchar](2000) NULL,
      [PolicyTravellerKey] [varchar](41) NULL,
      [TravellerName] [nvarchar](201) NULL,
      [DOB] [datetime] NULL,
      [Gender] [nchar](2) NULL,
      [isAdult] [bit] NULL,
      [EmailAddress] [nvarchar](255) NULL,
      [PolicyTravellerTransactionKey] [varchar](41) NULL,
      [PolicyEMCKey] [varchar](41) NULL,
      [PolicyHasEMC] [varchar](1) NULL,
      [EMCRef] [varchar](100) NULL,
      [EMCScore] [numeric](10, 4) NULL,
      [CommentProcessed] [varchar](1) NULL,
      [Has Motorcycle] [varchar](1) NULL,
      [Has Wintersport] [varchar](1) NULL,
	  [Has Cruise] [varchar](1) NULL
    ) ON [PRIMARY]


    CREATE NONCLUSTERED INDEX [TravellerPremiumComponentMovemen_IDX1] ON [ws].[TravellerPremiumComponentMovemen] ([PolicyKey] ASC, [IssueDate] ASC, [PolicyTransactionKey] ASC, [PolicyTravellerKey] ASC, [PolicyTravellerTransactionKey] ASC)

    CREATE NONCLUSTERED INDEX [TravellerPremiumComponentMovemen_IDX2] ON [ws].[TravellerPremiumComponentMovemen] ([PolicyTransactionKey] ASC, [PolicyTravellerTransactionKey] ASC)

    CREATE CLUSTERED INDEX [TravellerPremiumComponentMovemen_IDX3] ON [ws].[TravellerPremiumComponentMovemen] ([CommentProcessed] ASC)

  END;

  DELETE FROM [db-au-actuary].ws.TravellerPremiumComponentMovemen
  WHERE [IssueDate] >= @StartDate
    AND [IssueDate] < DATEADD(DAY, 1, @EndDate)

	--delete from [db-au-actuary].ws.TravellerPremiumComponentMovemen where PolicyKey='AU-CM7-10002865'

  INSERT INTO [db-au-actuary].ws.TravellerPremiumComponentMovemen  WITH (TABLOCK)
  ( PolicyKey,
      PolicyStart,
      PolicyEnd,
	  MaxDuration,
	  Destination,
      PolicyTransactionKey,
      TripCost,
      RunningTotalTripCost,
	  GrossPremium,
      IssueDate,
      AutoComments,
      PolicyTravellerKey,
      TravellerName,
      DOB,
      Gender,
      isAdult,
      EmailAddress,
      PolicyTravellerTransactionKey,
      PolicyEMCKey,
      PolicyHasEMC,
      EMCRef,
      EMCScore,
      CommentProcessed,
      [Has Motorcycle],
      [Has Wintersport],
	  [Has Cruise]
	  )
    SELECT
      pptr.PolicyKey,
      pptr.PolicyStart,
      pptr.PolicyEnd,
	  pptr.MaxDuration,
	  pptr.Destination,
      pptr.PolicyTransactionKey,
      pptr.TripCost,
      pptr.RunningTotalTripCost,
	  pptr.GrossPremium,
      pptr.IssueDate,
      pptr.AutoComments,
      pptr.PolicyTravellerKey,
      pptr.TravellerName,
      pptr.DOB,
      pptr.Gender,
      pptr.isAdult,
      pptr.EmailAddress,
      penPolicyTravellerTransaction.PolicyTravellerTransactionKey,
      penPolicyEMC.PolicyEMCKey,
      CASE
        WHEN penPolicyEMC.PolicyEMCKey IS NOT NULL THEN 'Y'
        ELSE 'N'
      END PolicyHasEMC,
      penPolicyEMC.EMCRef,
      penPolicyEMC.EMCScore,
      'N' CommentProcessed,
      'N' [Has Motorcycle],
      'N' [Has Wintersport],
	  'N' [Has Cruise]
    --into [db-au-actuary].ws.TravellerPremiumComponentMovemen
    FROM (SELECT
      ppt.PolicyKey,
      ppt.policystart,
      ppt.PolicyEnd,
	  ppt.MaxDuration,
	  ppt.Destination,
      ppt.PolicyTransactionKey,
      ppt.TripCost,
      ppt.RunningTotalTripCost,
	  ppt.GrossPremium,
      ppt.IssueDate,
      ppt.AutoComments,
      penpolicytraveller.PolicyTravellerKey,
      penpolicytraveller.FirstName + ' ' + penpolicytraveller.LastName TravellerName,
      penpolicytraveller.EmailAddress,
      penpolicytraveller.DOB,
      penpolicytraveller.Gender,
      penpolicytraveller.isAdult
    FROM (SELECT --top 10 
      penPolicy.policykey,
      penPolicy.PolicyStart,
      penPolicy.PolicyEnd,
	  penPolicy.MaxDuration,
	  penPolicy.PrimaryCountry Destination,
      penPolicyTransaction.PolicyTransactionKey,
      penPolicyTransaction.TripCost,
      SUM(CAST(
      REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(penPolicyTransaction.TripCost, '$', ''), ',', ''), 'Unlimited', ''), 'Nil', ''), '[object Object]', ''), 'DA-', ''), 'DC-', ''), 'DE-', ''), 'FD-', ''), 'init', ''), 'More than', ''), 'null', ''), 'Please Select', ''), 'SD-', ''), ' ', ''), 'S', ''), 'C-', ''), 'D-', '')
      AS int)) OVER (PARTITION BY penPolicyTransaction.policykey ORDER BY penPolicyTransaction.issuedate) RunningTotalTripCost,
	  penPolicyTransaction.GrossPremium,
      penPolicyTransaction.IssueDate,
      penPolicyTransaction.AutoComments
    FROM [db-au-cmdwh]..penPolicy
    OUTER APPLY [db-au-cmdwh]..penPolicyTransaction
    WHERE penPolicy.CountryKey IN ('AU', 'NZ')
    --and penPolicy.policykey in ('AU-CM7-1000047')--,'AU-CM7-100027','AU-CM7-8956027')
    AND penPolicy.policykey IN (SELECT policykey FROM [db-au-cmdwh]..penPolicyTransaction WHERE IssueDate > DATEADD(YEAR, -1, GETDATE())
																							AND IssueDate >= @StartDate
																							AND IssueDate < DATEADD(DAY, 1, @EndDate))
    AND penPolicy.PolicyKey = penPolicyTransaction.PolicyKey) ppt
    OUTER APPLY [db-au-cmdwh]..penpolicytraveller
    WHERE ppt.PolicyKey = penpolicytraveller.PolicyKey) pptr
    LEFT JOIN [db-au-cmdwh]..penPolicyTravellerTransaction
      ON (pptr.PolicyTravellerKey = penPolicyTravellerTransaction.PolicyTravellerKey
      AND pptr.PolicyTransactionKey = penPolicyTravellerTransaction.PolicyTransactionKey)
    LEFT JOIN [db-au-cmdwh]..penPolicyEMC
      ON (penPolicyEMC.PolicyTravellerTransactionKey = penPolicyTravellerTransaction.policytravellertransactionkey)
    ORDER BY --pptt.PolicyTravellerTransactionKey
    policykey, IssueDate;


  UPDATE STATISTICS [db-au-actuary].ws.TravellerPremiumComponentMovemen


END;
GO

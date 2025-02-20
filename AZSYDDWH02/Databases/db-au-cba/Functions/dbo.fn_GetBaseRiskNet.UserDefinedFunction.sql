USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetBaseRiskNet]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fn_GetBaseRiskNet] (@CountryPolicyKey varchar(50))
returns float
as
begin

  declare @risknet float
  declare @policytype varchar(1)
  declare @oldpolicytype varchar(1)
  declare @oldcountrypolicykey varchar(50)
  declare @result float
  
  select
    @risknet = RiskNet,
    @policytype = PolicyType,
    @oldpolicytype = OldPolicyType,
    @oldcountrypolicykey = CountryKey + '-' + convert(varchar(48), OldPolicyNo)
  from Policy
  where CountryPolicyKey = @CountryPolicyKey

  set @result = 0

  if @policytype = 'N' 
    set @result = @risknet
    
  else if @policytype = 'R'
    set @result = @risknet
    
  else if @policytype is not null
    set @result = dbo.fn_GetBaseRiskNet(@oldcountrypolicykey)
    
  return @result

end



GO

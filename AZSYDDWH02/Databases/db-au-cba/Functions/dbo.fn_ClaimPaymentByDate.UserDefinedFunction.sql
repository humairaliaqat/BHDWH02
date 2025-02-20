USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ClaimPaymentByDate]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_ClaimPaymentByDate] (@ClaimKey varchar(9), @ReferenceDate date) returns float
as
begin

	declare @payment float

	select @payment = sum(PaymentAmount)
	from dbo.clmPayment cp
	where 
		cp.ClaimKey = @ClaimKey and
		cp.PaymentStatus in ('PAID', 'RECY') and
		cp.ModifiedDate < dateadd(day, 1, @ReferenceDate)

	return @payment

end

GO

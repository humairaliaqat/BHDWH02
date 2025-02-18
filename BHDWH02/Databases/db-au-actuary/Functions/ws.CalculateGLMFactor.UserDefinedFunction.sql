USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [ws].[CalculateGLMFactor]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [ws].[CalculateGLMFactor]
(
    @IssueDate date,
    @CountryGroup varchar(255),
    @LeadTimedBand varchar(255),
    @TripLengthBand varchar(255),
    @AMTTripLengthBand varchar(255),
    @AgeOldestBand varchar(255),
    @PlanType varchar(255),
    @JVGroup varchar(255),
    @ExcessBand varchar(255),
    @ProductGroup varchar(255),
    @NoOfChildrenBand varchar(255),
    @NoOfChargedTravellerBand varchar(255),
    @HasMotorcycle varchar(255),
    @HasEMC varchar(255),
    @HasWintersport varchar(255)
)
returns decimal(30,20)
as
begin

    declare 
        @factor decimal(30,20)

    select 
        @factor = sum(try_convert(decimal(30,20), [Estimate Value]))
        --exp(5.18952177037601801621)
        --*
    from 
        ws.GLMFactors
    where
        [Factor Name] = 'Intercept' or
        (
            [Factor Name] = 'Country_Group' and
            [Factor Level] = @CountryGroup
        ) or
        (
            [Factor Name] = 'Trip_Length_Band' and
            [Factor Level] = @TripLengthBand
        ) or
        (
            [Factor Name] = 'm_Issue' and
            [Factor Level] = right('0' + convert(varchar, datepart(mm, @IssueDate)), 2)
        ) or
        (
            [Factor Name] = 'y_Issue' and
            [Factor Level] = convert(varchar, datepart(yyyy, @IssueDate))
        ) or
        (
            [Factor Name] = 'Age_Oldest_Band' and
            [Factor Level] = @AgeOldestBand
        ) or
        (
            [Factor Name] = 'Lead_Time_Band' and
            [Factor Level] = @LeadTimedBand
        ) or
        (
            [Factor Name] = 'Plan_Type' and
            [Factor Level] = @PlanType
        ) or
        (
            [Factor Name] = 'Max_Trip_Length_Band' and
            [Factor Level] = @AMTTripLengthBand
        ) or
        (
            [Factor Name] = 'JV_Grp' and
            [Factor Level] = @JVGroup
        ) or
        (
            [Factor Name] = 'Excess_Band' and
            [Factor Level] = @ExcessBand
        ) or
        (
            [Factor Name] = 'Product_Grp' and
            [Factor Level] = @ProductGroup
        ) or
        (
            [Factor Name] = 'No_Of_Children_Band' and
            [Factor Level] = @NoOfChildrenBand
        ) or
        (
            [Factor Name] = 'No_Of_Charged_Traveller_Band' and
            [Factor Level] = @NoOfChargedTravellerBand
        ) or
        (
            [Factor Name] = 'Motorcycle_YN' and
            [Factor Level] = @HasMotorcycle
        ) or
        (
            [Factor Name] = 'Has_EMC' and
            [Factor Level] = @HasEMC
        ) or
        (
            [Factor Name] = 'Has_Wintersport' and
            [Factor Level] = @HasWintersport
        )
        

    return @factor

end

GO

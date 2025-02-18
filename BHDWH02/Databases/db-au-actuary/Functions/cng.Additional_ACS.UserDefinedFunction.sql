USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Additional_ACS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Additional_ACS] ( 
 @return_yr nvarchar(30)
,@Return_Mth nvarchar(30)
,@Trip_Length2 nvarchar(30)
,@Destination2 nvarchar(30)
,@Destination3 nvarchar(30)
,@Lead_Time2 nvarchar(30)
,@Has_EMC nvarchar(30)
,@OldestAge2 nvarchar(30)
,@Gender nvarchar(30)
,@Charged_Traveller_Count nvarchar(30)
,@Non_Charged_Traveller_Count2 nvarchar(30)
,@Traveller_Count2 nvarchar(30)
,@JV_Description nvarchar(30)
,@Product_Indicator nvarchar(30)
,@Maximum_Trip_Length nvarchar(30)
,@Excess nvarchar(30)
,@Has_Wintersport nvarchar(30)
,@Has_Motorcycle nvarchar(30)
,@Issue_Month nvarchar(30)
,@Departure_Month nvarchar(30)
,@random_group nvarchar(30)
,@EMCBand nvarchar(30)
,@EMCBand2 nvarchar(30)
)

returns float
as
begin
declare @LinearPredictor float
declare @PredictedValue float

set @LinearPredictor = 0

-- Adding the base value
set @LinearPredictor = @LinearPredictor + 7.42281196983039

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.237118020178736
    when @Trip_Length2 = '2' then -0.237118020178736
    when @Trip_Length2 = '3' then -0.237118020178736
    when @Trip_Length2 = '4' then -0.237118020178736
    when @Trip_Length2 = '5' then -0.237118020178736
    when @Trip_Length2 = '6' then -0.237118020178736
    when @Trip_Length2 = '7' then -0.237118020178736
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0
    when @Trip_Length2 = '10' then 0
    when @Trip_Length2 = '11' then 0
    when @Trip_Length2 = '12' then 0
    when @Trip_Length2 = '13' then 0
    when @Trip_Length2 = '14' then 0
    when @Trip_Length2 = '15' then 0
    when @Trip_Length2 = '16' then 0
    when @Trip_Length2 = '17' then 0
    when @Trip_Length2 = '18' then 0
    when @Trip_Length2 = '19' then 0
    when @Trip_Length2 = '20' then 0
    when @Trip_Length2 = '21' then 0
    when @Trip_Length2 = '22' then 0
    when @Trip_Length2 = '23' then 0
    when @Trip_Length2 = '24' then 0
    when @Trip_Length2 = '25' then 0
    when @Trip_Length2 = '26' then 0
    when @Trip_Length2 = '27' then 0
    when @Trip_Length2 = '28' then 0
    when @Trip_Length2 = '29' then 0
    when @Trip_Length2 = '30' then 0
    when @Trip_Length2 = '31' then 0
    when @Trip_Length2 = '32' then 0
    when @Trip_Length2 = '33' then 0
    when @Trip_Length2 = '34' then 0
    when @Trip_Length2 = '35' then 0
    when @Trip_Length2 = '36' then 0
    when @Trip_Length2 = '37' then 0
    when @Trip_Length2 = '38' then 0
    when @Trip_Length2 = '39' then 0
    when @Trip_Length2 = '40' then 0
    when @Trip_Length2 = '41' then 0
    when @Trip_Length2 = '42' then 0
    when @Trip_Length2 = '43' then 0
    when @Trip_Length2 = '44' then 0
    when @Trip_Length2 = '45' then 0
    when @Trip_Length2 = '46' then 0
    when @Trip_Length2 = '47' then 0
    when @Trip_Length2 = '48' then 0
    when @Trip_Length2 = '49' then 0
    when @Trip_Length2 = '50' then 0
    when @Trip_Length2 = '51' then 0
    when @Trip_Length2 = '52' then 0
    when @Trip_Length2 = '53' then 0
    when @Trip_Length2 = '54' then 0
    when @Trip_Length2 = '55' then 0
    when @Trip_Length2 = '56' then 0
    when @Trip_Length2 = '57' then 0
    when @Trip_Length2 = '58' then 0
    when @Trip_Length2 = '59' then 0
    when @Trip_Length2 = '60' then 0
    when @Trip_Length2 = '61' then 0
    when @Trip_Length2 = '62' then 0
    when @Trip_Length2 = '63' then 0
    when @Trip_Length2 = '64' then 0
    when @Trip_Length2 = '65' then 0
    when @Trip_Length2 = '66' then 0
    when @Trip_Length2 = '67' then 0
    when @Trip_Length2 = '68' then 0
    when @Trip_Length2 = '69' then 0
    when @Trip_Length2 = '70' then 0
    when @Trip_Length2 = '71' then 0
    when @Trip_Length2 = '72' then 0
    when @Trip_Length2 = '73' then 0
    when @Trip_Length2 = '74' then 0
    when @Trip_Length2 = '75' then 0
    when @Trip_Length2 = '76' then 0
    when @Trip_Length2 = '77' then 0
    when @Trip_Length2 = '78' then 0
    when @Trip_Length2 = '79' then 0
    when @Trip_Length2 = '80' then 0
    when @Trip_Length2 = '81' then 0
    when @Trip_Length2 = '82' then 0
    when @Trip_Length2 = '83' then 0
    when @Trip_Length2 = '84' then 0
    when @Trip_Length2 = '85' then 0
    when @Trip_Length2 = '86' then 0
    when @Trip_Length2 = '87' then 0
    when @Trip_Length2 = '88' then 0
    when @Trip_Length2 = '89' then 0
    when @Trip_Length2 = '90' then 0
    when @Trip_Length2 = '97' then 0
    when @Trip_Length2 = '104' then 0
    when @Trip_Length2 = '111' then 0
    when @Trip_Length2 = '118' then 0
    when @Trip_Length2 = '125' then 0
    when @Trip_Length2 = '132' then 0
    when @Trip_Length2 = '139' then 0
    when @Trip_Length2 = '146' then 0
    when @Trip_Length2 = '153' then 0
    when @Trip_Length2 = '160' then 0
    when @Trip_Length2 = '167' then 0
    when @Trip_Length2 = '174' then 0
    when @Trip_Length2 = '181' then 0
    when @Trip_Length2 = '188' then 0
    when @Trip_Length2 = '195' then 0
    when @Trip_Length2 = '202' then 0
    when @Trip_Length2 = '209' then 0
    when @Trip_Length2 = '216' then 0
    when @Trip_Length2 = '223' then 0
    when @Trip_Length2 = '230' then 0
    when @Trip_Length2 = '237' then 0
    when @Trip_Length2 = '244' then 0
    when @Trip_Length2 = '251' then 0
    when @Trip_Length2 = '258' then 0
    when @Trip_Length2 = '265' then 0
    when @Trip_Length2 = '272' then 0
    when @Trip_Length2 = '279' then 0
    when @Trip_Length2 = '286' then 0
    when @Trip_Length2 = '293' then 0
    when @Trip_Length2 = '300' then 0
    when @Trip_Length2 = '307' then 0
    when @Trip_Length2 = '314' then 0
    when @Trip_Length2 = '321' then 0
    when @Trip_Length2 = '328' then 0
    when @Trip_Length2 = '335' then 0
    when @Trip_Length2 = '342' then 0
    when @Trip_Length2 = '349' then 0
    when @Trip_Length2 = '356' then 0
    when @Trip_Length2 = '363' then 0
    when @Trip_Length2 = '365' then 0
    when @Trip_Length2 = '370' then 0
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.849543434430622
    when @Destination3 = 'Africa-SOUTH AFRICA' then 1.02838681292702
    when @Destination3 = 'Asia Others' then 0.730030052891072
    when @Destination3 = 'Domestic' then 0
    when @Destination3 = 'East Asia' then 0
    when @Destination3 = 'East Asia-CHINA' then 0.437206841585512
    when @Destination3 = 'East Asia-HONG KONG' then 0.437206841585512
    when @Destination3 = 'East Asia-JAPAN' then 0.730030052891072
    when @Destination3 = 'Europe' then 0.849543434430622
    when @Destination3 = 'Europe-CROATIA' then 0.849543434430622
    when @Destination3 = 'Europe-ENGLAND' then 1.02838681292702
    when @Destination3 = 'Europe-FRANCE' then 0.730030052891072
    when @Destination3 = 'Europe-GERMANY' then 0.849543434430622
    when @Destination3 = 'Europe-GREECE' then 0.849543434430622
    when @Destination3 = 'Europe-ITALY' then 0.849543434430622
    when @Destination3 = 'Europe-NETHERLANDS' then 0.849543434430622
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then 1.02838681292702
    when @Destination3 = 'Europe-SCOTLAND' then 1.02838681292702
    when @Destination3 = 'Europe-SPAIN' then 0.849543434430622
    when @Destination3 = 'Europe-SWITZERLAND' then 1.02838681292702
    when @Destination3 = 'Europe-UNITED KINGDOM' then 0.849543434430622
    when @Destination3 = 'Mid East' then 0.730030052891072
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then 1.02838681292702
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 0.849543434430622
    when @Destination3 = 'Pacific Region' then 0.730030052891072
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then 0
    when @Destination3 = 'Pacific Region-FIJI' then 0.437206841585512
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then 0.437206841585512
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0.730030052891072
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then 0.730030052891072
    when @Destination3 = 'Pacific Region-VANUATU' then 0
    when @Destination3 = 'SEA-INDONESIA' then 0.437206841585512
    when @Destination3 = 'SEA-MALAYSIA' then 0.730030052891072
    when @Destination3 = 'SEA-PHILIPPINES' then 0.437206841585512
    when @Destination3 = 'SEA-SINGAPORE' then 0.730030052891072
    when @Destination3 = 'South America' then 0.849543434430622
    when @Destination3 = 'South Asia' then 0
    when @Destination3 = 'South Asia-CAMBODIA' then 0.730030052891072
    when @Destination3 = 'South Asia-INDIA' then 0.849543434430622
    when @Destination3 = 'South Asia-NEPAL' then 1.37250055598324
    when @Destination3 = 'South Asia-SRI LANKA' then 0.437206841585512
    when @Destination3 = 'South Asia-THAILAND' then 0.849543434430622
    when @Destination3 = 'South Asia-VIETNAM' then 0.730030052891072
    when @Destination3 = 'World Others' then 0.730030052891072
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then 0
    when @Lead_Time2 = '3' then 0
    when @Lead_Time2 = '4' then 0
    when @Lead_Time2 = '5' then 0
    when @Lead_Time2 = '6' then 0
    when @Lead_Time2 = '7' then 0
    when @Lead_Time2 = '8' then 0
    when @Lead_Time2 = '9' then 0
    when @Lead_Time2 = '10' then -0.156695667430332
    when @Lead_Time2 = '11' then -0.156695667430332
    when @Lead_Time2 = '12' then -0.156695667430332
    when @Lead_Time2 = '13' then -0.156695667430332
    when @Lead_Time2 = '14' then -0.156695667430332
    when @Lead_Time2 = '15' then -0.156695667430332
    when @Lead_Time2 = '16' then -0.156695667430332
    when @Lead_Time2 = '17' then -0.156695667430332
    when @Lead_Time2 = '18' then -0.156695667430332
    when @Lead_Time2 = '19' then -0.156695667430332
    when @Lead_Time2 = '20' then -0.156695667430332
    when @Lead_Time2 = '21' then -0.156695667430332
    when @Lead_Time2 = '22' then -0.156695667430332
    when @Lead_Time2 = '23' then -0.156695667430332
    when @Lead_Time2 = '24' then -0.156695667430332
    when @Lead_Time2 = '25' then -0.156695667430332
    when @Lead_Time2 = '26' then -0.156695667430332
    when @Lead_Time2 = '27' then -0.156695667430332
    when @Lead_Time2 = '28' then -0.156695667430332
    when @Lead_Time2 = '29' then -0.156695667430332
    when @Lead_Time2 = '30' then -0.156695667430332
    when @Lead_Time2 = '31' then -0.156695667430332
    when @Lead_Time2 = '32' then -0.156695667430332
    when @Lead_Time2 = '33' then -0.156695667430332
    when @Lead_Time2 = '34' then -0.156695667430332
    when @Lead_Time2 = '35' then -0.156695667430332
    when @Lead_Time2 = '36' then -0.156695667430332
    when @Lead_Time2 = '37' then -0.156695667430332
    when @Lead_Time2 = '38' then -0.156695667430332
    when @Lead_Time2 = '39' then -0.156695667430332
    when @Lead_Time2 = '40' then -0.156695667430332
    when @Lead_Time2 = '41' then -0.156695667430332
    when @Lead_Time2 = '42' then -0.156695667430332
    when @Lead_Time2 = '43' then -0.156695667430332
    when @Lead_Time2 = '44' then -0.156695667430332
    when @Lead_Time2 = '45' then -0.156695667430332
    when @Lead_Time2 = '46' then -0.156695667430332
    when @Lead_Time2 = '47' then -0.156695667430332
    when @Lead_Time2 = '48' then -0.156695667430332
    when @Lead_Time2 = '49' then -0.156695667430332
    when @Lead_Time2 = '50' then -0.156695667430332
    when @Lead_Time2 = '51' then -0.156695667430332
    when @Lead_Time2 = '52' then -0.156695667430332
    when @Lead_Time2 = '53' then -0.156695667430332
    when @Lead_Time2 = '54' then -0.156695667430332
    when @Lead_Time2 = '55' then -0.156695667430332
    when @Lead_Time2 = '56' then -0.156695667430332
    when @Lead_Time2 = '57' then -0.156695667430332
    when @Lead_Time2 = '58' then -0.156695667430332
    when @Lead_Time2 = '59' then -0.156695667430332
    when @Lead_Time2 = '60' then -0.156695667430332
    when @Lead_Time2 = '61' then -0.156695667430332
    when @Lead_Time2 = '62' then -0.156695667430332
    when @Lead_Time2 = '63' then -0.156695667430332
    when @Lead_Time2 = '64' then -0.156695667430332
    when @Lead_Time2 = '65' then -0.156695667430332
    when @Lead_Time2 = '66' then -0.156695667430332
    when @Lead_Time2 = '67' then -0.156695667430332
    when @Lead_Time2 = '68' then -0.156695667430332
    when @Lead_Time2 = '69' then -0.156695667430332
    when @Lead_Time2 = '70' then -0.156695667430332
    when @Lead_Time2 = '71' then -0.156695667430332
    when @Lead_Time2 = '72' then -0.156695667430332
    when @Lead_Time2 = '73' then -0.156695667430332
    when @Lead_Time2 = '74' then -0.156695667430332
    when @Lead_Time2 = '75' then -0.156695667430332
    when @Lead_Time2 = '76' then -0.156695667430332
    when @Lead_Time2 = '77' then -0.156695667430332
    when @Lead_Time2 = '78' then -0.156695667430332
    when @Lead_Time2 = '79' then -0.156695667430332
    when @Lead_Time2 = '80' then -0.156695667430332
    when @Lead_Time2 = '81' then -0.156695667430332
    when @Lead_Time2 = '82' then -0.156695667430332
    when @Lead_Time2 = '83' then -0.156695667430332
    when @Lead_Time2 = '84' then -0.156695667430332
    when @Lead_Time2 = '85' then -0.156695667430332
    when @Lead_Time2 = '86' then -0.156695667430332
    when @Lead_Time2 = '87' then -0.156695667430332
    when @Lead_Time2 = '88' then -0.156695667430332
    when @Lead_Time2 = '89' then -0.156695667430332
    when @Lead_Time2 = '90' then -0.156695667430332
    when @Lead_Time2 = '91' then -0.156695667430332
    when @Lead_Time2 = '92' then -0.156695667430332
    when @Lead_Time2 = '93' then -0.156695667430332
    when @Lead_Time2 = '94' then -0.156695667430332
    when @Lead_Time2 = '95' then -0.156695667430332
    when @Lead_Time2 = '96' then -0.156695667430332
    when @Lead_Time2 = '97' then -0.156695667430332
    when @Lead_Time2 = '98' then -0.156695667430332
    when @Lead_Time2 = '99' then -0.156695667430332
    when @Lead_Time2 = '100' then -0.156695667430332
    when @Lead_Time2 = '101' then -0.156695667430332
    when @Lead_Time2 = '102' then -0.156695667430332
    when @Lead_Time2 = '103' then -0.156695667430332
    when @Lead_Time2 = '104' then -0.156695667430332
    when @Lead_Time2 = '105' then -0.156695667430332
    when @Lead_Time2 = '106' then -0.156695667430332
    when @Lead_Time2 = '107' then -0.156695667430332
    when @Lead_Time2 = '108' then -0.156695667430332
    when @Lead_Time2 = '109' then -0.156695667430332
    when @Lead_Time2 = '110' then -0.156695667430332
    when @Lead_Time2 = '111' then -0.156695667430332
    when @Lead_Time2 = '112' then -0.156695667430332
    when @Lead_Time2 = '113' then -0.156695667430332
    when @Lead_Time2 = '114' then -0.156695667430332
    when @Lead_Time2 = '115' then -0.156695667430332
    when @Lead_Time2 = '116' then -0.156695667430332
    when @Lead_Time2 = '117' then -0.156695667430332
    when @Lead_Time2 = '118' then -0.156695667430332
    when @Lead_Time2 = '119' then -0.156695667430332
    when @Lead_Time2 = '120' then -0.156695667430332
    when @Lead_Time2 = '121' then -0.156695667430332
    when @Lead_Time2 = '122' then -0.156695667430332
    when @Lead_Time2 = '123' then -0.156695667430332
    when @Lead_Time2 = '124' then -0.156695667430332
    when @Lead_Time2 = '125' then -0.156695667430332
    when @Lead_Time2 = '126' then -0.156695667430332
    when @Lead_Time2 = '127' then -0.156695667430332
    when @Lead_Time2 = '128' then -0.156695667430332
    when @Lead_Time2 = '129' then -0.156695667430332
    when @Lead_Time2 = '130' then -0.156695667430332
    when @Lead_Time2 = '131' then -0.156695667430332
    when @Lead_Time2 = '132' then -0.156695667430332
    when @Lead_Time2 = '133' then -0.156695667430332
    when @Lead_Time2 = '134' then -0.156695667430332
    when @Lead_Time2 = '135' then -0.156695667430332
    when @Lead_Time2 = '136' then -0.156695667430332
    when @Lead_Time2 = '137' then -0.156695667430332
    when @Lead_Time2 = '138' then -0.156695667430332
    when @Lead_Time2 = '139' then -0.156695667430332
    when @Lead_Time2 = '140' then -0.156695667430332
    when @Lead_Time2 = '141' then -0.156695667430332
    when @Lead_Time2 = '142' then -0.156695667430332
    when @Lead_Time2 = '143' then -0.156695667430332
    when @Lead_Time2 = '144' then -0.156695667430332
    when @Lead_Time2 = '145' then -0.156695667430332
    when @Lead_Time2 = '146' then -0.156695667430332
    when @Lead_Time2 = '147' then -0.156695667430332
    when @Lead_Time2 = '148' then -0.156695667430332
    when @Lead_Time2 = '149' then -0.156695667430332
    when @Lead_Time2 = '150' then -0.156695667430332
    when @Lead_Time2 = '151' then -0.156695667430332
    when @Lead_Time2 = '152' then -0.156695667430332
    when @Lead_Time2 = '153' then -0.156695667430332
    when @Lead_Time2 = '154' then -0.156695667430332
    when @Lead_Time2 = '155' then -0.156695667430332
    when @Lead_Time2 = '156' then -0.156695667430332
    when @Lead_Time2 = '157' then -0.156695667430332
    when @Lead_Time2 = '158' then -0.156695667430332
    when @Lead_Time2 = '159' then -0.156695667430332
    when @Lead_Time2 = '160' then -0.156695667430332
    when @Lead_Time2 = '161' then -0.156695667430332
    when @Lead_Time2 = '162' then -0.156695667430332
    when @Lead_Time2 = '163' then -0.156695667430332
    when @Lead_Time2 = '164' then -0.156695667430332
    when @Lead_Time2 = '165' then -0.156695667430332
    when @Lead_Time2 = '166' then -0.156695667430332
    when @Lead_Time2 = '167' then -0.156695667430332
    when @Lead_Time2 = '168' then -0.156695667430332
    when @Lead_Time2 = '169' then -0.156695667430332
    when @Lead_Time2 = '170' then -0.156695667430332
    when @Lead_Time2 = '171' then -0.156695667430332
    when @Lead_Time2 = '172' then -0.156695667430332
    when @Lead_Time2 = '173' then -0.156695667430332
    when @Lead_Time2 = '174' then -0.156695667430332
    when @Lead_Time2 = '175' then -0.156695667430332
    when @Lead_Time2 = '176' then -0.156695667430332
    when @Lead_Time2 = '177' then -0.156695667430332
    when @Lead_Time2 = '178' then -0.156695667430332
    when @Lead_Time2 = '179' then -0.156695667430332
    when @Lead_Time2 = '180' then -0.156695667430332
    when @Lead_Time2 = '181' then -0.156695667430332
    when @Lead_Time2 = '188' then -0.156695667430332
    when @Lead_Time2 = '195' then -0.156695667430332
    when @Lead_Time2 = '202' then -0.156695667430332
    when @Lead_Time2 = '209' then -0.156695667430332
    when @Lead_Time2 = '216' then -0.156695667430332
    when @Lead_Time2 = '223' then -0.156695667430332
    when @Lead_Time2 = '230' then -0.156695667430332
    when @Lead_Time2 = '237' then -0.156695667430332
    when @Lead_Time2 = '244' then -0.156695667430332
    when @Lead_Time2 = '251' then -0.156695667430332
    when @Lead_Time2 = '258' then -0.156695667430332
    when @Lead_Time2 = '265' then -0.156695667430332
    when @Lead_Time2 = '272' then -0.156695667430332
    when @Lead_Time2 = '279' then -0.156695667430332
    when @Lead_Time2 = '286' then -0.156695667430332
    when @Lead_Time2 = '293' then -0.156695667430332
    when @Lead_Time2 = '300' then -0.156695667430332
    when @Lead_Time2 = '307' then -0.156695667430332
    when @Lead_Time2 = '314' then -0.156695667430332
    when @Lead_Time2 = '321' then -0.156695667430332
    when @Lead_Time2 = '328' then -0.156695667430332
    when @Lead_Time2 = '335' then -0.156695667430332
    when @Lead_Time2 = '342' then -0.156695667430332
    when @Lead_Time2 = '349' then -0.156695667430332
    when @Lead_Time2 = '356' then -0.156695667430332
    when @Lead_Time2 = '363' then -0.156695667430332
    when @Lead_Time2 = '370' then -0.156695667430332
    when @Lead_Time2 = '377' then -0.156695667430332
    when @Lead_Time2 = '384' then -0.156695667430332
    when @Lead_Time2 = '391' then -0.156695667430332
    when @Lead_Time2 = '398' then -0.156695667430332
    when @Lead_Time2 = '405' then -0.156695667430332
    when @Lead_Time2 = '412' then -0.156695667430332
    when @Lead_Time2 = '419' then -0.156695667430332
    when @Lead_Time2 = '426' then -0.156695667430332
    when @Lead_Time2 = '433' then -0.156695667430332
    when @Lead_Time2 = '440' then -0.156695667430332
    when @Lead_Time2 = '447' then -0.156695667430332
    when @Lead_Time2 = '454' then -0.156695667430332
    when @Lead_Time2 = '461' then -0.156695667430332
    when @Lead_Time2 = '468' then -0.156695667430332
    when @Lead_Time2 = '475' then -0.156695667430332
    when @Lead_Time2 = '482' then -0.156695667430332
    when @Lead_Time2 = '489' then -0.156695667430332
    when @Lead_Time2 = '496' then -0.156695667430332
    when @Lead_Time2 = '503' then -0.156695667430332
    when @Lead_Time2 = '510' then -0.156695667430332
    when @Lead_Time2 = '517' then -0.156695667430332
    when @Lead_Time2 = '524' then -0.156695667430332
    when @Lead_Time2 = '531' then -0.156695667430332
    when @Lead_Time2 = '538' then -0.156695667430332
    when @Lead_Time2 = '545' then -0.156695667430332
    when @Lead_Time2 = '552' then -0.156695667430332
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then -0.462980966603908
    when @OldestAge2 = '12' then -0.704703344875293
    when @OldestAge2 = '13' then -0.690462679456506
    when @OldestAge2 = '14' then -0.658551355608596
    when @OldestAge2 = '15' then -0.616411421787705
    when @OldestAge2 = '16' then -0.572010221776731
    when @OldestAge2 = '17' then -0.531381266874967
    when @OldestAge2 = '18' then -0.497732621414183
    when @OldestAge2 = '19' then -0.471744856153955
    when @OldestAge2 = '20' then -0.452358468474872
    when @OldestAge2 = '21' then -0.437568559274134
    when @OldestAge2 = '22' then -0.425047115507726
    when @OldestAge2 = '23' then -0.412612923379092
    when @OldestAge2 = '24' then -0.398616130810141
    when @OldestAge2 = '25' then -0.382233905720877
    when @OldestAge2 = '26' then -0.363583747929467
    when @OldestAge2 = '27' then -0.343565382195378
    when @OldestAge2 = '28' then -0.323458983718528
    when @OldestAge2 = '29' then -0.304439876081796
    when @OldestAge2 = '30' then -0.287205027153209
    when @OldestAge2 = '31' then -0.271826272722421
    when @OldestAge2 = '32' then -0.257821772444712
    when @OldestAge2 = '33' then -0.244351578574924
    when @OldestAge2 = '34' then -0.230434623150836
    when @OldestAge2 = '35' then -0.215134721033245
    when @OldestAge2 = '36' then -0.197723501045639
    when @OldestAge2 = '37' then -0.177843452136889
    when @OldestAge2 = '38' then -0.155655377753332
    when @OldestAge2 = '39' then -0.131902087094672
    when @OldestAge2 = '40' then -0.10781847309837
    when @OldestAge2 = '41' then -0.0848818555066986
    when @OldestAge2 = '42' then -0.0644792326202399
    when @OldestAge2 = '43' then -0.0476021944928381
    when @OldestAge2 = '44' then -0.0346518028804628
    when @OldestAge2 = '45' then -0.0253822978049935
    when @OldestAge2 = '46' then -0.0189812769411395
    when @OldestAge2 = '47' then -0.0142783615717166
    when @OldestAge2 = '48' then -0.0100605390469246
    when @OldestAge2 = '49' then -0.00542018878428066
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00599612377605223
    when @OldestAge2 = '52' then 0.0120425519411204
    when @OldestAge2 = '53' then 0.0176415222759089
    when @OldestAge2 = '54' then 0.0225730711316308
    when @OldestAge2 = '55' then 0.0269180250733543
    when @OldestAge2 = '56' then 0.0309002372572778
    when @OldestAge2 = '57' then 0.0347271596917276
    when @OldestAge2 = '58' then 0.0386013323439025
    when @OldestAge2 = '59' then 0.0429347387340719
    when @OldestAge2 = '60' then 0.0486261082840596
    when @OldestAge2 = '61' then 0.057174285475761
    when @OldestAge2 = '62' then 0.0704528037339918
    when @OldestAge2 = '63' then 0.0901456869261094
    when @OldestAge2 = '64' then 0.1170653536911
    when @OldestAge2 = '65' then 0.150699825358185
    when @OldestAge2 = '66' then 0.189236849273165
    when @OldestAge2 = '67' then 0.230027739737231
    when @OldestAge2 = '68' then 0.270214783377211
    when @OldestAge2 = '69' then 0.307243671103728
    when @OldestAge2 = '70' then 0.339169852056012
    when @OldestAge2 = '71' then 0.364853558572455
    when @OldestAge2 = '72' then 0.384184830333167
    when @OldestAge2 = '73' then 0.398383376955071
    when @OldestAge2 = '74' then 0.410252179483368
    when @OldestAge2 = '75' then 0.424116965791108
    when @OldestAge2 = '76' then 0.445155561493083
    when @OldestAge2 = '77' then 0.478040425738953
    when @OldestAge2 = '78' then 0.525314741349113
    when @OldestAge2 = '79' then 0.586365623076679
    when @OldestAge2 = '80' then 0.657676317568843
    when @OldestAge2 = '81' then 0.734196990284666
    when @OldestAge2 = '82' then 0.810962475893989
    when @OldestAge2 = '83' then 0.88413926393701
    when @OldestAge2 = '84' then 0.951250315346183
    when @OldestAge2 = '85' then 1.01081952362341
    when @OldestAge2 = '86' then 1.06184558985949
    when @OldestAge2 = '87' then 1.10342286088565
    when @OldestAge2 = '88' then 1.13462516153958
    when @OldestAge2 = '89' then 1.154592993128
    when @OldestAge2 = '90' then 1.16269372033363
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then -0.246081806059724
    when @JV_Description = 'Air New Zealand' then 0
    when @JV_Description = 'Australia Post' then -0.0671301881889512
    when @JV_Description = 'CBA White Label' then 0
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then 0
    when @JV_Description = 'Helloworld' then 0.18124936392265
    when @JV_Description = 'Indep + Others' then 0.18124936392265
    when @JV_Description = 'Insurance Australia Ltd' then 0
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then -0.246081806059724
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then -0.0671301881889512
    when @JV_Description = 'Virgin' then 0
    when @JV_Description = 'Websales' then -0.0671301881889512
    when @JV_Description = 'YouGo' then 0
end

-- Start of Product_Indicator
set @LinearPredictor = @LinearPredictor +
case
     when @Product_Indicator = 'Car Hire' then 0
     when @Product_Indicator = 'Corporate' then 0
     when @Product_Indicator = 'Domestic AMT' then 0
     when @Product_Indicator = 'Domestic Cancellation' then 0
     when @Product_Indicator = 'Domestic Inbound' then 0
     when @Product_Indicator = 'Domestic Single Trip' then 0
     when @Product_Indicator = 'Domestic Single Trip Integrated' then 0
     when @Product_Indicator = 'International AMT' then -0.122997539715405
     when @Product_Indicator = 'International Single Trip' then 0
     when @Product_Indicator = 'International Single Trip Integrated' then 0
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then -0.319241541359546
    when @Excess = '25' then -0.285284947852059
    when @Excess = '50' then -0.252572362005022
    when @Excess = '60' then -0.239783660696004
    when @Excess = '100' then -0.190192451174524
    when @Excess = '150' then -0.0905813782312386
    when @Excess = '200' then 0
    when @Excess = '250' then 0
    when @Excess = '300' then 0.0582288658128595
    when @Excess = '500' then 0.262210406478111
    when @Excess = '1000' then 0.357511184092451
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0.291922745767973
    when @Departure_Month = '2' then -0.0954934397182195
    when @Departure_Month = '3' then -0.0954934397182195
    when @Departure_Month = '4' then -0.0954934397182195
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then -0.0954934397182195
    when @Departure_Month = '9' then 0
    when @Departure_Month = '10' then 0
    when @Departure_Month = '11' then 0
    when @Departure_Month = '12' then 0
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.0897569174125383
    when @EMCBand = '1_>50%' then 0.0897569174125383
    when @EMCBand = '2_<50%' then 0.0897569174125383
    when @EMCBand = '2_>50%' then 0.0897569174125383
    when @EMCBand = '3_<50%' then 0.0897569174125383
    when @EMCBand = '3_>50%' then 0.0897569174125383
    when @EMCBand = '4_<50%' then 0.210377525329019
    when @EMCBand = '4_>50%' then 0.210377525329019
    when @EMCBand = '5_<50%' then 0.210377525329019
    when @EMCBand = '5_>50%' then 0.210377525329019
    when @EMCBand = '6_<50%' then 0.210377525329019
    when @EMCBand = '6_>50%' then 0.210377525329019
    when @EMCBand = '7_<50%' then 0.210377525329019
    when @EMCBand = '7_>50%' then 0.210377525329019
    when @EMCBand = '8_<50%' then 0.210377525329019
    when @EMCBand = '8_>50%' then 0.210377525329019
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.204732402399806
    when @Gender = 'FF' then 0
    when @Gender = 'FM' then 0
    when @Gender = 'M' then 0
    when @Gender = 'MM' then 0
    when @Gender = 'O' then 0
    when @Gender = 'U' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

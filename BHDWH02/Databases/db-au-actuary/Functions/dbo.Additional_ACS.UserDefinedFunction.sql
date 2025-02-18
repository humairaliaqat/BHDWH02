USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [dbo].[Additional_ACS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create function [dbo].[Additional_ACS]
 ( @return_yr as nvarchar(30) 
 , @return_mth nvarchar(30) 
 , @Trip_Length2 nvarchar(30) 
 , @Destination2 nvarchar(30) 
 , @Destination3 nvarchar(30) 
 , @Lead_Time2 nvarchar(30) 
 , @Has_EMC nvarchar(30) 
 , @OldestAge2 nvarchar(30) 
 , @Gender nvarchar(30) 
 , @Charged_Traveller_Count nvarchar
 , @Non_Charged_Traveller_Count2 nvarchar(30) 
 , @Traveller_Count2 nvarchar(30) 
 , @JV_Description nvarchar(30) 
 , @Product_Indicator nvarchar(30) 
 , @Maximum_Trip_Length nvarchar(30) 
 , @Excess nvarchar(30) 
 , @Has_Wintersport nvarchar(30) 
 , @Has_Motorcycle nvarchar(30) 
 , @Issue_Month nvarchar(30) 
 , @Departure_Month nvarchar(30) 
 , @random_group nvarchar(30) 
 , @EMCBand nvarchar(30) 
 , @EMCBand2 nvarchar(30) 
 ) 
returns float 
as 
begin 
declare @LinearPredictor float 
declare @PredictedValue float 

set @LinearPredictor = 0
 
-- Adding the base value 
 set @LinearPredictor = @LinearPredictor +  7.01066382948124 

 -- Start of return_yr
set @LinearPredictor = @LinearPredictor + 
case
   when @return_yr = '2016' then    0
   when @return_yr = '2017' then    .132307210053531
 end 
 

 -- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor + 
case
   when @Trip_Length2 = '0' then    0
   when @Trip_Length2 = '1' then    0
   when @Trip_Length2 = '2' then    0
   when @Trip_Length2 = '3' then    0
   when @Trip_Length2 = '4' then    0
   when @Trip_Length2 = '5' then    0
   when @Trip_Length2 = '6' then    0
   when @Trip_Length2 = '7' then    0
   when @Trip_Length2 = '8' then    0
   when @Trip_Length2 = '9' then    0
   when @Trip_Length2 = '10' then    .31625972993871
   when @Trip_Length2 = '11' then    .31625972993871
   when @Trip_Length2 = '12' then    .31625972993871
   when @Trip_Length2 = '13' then    .31625972993871
   when @Trip_Length2 = '14' then    .31625972993871
   when @Trip_Length2 = '15' then    .31625972993871
   when @Trip_Length2 = '16' then    .31625972993871
   when @Trip_Length2 = '17' then    .31625972993871
   when @Trip_Length2 = '18' then    .31625972993871
   when @Trip_Length2 = '19' then    .31625972993871
   when @Trip_Length2 = '20' then    .31625972993871
   when @Trip_Length2 = '21' then    .31625972993871
   when @Trip_Length2 = '22' then    .31625972993871
   when @Trip_Length2 = '23' then    .31625972993871
   when @Trip_Length2 = '24' then    .31625972993871
   when @Trip_Length2 = '25' then    .31625972993871
   when @Trip_Length2 = '26' then    .31625972993871
   when @Trip_Length2 = '27' then    .31625972993871
   when @Trip_Length2 = '28' then    .31625972993871
   when @Trip_Length2 = '29' then    .31625972993871
   when @Trip_Length2 = '30' then    .31625972993871
   when @Trip_Length2 = '31' then    .31625972993871
   when @Trip_Length2 = '32' then    .31625972993871
   when @Trip_Length2 = '33' then    .31625972993871
   when @Trip_Length2 = '34' then    .31625972993871
   when @Trip_Length2 = '35' then    .31625972993871
   when @Trip_Length2 = '36' then    .31625972993871
   when @Trip_Length2 = '37' then    .31625972993871
   when @Trip_Length2 = '38' then    .31625972993871
   when @Trip_Length2 = '39' then    .31625972993871
   when @Trip_Length2 = '40' then    .31625972993871
   when @Trip_Length2 = '41' then    .31625972993871
   when @Trip_Length2 = '42' then    .31625972993871
   when @Trip_Length2 = '43' then    .31625972993871
   when @Trip_Length2 = '44' then    .31625972993871
   when @Trip_Length2 = '45' then    .31625972993871
   when @Trip_Length2 = '46' then    .31625972993871
   when @Trip_Length2 = '47' then    .31625972993871
   when @Trip_Length2 = '48' then    .31625972993871
   when @Trip_Length2 = '49' then    .31625972993871
   when @Trip_Length2 = '50' then    .31625972993871
   when @Trip_Length2 = '51' then    .31625972993871
   when @Trip_Length2 = '52' then    .31625972993871
   when @Trip_Length2 = '53' then    .31625972993871
   when @Trip_Length2 = '54' then    .31625972993871
   when @Trip_Length2 = '55' then    .31625972993871
   when @Trip_Length2 = '56' then    .31625972993871
   when @Trip_Length2 = '57' then    .31625972993871
   when @Trip_Length2 = '58' then    .31625972993871
   when @Trip_Length2 = '59' then    .31625972993871
   when @Trip_Length2 = '60' then    .31625972993871
   when @Trip_Length2 = '61' then    .31625972993871
   when @Trip_Length2 = '62' then    .31625972993871
   when @Trip_Length2 = '63' then    .31625972993871
   when @Trip_Length2 = '64' then    .31625972993871
   when @Trip_Length2 = '65' then    .31625972993871
   when @Trip_Length2 = '66' then    .31625972993871
   when @Trip_Length2 = '67' then    .31625972993871
   when @Trip_Length2 = '68' then    .31625972993871
   when @Trip_Length2 = '69' then    .31625972993871
   when @Trip_Length2 = '70' then    .31625972993871
   when @Trip_Length2 = '71' then    .31625972993871
   when @Trip_Length2 = '72' then    .31625972993871
   when @Trip_Length2 = '73' then    .31625972993871
   when @Trip_Length2 = '74' then    .31625972993871
   when @Trip_Length2 = '75' then    .31625972993871
   when @Trip_Length2 = '76' then    .31625972993871
   when @Trip_Length2 = '77' then    .31625972993871
   when @Trip_Length2 = '78' then    .31625972993871
   when @Trip_Length2 = '79' then    .31625972993871
   when @Trip_Length2 = '80' then    .31625972993871
   when @Trip_Length2 = '81' then    .31625972993871
   when @Trip_Length2 = '82' then    .31625972993871
   when @Trip_Length2 = '83' then    .31625972993871
   when @Trip_Length2 = '84' then    .31625972993871
   when @Trip_Length2 = '85' then    .31625972993871
   when @Trip_Length2 = '86' then    .31625972993871
   when @Trip_Length2 = '87' then    .31625972993871
   when @Trip_Length2 = '88' then    .31625972993871
   when @Trip_Length2 = '89' then    .31625972993871
   when @Trip_Length2 = '90' then    .31625972993871
   when @Trip_Length2 = '97' then    .31625972993871
   when @Trip_Length2 = '104' then    .31625972993871
   when @Trip_Length2 = '111' then    .31625972993871
   when @Trip_Length2 = '118' then    .31625972993871
   when @Trip_Length2 = '125' then    .31625972993871
   when @Trip_Length2 = '132' then    .31625972993871
   when @Trip_Length2 = '139' then    .31625972993871
   when @Trip_Length2 = '146' then    .31625972993871
   when @Trip_Length2 = '153' then    .31625972993871
   when @Trip_Length2 = '160' then    .31625972993871
   when @Trip_Length2 = '167' then    .31625972993871
   when @Trip_Length2 = '174' then    .31625972993871
   when @Trip_Length2 = '181' then    .31625972993871
   when @Trip_Length2 = '188' then    .31625972993871
   when @Trip_Length2 = '195' then    .31625972993871
   when @Trip_Length2 = '202' then    .31625972993871
   when @Trip_Length2 = '209' then    .31625972993871
   when @Trip_Length2 = '216' then    .31625972993871
   when @Trip_Length2 = '223' then    .31625972993871
   when @Trip_Length2 = '230' then    .31625972993871
   when @Trip_Length2 = '237' then    .31625972993871
   when @Trip_Length2 = '244' then    .31625972993871
   when @Trip_Length2 = '251' then    .31625972993871
   when @Trip_Length2 = '258' then    .31625972993871
   when @Trip_Length2 = '265' then    .31625972993871
   when @Trip_Length2 = '272' then    .31625972993871
   when @Trip_Length2 = '279' then    .31625972993871
   when @Trip_Length2 = '286' then    .31625972993871
   when @Trip_Length2 = '293' then    .31625972993871
   when @Trip_Length2 = '300' then    .31625972993871
   when @Trip_Length2 = '307' then    .31625972993871
   when @Trip_Length2 = '314' then    .31625972993871
   when @Trip_Length2 = '321' then    .31625972993871
   when @Trip_Length2 = '328' then    .31625972993871
   when @Trip_Length2 = '335' then    .31625972993871
   when @Trip_Length2 = '342' then    .31625972993871
   when @Trip_Length2 = '349' then    .31625972993871
   when @Trip_Length2 = '356' then    .31625972993871
   when @Trip_Length2 = '363' then    .31625972993871
   when @Trip_Length2 = '365' then    .31625972993871
   when @Trip_Length2 = '370' then    .31625972993871
 end 
 

 -- Start of Destination3
set @LinearPredictor = @LinearPredictor + 
case
   when @Destination3 = 'Africa' then    .837381425771795
   when @Destination3 = 'Africa-SOUTH AFRICA' then    .326704594327417
   when @Destination3 = 'America Others' then    0
   when @Destination3 = 'Asia Others' then    .326704594327417
   when @Destination3 = 'Domestic' then    0
   when @Destination3 = 'East Asia' then    0
   when @Destination3 = 'East Asia-CHINA' then    .326704594327417
   when @Destination3 = 'East Asia-HONG KONG' then    .326704594327417
   when @Destination3 = 'East Asia-JAPAN' then    .837381425771795
   when @Destination3 = 'Europe' then    .638882806796112
   when @Destination3 = 'Europe-ENGLAND' then    .837381425771795
   when @Destination3 = 'Europe-FRANCE' then    .638882806796112
   when @Destination3 = 'Europe-GERMANY' then    .638882806796112
   when @Destination3 = 'Europe-GREECE' then    .638882806796112
   when @Destination3 = 'Europe-ITALY' then    .837381425771795
   when @Destination3 = 'Europe-SPAIN' then    .326704594327417
   when @Destination3 = 'Mid East' then    .638882806796112
   when @Destination3 = 'New Zealand-NEW ZEALAND' then    0
   when @Destination3 = 'North America' then    .326704594327417
   when @Destination3 = 'North America-CANADA' then    .837381425771795
   when @Destination3 = 'North America-UNITED STATES OF AMERICA' then    .638882806796112
   when @Destination3 = 'Pacific Region' then    0
   when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then    0
   when @Destination3 = 'Pacific Region-FIJI' then    .326704594327417
   when @Destination3 = 'Pacific Region-NEW CALEDONIA' then    0
   when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then    .638882806796112
   when @Destination3 = 'Pacific Region-VANUATU' then    .638882806796112
   when @Destination3 = 'SEA' then    .638882806796112
   when @Destination3 = 'SEA-INDONESIA' then    .326704594327417
   when @Destination3 = 'SEA-MALAYSIA' then    .326704594327417
   when @Destination3 = 'SEA-PHILIPPINES' then    .326704594327417
   when @Destination3 = 'SEA-SINGAPORE' then    .326704594327417
   when @Destination3 = 'South America' then    .638882806796112
   when @Destination3 = 'South Asia' then    .837381425771795
   when @Destination3 = 'South Asia-INDIA' then    .326704594327417
   when @Destination3 = 'South Asia-THAILAND' then    .638882806796112
   when @Destination3 = 'South Asia-VIETNAM' then    .638882806796112
   when @Destination3 = 'World Others' then    .638882806796112
   when @Destination3 is null  then    0
 end 
 

 -- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor + 
case
   when @Lead_Time2 = '0' then    0
   when @Lead_Time2 = '1' then    0
   when @Lead_Time2 = '2' then    0
   when @Lead_Time2 = '3' then    0
   when @Lead_Time2 = '4' then    0
   when @Lead_Time2 = '5' then    0
   when @Lead_Time2 = '6' then    0
   when @Lead_Time2 = '7' then    0
   when @Lead_Time2 = '8' then    0
   when @Lead_Time2 = '9' then    0
   when @Lead_Time2 = '10' then   -.118765485094271
   when @Lead_Time2 = '11' then   -.118765485094271
   when @Lead_Time2 = '12' then   -.118765485094271
   when @Lead_Time2 = '13' then   -.118765485094271
   when @Lead_Time2 = '14' then   -.118765485094271
   when @Lead_Time2 = '15' then   -.118765485094271
   when @Lead_Time2 = '16' then   -.118765485094271
   when @Lead_Time2 = '17' then   -.118765485094271
   when @Lead_Time2 = '18' then   -.118765485094271
   when @Lead_Time2 = '19' then   -.118765485094271
   when @Lead_Time2 = '20' then   -.118765485094271
   when @Lead_Time2 = '21' then   -.118765485094271
   when @Lead_Time2 = '22' then   -.118765485094271
   when @Lead_Time2 = '23' then   -.118765485094271
   when @Lead_Time2 = '24' then   -.118765485094271
   when @Lead_Time2 = '25' then   -.118765485094271
   when @Lead_Time2 = '26' then   -.118765485094271
   when @Lead_Time2 = '27' then   -.118765485094271
   when @Lead_Time2 = '28' then   -.118765485094271
   when @Lead_Time2 = '29' then   -.118765485094271
   when @Lead_Time2 = '30' then   -.118765485094271
   when @Lead_Time2 = '31' then   -.118765485094271
   when @Lead_Time2 = '32' then   -.118765485094271
   when @Lead_Time2 = '33' then   -.118765485094271
   when @Lead_Time2 = '34' then   -.118765485094271
   when @Lead_Time2 = '35' then   -.118765485094271
   when @Lead_Time2 = '36' then   -.118765485094271
   when @Lead_Time2 = '37' then   -.118765485094271
   when @Lead_Time2 = '38' then   -.118765485094271
   when @Lead_Time2 = '39' then   -.118765485094271
   when @Lead_Time2 = '40' then   -.118765485094271
   when @Lead_Time2 = '41' then   -.118765485094271
   when @Lead_Time2 = '42' then   -.118765485094271
   when @Lead_Time2 = '43' then   -.118765485094271
   when @Lead_Time2 = '44' then   -.118765485094271
   when @Lead_Time2 = '45' then   -.118765485094271
   when @Lead_Time2 = '46' then   -.118765485094271
   when @Lead_Time2 = '47' then   -.118765485094271
   when @Lead_Time2 = '48' then   -.118765485094271
   when @Lead_Time2 = '49' then   -.118765485094271
   when @Lead_Time2 = '50' then   -.118765485094271
   when @Lead_Time2 = '51' then   -.118765485094271
   when @Lead_Time2 = '52' then   -.118765485094271
   when @Lead_Time2 = '53' then   -.118765485094271
   when @Lead_Time2 = '54' then   -.118765485094271
   when @Lead_Time2 = '55' then   -.118765485094271
   when @Lead_Time2 = '56' then   -.118765485094271
   when @Lead_Time2 = '57' then   -.118765485094271
   when @Lead_Time2 = '58' then   -.118765485094271
   when @Lead_Time2 = '59' then   -.118765485094271
   when @Lead_Time2 = '60' then   -.118765485094271
   when @Lead_Time2 = '61' then   -.118765485094271
   when @Lead_Time2 = '62' then   -.118765485094271
   when @Lead_Time2 = '63' then   -.118765485094271
   when @Lead_Time2 = '64' then   -.118765485094271
   when @Lead_Time2 = '65' then   -.118765485094271
   when @Lead_Time2 = '66' then   -.118765485094271
   when @Lead_Time2 = '67' then   -.118765485094271
   when @Lead_Time2 = '68' then   -.118765485094271
   when @Lead_Time2 = '69' then   -.118765485094271
   when @Lead_Time2 = '70' then   -.118765485094271
   when @Lead_Time2 = '71' then   -.118765485094271
   when @Lead_Time2 = '72' then   -.118765485094271
   when @Lead_Time2 = '73' then   -.118765485094271
   when @Lead_Time2 = '74' then   -.118765485094271
   when @Lead_Time2 = '75' then   -.118765485094271
   when @Lead_Time2 = '76' then   -.118765485094271
   when @Lead_Time2 = '77' then   -.118765485094271
   when @Lead_Time2 = '78' then   -.118765485094271
   when @Lead_Time2 = '79' then   -.118765485094271
   when @Lead_Time2 = '80' then   -.118765485094271
   when @Lead_Time2 = '81' then   -.118765485094271
   when @Lead_Time2 = '82' then   -.118765485094271
   when @Lead_Time2 = '83' then   -.118765485094271
   when @Lead_Time2 = '84' then   -.118765485094271
   when @Lead_Time2 = '85' then   -.118765485094271
   when @Lead_Time2 = '86' then   -.118765485094271
   when @Lead_Time2 = '87' then   -.118765485094271
   when @Lead_Time2 = '88' then   -.118765485094271
   when @Lead_Time2 = '89' then   -.118765485094271
   when @Lead_Time2 = '90' then   -.118765485094271
   when @Lead_Time2 = '91' then   -.118765485094271
   when @Lead_Time2 = '92' then   -.118765485094271
   when @Lead_Time2 = '93' then   -.118765485094271
   when @Lead_Time2 = '94' then   -.118765485094271
   when @Lead_Time2 = '95' then   -.118765485094271
   when @Lead_Time2 = '96' then   -.118765485094271
   when @Lead_Time2 = '97' then   -.118765485094271
   when @Lead_Time2 = '98' then   -.118765485094271
   when @Lead_Time2 = '99' then   -.118765485094271
   when @Lead_Time2 = '100' then   -.118765485094271
   when @Lead_Time2 = '101' then   -.118765485094271
   when @Lead_Time2 = '102' then   -.118765485094271
   when @Lead_Time2 = '103' then   -.118765485094271
   when @Lead_Time2 = '104' then   -.118765485094271
   when @Lead_Time2 = '105' then   -.118765485094271
   when @Lead_Time2 = '106' then   -.118765485094271
   when @Lead_Time2 = '107' then   -.118765485094271
   when @Lead_Time2 = '108' then   -.118765485094271
   when @Lead_Time2 = '109' then   -.118765485094271
   when @Lead_Time2 = '110' then   -.118765485094271
   when @Lead_Time2 = '111' then   -.118765485094271
   when @Lead_Time2 = '112' then   -.118765485094271
   when @Lead_Time2 = '113' then   -.118765485094271
   when @Lead_Time2 = '114' then   -.118765485094271
   when @Lead_Time2 = '115' then   -.118765485094271
   when @Lead_Time2 = '116' then   -.118765485094271
   when @Lead_Time2 = '117' then   -.118765485094271
   when @Lead_Time2 = '118' then   -.118765485094271
   when @Lead_Time2 = '119' then   -.118765485094271
   when @Lead_Time2 = '120' then   -.118765485094271
   when @Lead_Time2 = '121' then   -.118765485094271
   when @Lead_Time2 = '122' then   -.118765485094271
   when @Lead_Time2 = '123' then   -.118765485094271
   when @Lead_Time2 = '124' then   -.118765485094271
   when @Lead_Time2 = '125' then   -.118765485094271
   when @Lead_Time2 = '126' then   -.118765485094271
   when @Lead_Time2 = '127' then   -.118765485094271
   when @Lead_Time2 = '128' then   -.118765485094271
   when @Lead_Time2 = '129' then   -.118765485094271
   when @Lead_Time2 = '130' then   -.118765485094271
   when @Lead_Time2 = '131' then   -.118765485094271
   when @Lead_Time2 = '132' then   -.118765485094271
   when @Lead_Time2 = '133' then   -.118765485094271
   when @Lead_Time2 = '134' then   -.118765485094271
   when @Lead_Time2 = '135' then   -.118765485094271
   when @Lead_Time2 = '136' then   -.118765485094271
   when @Lead_Time2 = '137' then   -.118765485094271
   when @Lead_Time2 = '138' then   -.118765485094271
   when @Lead_Time2 = '139' then   -.118765485094271
   when @Lead_Time2 = '140' then   -.118765485094271
   when @Lead_Time2 = '141' then   -.118765485094271
   when @Lead_Time2 = '142' then   -.118765485094271
   when @Lead_Time2 = '143' then   -.118765485094271
   when @Lead_Time2 = '144' then   -.118765485094271
   when @Lead_Time2 = '145' then   -.118765485094271
   when @Lead_Time2 = '146' then   -.118765485094271
   when @Lead_Time2 = '147' then   -.118765485094271
   when @Lead_Time2 = '148' then   -.118765485094271
   when @Lead_Time2 = '149' then   -.118765485094271
   when @Lead_Time2 = '150' then   -.118765485094271
   when @Lead_Time2 = '151' then   -.118765485094271
   when @Lead_Time2 = '152' then   -.118765485094271
   when @Lead_Time2 = '153' then   -.118765485094271
   when @Lead_Time2 = '154' then   -.118765485094271
   when @Lead_Time2 = '155' then   -.118765485094271
   when @Lead_Time2 = '156' then   -.118765485094271
   when @Lead_Time2 = '157' then   -.118765485094271
   when @Lead_Time2 = '158' then   -.118765485094271
   when @Lead_Time2 = '159' then   -.118765485094271
   when @Lead_Time2 = '160' then   -.118765485094271
   when @Lead_Time2 = '161' then   -.118765485094271
   when @Lead_Time2 = '162' then   -.118765485094271
   when @Lead_Time2 = '163' then   -.118765485094271
   when @Lead_Time2 = '164' then   -.118765485094271
   when @Lead_Time2 = '165' then   -.118765485094271
   when @Lead_Time2 = '166' then   -.118765485094271
   when @Lead_Time2 = '167' then   -.118765485094271
   when @Lead_Time2 = '168' then   -.118765485094271
   when @Lead_Time2 = '169' then   -.118765485094271
   when @Lead_Time2 = '170' then   -.118765485094271
   when @Lead_Time2 = '171' then   -.118765485094271
   when @Lead_Time2 = '172' then   -.118765485094271
   when @Lead_Time2 = '173' then   -.118765485094271
   when @Lead_Time2 = '174' then   -.118765485094271
   when @Lead_Time2 = '175' then   -.118765485094271
   when @Lead_Time2 = '176' then   -.118765485094271
   when @Lead_Time2 = '177' then   -.118765485094271
   when @Lead_Time2 = '178' then   -.118765485094271
   when @Lead_Time2 = '179' then   -.118765485094271
   when @Lead_Time2 = '180' then   -.118765485094271
   when @Lead_Time2 = '181' then   -.118765485094271
   when @Lead_Time2 = '188' then   -.118765485094271
   when @Lead_Time2 = '195' then   -.118765485094271
   when @Lead_Time2 = '202' then   -.118765485094271
   when @Lead_Time2 = '209' then   -.118765485094271
   when @Lead_Time2 = '216' then   -.118765485094271
   when @Lead_Time2 = '223' then   -.118765485094271
   when @Lead_Time2 = '230' then   -.118765485094271
   when @Lead_Time2 = '237' then   -.118765485094271
   when @Lead_Time2 = '244' then   -.118765485094271
   when @Lead_Time2 = '251' then   -.118765485094271
   when @Lead_Time2 = '258' then   -.118765485094271
   when @Lead_Time2 = '265' then   -.118765485094271
   when @Lead_Time2 = '272' then   -.118765485094271
   when @Lead_Time2 = '279' then   -.118765485094271
   when @Lead_Time2 = '286' then   -.118765485094271
   when @Lead_Time2 = '293' then   -.118765485094271
   when @Lead_Time2 = '300' then   -.118765485094271
   when @Lead_Time2 = '307' then   -.118765485094271
   when @Lead_Time2 = '314' then   -.118765485094271
   when @Lead_Time2 = '321' then   -.118765485094271
   when @Lead_Time2 = '328' then   -.118765485094271
   when @Lead_Time2 = '335' then   -.118765485094271
   when @Lead_Time2 = '342' then   -.118765485094271
   when @Lead_Time2 = '349' then   -.118765485094271
   when @Lead_Time2 = '356' then   -.118765485094271
   when @Lead_Time2 = '363' then   -.118765485094271
   when @Lead_Time2 = '370' then   -.118765485094271
   when @Lead_Time2 = '377' then   -.118765485094271
   when @Lead_Time2 = '384' then   -.118765485094271
   when @Lead_Time2 = '391' then   -.118765485094271
   when @Lead_Time2 = '398' then   -.118765485094271
   when @Lead_Time2 = '405' then   -.118765485094271
   when @Lead_Time2 = '412' then   -.118765485094271
   when @Lead_Time2 = '419' then   -.118765485094271
   when @Lead_Time2 = '426' then   -.118765485094271
   when @Lead_Time2 = '433' then   -.118765485094271
   when @Lead_Time2 = '440' then   -.118765485094271
   when @Lead_Time2 = '447' then   -.118765485094271
   when @Lead_Time2 = '454' then   -.118765485094271
   when @Lead_Time2 = '461' then   -.118765485094271
   when @Lead_Time2 = '468' then   -.118765485094271
   when @Lead_Time2 = '475' then   -.118765485094271
   when @Lead_Time2 = '482' then   -.118765485094271
   when @Lead_Time2 = '489' then   -.118765485094271
   when @Lead_Time2 = '496' then   -.118765485094271
   when @Lead_Time2 = '503' then   -.118765485094271
   when @Lead_Time2 = '510' then   -.118765485094271
   when @Lead_Time2 = '517' then   -.118765485094271
   when @Lead_Time2 = '524' then   -.118765485094271
   when @Lead_Time2 = '531' then   -.118765485094271
   when @Lead_Time2 = '538' then   -.118765485094271
   when @Lead_Time2 = '545' then   -.118765485094271
   when @Lead_Time2 = '552' then   -.118765485094271
 end 
 

 -- Start of OldestAge2
set @LinearPredictor = @LinearPredictor + 
case
   when @OldestAge2 = '12' then   -.290418299070616
   when @OldestAge2 = '13' then   -.290418299070616
   when @OldestAge2 = '14' then   -.290418299070616
   when @OldestAge2 = '15' then   -.290418299070616
   when @OldestAge2 = '16' then   -.290418299070616
   when @OldestAge2 = '17' then   -.290418299070616
   when @OldestAge2 = '18' then   -.290418299070616
   when @OldestAge2 = '19' then   -.290418299070616
   when @OldestAge2 = '20' then   -.290418299070616
   when @OldestAge2 = '21' then   -.296458423739963
   when @OldestAge2 = '22' then   -.301438695193823
   when @OldestAge2 = '23' then   -.304609816280299
   when @OldestAge2 = '24' then   -.305954477567193
   when @OldestAge2 = '25' then   -.305832160889161
   when @OldestAge2 = '26' then   -.305220801818949
   when @OldestAge2 = '27' then   -.305098574843304
   when @OldestAge2 = '28' then   -.305465300597673
   when @OldestAge2 = '29' then   -.305954477567193
   when @OldestAge2 = '30' then   -.304854165701185
   when @OldestAge2 = '31' then   -.300586647184147
   when @OldestAge2 = '32' then   -.291743999776977
   when @OldestAge2 = '33' then   -.27785156077586
   when @OldestAge2 = '34' then   -.259818188590161
   when @OldestAge2 = '35' then   -.239010594752159
   when @OldestAge2 = '36' then   -.217170971420583
   when @OldestAge2 = '37' then   -.195579034767566
   when @OldestAge2 = '38' then   -.17476527527149
   when @OldestAge2 = '39' then   -.155322431730221
   when @OldestAge2 = '40' then   -.137489955434664
   when @OldestAge2 = '41' then   -.121799739691578
   when @OldestAge2 = '42' then   -.108558529401008
   when @OldestAge2 = '43' then   -9.80704943924255E-02
   when @OldestAge2 = '44' then   -8.97585526134748E-02
   when @OldestAge2 = '45' then   -8.21994924216449E-02
   when @OldestAge2 = '46' then   -.073726928713624
   when @OldestAge2 = '47' then   -6.22530526566765E-02
   when @OldestAge2 = '48' then   -4.62755373053927E-02
   when @OldestAge2 = '49' then   -2.52693034820233E-02
   when @OldestAge2 = '50' then    0
   when @OldestAge2 = '51' then    2.78930856312485E-02
   when @OldestAge2 = '52' then    5.58814375458745E-02
   when @OldestAge2 = '53' then    8.12822985595716E-02
   when @OldestAge2 = '54' then    .101832092882334
   when @OldestAge2 = '55' then    .11613016755458
   when @OldestAge2 = '56' then    .12419827059219
   when @OldestAge2 = '57' then    .127137696740408
   when @OldestAge2 = '58' then    .127296338765013
   when @OldestAge2 = '59' then    .127851387742511
   when @OldestAge2 = '60' then    .131649161117961
   when @OldestAge2 = '61' then    .140846254598879
   when @OldestAge2 = '62' then    .155989234701442
   when @OldestAge2 = '63' then    .176433916594317
   when @OldestAge2 = '64' then    .200457751760385
   when @OldestAge2 = '65' then    .226147772072148
   when @OldestAge2 = '66' then    .251964808776408
   when @OldestAge2 = '67' then    .27692721122261
   when @OldestAge2 = '68' then    .301081671196243
   when @OldestAge2 = '69' then    .324926826798013
   when @OldestAge2 = '70' then    .349551170411766
   when @OldestAge2 = '71' then    .375998785750809
   when @OldestAge2 = '72' then    .405074676676478
   when @OldestAge2 = '73' then    .436885328614098
   when @OldestAge2 = '74' then    .47143265904283
   when @OldestAge2 = '75' then    .508462686492875
   when @OldestAge2 = '76' then    .547979245924922
   when @OldestAge2 = '77' then    .590245879193331
   when @OldestAge2 = '78' then    .635342087026524
   when @OldestAge2 = '79' then    .683097754624965
   when @OldestAge2 = '80' then    .732883999515979
   when @OldestAge2 = '81' then    .783605751502907
   when @OldestAge2 = '82' then    .834149917437525
   when @OldestAge2 = '83' then    .883342352206402
   when @OldestAge2 = '84' then    .930227928015554
   when @OldestAge2 = '85' then    .975013346250662
 end 
 

 -- Start of JV Description
set @LinearPredictor = @LinearPredictor + 
case
   when @JV_Description = 'AAA' then   -.169673697166467
   when @JV_Description = 'Air New Zealand' then   -.811669899261256
   when @JV_Description = 'Australia Post' then    0
   when @JV_Description = 'Coles' then    0
   when @JV_Description = 'Cruise Republic' then    0
   when @JV_Description = 'Flight Centre' then    0
   when @JV_Description = 'HIF' then    0
   when @JV_Description = 'Helloworld' then    0
   when @JV_Description = 'Helloworld Integrated' then    0
   when @JV_Description = 'Indep + Others' then    0
   when @JV_Description = 'Insurance Australia Ltd' then   -.123143995683312
   when @JV_Description = 'Malaysia Airline' then    0
   when @JV_Description = 'Medibank' then   -.275945205633774
   when @JV_Description = 'Non Travel Agency - Dist' then    0
   when @JV_Description = 'P&O Cruises' then    0
   when @JV_Description = 'Phone Sales' then   -.166518747164713
   when @JV_Description = 'Virgin' then    0
   when @JV_Description = 'Websales' then    0
   when @JV_Description = 'White Label Platform' then    0
   when @JV_Description = 'YouGo' then    0
   when @JV_Description = 'ahm - Medibank' then    0
 end 
 

 -- Start of Product_Indicator
set @LinearPredictor = @LinearPredictor + 
case
   when @Product_Indicator = 'Business' then    0
   when @Product_Indicator = 'Car Hire' then    0
   when @Product_Indicator = 'Corporate' then    0
   when @Product_Indicator = 'Domestic AMT' then    0
   when @Product_Indicator = 'Domestic Cancellation' then    0
   when @Product_Indicator = 'Domestic Inbound' then    0
   when @Product_Indicator = 'Domestic Single Trip' then    0
   when @Product_Indicator = 'Domestic Single Trip Integrated' then    0
   when @Product_Indicator = 'International AMT' then   -6.63362702475983E-02
   when @Product_Indicator = 'International Single Trip Comprehensive' then    0
   when @Product_Indicator = 'International Single Trip Integrated' then    .411430243168722
   when @Product_Indicator = 'International Single Trip Standard' then   -6.63362702475983E-02
 end 
 

 -- Start of Excess
set @LinearPredictor = @LinearPredictor + 
case
   when @Excess = '0' then   -.333914869000031
   when @Excess = '25' then   -.333914869000031
   when @Excess = '50' then   -.333914869000031
   when @Excess = '60' then   -.333914869000031
   when @Excess = '100' then   -.230819060817238
   when @Excess = '150' then   -.230819060817238
   when @Excess = '200' then    0
   when @Excess = '250' then    0
   when @Excess = '300' then    0
   when @Excess = '500' then    0
   when @Excess = '1000' then    0
 end 
 

 -- Start of Departure_Month
set @LinearPredictor = @LinearPredictor + 
case
   when @Departure_Month = '1' then    .168449060164101
   when @Departure_Month = '2' then    0
   when @Departure_Month = '3' then    0
   when @Departure_Month = '4' then    0
   when @Departure_Month = '5' then    0
   when @Departure_Month = '6' then    0
   when @Departure_Month = '7' then    0
   when @Departure_Month = '8' then    0
   when @Departure_Month = '9' then    .150291933533262
   when @Departure_Month = '10' then    0
   when @Departure_Month = '11' then    0
   when @Departure_Month = '12' then    0
 end 
 

 -- Start of EMCBand2
set @LinearPredictor = @LinearPredictor + 
case
   when @EMCBand2 = '0_<50%' then    0
   when @EMCBand2 = '1_<50%' then    .16991417588458
   when @EMCBand2 = '1_>50%' then    .16991417588458
   when @EMCBand2 = '2_<50%' then    .16991417588458
   when @EMCBand2 = '2_>50%' then    .16991417588458
   when @EMCBand2 = '3_<50%' then    .16991417588458
   when @EMCBand2 = '3_>50%' then    .16991417588458
   when @EMCBand2 = '4_<50%' then    .307228764993804
   when @EMCBand2 = '4_>50%' then    .307228764993804
   when @EMCBand2 = '5_<50%' then    .307228764993804
   when @EMCBand2 = '5_>50%' then    .307228764993804
   when @EMCBand2 = '6_<50%' then    .307228764993804
   when @EMCBand2 = '6_>50%' then    .307228764993804
   when @EMCBand2 = '7_<50%' then    .307228764993804
   when @EMCBand2 = '7_>50%' then    .307228764993804
   when @EMCBand2 = '8_<50%' then    .307228764993804
   when @EMCBand2 = '8_>50%' then    .307228764993804
 end 
 
set @PredictedValue = exp(@LinearPredictor) 
return @PredictedValue

end
GO

USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Medical_ACS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Medical_ACS] (
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
set @LinearPredictor = @LinearPredictor + 6.75915419702737

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.771851346578306
    when @Destination3 = 'Africa-SOUTH AFRICA' then 0.771851346578306
    when @Destination3 = 'Asia Others' then 0.771851346578306
    when @Destination3 = 'Domestic' then 0
    when @Destination3 = 'East Asia' then 0.771851346578306
    when @Destination3 = 'East Asia-CHINA' then 0.771851346578306
    when @Destination3 = 'East Asia-HONG KONG' then 0.529067802717195
    when @Destination3 = 'East Asia-JAPAN' then 0.771851346578306
    when @Destination3 = 'Europe' then 0.771851346578306
    when @Destination3 = 'Europe-CROATIA' then 0.529067802717195
    when @Destination3 = 'Europe-ENGLAND' then 0.529067802717195
    when @Destination3 = 'Europe-FRANCE' then 0.771851346578306
    when @Destination3 = 'Europe-GERMANY' then 0.771851346578306
    when @Destination3 = 'Europe-GREECE' then 1.12515910962752
    when @Destination3 = 'Europe-ITALY' then 0.529067802717195
    when @Destination3 = 'Europe-NETHERLANDS' then 0.529067802717195
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then 0.529067802717195
    when @Destination3 = 'Europe-SCOTLAND' then 0.529067802717195
    when @Destination3 = 'Europe-SPAIN' then 0.771851346578306
    when @Destination3 = 'Europe-SWITZERLAND' then 1.12515910962752
    when @Destination3 = 'Europe-UNITED KINGDOM' then 0.529067802717195
    when @Destination3 = 'Mid East' then 0.771851346578306
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then 1.12515910962752
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 1.61247745461061
    when @Destination3 = 'Pacific Region' then 0.529067802717195
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then 0
    when @Destination3 = 'Pacific Region-FIJI' then 0
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then 0.529067802717195
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0.529067802717195
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then 0.529067802717195
    when @Destination3 = 'Pacific Region-VANUATU' then 0.529067802717195
    when @Destination3 = 'SEA-INDONESIA' then 0.771851346578306
    when @Destination3 = 'SEA-MALAYSIA' then 0.529067802717195
    when @Destination3 = 'SEA-PHILIPPINES' then 0.771851346578306
    when @Destination3 = 'SEA-SINGAPORE' then 0.771851346578306
    when @Destination3 = 'South America' then 1.12515910962752
    when @Destination3 = 'South Asia' then 0.529067802717195
    when @Destination3 = 'South Asia-CAMBODIA' then 1.12515910962752
    when @Destination3 = 'South Asia-INDIA' then 1.12515910962752
    when @Destination3 = 'South Asia-NEPAL' then 1.61247745461061
    when @Destination3 = 'South Asia-SRI LANKA' then 0.771851346578306
    when @Destination3 = 'South Asia-THAILAND' then 1.12515910962752
    when @Destination3 = 'South Asia-VIETNAM' then 1.12515910962752
    when @Destination3 = 'World Others' then 1.12515910962752
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
    when @Lead_Time2 = '8' then -0.107700129764788
    when @Lead_Time2 = '9' then -0.107700129764788
    when @Lead_Time2 = '10' then -0.107700129764788
    when @Lead_Time2 = '11' then -0.107700129764788
    when @Lead_Time2 = '12' then -0.107700129764788
    when @Lead_Time2 = '13' then -0.107700129764788
    when @Lead_Time2 = '14' then -0.107700129764788
    when @Lead_Time2 = '15' then -0.107700129764788
    when @Lead_Time2 = '16' then -0.107700129764788
    when @Lead_Time2 = '17' then -0.107700129764788
    when @Lead_Time2 = '18' then -0.107700129764788
    when @Lead_Time2 = '19' then -0.107700129764788
    when @Lead_Time2 = '20' then -0.107700129764788
    when @Lead_Time2 = '21' then -0.107700129764788
    when @Lead_Time2 = '22' then -0.107700129764788
    when @Lead_Time2 = '23' then -0.107700129764788
    when @Lead_Time2 = '24' then -0.107700129764788
    when @Lead_Time2 = '25' then -0.107700129764788
    when @Lead_Time2 = '26' then -0.107700129764788
    when @Lead_Time2 = '27' then -0.107700129764788
    when @Lead_Time2 = '28' then -0.107700129764788
    when @Lead_Time2 = '29' then -0.107700129764788
    when @Lead_Time2 = '30' then -0.107700129764788
    when @Lead_Time2 = '31' then -0.107700129764788
    when @Lead_Time2 = '32' then -0.107700129764788
    when @Lead_Time2 = '33' then -0.107700129764788
    when @Lead_Time2 = '34' then -0.107700129764788
    when @Lead_Time2 = '35' then -0.107700129764788
    when @Lead_Time2 = '36' then -0.107700129764788
    when @Lead_Time2 = '37' then -0.107700129764788
    when @Lead_Time2 = '38' then -0.107700129764788
    when @Lead_Time2 = '39' then -0.107700129764788
    when @Lead_Time2 = '40' then -0.107700129764788
    when @Lead_Time2 = '41' then -0.107700129764788
    when @Lead_Time2 = '42' then -0.107700129764788
    when @Lead_Time2 = '43' then -0.107700129764788
    when @Lead_Time2 = '44' then -0.107700129764788
    when @Lead_Time2 = '45' then -0.107700129764788
    when @Lead_Time2 = '46' then -0.107700129764788
    when @Lead_Time2 = '47' then -0.107700129764788
    when @Lead_Time2 = '48' then -0.107700129764788
    when @Lead_Time2 = '49' then -0.107700129764788
    when @Lead_Time2 = '50' then -0.107700129764788
    when @Lead_Time2 = '51' then -0.107700129764788
    when @Lead_Time2 = '52' then -0.107700129764788
    when @Lead_Time2 = '53' then -0.107700129764788
    when @Lead_Time2 = '54' then -0.107700129764788
    when @Lead_Time2 = '55' then -0.107700129764788
    when @Lead_Time2 = '56' then -0.107700129764788
    when @Lead_Time2 = '57' then -0.107700129764788
    when @Lead_Time2 = '58' then -0.107700129764788
    when @Lead_Time2 = '59' then -0.107700129764788
    when @Lead_Time2 = '60' then -0.107700129764788
    when @Lead_Time2 = '61' then -0.107700129764788
    when @Lead_Time2 = '62' then -0.107700129764788
    when @Lead_Time2 = '63' then -0.107700129764788
    when @Lead_Time2 = '64' then -0.107700129764788
    when @Lead_Time2 = '65' then -0.107700129764788
    when @Lead_Time2 = '66' then -0.107700129764788
    when @Lead_Time2 = '67' then -0.107700129764788
    when @Lead_Time2 = '68' then -0.107700129764788
    when @Lead_Time2 = '69' then -0.107700129764788
    when @Lead_Time2 = '70' then -0.107700129764788
    when @Lead_Time2 = '71' then -0.107700129764788
    when @Lead_Time2 = '72' then -0.107700129764788
    when @Lead_Time2 = '73' then -0.107700129764788
    when @Lead_Time2 = '74' then -0.107700129764788
    when @Lead_Time2 = '75' then -0.107700129764788
    when @Lead_Time2 = '76' then -0.107700129764788
    when @Lead_Time2 = '77' then -0.107700129764788
    when @Lead_Time2 = '78' then -0.107700129764788
    when @Lead_Time2 = '79' then -0.107700129764788
    when @Lead_Time2 = '80' then -0.107700129764788
    when @Lead_Time2 = '81' then -0.107700129764788
    when @Lead_Time2 = '82' then -0.107700129764788
    when @Lead_Time2 = '83' then -0.107700129764788
    when @Lead_Time2 = '84' then -0.107700129764788
    when @Lead_Time2 = '85' then -0.107700129764788
    when @Lead_Time2 = '86' then -0.107700129764788
    when @Lead_Time2 = '87' then -0.107700129764788
    when @Lead_Time2 = '88' then -0.107700129764788
    when @Lead_Time2 = '89' then -0.107700129764788
    when @Lead_Time2 = '90' then -0.107700129764788
    when @Lead_Time2 = '91' then -0.107700129764788
    when @Lead_Time2 = '92' then -0.107700129764788
    when @Lead_Time2 = '93' then -0.107700129764788
    when @Lead_Time2 = '94' then -0.107700129764788
    when @Lead_Time2 = '95' then -0.107700129764788
    when @Lead_Time2 = '96' then -0.107700129764788
    when @Lead_Time2 = '97' then -0.107700129764788
    when @Lead_Time2 = '98' then -0.107700129764788
    when @Lead_Time2 = '99' then -0.107700129764788
    when @Lead_Time2 = '100' then -0.107700129764788
    when @Lead_Time2 = '101' then -0.107700129764788
    when @Lead_Time2 = '102' then -0.107700129764788
    when @Lead_Time2 = '103' then -0.107700129764788
    when @Lead_Time2 = '104' then -0.107700129764788
    when @Lead_Time2 = '105' then -0.107700129764788
    when @Lead_Time2 = '106' then -0.107700129764788
    when @Lead_Time2 = '107' then -0.107700129764788
    when @Lead_Time2 = '108' then -0.107700129764788
    when @Lead_Time2 = '109' then -0.107700129764788
    when @Lead_Time2 = '110' then -0.107700129764788
    when @Lead_Time2 = '111' then -0.107700129764788
    when @Lead_Time2 = '112' then -0.107700129764788
    when @Lead_Time2 = '113' then -0.107700129764788
    when @Lead_Time2 = '114' then -0.107700129764788
    when @Lead_Time2 = '115' then -0.107700129764788
    when @Lead_Time2 = '116' then -0.107700129764788
    when @Lead_Time2 = '117' then -0.107700129764788
    when @Lead_Time2 = '118' then -0.107700129764788
    when @Lead_Time2 = '119' then -0.107700129764788
    when @Lead_Time2 = '120' then -0.107700129764788
    when @Lead_Time2 = '121' then -0.107700129764788
    when @Lead_Time2 = '122' then -0.107700129764788
    when @Lead_Time2 = '123' then -0.107700129764788
    when @Lead_Time2 = '124' then -0.107700129764788
    when @Lead_Time2 = '125' then -0.107700129764788
    when @Lead_Time2 = '126' then -0.107700129764788
    when @Lead_Time2 = '127' then -0.107700129764788
    when @Lead_Time2 = '128' then -0.107700129764788
    when @Lead_Time2 = '129' then -0.107700129764788
    when @Lead_Time2 = '130' then -0.107700129764788
    when @Lead_Time2 = '131' then -0.107700129764788
    when @Lead_Time2 = '132' then -0.107700129764788
    when @Lead_Time2 = '133' then -0.107700129764788
    when @Lead_Time2 = '134' then -0.107700129764788
    when @Lead_Time2 = '135' then -0.107700129764788
    when @Lead_Time2 = '136' then -0.107700129764788
    when @Lead_Time2 = '137' then -0.107700129764788
    when @Lead_Time2 = '138' then -0.107700129764788
    when @Lead_Time2 = '139' then -0.107700129764788
    when @Lead_Time2 = '140' then -0.107700129764788
    when @Lead_Time2 = '141' then -0.107700129764788
    when @Lead_Time2 = '142' then -0.107700129764788
    when @Lead_Time2 = '143' then -0.107700129764788
    when @Lead_Time2 = '144' then -0.107700129764788
    when @Lead_Time2 = '145' then -0.107700129764788
    when @Lead_Time2 = '146' then -0.107700129764788
    when @Lead_Time2 = '147' then -0.107700129764788
    when @Lead_Time2 = '148' then -0.107700129764788
    when @Lead_Time2 = '149' then -0.107700129764788
    when @Lead_Time2 = '150' then -0.107700129764788
    when @Lead_Time2 = '151' then -0.107700129764788
    when @Lead_Time2 = '152' then -0.107700129764788
    when @Lead_Time2 = '153' then -0.107700129764788
    when @Lead_Time2 = '154' then -0.107700129764788
    when @Lead_Time2 = '155' then -0.107700129764788
    when @Lead_Time2 = '156' then -0.107700129764788
    when @Lead_Time2 = '157' then -0.107700129764788
    when @Lead_Time2 = '158' then -0.107700129764788
    when @Lead_Time2 = '159' then -0.107700129764788
    when @Lead_Time2 = '160' then -0.107700129764788
    when @Lead_Time2 = '161' then -0.107700129764788
    when @Lead_Time2 = '162' then -0.107700129764788
    when @Lead_Time2 = '163' then -0.107700129764788
    when @Lead_Time2 = '164' then -0.107700129764788
    when @Lead_Time2 = '165' then -0.107700129764788
    when @Lead_Time2 = '166' then -0.107700129764788
    when @Lead_Time2 = '167' then -0.107700129764788
    when @Lead_Time2 = '168' then -0.107700129764788
    when @Lead_Time2 = '169' then -0.107700129764788
    when @Lead_Time2 = '170' then -0.107700129764788
    when @Lead_Time2 = '171' then -0.107700129764788
    when @Lead_Time2 = '172' then -0.107700129764788
    when @Lead_Time2 = '173' then -0.107700129764788
    when @Lead_Time2 = '174' then -0.107700129764788
    when @Lead_Time2 = '175' then -0.107700129764788
    when @Lead_Time2 = '176' then -0.107700129764788
    when @Lead_Time2 = '177' then -0.107700129764788
    when @Lead_Time2 = '178' then -0.107700129764788
    when @Lead_Time2 = '179' then -0.107700129764788
    when @Lead_Time2 = '180' then -0.107700129764788
    when @Lead_Time2 = '181' then -0.107700129764788
    when @Lead_Time2 = '188' then -0.107700129764788
    when @Lead_Time2 = '195' then -0.107700129764788
    when @Lead_Time2 = '202' then -0.107700129764788
    when @Lead_Time2 = '209' then -0.107700129764788
    when @Lead_Time2 = '216' then -0.107700129764788
    when @Lead_Time2 = '223' then -0.107700129764788
    when @Lead_Time2 = '230' then -0.107700129764788
    when @Lead_Time2 = '237' then -0.107700129764788
    when @Lead_Time2 = '244' then -0.107700129764788
    when @Lead_Time2 = '251' then -0.107700129764788
    when @Lead_Time2 = '258' then -0.107700129764788
    when @Lead_Time2 = '265' then -0.107700129764788
    when @Lead_Time2 = '272' then -0.107700129764788
    when @Lead_Time2 = '279' then -0.107700129764788
    when @Lead_Time2 = '286' then -0.107700129764788
    when @Lead_Time2 = '293' then -0.107700129764788
    when @Lead_Time2 = '300' then -0.107700129764788
    when @Lead_Time2 = '307' then -0.107700129764788
    when @Lead_Time2 = '314' then -0.107700129764788
    when @Lead_Time2 = '321' then -0.107700129764788
    when @Lead_Time2 = '328' then -0.107700129764788
    when @Lead_Time2 = '335' then -0.107700129764788
    when @Lead_Time2 = '342' then -0.107700129764788
    when @Lead_Time2 = '349' then -0.107700129764788
    when @Lead_Time2 = '356' then -0.107700129764788
    when @Lead_Time2 = '363' then -0.107700129764788
    when @Lead_Time2 = '370' then -0.107700129764788
    when @Lead_Time2 = '377' then -0.107700129764788
    when @Lead_Time2 = '384' then -0.107700129764788
    when @Lead_Time2 = '391' then -0.107700129764788
    when @Lead_Time2 = '398' then -0.107700129764788
    when @Lead_Time2 = '405' then -0.107700129764788
    when @Lead_Time2 = '412' then -0.107700129764788
    when @Lead_Time2 = '419' then -0.107700129764788
    when @Lead_Time2 = '426' then -0.107700129764788
    when @Lead_Time2 = '433' then -0.107700129764788
    when @Lead_Time2 = '440' then -0.107700129764788
    when @Lead_Time2 = '447' then -0.107700129764788
    when @Lead_Time2 = '454' then -0.107700129764788
    when @Lead_Time2 = '461' then -0.107700129764788
    when @Lead_Time2 = '468' then -0.107700129764788
    when @Lead_Time2 = '475' then -0.107700129764788
    when @Lead_Time2 = '482' then -0.107700129764788
    when @Lead_Time2 = '489' then -0.107700129764788
    when @Lead_Time2 = '496' then -0.107700129764788
    when @Lead_Time2 = '503' then -0.107700129764788
    when @Lead_Time2 = '510' then -0.107700129764788
    when @Lead_Time2 = '517' then -0.107700129764788
    when @Lead_Time2 = '524' then -0.107700129764788
    when @Lead_Time2 = '531' then -0.107700129764788
    when @Lead_Time2 = '538' then -0.107700129764788
    when @Lead_Time2 = '545' then -0.107700129764788
    when @Lead_Time2 = '552' then -0.107700129764788
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then -0.334496908296258
    when @OldestAge2 = '12' then -0.305110527677338
    when @OldestAge2 = '13' then -0.310494631368066
    when @OldestAge2 = '14' then -0.315677899776142
    when @OldestAge2 = '15' then -0.320413606318845
    when @OldestAge2 = '16' then -0.324433481434504
    when @OldestAge2 = '17' then -0.327456238998535
    when @OldestAge2 = '18' then -0.329209853449968
    when @OldestAge2 = '19' then -0.329463417573261
    when @OldestAge2 = '20' then -0.328060689525125
    when @OldestAge2 = '21' then -0.324946667131727
    when @OldestAge2 = '22' then -0.320180676115953
    when @OldestAge2 = '23' then -0.313933948214552
    when @OldestAge2 = '24' then -0.306474146202054
    when @OldestAge2 = '25' then -0.298142104648187
    when @OldestAge2 = '26' then -0.289325963363179
    when @OldestAge2 = '27' then -0.280435555068284
    when @OldestAge2 = '28' then -0.271876674401219
    when @OldestAge2 = '29' then -0.264022649223421
    when @OldestAge2 = '30' then -0.257180607923926
    when @OldestAge2 = '31' then -0.251552087428736
    when @OldestAge2 = '32' then -0.247191431500966
    when @OldestAge2 = '33' then -0.243969432855692
    when @OldestAge2 = '34' then -0.241552373328358
    when @OldestAge2 = '35' then -0.23940700858382
    when @OldestAge2 = '36' then -0.236839147941742
    when @OldestAge2 = '37' then -0.233067224552748
    when @OldestAge2 = '38' then -0.227323319883839
    when @OldestAge2 = '39' then -0.218964702322736
    when @OldestAge2 = '40' then -0.207572761501106
    when @OldestAge2 = '41' then -0.193016725371167
    when @OldestAge2 = '42' then -0.175467987855408
    when @OldestAge2 = '43' then -0.155364589688759
    when @OldestAge2 = '44' then -0.133338672637963
    when @OldestAge2 = '45' then -0.110127188605483
    when @OldestAge2 = '46' then -0.0864855895757586
    when @OldestAge2 = '47' then -0.0631176334917472
    when @OldestAge2 = '48' then -0.040625830885947
    when @OldestAge2 = '49' then -0.0194802111323052
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.0176566690174598
    when @OldestAge2 = '52' then 0.0334969659731587
    when @OldestAge2 = '53' then 0.0476900223633372
    when @OldestAge2 = '54' then 0.0605521963188939
    when @OldestAge2 = '55' then 0.0725169849136228
    when @OldestAge2 = '56' then 0.0840880789232727
    when @OldestAge2 = '57' then 0.095778677417889
    when @OldestAge2 = '58' then 0.108045422242867
    when @OldestAge2 = '59' then 0.121229271613416
    when @OldestAge2 = '60' then 0.135516069218104
    when @OldestAge2 = '61' then 0.150925780245158
    when @OldestAge2 = '62' then 0.16733218477331
    when @OldestAge2 = '63' then 0.184506922317091
    when @OldestAge2 = '64' then 0.20217612576824
    when @OldestAge2 = '65' then 0.220076249083883
    when @OldestAge2 = '66' then 0.237998038483321
    when @OldestAge2 = '67' then 0.255812303183536
    when @OldestAge2 = '68' then 0.273476222952854
    when @OldestAge2 = '69' then 0.291022988880198
    when @OldestAge2 = '70' then 0.308540094416795
    when @OldestAge2 = '71' then 0.326142684833338
    when @OldestAge2 = '72' then 0.343948559352735
    when @OldestAge2 = '73' then 0.362060713478405
    when @OldestAge2 = '74' then 0.380561605046019
    when @OldestAge2 = '75' then 0.399520410073999
    when @OldestAge2 = '76' then 0.419010390682851
    when @OldestAge2 = '77' then 0.439129281027727
    when @OldestAge2 = '78' then 0.460012704763737
    when @OldestAge2 = '79' then 0.481831074671921
    when @OldestAge2 = '80' then 0.504764952634263
    when @OldestAge2 = '81' then 0.528961884127895
    when @OldestAge2 = '82' then 0.554486498165369
    when @OldestAge2 = '83' then 0.581281139107316
    when @OldestAge2 = '84' then 0.609153134361137
    when @OldestAge2 = '85' then 0.63779627773088
    when @OldestAge2 = '86' then 0.666841432056015
    when @OldestAge2 = '87' then 0.695919950773094
    when @OldestAge2 = '88' then 0.724718919346194
    when @OldestAge2 = '89' then 0.753010935210503
    when @OldestAge2 = '90' then 0.780651349011952
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then -0.131283256119238
    when @Traveller_Count2 = '3' then -0.245760497180608
    when @Traveller_Count2 = '4' then -0.245760497180608
    when @Traveller_Count2 = '5' then -0.245760497180608
    when @Traveller_Count2 = '6' then -0.245760497180608
    when @Traveller_Count2 = '7' then -0.245760497180608
    when @Traveller_Count2 = '8' then -0.245760497180608
    when @Traveller_Count2 = '9' then -0.245760497180608
    when @Traveller_Count2 = '10' then -0.245760497180608
    when @Traveller_Count2 = '11' then -0.245760497180609
    when @Traveller_Count2 = '12' then -0.245760497180609
    when @Traveller_Count2 = '13' then -0.245760497180609
    when @Traveller_Count2 = '14' then -0.245760497180609
    when @Traveller_Count2 = '15' then -0.245760497180609
    when @Traveller_Count2 = '16' then -0.245760497180609
    when @Traveller_Count2 = '17' then -0.245760497180609
    when @Traveller_Count2 = '18' then -0.245760497180609
    when @Traveller_Count2 = '19' then -0.245760497180609
    when @Traveller_Count2 = '20' then -0.245760497180609
    when @Traveller_Count2 = '21' then -0.245760497180609
    when @Traveller_Count2 = '22' then -0.245760497180609
    when @Traveller_Count2 = '23' then -0.245760497180609
    when @Traveller_Count2 = '24' then -0.245760497180609
    when @Traveller_Count2 = '25' then -0.245760497180609
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then -0.654118793592467
    when @Excess = '25' then -0.574120474138304
    when @Excess = '50' then -0.500050550598032
    when @Excess = '60' then -0.471925474808434
    when @Excess = '100' then -0.366580990058198
    when @Excess = '150' then -0.226341158214417
    when @Excess = '200' then -0.110201101300741
    when @Excess = '250' then 0
    when @Excess = '300' then 0.430125199844535
    when @Excess = '500' then 0.729912959750268
    when @Excess = '1000' then 0.729912959750268
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.133676914247466
    when @EMCBand = '1_>50%' then 0.133676914247466
    when @EMCBand = '2_<50%' then 0.133676914247466
    when @EMCBand = '2_>50%' then 0.133676914247466
    when @EMCBand = '3_<50%' then 0.133676914247466
    when @EMCBand = '3_>50%' then 0.133676914247466
    when @EMCBand = '4_<50%' then 0.29758686711377
    when @EMCBand = '4_>50%' then 0.29758686711377
    when @EMCBand = '5_<50%' then 0.29758686711377
    when @EMCBand = '5_>50%' then 0.29758686711377
    when @EMCBand = '6_<50%' then 0.29758686711377
    when @EMCBand = '6_>50%' then 0.29758686711377
    when @EMCBand = '7_<50%' then 0.29758686711377
    when @EMCBand = '7_>50%' then 0.29758686711377
    when @EMCBand = '8_<50%' then 0.29758686711377
    when @EMCBand = '8_>50%' then 0.29758686711377
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.139637390663708
    when @Gender = 'FF' then 0
    when @Gender = 'FM' then 0
    when @Gender = 'M' then 0.231334874565945
    when @Gender = 'MM' then 0.231334874565945
    when @Gender = 'O' then 0.231334874565945
    when @Gender = 'U' then 0
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then -0.152202153541109
    when @JV_Description = 'Air New Zealand' then 0
    when @JV_Description = 'Australia Post' then -0.0711449633278703
    when @JV_Description = 'CBA White Label' then 0
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then 0
    when @JV_Description = 'Helloworld' then 0.166227832839144
    when @JV_Description = 'Indep + Others' then 0
    when @JV_Description = 'Insurance Australia Ltd' then -0.0711449633278703
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then -0.152202153541109
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0
    when @JV_Description = 'Virgin' then 0
    when @JV_Description = 'Websales' then 0
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
    when @Product_Indicator = 'International AMT' then -0.125056413604741
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

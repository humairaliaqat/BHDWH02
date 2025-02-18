USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Other_Freq]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Other_Freq] (
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
set @LinearPredictor = @LinearPredictor + -5.42564921177174

-- Start of return_yr
set @LinearPredictor = @LinearPredictor +
case
  when @return_yr= '2018' then 0.0497339644244032
  when @return_yr= '2019' then 0
end

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.819617844613894
    when @Trip_Length2 = '2' then -0.819617844613894
    when @Trip_Length2 = '3' then -0.819617844613894
    when @Trip_Length2 = '4' then -0.495116330060811
    when @Trip_Length2 = '5' then -0.340942212092664
    when @Trip_Length2 = '6' then -0.209610537031626
    when @Trip_Length2 = '7' then -0.0970617128431312
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.0845249550696882
    when @Trip_Length2 = '10' then 0.158626363282419
    when @Trip_Length2 = '11' then 0.224342831889692
    when @Trip_Length2 = '12' then 0.28277002809076
    when @Trip_Length2 = '13' then 0.335757695683344
    when @Trip_Length2 = '14' then 0.384786096899764
    when @Trip_Length2 = '15' then 0.431457688382418
    when @Trip_Length2 = '16' then 0.476917175514804
    when @Trip_Length2 = '17' then 0.521706214862203
    when @Trip_Length2 = '18' then 0.565654660044669
    when @Trip_Length2 = '19' then 0.608079368169881
    when @Trip_Length2 = '20' then 0.648463572933305
    when @Trip_Length2 = '21' then 0.686575635176906
    when @Trip_Length2 = '22' then 0.722463234893998
    when @Trip_Length2 = '23' then 0.75640363019496
    when @Trip_Length2 = '24' then 0.788775491573352
    when @Trip_Length2 = '25' then 0.819779831493311
    when @Trip_Length2 = '26' then 0.849680733374711
    when @Trip_Length2 = '27' then 0.878962626608156
    when @Trip_Length2 = '28' then 0.908500466399092
    when @Trip_Length2 = '29' then 0.939342975404308
    when @Trip_Length2 = '30' then 0.972028136558657
    when @Trip_Length2 = '31' then 1.00671627396357
    when @Trip_Length2 = '32' then 1.04260615187837
    when @Trip_Length2 = '33' then 1.07834155182575
    when @Trip_Length2 = '34' then 1.11267954587955
    when @Trip_Length2 = '35' then 1.14460489251858
    when @Trip_Length2 = '36' then 1.17384343934442
    when @Trip_Length2 = '37' then 1.20086798937246
    when @Trip_Length2 = '38' then 1.22636032320356
    when @Trip_Length2 = '39' then 1.25084684819453
    when @Trip_Length2 = '40' then 1.27458037148989
    when @Trip_Length2 = '41' then 1.29735385182324
    when @Trip_Length2 = '42' then 1.31871120979609
    when @Trip_Length2 = '43' then 1.33807528384929
    when @Trip_Length2 = '44' then 1.35495848081004
    when @Trip_Length2 = '45' then 1.36897015998669
    when @Trip_Length2 = '46' then 1.37999959055714
    when @Trip_Length2 = '47' then 1.38829236378256
    when @Trip_Length2 = '48' then 1.39458489943762
    when @Trip_Length2 = '49' then 1.40004932635223
    when @Trip_Length2 = '50' then 1.40621952992716
    when @Trip_Length2 = '51' then 1.41427424762685
    when @Trip_Length2 = '52' then 1.42462525542485
    when @Trip_Length2 = '53' then 1.43672603441858
    when @Trip_Length2 = '54' then 1.44917525915909
    when @Trip_Length2 = '55' then 1.4604969716524
    when @Trip_Length2 = '56' then 1.46992293955946
    when @Trip_Length2 = '57' then 1.47807559423727
    when @Trip_Length2 = '58' then 1.48668253515116
    when @Trip_Length2 = '59' then 1.49796989501048
    when @Trip_Length2 = '60' then 1.51334542670828
    when @Trip_Length2 = '61' then 1.52881336886021
    when @Trip_Length2 = '62' then 1.54579499012814
    when @Trip_Length2 = '63' then 1.56234630490025
    when @Trip_Length2 = '64' then 1.57445301553114
    when @Trip_Length2 = '65' then 1.586333038719
    when @Trip_Length2 = '66' then 1.59801289476463
    when @Trip_Length2 = '67' then 1.6094379124341
    when @Trip_Length2 = '68' then 1.62065476763927
    when @Trip_Length2 = '69' then 1.63170808107983
    when @Trip_Length2 = '70' then 1.64260185881253
    when @Trip_Length2 = '71' then 1.65343565891175
    when @Trip_Length2 = '72' then 1.66422908211679
    when @Trip_Length2 = '73' then 1.67513201562946
    when @Trip_Length2 = '74' then 1.68617670665299
    when @Trip_Length2 = '75' then 1.69750373330233
    when @Trip_Length2 = '76' then 1.70924704765359
    when @Trip_Length2 = '77' then 1.72146217592419
    when @Trip_Length2 = '78' then 1.73432454657483
    when @Trip_Length2 = '79' then 1.7479294830112
    when @Trip_Length2 = '80' then 1.76238215051738
    when @Trip_Length2 = '81' then 1.77777886104026
    when @Trip_Length2 = '82' then 1.79417322045199
    when @Trip_Length2 = '83' then 1.81164379253343
    when @Trip_Length2 = '84' then 1.83021065560231
    when @Trip_Length2 = '85' then 1.84987113228527
    when @Trip_Length2 = '86' then 1.87063226204878
    when @Trip_Length2 = '87' then 1.89241895232723
    when @Trip_Length2 = '88' then 1.91515634737198
    when @Trip_Length2 = '89' then 1.93878482411272
    when @Trip_Length2 = '90' then 1.96314646096923
    when @Trip_Length2 = '97' then 1.98812089310211
    when @Trip_Length2 = '104' then 2.01354209490292
    when @Trip_Length2 = '111' then 2.03927037699056
    when @Trip_Length2 = '118' then 2.06510171607501
    when @Trip_Length2 = '125' then 2.09088827711347
    when @Trip_Length2 = '132' then 2.11646031310706
    when @Trip_Length2 = '139' then 2.14162964650184
    when @Trip_Length2 = '146' then 2.16627269409666
    when @Trip_Length2 = '153' then 2.19019996239925
    when @Trip_Length2 = '160' then 2.21330569143456
    when @Trip_Length2 = '167' then 2.23546190113775
    when @Trip_Length2 = '174' then 2.25658303843225
    when @Trip_Length2 = '181' then 2.27657986930653
    when @Trip_Length2 = '188' then 2.29538926501224
    when @Trip_Length2 = '195' then 2.31298086917617
    when @Trip_Length2 = '202' then 2.32931465398594
    when @Trip_Length2 = '209' then 2.34440818624771
    when @Trip_Length2 = '216' then 2.35827520718724
    when @Trip_Length2 = '223' then 2.37094443050739
    when @Trip_Length2 = '230' then 2.38249548422184
    when @Trip_Length2 = '237' then 2.39297409272173
    when @Trip_Length2 = '244' then 2.40246662640361
    when @Trip_Length2 = '251' then 2.41108966093556
    when @Trip_Length2 = '258' then 2.41891818910706
    when @Trip_Length2 = '265' then 2.42608508897966
    when @Trip_Length2 = '272' then 2.43269187833926
    when @Trip_Length2 = '279' then 2.43885398524503
    when @Trip_Length2 = '286' then 2.44467475890012
    when @Trip_Length2 = '293' then 2.45025481672161
    when @Trip_Length2 = '300' then 2.4556837911111
    when @Trip_Length2 = '307' then 2.46105784775601
    when @Trip_Length2 = '314' then 2.46639468922306
    when @Trip_Length2 = '321' then 2.47182141023934
    when @Trip_Length2 = '328' then 2.47723563598365
    when @Trip_Length2 = '335' then 2.48295474606276
    when @Trip_Length2 = '342' then 2.48820121673743
    when @Trip_Length2 = '349' then 2.49501373403128
    when @Trip_Length2 = '356' then 2.49803673833092
    when @Trip_Length2 = '363' then 2.51106972543291
    when @Trip_Length2 = '365' then 2.51106972543291
    when @Trip_Length2 = '370' then 2.51106972543291
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.236401630706106
    when @Destination3 = 'Africa-SOUTH AFRICA' then 0.236401630706106
    when @Destination3 = 'Asia Others' then 0.0699866704503416
    when @Destination3 = 'Domestic' then -0.588274471712141
    when @Destination3 = 'East Asia' then -0.162960226536212
    when @Destination3 = 'East Asia-CHINA' then -0.162960226536212
    when @Destination3 = 'East Asia-HONG KONG' then -0.162960226536212
    when @Destination3 = 'East Asia-JAPAN' then -0.162960226536212
    when @Destination3 = 'Europe' then 0.236401630706106
    when @Destination3 = 'Europe-CROATIA' then 0.487838982937407
    when @Destination3 = 'Europe-ENGLAND' then 0.0699866704503416
    when @Destination3 = 'Europe-FRANCE' then 0.487838982937407
    when @Destination3 = 'Europe-GERMANY' then 0.0699866704503416
    when @Destination3 = 'Europe-GREECE' then 0.487838982937407
    when @Destination3 = 'Europe-ITALY' then 0.487838982937407
    when @Destination3 = 'Europe-NETHERLANDS' then 0.236401630706106
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then 0
    when @Destination3 = 'Europe-SCOTLAND' then 0.0699866704503416
    when @Destination3 = 'Europe-SPAIN' then 0.487838982937407
    when @Destination3 = 'Europe-SWITZERLAND' then 0.0699866704503416
    when @Destination3 = 'Europe-UNITED KINGDOM' then 0.0699866704503416
    when @Destination3 = 'Mid East' then 0
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then 0.0699866704503416
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 0.0699866704503416
    when @Destination3 = 'Pacific Region' then 0.0699866704503416
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then -0.588274471712141
    when @Destination3 = 'Pacific Region-FIJI' then -0.162960226536212
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then -0.314175230404187
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then -0.162960226536212
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then -0.588274471712141
    when @Destination3 = 'Pacific Region-VANUATU' then -0.162960226536212
    when @Destination3 = 'SEA-INDONESIA' then 0.0699866704503416
    when @Destination3 = 'SEA-MALAYSIA' then -0.162960226536212
    when @Destination3 = 'SEA-PHILIPPINES' then -0.314175230404187
    when @Destination3 = 'SEA-SINGAPORE' then -0.314175230404187
    when @Destination3 = 'South America' then 0.487838982937407
    when @Destination3 = 'South Asia' then 0.0699866704503416
    when @Destination3 = 'South Asia-CAMBODIA' then 0.236401630706106
    when @Destination3 = 'South Asia-INDIA' then 0.0699866704503416
    when @Destination3 = 'South Asia-NEPAL' then 0.236401630706106
    when @Destination3 = 'South Asia-SRI LANKA' then 0
    when @Destination3 = 'South Asia-THAILAND' then -0.162960226536212
    when @Destination3 = 'South Asia-VIETNAM' then 0
    when @Destination3 = 'World Others' then 0.487838982937407
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then -0.153938447940398
    when @Lead_Time2 = '3' then -0.153938447940398
    when @Lead_Time2 = '4' then -0.153938447940398
    when @Lead_Time2 = '5' then -0.153938447940398
    when @Lead_Time2 = '6' then -0.153938447940398
    when @Lead_Time2 = '7' then -0.153938447940398
    when @Lead_Time2 = '8' then -0.153938447940398
    when @Lead_Time2 = '9' then -0.153938447940398
    when @Lead_Time2 = '10' then -0.153938447940398
    when @Lead_Time2 = '11' then -0.153938447940398
    when @Lead_Time2 = '12' then -0.153938447940398
    when @Lead_Time2 = '13' then -0.153938447940398
    when @Lead_Time2 = '14' then -0.153938447940398
    when @Lead_Time2 = '15' then -0.153938447940398
    when @Lead_Time2 = '16' then -0.153938447940398
    when @Lead_Time2 = '17' then -0.153938447940398
    when @Lead_Time2 = '18' then -0.153938447940398
    when @Lead_Time2 = '19' then -0.153938447940398
    when @Lead_Time2 = '20' then -0.153938447940398
    when @Lead_Time2 = '21' then -0.153938447940398
    when @Lead_Time2 = '22' then -0.153938447940398
    when @Lead_Time2 = '23' then -0.153938447940398
    when @Lead_Time2 = '24' then -0.153938447940398
    when @Lead_Time2 = '25' then -0.153938447940398
    when @Lead_Time2 = '26' then -0.153938447940398
    when @Lead_Time2 = '27' then -0.153938447940398
    when @Lead_Time2 = '28' then -0.153938447940398
    when @Lead_Time2 = '29' then -0.153938447940398
    when @Lead_Time2 = '30' then -0.153938447940398
    when @Lead_Time2 = '31' then -0.153938447940398
    when @Lead_Time2 = '32' then -0.153938447940398
    when @Lead_Time2 = '33' then -0.153938447940398
    when @Lead_Time2 = '34' then -0.153938447940398
    when @Lead_Time2 = '35' then -0.153938447940398
    when @Lead_Time2 = '36' then -0.153938447940398
    when @Lead_Time2 = '37' then -0.153938447940398
    when @Lead_Time2 = '38' then -0.153938447940398
    when @Lead_Time2 = '39' then -0.153938447940398
    when @Lead_Time2 = '40' then -0.153938447940398
    when @Lead_Time2 = '41' then -0.153938447940398
    when @Lead_Time2 = '42' then -0.153938447940398
    when @Lead_Time2 = '43' then -0.153938447940398
    when @Lead_Time2 = '44' then -0.153938447940398
    when @Lead_Time2 = '45' then -0.153938447940398
    when @Lead_Time2 = '46' then -0.153938447940398
    when @Lead_Time2 = '47' then -0.153938447940398
    when @Lead_Time2 = '48' then -0.153938447940398
    when @Lead_Time2 = '49' then -0.153938447940398
    when @Lead_Time2 = '50' then -0.153938447940398
    when @Lead_Time2 = '51' then -0.153938447940398
    when @Lead_Time2 = '52' then -0.153938447940398
    when @Lead_Time2 = '53' then -0.153938447940398
    when @Lead_Time2 = '54' then -0.153938447940398
    when @Lead_Time2 = '55' then -0.153938447940398
    when @Lead_Time2 = '56' then -0.153938447940398
    when @Lead_Time2 = '57' then -0.153938447940398
    when @Lead_Time2 = '58' then -0.153938447940398
    when @Lead_Time2 = '59' then -0.153938447940398
    when @Lead_Time2 = '60' then -0.153938447940398
    when @Lead_Time2 = '61' then -0.153938447940398
    when @Lead_Time2 = '62' then -0.153938447940398
    when @Lead_Time2 = '63' then -0.153938447940398
    when @Lead_Time2 = '64' then -0.153938447940398
    when @Lead_Time2 = '65' then -0.153938447940398
    when @Lead_Time2 = '66' then -0.153938447940398
    when @Lead_Time2 = '67' then -0.153938447940398
    when @Lead_Time2 = '68' then -0.153938447940398
    when @Lead_Time2 = '69' then -0.153938447940398
    when @Lead_Time2 = '70' then -0.153938447940398
    when @Lead_Time2 = '71' then -0.153938447940398
    when @Lead_Time2 = '72' then -0.153938447940398
    when @Lead_Time2 = '73' then -0.153938447940398
    when @Lead_Time2 = '74' then -0.153938447940398
    when @Lead_Time2 = '75' then -0.153938447940398
    when @Lead_Time2 = '76' then -0.153938447940398
    when @Lead_Time2 = '77' then -0.153938447940398
    when @Lead_Time2 = '78' then -0.153938447940398
    when @Lead_Time2 = '79' then -0.153938447940398
    when @Lead_Time2 = '80' then -0.153938447940398
    when @Lead_Time2 = '81' then -0.153938447940398
    when @Lead_Time2 = '82' then -0.153938447940398
    when @Lead_Time2 = '83' then -0.153938447940398
    when @Lead_Time2 = '84' then -0.153938447940398
    when @Lead_Time2 = '85' then -0.153938447940398
    when @Lead_Time2 = '86' then -0.153938447940398
    when @Lead_Time2 = '87' then -0.153938447940398
    when @Lead_Time2 = '88' then -0.153938447940398
    when @Lead_Time2 = '89' then -0.153938447940398
    when @Lead_Time2 = '90' then -0.153938447940398
    when @Lead_Time2 = '91' then -0.153938447940398
    when @Lead_Time2 = '92' then -0.153938447940398
    when @Lead_Time2 = '93' then -0.153938447940398
    when @Lead_Time2 = '94' then -0.153938447940398
    when @Lead_Time2 = '95' then -0.153938447940398
    when @Lead_Time2 = '96' then -0.153938447940398
    when @Lead_Time2 = '97' then -0.153938447940398
    when @Lead_Time2 = '98' then -0.153938447940398
    when @Lead_Time2 = '99' then -0.153938447940398
    when @Lead_Time2 = '100' then -0.153938447940398
    when @Lead_Time2 = '101' then -0.153938447940398
    when @Lead_Time2 = '102' then -0.153938447940398
    when @Lead_Time2 = '103' then -0.153938447940398
    when @Lead_Time2 = '104' then -0.153938447940398
    when @Lead_Time2 = '105' then -0.153938447940398
    when @Lead_Time2 = '106' then -0.153938447940398
    when @Lead_Time2 = '107' then -0.153938447940398
    when @Lead_Time2 = '108' then -0.153938447940398
    when @Lead_Time2 = '109' then -0.153938447940398
    when @Lead_Time2 = '110' then -0.153938447940398
    when @Lead_Time2 = '111' then -0.153938447940398
    when @Lead_Time2 = '112' then -0.153938447940398
    when @Lead_Time2 = '113' then -0.153938447940398
    when @Lead_Time2 = '114' then -0.153938447940398
    when @Lead_Time2 = '115' then -0.153938447940398
    when @Lead_Time2 = '116' then -0.153938447940398
    when @Lead_Time2 = '117' then -0.153938447940398
    when @Lead_Time2 = '118' then -0.153938447940398
    when @Lead_Time2 = '119' then -0.153938447940398
    when @Lead_Time2 = '120' then -0.153938447940398
    when @Lead_Time2 = '121' then -0.153938447940398
    when @Lead_Time2 = '122' then -0.153938447940398
    when @Lead_Time2 = '123' then -0.153938447940398
    when @Lead_Time2 = '124' then -0.153938447940398
    when @Lead_Time2 = '125' then -0.153938447940398
    when @Lead_Time2 = '126' then -0.153938447940398
    when @Lead_Time2 = '127' then -0.153938447940398
    when @Lead_Time2 = '128' then -0.153938447940398
    when @Lead_Time2 = '129' then -0.153938447940398
    when @Lead_Time2 = '130' then -0.153938447940398
    when @Lead_Time2 = '131' then -0.153938447940398
    when @Lead_Time2 = '132' then -0.153938447940398
    when @Lead_Time2 = '133' then -0.153938447940398
    when @Lead_Time2 = '134' then -0.153938447940398
    when @Lead_Time2 = '135' then -0.153938447940398
    when @Lead_Time2 = '136' then -0.153938447940398
    when @Lead_Time2 = '137' then -0.153938447940398
    when @Lead_Time2 = '138' then -0.153938447940398
    when @Lead_Time2 = '139' then -0.153938447940398
    when @Lead_Time2 = '140' then -0.153938447940398
    when @Lead_Time2 = '141' then -0.153938447940398
    when @Lead_Time2 = '142' then -0.153938447940398
    when @Lead_Time2 = '143' then -0.153938447940398
    when @Lead_Time2 = '144' then -0.153938447940398
    when @Lead_Time2 = '145' then -0.153938447940398
    when @Lead_Time2 = '146' then -0.153938447940398
    when @Lead_Time2 = '147' then -0.153938447940398
    when @Lead_Time2 = '148' then -0.153938447940398
    when @Lead_Time2 = '149' then -0.153938447940398
    when @Lead_Time2 = '150' then -0.153938447940398
    when @Lead_Time2 = '151' then -0.153938447940398
    when @Lead_Time2 = '152' then -0.153938447940398
    when @Lead_Time2 = '153' then -0.153938447940398
    when @Lead_Time2 = '154' then -0.153938447940398
    when @Lead_Time2 = '155' then -0.153938447940398
    when @Lead_Time2 = '156' then -0.153938447940398
    when @Lead_Time2 = '157' then -0.153938447940398
    when @Lead_Time2 = '158' then -0.153938447940398
    when @Lead_Time2 = '159' then -0.153938447940398
    when @Lead_Time2 = '160' then -0.153938447940398
    when @Lead_Time2 = '161' then -0.153938447940398
    when @Lead_Time2 = '162' then -0.153938447940398
    when @Lead_Time2 = '163' then -0.153938447940398
    when @Lead_Time2 = '164' then -0.153938447940398
    when @Lead_Time2 = '165' then -0.153938447940398
    when @Lead_Time2 = '166' then -0.153938447940398
    when @Lead_Time2 = '167' then -0.153938447940398
    when @Lead_Time2 = '168' then -0.153938447940398
    when @Lead_Time2 = '169' then -0.153938447940398
    when @Lead_Time2 = '170' then -0.153938447940398
    when @Lead_Time2 = '171' then -0.153938447940398
    when @Lead_Time2 = '172' then -0.153938447940398
    when @Lead_Time2 = '173' then -0.153938447940398
    when @Lead_Time2 = '174' then -0.153938447940398
    when @Lead_Time2 = '175' then -0.153938447940398
    when @Lead_Time2 = '176' then -0.153938447940398
    when @Lead_Time2 = '177' then -0.153938447940398
    when @Lead_Time2 = '178' then -0.153938447940398
    when @Lead_Time2 = '179' then -0.153938447940398
    when @Lead_Time2 = '180' then -0.153938447940398
    when @Lead_Time2 = '181' then -0.153938447940398
    when @Lead_Time2 = '188' then -0.153938447940398
    when @Lead_Time2 = '195' then -0.153938447940398
    when @Lead_Time2 = '202' then -0.153938447940398
    when @Lead_Time2 = '209' then -0.153938447940398
    when @Lead_Time2 = '216' then -0.153938447940398
    when @Lead_Time2 = '223' then -0.153938447940398
    when @Lead_Time2 = '230' then -0.153938447940398
    when @Lead_Time2 = '237' then -0.153938447940398
    when @Lead_Time2 = '244' then -0.153938447940398
    when @Lead_Time2 = '251' then -0.153938447940398
    when @Lead_Time2 = '258' then -0.153938447940398
    when @Lead_Time2 = '265' then -0.153938447940398
    when @Lead_Time2 = '272' then -0.153938447940398
    when @Lead_Time2 = '279' then -0.153938447940398
    when @Lead_Time2 = '286' then -0.153938447940398
    when @Lead_Time2 = '293' then -0.153938447940398
    when @Lead_Time2 = '300' then -0.275429742551055
    when @Lead_Time2 = '307' then -0.275429742551055
    when @Lead_Time2 = '314' then -0.275429742551055
    when @Lead_Time2 = '321' then -0.275429742551055
    when @Lead_Time2 = '328' then -0.275429742551055
    when @Lead_Time2 = '335' then -0.275429742551055
    when @Lead_Time2 = '342' then -0.275429742551055
    when @Lead_Time2 = '349' then -0.275429742551055
    when @Lead_Time2 = '356' then -0.275429742551055
    when @Lead_Time2 = '363' then -0.275429742551055
    when @Lead_Time2 = '370' then -0.275429742551055
    when @Lead_Time2 = '377' then -0.275429742551055
    when @Lead_Time2 = '384' then -0.275429742551055
    when @Lead_Time2 = '391' then -0.275429742551055
    when @Lead_Time2 = '398' then -0.275429742551055
    when @Lead_Time2 = '405' then -0.275429742551055
    when @Lead_Time2 = '412' then -0.275429742551055
    when @Lead_Time2 = '419' then -0.275429742551055
    when @Lead_Time2 = '426' then -0.275429742551055
    when @Lead_Time2 = '433' then -0.275429742551055
    when @Lead_Time2 = '440' then -0.275429742551055
    when @Lead_Time2 = '447' then -0.275429742551055
    when @Lead_Time2 = '454' then -0.275429742551055
    when @Lead_Time2 = '461' then -0.275429742551055
    when @Lead_Time2 = '468' then -0.275429742551055
    when @Lead_Time2 = '475' then -0.275429742551055
    when @Lead_Time2 = '482' then -0.275429742551055
    when @Lead_Time2 = '489' then -0.275429742551055
    when @Lead_Time2 = '496' then -0.275429742551055
    when @Lead_Time2 = '503' then -0.275429742551055
    when @Lead_Time2 = '510' then -0.275429742551055
    when @Lead_Time2 = '517' then -0.275429742551055
    when @Lead_Time2 = '524' then -0.275429742551055
    when @Lead_Time2 = '531' then -0.275429742551055
    when @Lead_Time2 = '538' then -0.275429742551055
    when @Lead_Time2 = '545' then -0.275429742551055
    when @Lead_Time2 = '552' then -0.275429742551055
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then -0.0431496568511847
    when @OldestAge2 = '12' then -0.811882824367725
    when @OldestAge2 = '13' then -0.80350558710458
    when @OldestAge2 = '14' then -0.624574021179082
    when @OldestAge2 = '15' then -0.472089391108942
    when @OldestAge2 = '16' then -0.3389926928957
    when @OldestAge2 = '17' then -0.221451148944121
    when @OldestAge2 = '18' then -0.117490467032653
    when @OldestAge2 = '19' then -0.0260993804667891
    when @OldestAge2 = '20' then 0.0533581482408687
    when @OldestAge2 = '21' then 0.12148232373086
    when @OldestAge2 = '22' then 0.178978332554555
    when @OldestAge2 = '23' then 0.226657966194068
    when @OldestAge2 = '24' then 0.265365262038752
    when @OldestAge2 = '25' then 0.295883021183329
    when @OldestAge2 = '26' then 0.318862129078608
    when @OldestAge2 = '27' then 0.334795543849332
    when @OldestAge2 = '28' then 0.344038369005003
    when @OldestAge2 = '29' then 0.346860270186894
    when @OldestAge2 = '30' then 0.343510423872497
    when @OldestAge2 = '31' then 0.334278225929934
    when @OldestAge2 = '32' then 0.319541500826384
    when @OldestAge2 = '33' then 0.299802526635123
    when @OldestAge2 = '34' then 0.275716397250544
    when @OldestAge2 = '35' then 0.24811415675062
    when @OldestAge2 = '36' then 0.218016010354745
    when @OldestAge2 = '37' then 0.186621744062232
    when @OldestAge2 = '38' then 0.155261759451653
    when @OldestAge2 = '39' then 0.125297515092071
    when @OldestAge2 = '40' then 0.0979762870247419
    when @OldestAge2 = '41' then 0.0742673891724967
    when @OldestAge2 = '42' then 0.0547247887751672
    when @OldestAge2 = '43' then 0.039422287758149
    when @OldestAge2 = '44' then 0.0279871433107353
    when @OldestAge2 = '45' then 0.019724190735892
    when @OldestAge2 = '46' then 0.0137921465304133
    when @OldestAge2 = '47' then 0.00938099913865464
    when @OldestAge2 = '48' then 0.00584666987481077
    when @OldestAge2 = '49' then 0.00277889203809697
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then -0.00249045958168279
    when @OldestAge2 = '52' then -0.00460020067123331
    when @OldestAge2 = '53' then -0.00622983872783852
    when @OldestAge2 = '54' then -0.00733595250522077
    when @OldestAge2 = '55' then -0.00795806703263674
    when @OldestAge2 = '56' then -0.00820936568554489
    when @OldestAge2 = '57' then -0.00824302733549591
    when @OldestAge2 = '58' then -0.00821261514706608
    when @OldestAge2 = '59' then -0.00824396695773633
    when @OldestAge2 = '60' then -0.00842869664905082
    when @OldestAge2 = '61' then -0.00883909513151599
    when @OldestAge2 = '62' then -0.00955512079997691
    when @OldestAge2 = '63' then -0.0106893902613683
    when @OldestAge2 = '64' then -0.0123971692772855
    when @OldestAge2 = '65' then -0.0148643894828755
    when @OldestAge2 = '66' then -0.0182752812685116
    when @OldestAge2 = '67' then -0.0227689574551943
    when @OldestAge2 = '68' then -0.028398864691658
    when @OldestAge2 = '69' then -0.0351090810932346
    when @OldestAge2 = '70' then -0.0427375307867983
    when @OldestAge2 = '71' then -0.0510492788658041
    when @OldestAge2 = '72' then -0.0597948455670068
    when @OldestAge2 = '73' then -0.0687807169707249
    when @OldestAge2 = '74' then -0.0779339659736307
    when @OldestAge2 = '75' then -0.0873421292224457
    when @OldestAge2 = '76' then -0.0972539478640898
    when @OldestAge2 = '77' then -0.108035413734776
    when @OldestAge2 = '78' then -0.120085967293119
    when @OldestAge2 = '79' then -0.133728881592296
    when @OldestAge2 = '80' then -0.149096008521867
    when @OldestAge2 = '81' then -0.166030326896105
    when @OldestAge2 = '82' then -0.184030926339268
    when @OldestAge2 = '83' then -0.202263786909679
    when @OldestAge2 = '84' then -0.219655338282404
    when @OldestAge2 = '85' then -0.235070264676289
    when @OldestAge2 = '86' then -0.247548992504937
    when @OldestAge2 = '87' then -0.256550335711419
    when @OldestAge2 = '88' then -0.262126512162336
    when @OldestAge2 = '89' then -0.264967639619707
    when @OldestAge2 = '90' then -0.266293208165394

end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.131753554452852
    when @Traveller_Count2 = '3' then 0.208121664649395
    when @Traveller_Count2 = '4' then 0.300744672127846
    when @Traveller_Count2 = '5' then 0.449580818925898
    when @Traveller_Count2 = '6' then 0.449580818925898
    when @Traveller_Count2 = '7' then 0.449580818925898
    when @Traveller_Count2 = '8' then 0.449580818925898
    when @Traveller_Count2 = '9' then 0.449580818925898
    when @Traveller_Count2 = '10' then 0.449580818925898
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then 0.195384093565236
    when @JV_Description = 'Air New Zealand' then -0.335206996893423
    when @JV_Description = 'Australia Post' then 0.195384093565236
    when @JV_Description = 'CBA White Label' then -0.335206996893423
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then 0
    when @JV_Description = 'Helloworld' then 0
    when @JV_Description = 'Indep + Others' then 0
    when @JV_Description = 'Insurance Australia Ltd' then 0.195384093565236
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then 0.195384093565236
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0
    when @JV_Description = 'Virgin' then 0
    when @JV_Description = 'Websales' then 0.371974148185553
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
    when @Product_Indicator = 'International AMT' then -0.830310599204187
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then -0.452456142134112
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then 1.13584384527344
    when @Excess = '25' then 1.03726589216415
    when @Excess = '50' then 0.927907523311234
    when @Excess = '60' then 0.880580222676125
    when @Excess = '100' then 0.665056300393419
    when @Excess = '150' then 0.488436680620435
    when @Excess = '200' then 0.273747833547393
    when @Excess = '250' then 0
    when @Excess = '300' then -0.193584749072666
    when @Excess = '500' then -2.11859825688103
    when @Excess = '1000' then -2.11859825688103
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0
    when @Departure_Month = '2' then 0
    when @Departure_Month = '3' then 0
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then 0
    when @Departure_Month = '9' then 0
    when @Departure_Month = '10' then -0.0809763857462587
    when @Departure_Month = '11' then -0.0809763857462587
    when @Departure_Month = '12' then 0
end

-- Start of return_yr
set @LinearPredictor = @LinearPredictor +
case
    when @return_yr = '2018' then 0.0497339644244032
    when @return_yr = '2019' then 0
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.318418638139423
    when @Gender = 'FF' then 0.109822404905437
    when @Gender = 'FM' then 0
    when @Gender = 'M' then -0.318418638139423
    when @Gender = 'MM' then 0.109822404905437
    when @Gender = 'O' then -0.501618485923926
    when @Gender = 'U' then -0.501618485923926
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Cancellation_ACS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Cancellation_ACS] (
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
,@Latest_product nvarchar(30)
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
set @LinearPredictor = @LinearPredictor +  6.61741509188679

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.497909398499444
    when @Trip_Length2 = '2' then -0.497909398499444
    when @Trip_Length2 = '3' then -0.384046140734864
    when @Trip_Length2 = '4' then -0.28382286212606
    when @Trip_Length2 = '5' then -0.196623341504814
    when @Trip_Length2 = '6' then -0.121038328377056
    when @Trip_Length2 = '7' then -0.0560413908836246
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.0487901641694323
    when @Trip_Length2 = '10' then 0.0921232888758059
    when @Trip_Length2 = '11' then 0.131905070879939
    when @Trip_Length2 = '12' then 0.169658382840558
    when @Trip_Length2 = '13' then 0.206526245490772
    when @Trip_Length2 = '14' then 0.243181445050717
    when @Trip_Length2 = '15' then 0.279599496258425
    when @Trip_Length2 = '16' then 0.315321558255198
    when @Trip_Length2 = '17' then 0.349529475777861
    when @Trip_Length2 = '18' then 0.380967476507764
    when @Trip_Length2 = '19' then 0.408925779737145
    when @Trip_Length2 = '20' then 0.432885703684157
    when @Trip_Length2 = '21' then 0.452603114565569
    when @Trip_Length2 = '22' then 0.468502503119469
    when @Trip_Length2 = '23' then 0.48094356928407
    when @Trip_Length2 = '24' then 0.490357575126127
    when @Trip_Length2 = '25' then 0.497193122034695
    when @Trip_Length2 = '26' then 0.501986675098786
    when @Trip_Length2 = '27' then 0.505250109432805
    when @Trip_Length2 = '28' then 0.507901352248744
    when @Trip_Length2 = '29' then 0.510545584558672
    when @Trip_Length2 = '30' then 0.513841072726448
    when @Trip_Length2 = '31' then 0.517840958659896
    when @Trip_Length2 = '32' then 0.522299545839618
    when @Trip_Length2 = '33' then 0.526856440838518
    when @Trip_Length2 = '34' then 0.531157522737909
    when @Trip_Length2 = '35' then 0.535264545643009
    when @Trip_Length2 = '36' then 0.539413080617903
    when @Trip_Length2 = '37' then 0.543776723905676
    when @Trip_Length2 = '38' then 0.548525950948816
    when @Trip_Length2 = '39' then 0.553655201741346
    when @Trip_Length2 = '40' then 0.558929838440137
    when @Trip_Length2 = '41' then 0.564119914823708
    when @Trip_Length2 = '42' then 0.569170000740234
    when @Trip_Length2 = '43' then 0.574082073401006
    when @Trip_Length2 = '44' then 0.578801978775084
    when @Trip_Length2 = '45' then 0.583220701181341
    when @Trip_Length2 = '46' then 0.587119775914415
    when @Trip_Length2 = '47' then 0.588730663639518
    when @Trip_Length2 = '48' then 0.588730663639518
    when @Trip_Length2 = '49' then 0.588730663639518
    when @Trip_Length2 = '50' then 0.588730663639518
    when @Trip_Length2 = '51' then 0.588730663639518
    when @Trip_Length2 = '52' then 0.588730663639518
    when @Trip_Length2 = '53' then 0.588730663639518
    when @Trip_Length2 = '54' then 0.588730663639518
    when @Trip_Length2 = '55' then 0.588730663639518
    when @Trip_Length2 = '56' then 0.588730663639518
    when @Trip_Length2 = '57' then 0.588730663639518
    when @Trip_Length2 = '58' then 0.588730663639518
    when @Trip_Length2 = '59' then 0.588730663639518
    when @Trip_Length2 = '60' then 0.588730663639518
    when @Trip_Length2 = '61' then 0.588730663639518
    when @Trip_Length2 = '62' then 0.588730663639518
    when @Trip_Length2 = '63' then 0.588730663639518
    when @Trip_Length2 = '64' then 0.588730663639518
    when @Trip_Length2 = '65' then 0.588730663639518
    when @Trip_Length2 = '66' then 0.588730663639518
    when @Trip_Length2 = '67' then 0.588730663639518
    when @Trip_Length2 = '68' then 0.588730663639518
    when @Trip_Length2 = '69' then 0.588730663639518
    when @Trip_Length2 = '70' then 0.588730663639518
    when @Trip_Length2 = '71' then 0.588730663639518
    when @Trip_Length2 = '72' then 0.588730663639518
    when @Trip_Length2 = '73' then 0.588730663639518
    when @Trip_Length2 = '74' then 0.588730663639518
    when @Trip_Length2 = '75' then 0.588730663639518
    when @Trip_Length2 = '76' then 0.588730663639518
    when @Trip_Length2 = '77' then 0.588730663639518
    when @Trip_Length2 = '78' then 0.588730663639518
    when @Trip_Length2 = '79' then 0.588730663639518
    when @Trip_Length2 = '80' then 0.588730663639518
    when @Trip_Length2 = '81' then 0.588730663639518
    when @Trip_Length2 = '82' then 0.588730663639518
    when @Trip_Length2 = '83' then 0.588730663639518
    when @Trip_Length2 = '84' then 0.588730663639518
    when @Trip_Length2 = '85' then 0.588730663639518
    when @Trip_Length2 = '86' then 0.588730663639518
    when @Trip_Length2 = '87' then 0.588730663639518
    when @Trip_Length2 = '88' then 0.588730663639518
    when @Trip_Length2 = '89' then 0.588730663639518
    when @Trip_Length2 = '90' then 0.588730663639518
    when @Trip_Length2 = '97' then 0.588730663639518
    when @Trip_Length2 = '104' then 0.588730663639518
    when @Trip_Length2 = '111' then 0.588730663639518
    when @Trip_Length2 = '118' then 0.588730663639518
    when @Trip_Length2 = '125' then 0.588730663639518
    when @Trip_Length2 = '132' then 0.588730663639518
    when @Trip_Length2 = '139' then 0.588730663639518
    when @Trip_Length2 = '146' then 0.588730663639518
    when @Trip_Length2 = '153' then 0.588730663639518
    when @Trip_Length2 = '160' then 0.588730663639518
    when @Trip_Length2 = '167' then 0.588730663639518
    when @Trip_Length2 = '174' then 0.588730663639518
    when @Trip_Length2 = '181' then 0.588730663639518
    when @Trip_Length2 = '188' then 0.588730663639518
    when @Trip_Length2 = '195' then 0.588730663639518
    when @Trip_Length2 = '202' then 0.588730663639518
    when @Trip_Length2 = '209' then 0.588730663639518
    when @Trip_Length2 = '216' then 0.588730663639518
    when @Trip_Length2 = '223' then 0.588730663639518
    when @Trip_Length2 = '230' then 0.588730663639518
    when @Trip_Length2 = '237' then 0.588730663639518
    when @Trip_Length2 = '244' then 0.588730663639518
    when @Trip_Length2 = '251' then 0.588730663639518
    when @Trip_Length2 = '258' then 0.588730663639518
    when @Trip_Length2 = '265' then 0.588730663639518
    when @Trip_Length2 = '272' then 0.588730663639518
    when @Trip_Length2 = '279' then 0.588730663639518
    when @Trip_Length2 = '286' then 0.588730663639518
    when @Trip_Length2 = '293' then 0.588730663639518
    when @Trip_Length2 = '300' then 0.588730663639518
    when @Trip_Length2 = '307' then 0.588730663639518
    when @Trip_Length2 = '314' then 0.588730663639518
    when @Trip_Length2 = '321' then 0.588730663639518
    when @Trip_Length2 = '328' then 0.588730663639518
    when @Trip_Length2 = '335' then 0.588730663639518
    when @Trip_Length2 = '342' then 0.588730663639518
    when @Trip_Length2 = '349' then 0.588730663639518
    when @Trip_Length2 = '356' then 0.588730663639518
    when @Trip_Length2 = '363' then 0.588730663639518
    when @Trip_Length2 = '365' then 0.588730663639518
    when @Trip_Length2 = '370' then 0.588730663639518
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.663460760820167
    when @Destination3 = 'Africa-SOUTH AFRICA' then 0.309645776393062
    when @Destination3 = 'Asia Others' then 0.309645776393062
    when @Destination3 = 'Domestic' then 0
    when @Destination3 = 'East Asia' then 0
    when @Destination3 = 'East Asia-CHINA' then 0.160538111286461
    when @Destination3 = 'East Asia-HONG KONG' then 0.160538111286461
    when @Destination3 = 'East Asia-JAPAN' then 0.309645776393062
    when @Destination3 = 'Europe' then 0.309645776393062
    when @Destination3 = 'Europe-CROATIA' then 0.160538111286461
    when @Destination3 = 'Europe-ENGLAND' then 0
    when @Destination3 = 'Europe-FRANCE' then 0.309645776393062
    when @Destination3 = 'Europe-GERMANY' then 0.309645776393062
    when @Destination3 = 'Europe-GREECE' then 0.160538111286461
    when @Destination3 = 'Europe-ITALY' then 0.309645776393062
    when @Destination3 = 'Europe-NETHERLANDS' then 0.309645776393062
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then 0
    when @Destination3 = 'Europe-SCOTLAND' then 0
    when @Destination3 = 'Europe-SPAIN' then 0.309645776393062
    when @Destination3 = 'Europe-SWITZERLAND' then 0
    when @Destination3 = 'Europe-UNITED KINGDOM' then 0
    when @Destination3 = 'Mid East' then 0.160538111286461
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then 0.663460760820167
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 0.309645776393062
    when @Destination3 = 'Pacific Region' then 0.309645776393062
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then 0.160538111286461
    when @Destination3 = 'Pacific Region-FIJI' then 0.309645776393062
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then 0.160538111286461
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0.309645776393062
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then 0.160538111286461
    when @Destination3 = 'Pacific Region-VANUATU' then 0.160538111286461
    when @Destination3 = 'SEA-INDONESIA' then 0
    when @Destination3 = 'SEA-MALAYSIA' then 0
    when @Destination3 = 'SEA-PHILIPPINES' then 0
    when @Destination3 = 'SEA-SINGAPORE' then 0.160538111286461
    when @Destination3 = 'South America' then 0.663460760820167
    when @Destination3 = 'South Asia' then 0.663460760820167
    when @Destination3 = 'South Asia-CAMBODIA' then 0
    when @Destination3 = 'South Asia-INDIA' then 0.160538111286461
    when @Destination3 = 'South Asia-NEPAL' then 0.160538111286461
    when @Destination3 = 'South Asia-SRI LANKA' then 0.160538111286461
    when @Destination3 = 'South Asia-THAILAND' then 0
    when @Destination3 = 'South Asia-VIETNAM' then 0.160538111286461
    when @Destination3 = 'World Others' then 0.309645776393062
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then 0.00339423306801562
    when @Lead_Time2 = '3' then 0.00687630393943184
    when @Lead_Time2 = '4' then 0.0106431600984793
    when @Lead_Time2 = '5' then 0.0146915487429897
    when @Lead_Time2 = '6' then 0.0191161171922306
    when @Lead_Time2 = '7' then 0.0241070753432329
    when @Lead_Time2 = '8' then 0.029558802241544
    when @Lead_Time2 = '9' then 0.0354636642755688
    when @Lead_Time2 = '10' then 0.0418135028134108
    when @Lead_Time2 = '11' then 0.0484091392076876
    when @Lead_Time2 = '12' then 0.0551508444648476
    when @Lead_Time2 = '13' then 0.0617533962754822
    when @Lead_Time2 = '14' then 0.0682192389771439
    when @Lead_Time2 = '15' then 0.0743650819553067
    when @Lead_Time2 = '16' then 0.080196541994277
    when @Lead_Time2 = '17' then 0.0856270859674374
    when @Lead_Time2 = '18' then 0.0908456832995768
    when @Lead_Time2 = '19' then 0.0960371881969424
    when @Lead_Time2 = '20' then 0.101201880508968
    when @Lead_Time2 = '21' then 0.106699618659055
    when @Lead_Time2 = '22' then 0.112524790841844
    when @Lead_Time2 = '23' then 0.118849133838381
    when @Lead_Time2 = '24' then 0.12575120530556
    when @Lead_Time2 = '25' then 0.133218843786223
    when @Lead_Time2 = '26' then 0.141065440278603
    when @Lead_Time2 = '27' then 0.149281702715754
    when @Lead_Time2 = '28' then 0.157772683872542
    when @Lead_Time2 = '29' then 0.166361537215225
    when @Lead_Time2 = '30' then 0.174877249904719
    when @Lead_Time2 = '31' then 0.183237803578308
    when @Lead_Time2 = '32' then 0.19111610447545
    when @Lead_Time2 = '33' then 0.198440938673838
    when @Lead_Time2 = '34' then 0.205142500204657
    when @Lead_Time2 = '35' then 0.210909013645867
    when @Lead_Time2 = '36' then 0.215756332880192
    when @Lead_Time2 = '37' then 0.219537055720098
    when @Lead_Time2 = '38' then 0.222423291989727
    when @Lead_Time2 = '39' then 0.22442273281259
    when @Lead_Time2 = '40' then 0.2257002800959
    when @Lead_Time2 = '41' then 0.226338442210729
    when @Lead_Time2 = '42' then 0.226657370614006
    when @Lead_Time2 = '43' then 0.226816796680506
    when @Lead_Time2 = '44' then 0.227055888134125
    when @Lead_Time2 = '45' then 0.227454246901295
    when @Lead_Time2 = '46' then 0.228170893028235
    when @Lead_Time2 = '47' then 0.22944366386269
    when @Lead_Time2 = '48' then 0.231191082893511
    when @Lead_Time2 = '49' then 0.233648183959295
    when @Lead_Time2 = '50' then 0.236809742078025
    when @Lead_Time2 = '51' then 0.240904880892852
    when @Lead_Time2 = '52' then 0.245843936834985
    when @Lead_Time2 = '53' then 0.251847619442565
    when @Lead_Time2 = '54' then 0.25881952776668
    when @Lead_Time2 = '55' then 0.266815879770396
    when @Lead_Time2 = '56' then 0.27573600143338
    when @Lead_Time2 = '57' then 0.285404480707723
    when @Lead_Time2 = '58' then 0.295724644094966
    when @Lead_Time2 = '59' then 0.306454757775065
    when @Lead_Time2 = '60' then 0.317289417204439
    when @Lead_Time2 = '61' then 0.317289417204439
    when @Lead_Time2 = '62' then 0.317289417204439
    when @Lead_Time2 = '63' then 0.317289417204439
    when @Lead_Time2 = '64' then 0.317289417204439
    when @Lead_Time2 = '65' then 0.317289417204439
    when @Lead_Time2 = '66' then 0.317289417204439
    when @Lead_Time2 = '67' then 0.317289417204439
    when @Lead_Time2 = '68' then 0.317289417204439
    when @Lead_Time2 = '69' then 0.317289417204439
    when @Lead_Time2 = '70' then 0.317289417204439
    when @Lead_Time2 = '71' then 0.317289417204439
    when @Lead_Time2 = '72' then 0.317289417204439
    when @Lead_Time2 = '73' then 0.317289417204439
    when @Lead_Time2 = '74' then 0.317289417204439
    when @Lead_Time2 = '75' then 0.317289417204439
    when @Lead_Time2 = '76' then 0.317289417204439
    when @Lead_Time2 = '77' then 0.317289417204439
    when @Lead_Time2 = '78' then 0.317289417204439
    when @Lead_Time2 = '79' then 0.317289417204439
    when @Lead_Time2 = '80' then 0.317289417204439
    when @Lead_Time2 = '81' then 0.317289417204439
    when @Lead_Time2 = '82' then 0.317289417204439
    when @Lead_Time2 = '83' then 0.317289417204439
    when @Lead_Time2 = '84' then 0.317289417204439
    when @Lead_Time2 = '85' then 0.317289417204439
    when @Lead_Time2 = '86' then 0.317289417204439
    when @Lead_Time2 = '87' then 0.317289417204439
    when @Lead_Time2 = '88' then 0.317289417204439
    when @Lead_Time2 = '89' then 0.317289417204439
    when @Lead_Time2 = '90' then 0.317289417204439
    when @Lead_Time2 = '91' then 0.317289417204439
    when @Lead_Time2 = '92' then 0.317289417204439
    when @Lead_Time2 = '93' then 0.317289417204439
    when @Lead_Time2 = '94' then 0.317289417204439
    when @Lead_Time2 = '95' then 0.317289417204439
    when @Lead_Time2 = '96' then 0.317289417204439
    when @Lead_Time2 = '97' then 0.317289417204439
    when @Lead_Time2 = '98' then 0.317289417204439
    when @Lead_Time2 = '99' then 0.317289417204439
    when @Lead_Time2 = '100' then 0.317289417204439
    when @Lead_Time2 = '101' then 0.317289417204439
    when @Lead_Time2 = '102' then 0.317289417204439
    when @Lead_Time2 = '103' then 0.317289417204439
    when @Lead_Time2 = '104' then 0.317289417204439
    when @Lead_Time2 = '105' then 0.317289417204439
    when @Lead_Time2 = '106' then 0.317289417204439
    when @Lead_Time2 = '107' then 0.317289417204439
    when @Lead_Time2 = '108' then 0.317289417204439
    when @Lead_Time2 = '109' then 0.317289417204439
    when @Lead_Time2 = '110' then 0.317289417204439
    when @Lead_Time2 = '111' then 0.317289417204439
    when @Lead_Time2 = '112' then 0.317289417204439
    when @Lead_Time2 = '113' then 0.317289417204439
    when @Lead_Time2 = '114' then 0.317289417204439
    when @Lead_Time2 = '115' then 0.317289417204439
    when @Lead_Time2 = '116' then 0.317289417204439
    when @Lead_Time2 = '117' then 0.317289417204439
    when @Lead_Time2 = '118' then 0.317289417204439
    when @Lead_Time2 = '119' then 0.317289417204439
    when @Lead_Time2 = '120' then 0.317289417204439
    when @Lead_Time2 = '121' then 0.317289417204439
    when @Lead_Time2 = '122' then 0.317289417204439
    when @Lead_Time2 = '123' then 0.317289417204439
    when @Lead_Time2 = '124' then 0.317289417204439
    when @Lead_Time2 = '125' then 0.317289417204439
    when @Lead_Time2 = '126' then 0.317289417204439
    when @Lead_Time2 = '127' then 0.317289417204439
    when @Lead_Time2 = '128' then 0.317289417204439
    when @Lead_Time2 = '129' then 0.317289417204439
    when @Lead_Time2 = '130' then 0.317289417204439
    when @Lead_Time2 = '131' then 0.317289417204439
    when @Lead_Time2 = '132' then 0.317289417204439
    when @Lead_Time2 = '133' then 0.317289417204439
    when @Lead_Time2 = '134' then 0.317289417204439
    when @Lead_Time2 = '135' then 0.317289417204439
    when @Lead_Time2 = '136' then 0.317289417204439
    when @Lead_Time2 = '137' then 0.317289417204439
    when @Lead_Time2 = '138' then 0.317289417204439
    when @Lead_Time2 = '139' then 0.317289417204439
    when @Lead_Time2 = '140' then 0.317289417204439
    when @Lead_Time2 = '141' then 0.317289417204439
    when @Lead_Time2 = '142' then 0.317289417204439
    when @Lead_Time2 = '143' then 0.317289417204439
    when @Lead_Time2 = '144' then 0.317289417204439
    when @Lead_Time2 = '145' then 0.317289417204439
    when @Lead_Time2 = '146' then 0.317289417204439
    when @Lead_Time2 = '147' then 0.317289417204439
    when @Lead_Time2 = '148' then 0.317289417204439
    when @Lead_Time2 = '149' then 0.317289417204439
    when @Lead_Time2 = '150' then 0.317289417204439
    when @Lead_Time2 = '151' then 0.317289417204439
    when @Lead_Time2 = '152' then 0.317289417204439
    when @Lead_Time2 = '153' then 0.317289417204439
    when @Lead_Time2 = '154' then 0.317289417204439
    when @Lead_Time2 = '155' then 0.317289417204439
    when @Lead_Time2 = '156' then 0.317289417204439
    when @Lead_Time2 = '157' then 0.317289417204439
    when @Lead_Time2 = '158' then 0.317289417204439
    when @Lead_Time2 = '159' then 0.317289417204439
    when @Lead_Time2 = '160' then 0.317289417204439
    when @Lead_Time2 = '161' then 0.317289417204439
    when @Lead_Time2 = '162' then 0.317289417204439
    when @Lead_Time2 = '163' then 0.317289417204439
    when @Lead_Time2 = '164' then 0.317289417204439
    when @Lead_Time2 = '165' then 0.317289417204439
    when @Lead_Time2 = '166' then 0.317289417204439
    when @Lead_Time2 = '167' then 0.317289417204439
    when @Lead_Time2 = '168' then 0.317289417204439
    when @Lead_Time2 = '169' then 0.317289417204439
    when @Lead_Time2 = '170' then 0.317289417204439
    when @Lead_Time2 = '171' then 0.317289417204439
    when @Lead_Time2 = '172' then 0.317289417204439
    when @Lead_Time2 = '173' then 0.317289417204439
    when @Lead_Time2 = '174' then 0.317289417204439
    when @Lead_Time2 = '175' then 0.317289417204439
    when @Lead_Time2 = '176' then 0.317289417204439
    when @Lead_Time2 = '177' then 0.317289417204439
    when @Lead_Time2 = '178' then 0.317289417204439
    when @Lead_Time2 = '179' then 0.317289417204439
    when @Lead_Time2 = '180' then 0.317289417204439
    when @Lead_Time2 = '181' then 0.317289417204439
    when @Lead_Time2 = '188' then 0.317289417204439
    when @Lead_Time2 = '195' then 0.317289417204439
    when @Lead_Time2 = '202' then 0.317289417204439
    when @Lead_Time2 = '209' then 0.317289417204439
    when @Lead_Time2 = '216' then 0.317289417204439
    when @Lead_Time2 = '223' then 0.317289417204439
    when @Lead_Time2 = '230' then 0.317289417204439
    when @Lead_Time2 = '237' then 0.317289417204439
    when @Lead_Time2 = '244' then 0.317289417204439
    when @Lead_Time2 = '251' then 0.317289417204439
    when @Lead_Time2 = '258' then 0.317289417204439
    when @Lead_Time2 = '265' then 0.317289417204439
    when @Lead_Time2 = '272' then 0.317289417204439
    when @Lead_Time2 = '279' then 0.317289417204439
    when @Lead_Time2 = '286' then 0.317289417204439
    when @Lead_Time2 = '293' then 0.317289417204439
    when @Lead_Time2 = '300' then 0.317289417204439
    when @Lead_Time2 = '307' then 0.317289417204439
    when @Lead_Time2 = '314' then 0.317289417204439
    when @Lead_Time2 = '321' then 0.317289417204439
    when @Lead_Time2 = '328' then 0.317289417204439
    when @Lead_Time2 = '335' then 0.317289417204439
    when @Lead_Time2 = '342' then 0.317289417204439
    when @Lead_Time2 = '349' then 0.317289417204439
    when @Lead_Time2 = '356' then 0.317289417204439
    when @Lead_Time2 = '363' then 0.317289417204439
    when @Lead_Time2 = '370' then 0.317289417204439
    when @Lead_Time2 = '377' then 0.317289417204439
    when @Lead_Time2 = '384' then 0.317289417204439
    when @Lead_Time2 = '391' then 0.317289417204439
    when @Lead_Time2 = '398' then 0.317289417204439
    when @Lead_Time2 = '405' then 0.317289417204439
    when @Lead_Time2 = '412' then 0.317289417204439
    when @Lead_Time2 = '419' then 0.317289417204439
    when @Lead_Time2 = '426' then 0.317289417204439
    when @Lead_Time2 = '433' then 0.317289417204439
    when @Lead_Time2 = '440' then 0.317289417204439
    when @Lead_Time2 = '447' then 0.317289417204439
    when @Lead_Time2 = '454' then 0.317289417204439
    when @Lead_Time2 = '461' then 0.317289417204439
    when @Lead_Time2 = '468' then 0.317289417204439
    when @Lead_Time2 = '475' then 0.317289417204439
    when @Lead_Time2 = '482' then 0.317289417204439
    when @Lead_Time2 = '489' then 0.317289417204439
    when @Lead_Time2 = '496' then 0.317289417204439
    when @Lead_Time2 = '503' then 0.317289417204439
    when @Lead_Time2 = '510' then 0.317289417204439
    when @Lead_Time2 = '517' then 0.317289417204439
    when @Lead_Time2 = '524' then 0.317289417204439
    when @Lead_Time2 = '531' then 0.317289417204439
    when @Lead_Time2 = '538' then 0.317289417204439
    when @Lead_Time2 = '545' then 0.317289417204439
    when @Lead_Time2 = '552' then 0.317289417204439
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then 0.0105561122216561
    when @OldestAge2 = '12' then -0.292307282225789
    when @OldestAge2 = '13' then -0.292307282225789
    when @OldestAge2 = '14' then -0.292307282225789
    when @OldestAge2 = '15' then -0.292307282225789
    when @OldestAge2 = '16' then -0.292307282225789
    when @OldestAge2 = '17' then -0.292307282225789
    when @OldestAge2 = '18' then -0.292307282225789
    when @OldestAge2 = '19' then -0.292307282225789
    when @OldestAge2 = '20' then -0.288368726611728
    when @OldestAge2 = '21' then -0.283857172091121
    when @OldestAge2 = '22' then -0.278259060612631
    when @OldestAge2 = '23' then -0.27119133699434
    when @OldestAge2 = '24' then -0.26243773037321
    when @OldestAge2 = '25' then -0.251961382284958
    when @OldestAge2 = '26' then -0.239894695229952
    when @OldestAge2 = '27' then -0.226511040353207
    when @OldestAge2 = '28' then -0.212184476542868
    when @OldestAge2 = '29' then -0.197343482105668
    when @OldestAge2 = '30' then -0.182424257631725
    when @OldestAge2 = '31' then -0.167828665067603
    when @OldestAge2 = '32' then -0.153891137644306
    when @OldestAge2 = '33' then -0.140857425166729
    when @OldestAge2 = '34' then -0.128875786773811
    when @OldestAge2 = '35' then -0.117998976481621
    when @OldestAge2 = '36' then -0.10819395473381
    when @OldestAge2 = '37' then -0.0993562161241357
    when @OldestAge2 = '38' then -0.0913266124125806
    when @OldestAge2 = '39' then -0.083909716647268
    when @OldestAge2 = '40' then -0.0768932686776829
    when @OldestAge2 = '41' then -0.0700678579355242
    when @OldestAge2 = '42' then -0.0632452537097885
    when @OldestAge2 = '43' then -0.0562734195444294
    when @OldestAge2 = '44' then -0.0490466079142058
    when @OldestAge2 = '45' then -0.041509734191588
    when @OldestAge2 = '46' then -0.0336566975370384
    when @OldestAge2 = '47' then -0.0255221609321614
    when @OldestAge2 = '48' then -0.0171658120536691
    when @OldestAge2 = '49' then -0.00864832618517747
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00881386939764706
    when @OldestAge2 = '52' then 0.0179233156124941
    when @OldestAge2 = '53' then 0.027570323142884
    when @OldestAge2 = '54' then 0.0381032117629933
    when @OldestAge2 = '55' then 0.0499445766885146
    when @OldestAge2 = '56' then 0.0635353205573024
    when @OldestAge2 = '57' then 0.0792645589970676
    when @OldestAge2 = '58' then 0.0974002368087161
    when @OldestAge2 = '59' then 0.118036037543285
    when @OldestAge2 = '60' then 0.141065870930002
    when @OldestAge2 = '61' then 0.166189389885963
    when @OldestAge2 = '62' then 0.192943813494683
    when @OldestAge2 = '63' then 0.220751904303329
    when @OldestAge2 = '64' then 0.248974814122024
    when @OldestAge2 = '65' then 0.276961096589007
    when @OldestAge2 = '66' then 0.304087344437076
    when @OldestAge2 = '67' then 0.329789630863221
    when @OldestAge2 = '68' then 0.353587005186559
    when @OldestAge2 = '69' then 0.375098767291555
    when @OldestAge2 = '70' then 0.394056872438398
    when @OldestAge2 = '71' then 0.410314486521989
    when @OldestAge2 = '72' then 0.423851802471942
    when @OldestAge2 = '73' then 0.434780569613773
    when @OldestAge2 = '74' then 0.443348602766117
    when @OldestAge2 = '75' then 0.449944075867462
    when @OldestAge2 = '76' then 0.455096478674295
    when @OldestAge2 = '77' then 0.459467476621072
    when @OldestAge2 = '78' then 0.463822496345415
    when @OldestAge2 = '79' then 0.468975106072032
    when @OldestAge2 = '80' then 0.475702992783848
    when @OldestAge2 = '81' then 0.484645897997302
    when @OldestAge2 = '82' then 0.496208239436115
    when @OldestAge2 = '83' then 0.510495498138124
    when @OldestAge2 = '84' then 0.527308116054803
    when @OldestAge2 = '85' then 0.546199426804192
    when @OldestAge2 = '86' then 0.566581942821576
    when @OldestAge2 = '87' then 0.587849499751818
    when @OldestAge2 = '88' then 0.609478770038323
    when @OldestAge2 = '89' then 0.63108315141238
    when @OldestAge2 = '90' then 0.652409998394051
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.37996914690014
    when @Traveller_Count2 = '3' then 0.37996914690014
    when @Traveller_Count2 = '4' then 0.619270735470371
    when @Traveller_Count2 = '5' then 0.619270735470371
    when @Traveller_Count2 = '6' then 0.619270735470371
    when @Traveller_Count2 = '7' then 0.619270735470371
    when @Traveller_Count2 = '8' then 0.619270735470371
    when @Traveller_Count2 = '9' then 0.619270735470371
    when @Traveller_Count2 = '10' then 0.619270735470371
    when @Traveller_Count2 = '11' then 0.619270735470369
    when @Traveller_Count2 = '12' then 0.619270735470369
    when @Traveller_Count2 = '13' then 0.619270735470369
    when @Traveller_Count2 = '14' then 0.619270735470369
    when @Traveller_Count2 = '15' then 0.619270735470369
    when @Traveller_Count2 = '16' then 0.619270735470369
    when @Traveller_Count2 = '17' then 0.619270735470369
    when @Traveller_Count2 = '18' then 0.619270735470369
    when @Traveller_Count2 = '19' then 0.619270735470369
    when @Traveller_Count2 = '20' then 0.619270735470369
    when @Traveller_Count2 = '21' then 0.619270735470369
    when @Traveller_Count2 = '22' then 0.619270735470369
    when @Traveller_Count2 = '23' then 0.619270735470369
    when @Traveller_Count2 = '24' then 0.619270735470369
    when @Traveller_Count2 = '25' then 0.619270735470369
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then 0.151051880012916
    when @JV_Description = 'Air New Zealand' then 0
    when @JV_Description = 'Australia Post' then 0
    when @JV_Description = 'CBA White Label' then 0
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then 0
    when @JV_Description = 'Helloworld' then 0.330634787188345
    when @JV_Description = 'Indep + Others' then 0.330634787188345
    when @JV_Description = 'Insurance Australia Ltd' then 0.151051880012916
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then 0.151051880012916
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0.151051880012916
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
    when @Product_Indicator = 'International AMT' then -0.223475670224811
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then 0
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then -0.0802701782241106
    when @Departure_Month = '2' then -0.0802701782241106
    when @Departure_Month = '3' then -0.0802701782241106
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then -0.0802701782241106
    when @Departure_Month = '9' then -0.0802701782241106
    when @Departure_Month = '10' then -0.0802701782241106
    when @Departure_Month = '11' then -0.0802701782241106
    when @Departure_Month = '12' then -0.0802701782241106
end

-- Start of EMCBand2
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.121163433173295
    when @EMCBand = '1_>50%' then 0.121163433173295
    when @EMCBand = '2_<50%' then 0.121163433173295
    when @EMCBand = '2_>50%' then 0.121163433173295
    when @EMCBand = '3_<50%' then 0.121163433173295
    when @EMCBand = '3_>50%' then 0.121163433173295
    when @EMCBand = '4_<50%' then 0.121163433173295
    when @EMCBand = '4_>50%' then 0.121163433173295
    when @EMCBand = '5_<50%' then 0.121163433173295
    when @EMCBand = '5_>50%' then 0.121163433173295
    when @EMCBand = '6_<50%' then 0.121163433173295
    when @EMCBand = '6_>50%' then 0.121163433173295
    when @EMCBand = '7_<50%' then 0.121163433173295
    when @EMCBand = '7_>50%' then 0.121163433173295
    when @EMCBand = '8_<50%' then 0.121163433173295
    when @EMCBand = '8_>50%' then 0.121163433173295
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.16979298896114
    when @Gender = 'FF' then -0.0964116980564258
    when @Gender = 'FM' then 0
    when @Gender = 'M' then -0.16979298896114
    when @Gender = 'MM' then 0
    when @Gender = 'O' then 0
    when @Gender = 'U' then 0
end

-- Start of Latest_product
set @LinearPredictor = @LinearPredictor +
case
    when @Latest_product = 'FCO' then 0.0818275951483924
    when @Latest_product = 'FCT' then 0
    when @Latest_product = 'NCC' then 0.0818275951483924
    when @Latest_product = 'Y' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

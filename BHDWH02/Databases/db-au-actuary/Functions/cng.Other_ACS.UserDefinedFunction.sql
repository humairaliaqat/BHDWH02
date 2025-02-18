USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Other_ACS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Other_ACS] (
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
set @LinearPredictor = @LinearPredictor +  6.87598089595122

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then 9.99950003332973E-05
    when @Trip_Length2 = '2' then 9.99950003332973E-05
    when @Trip_Length2 = '3' then 9.99950003332973E-05
    when @Trip_Length2 = '4' then 9.99950003332973E-05
    when @Trip_Length2 = '5' then 9.99950003332973E-05
    when @Trip_Length2 = '6' then 0
    when @Trip_Length2 = '7' then -0.000100005000333236
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.000199980002666023
    when @Trip_Length2 = '10' then 0.000799680170564022
    when @Trip_Length2 = '11' then 0.0015987213636973
    when @Trip_Length2 = '12' then 0.00279608730200119
    when @Trip_Length2 = '13' then 0.00429078141715603
    when @Trip_Length2 = '14' then 0.00628023795715024
    when @Trip_Length2 = '15' then 0.00856323066048759
    when @Trip_Length2 = '16' then 0.0113355096637457
    when @Trip_Length2 = '17' then 0.0141987193998129
    when @Trip_Length2 = '18' then 0.0173486383346129
    when @Trip_Length2 = '19' then 0.0206845911928326
    when @Trip_Length2 = '20' then 0.0242046886968169
    when @Trip_Length2 = '21' then 0.0280041964095971
    when @Trip_Length2 = '22' then 0.0319830458530505
    when @Trip_Length2 = '23' then 0.0363319292473898
    when @Trip_Length2 = '24' then 0.0411419433311754
    when @Trip_Length2 = '25' then 0.0463109028632499
    when @Trip_Length2 = '26' then 0.0522128714469341
    when @Trip_Length2 = '27' then 0.0585518869496155
    when @Trip_Length2 = '28' then 0.0654131385482319
    when @Trip_Length2 = '29' then 0.0726926853934406
    when @Trip_Length2 = '30' then 0.080196541994277
    when @Trip_Length2 = '31' then 0.0879192980378836
    when @Trip_Length2 = '32' then 0.0954010847632532
    when @Trip_Length2 = '33' then 0.10246633154449
    when @Trip_Length2 = '34' then 0.109033761024122
    when @Trip_Length2 = '35' then 0.11484539166904
    when @Trip_Length2 = '36' then 0.119736681602333
    when @Trip_Length2 = '37' then 0.123809285726287
    when @Trip_Length2 = '38' then 0.126985011754488
    when @Trip_Length2 = '39' then 0.129184458380826
    when @Trip_Length2 = '40' then 0.130677323641616
    when @Trip_Length2 = '41' then 0.131466762742305
    when @Trip_Length2 = '42' then 0.131642109051716
    when @Trip_Length2 = '43' then 0.131466762742305
    when @Trip_Length2 = '44' then 0.131203685615344
    when @Trip_Length2 = '45' then 0.130765069879552
    when @Trip_Length2 = '46' then 0.130414038721933
    when @Trip_Length2 = '47' then 0.130238476923729
    when @Trip_Length2 = '48' then 0.130414038721933
    when @Trip_Length2 = '49' then 0.130940539260596
    when @Trip_Length2 = '50' then 0.131729770677895
    when @Trip_Length2 = '51' then 0.132956227248625
    when @Trip_Length2 = '52' then 0.134443476549491
    when @Trip_Length2 = '53' then 0.136103082992341
    when @Trip_Length2 = '54' then 0.137847066692125
    when @Trip_Length2 = '55' then 0.139414055782678
    when @Trip_Length2 = '56' then 0.140718006938879
    when @Trip_Length2 = '57' then 0.141586364061871
    when @Trip_Length2 = '58' then 0.14210701662483
    when @Trip_Length2 = '59' then 0.142193765703175
    when @Trip_Length2 = '60' then 0.141846724228237
    when @Trip_Length2 = '61' then 0.141325936090435
    when @Trip_Length2 = '62' then 0.140718006938879
    when @Trip_Length2 = '63' then 0.140283545447056
    when @Trip_Length2 = '64' then 0.140109707984645
    when @Trip_Length2 = '65' then 0.140457352695256
    when @Trip_Length2 = '66' then 0.141325936090435
    when @Trip_Length2 = '67' then 0.142714102199175
    when @Trip_Length2 = '68' then 0.144706220999258
    when @Trip_Length2 = '69' then 0.146953412956163
    when @Trip_Length2 = '70' then 0.149367831650824
    when @Trip_Length2 = '71' then 0.151948256272058
    when @Trip_Length2 = '72' then 0.154436353304419
    when @Trip_Length2 = '73' then 0.156747305674524
    when @Trip_Length2 = '74' then 0.158882325060191
    when @Trip_Length2 = '75' then 0.160842525116831
    when @Trip_Length2 = '76' then 0.162628923448219
    when @Trip_Length2 = '77' then 0.164412136250387
    when @Trip_Length2 = '78' then 0.166276859625099
    when @Trip_Length2 = '79' then 0.168391651260457
    when @Trip_Length2 = '80' then 0.170754920422489
    when @Trip_Length2 = '81' then 0.173617116163808
    when @Trip_Length2 = '82' then 0.176806376105844
    when @Trip_Length2 = '83' then 0.180486540848225
    when @Trip_Length2 = '84' then 0.184485879623331
    when @Trip_Length2 = '85' then 0.188634918850546
    when @Trip_Length2 = '86' then 0.192849278680609
    when @Trip_Length2 = '87' then 0.196881708125284
    when @Trip_Length2 = '88' then 0.199915865194906
    when @Trip_Length2 = '89' then 0.199915865194906
    when @Trip_Length2 = '90' then 0.199915865194906
    when @Trip_Length2 = '97' then 0.199915865194906
    when @Trip_Length2 = '104' then 0.199915865194906
    when @Trip_Length2 = '111' then 0.199915865194906
    when @Trip_Length2 = '118' then 0.199915865194906
    when @Trip_Length2 = '125' then 0.199915865194906
    when @Trip_Length2 = '132' then 0.199915865194906
    when @Trip_Length2 = '139' then 0.199915865194906
    when @Trip_Length2 = '146' then 0.199915865194906
    when @Trip_Length2 = '153' then 0.199915865194906
    when @Trip_Length2 = '160' then 0.199915865194906
    when @Trip_Length2 = '167' then 0.199915865194906
    when @Trip_Length2 = '174' then 0.199915865194906
    when @Trip_Length2 = '181' then 0.199915865194906
    when @Trip_Length2 = '188' then 0.199915865194906
    when @Trip_Length2 = '195' then 0.199915865194906
    when @Trip_Length2 = '202' then 0.199915865194906
    when @Trip_Length2 = '209' then 0.199915865194906
    when @Trip_Length2 = '216' then 0.199915865194906
    when @Trip_Length2 = '223' then 0.199915865194906
    when @Trip_Length2 = '230' then 0.199915865194906
    when @Trip_Length2 = '237' then 0.199915865194906
    when @Trip_Length2 = '244' then 0.199915865194906
    when @Trip_Length2 = '251' then 0.199915865194906
    when @Trip_Length2 = '258' then 0.199915865194906
    when @Trip_Length2 = '265' then 0.199915865194906
    when @Trip_Length2 = '272' then 0.199915865194906
    when @Trip_Length2 = '279' then 0.199915865194906
    when @Trip_Length2 = '286' then 0.199915865194906
    when @Trip_Length2 = '293' then 0.199915865194906
    when @Trip_Length2 = '300' then 0.199915865194906
    when @Trip_Length2 = '307' then 0.199915865194906
    when @Trip_Length2 = '314' then 0.199915865194906
    when @Trip_Length2 = '321' then 0.199915865194906
    when @Trip_Length2 = '328' then 0.199915865194906
    when @Trip_Length2 = '335' then 0.199915865194906
    when @Trip_Length2 = '342' then 0.199915865194906
    when @Trip_Length2 = '349' then 0.199915865194906
    when @Trip_Length2 = '356' then 0.199915865194906
    when @Trip_Length2 = '363' then 0.199915865194906
    when @Trip_Length2 = '365' then 0.199915865194906
    when @Trip_Length2 = '370' then 0.199915865194906
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then -0.109138777184627
    when @Destination3 = 'Africa-SOUTH AFRICA' then 0
    when @Destination3 = 'Asia Others' then -0.242404765821959
    when @Destination3 = 'Domestic' then -0.109138777184627
    when @Destination3 = 'East Asia' then -0.242404765821959
    when @Destination3 = 'East Asia-CHINA' then -0.242404765821959
    when @Destination3 = 'East Asia-HONG KONG' then -0.242404765821959
    when @Destination3 = 'East Asia-JAPAN' then -0.242404765821959
    when @Destination3 = 'Europe' then -0.109138777184627
    when @Destination3 = 'Europe-CROATIA' then -0.109138777184627
    when @Destination3 = 'Europe-ENGLAND' then 0
    when @Destination3 = 'Europe-FRANCE' then 0
    when @Destination3 = 'Europe-GERMANY' then 0
    when @Destination3 = 'Europe-GREECE' then -0.109138777184627
    when @Destination3 = 'Europe-ITALY' then 0
    when @Destination3 = 'Europe-NETHERLANDS' then 0
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then 0
    when @Destination3 = 'Europe-SCOTLAND' then 0
    when @Destination3 = 'Europe-SPAIN' then -0.109138777184627
    when @Destination3 = 'Europe-SWITZERLAND' then 0
    when @Destination3 = 'Europe-UNITED KINGDOM' then -0.109138777184627
    when @Destination3 = 'Mid East' then 0
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then -0.242404765821959
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then -0.109138777184627
    when @Destination3 = 'Pacific Region' then -0.109138777184627
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then -0.109138777184627
    when @Destination3 = 'Pacific Region-FIJI' then -0.109138777184627
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then -0.109138777184627
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then -0.242404765821959
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then -0.242404765821959
    when @Destination3 = 'Pacific Region-VANUATU' then -0.109138777184627
    when @Destination3 = 'SEA-INDONESIA' then 0
    when @Destination3 = 'SEA-MALAYSIA' then -0.109138777184627
    when @Destination3 = 'SEA-PHILIPPINES' then -0.109138777184627
    when @Destination3 = 'SEA-SINGAPORE' then -0.242404765821959
    when @Destination3 = 'South America' then -0.109138777184627
    when @Destination3 = 'South Asia' then -0.109138777184627
    when @Destination3 = 'South Asia-CAMBODIA' then -0.109138777184627
    when @Destination3 = 'South Asia-INDIA' then 0
    when @Destination3 = 'South Asia-NEPAL' then -0.242404765821959
    when @Destination3 = 'South Asia-SRI LANKA' then -0.242404765821959
    when @Destination3 = 'South Asia-THAILAND' then -0.109138777184627
    when @Destination3 = 'South Asia-VIETNAM' then -0.109138777184627
    when @Destination3 = 'World Others' then -0.109138777184627
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0.00250962890789098
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then -0.00610009424586439
    when @Lead_Time2 = '3' then -0.0123590645005045
    when @Lead_Time2 = '4' then -0.0199146591782453
    when @Lead_Time2 = '5' then -0.0281021810799835
    when @Lead_Time2 = '6' then -0.036939712007948
    when @Lead_Time2 = '7' then -0.0461697205547748
    when @Lead_Time2 = '8' then -0.0556413198229313
    when @Lead_Time2 = '9' then -0.0651696933456192
    when @Lead_Time2 = '10' then -0.0745985986441004
    when @Lead_Time2 = '11' then -0.083782509200784
    when @Lead_Time2 = '12' then -0.092598834907255
    when @Lead_Time2 = '13' then -0.10094699524292
    when @Lead_Time2 = '14' then -0.108751217268873
    when @Lead_Time2 = '15' then -0.115960542314471
    when @Lead_Time2 = '16' then -0.122548662400613
    when @Lead_Time2 = '17' then -0.128512693819558
    when @Lead_Time2 = '18' then -0.133871345504051
    when @Lead_Time2 = '19' then -0.138662414156709
    when @Lead_Time2 = '20' then -0.142939774740309
    when @Lead_Time2 = '21' then -0.146769896245491
    when @Lead_Time2 = '22' then -0.150228067256061
    when @Lead_Time2 = '23' then -0.153394409037841
    when @Lead_Time2 = '24' then -0.156349903445333
    when @Lead_Time2 = '25' then -0.159172572228472
    when @Lead_Time2 = '26' then -0.161934039376659
    when @Lead_Time2 = '27' then -0.164696634108658
    when @Lead_Time2 = '28' then -0.167511211809186
    when @Lead_Time2 = '29' then -0.170415780613501
    when @Lead_Time2 = '30' then -0.173434969007094
    when @Lead_Time2 = '31' then -0.176580307299482
    when @Lead_Time2 = '32' then -0.179851208782429
    when @Lead_Time2 = '33' then -0.183236446464423
    when @Lead_Time2 = '34' then -0.186715954296084
    when @Lead_Time2 = '35' then -0.190262678117019
    when @Lead_Time2 = '36' then -0.193844335535404
    when @Lead_Time2 = '37' then -0.197424895432469
    when @Lead_Time2 = '38' then -0.200965776168094
    when @Lead_Time2 = '39' then -0.204426745780839
    when @Lead_Time2 = '40' then -0.207766677869906
    when @Lead_Time2 = '41' then -0.210944261865336
    when @Lead_Time2 = '42' then -0.213918856391703
    when @Lead_Time2 = '43' then -0.216651582058075
    when @Lead_Time2 = '44' then -0.21910668360487
    when @Lead_Time2 = '45' then -0.221253127270534
    when @Lead_Time2 = '46' then -0.223066301145369
    when @Lead_Time2 = '47' then -0.224529607346462
    when @Lead_Time2 = '48' then -0.225635763568193
    when @Lead_Time2 = '49' then -0.226387627095714
    when @Lead_Time2 = '50' then -0.226798438656159
    when @Lead_Time2 = '51' then -0.226891473721174
    when @Lead_Time2 = '52' then -0.226699205215581
    when @Lead_Time2 = '53' then -0.226262126640455
    when @Lead_Time2 = '54' then -0.225627442749864
    when @Lead_Time2 = '55' then -0.22484780704545
    when @Lead_Time2 = '56' then -0.223980243451694
    when @Lead_Time2 = '57' then -0.223085259170246
    when @Lead_Time2 = '58' then -0.222226117984654
    when @Lead_Time2 = '59' then -0.221468094438562
    when @Lead_Time2 = '60' then -0.220877539340477
    when @Lead_Time2 = '61' then -0.220520561359627
    when @Lead_Time2 = '62' then -0.220461184752939
    when @Lead_Time2 = '63' then -0.220758952062474
    when @Lead_Time2 = '64' then -0.221466064800858
    when @Lead_Time2 = '65' then -0.2226242511047
    when @Lead_Time2 = '66' then -0.224261701730041
    when @Lead_Time2 = '67' then -0.226390416950315
    when @Lead_Time2 = '68' then -0.229004363963668
    when @Lead_Time2 = '69' then -0.232078769220032
    when @Lead_Time2 = '70' then -0.235570759547476
    when @Lead_Time2 = '71' then -0.239421450762589
    when @Lead_Time2 = '72' then -0.24355936938215
    when @Lead_Time2 = '73' then -0.247904946491317
    when @Lead_Time2 = '74' then -0.252375662420151
    when @Lead_Time2 = '75' then -0.256891287511458
    when @Lead_Time2 = '76' then -0.261378677887688
    when @Lead_Time2 = '77' then -0.26577554754627
    when @Lead_Time2 = '78' then -0.270032797569694
    when @Lead_Time2 = '79' then -0.274115171339599
    when @Lead_Time2 = '80' then -0.278000180503995
    when @Lead_Time2 = '81' then -0.281675530733749
    when @Lead_Time2 = '82' then -0.285135462939625
    when @Lead_Time2 = '83' then -0.288376601728576
    when @Lead_Time2 = '84' then -0.291393944627544
    when @Lead_Time2 = '85' then -0.294177693575062
    when @Lead_Time2 = '86' then -0.296711440894949
    when @Lead_Time2 = '87' then -0.298972145433947
    when @Lead_Time2 = '88' then -0.30093202462357
    when @Lead_Time2 = '89' then -0.302562278961921
    when @Lead_Time2 = '90' then -0.303838248252753
    when @Lead_Time2 = '91' then -0.304745394450283
    when @Lead_Time2 = '92' then -0.30528531204686
    when @Lead_Time2 = '93' then -0.305480897840164
    when @Lead_Time2 = '94' then -0.305379862152683
    when @Lead_Time2 = '95' then -0.305055933222408
    when @Lead_Time2 = '96' then -0.304607361072904
    when @Lead_Time2 = '97' then -0.304152682519707
    when @Lead_Time2 = '98' then -0.303823999885114
    when @Lead_Time2 = '99' then -0.303758382325397
    when @Lead_Time2 = '100' then -0.304088117283181
    when @Lead_Time2 = '101' then -0.304930697773822
    when @Lead_Time2 = '102' then -0.306379402567041
    when @Lead_Time2 = '103' then -0.308495207640203
    when @Lead_Time2 = '104' then -0.31130065938747
    when @Lead_Time2 = '105' then -0.314776137536005
    when @Lead_Time2 = '106' then -0.318858767716275
    when @Lead_Time2 = '107' then -0.323444109549403
    when @Lead_Time2 = '108' then -0.328390570268041
    when @Lead_Time2 = '109' then -0.333526381923241
    when @Lead_Time2 = '110' then -0.338658865440484
    when @Lead_Time2 = '111' then -0.343585522521055
    when @Lead_Time2 = '112' then -0.343585522521055
    when @Lead_Time2 = '113' then -0.343585522521055
    when @Lead_Time2 = '114' then -0.343585522521055
    when @Lead_Time2 = '115' then -0.343585522521055
    when @Lead_Time2 = '116' then -0.343585522521055
    when @Lead_Time2 = '117' then -0.343585522521055
    when @Lead_Time2 = '118' then -0.343585522521055
    when @Lead_Time2 = '119' then -0.343585522521055
    when @Lead_Time2 = '120' then -0.343585522521055
    when @Lead_Time2 = '121' then -0.343585522521055
    when @Lead_Time2 = '122' then -0.343585522521055
    when @Lead_Time2 = '123' then -0.343585522521055
    when @Lead_Time2 = '124' then -0.343585522521055
    when @Lead_Time2 = '125' then -0.343585522521055
    when @Lead_Time2 = '126' then -0.343585522521055
    when @Lead_Time2 = '127' then -0.343585522521055
    when @Lead_Time2 = '128' then -0.343585522521055
    when @Lead_Time2 = '129' then -0.343585522521055
    when @Lead_Time2 = '130' then -0.343585522521055
    when @Lead_Time2 = '131' then -0.343585522521055
    when @Lead_Time2 = '132' then -0.343585522521055
    when @Lead_Time2 = '133' then -0.343585522521055
    when @Lead_Time2 = '134' then -0.343585522521055
    when @Lead_Time2 = '135' then -0.343585522521055
    when @Lead_Time2 = '136' then -0.343585522521055
    when @Lead_Time2 = '137' then -0.343585522521055
    when @Lead_Time2 = '138' then -0.343585522521055
    when @Lead_Time2 = '139' then -0.343585522521055
    when @Lead_Time2 = '140' then -0.343585522521055
    when @Lead_Time2 = '141' then -0.343585522521055
    when @Lead_Time2 = '142' then -0.343585522521055
    when @Lead_Time2 = '143' then -0.343585522521055
    when @Lead_Time2 = '144' then -0.343585522521055
    when @Lead_Time2 = '145' then -0.343585522521055
    when @Lead_Time2 = '146' then -0.343585522521055
    when @Lead_Time2 = '147' then -0.343585522521055
    when @Lead_Time2 = '148' then -0.343585522521055
    when @Lead_Time2 = '149' then -0.343585522521055
    when @Lead_Time2 = '150' then -0.343585522521055
    when @Lead_Time2 = '151' then -0.343585522521055
    when @Lead_Time2 = '152' then -0.343585522521055
    when @Lead_Time2 = '153' then -0.343585522521055
    when @Lead_Time2 = '154' then -0.343585522521055
    when @Lead_Time2 = '155' then -0.343585522521055
    when @Lead_Time2 = '156' then -0.343585522521055
    when @Lead_Time2 = '157' then -0.343585522521055
    when @Lead_Time2 = '158' then -0.343585522521055
    when @Lead_Time2 = '159' then -0.343585522521055
    when @Lead_Time2 = '160' then -0.343585522521055
    when @Lead_Time2 = '161' then -0.343585522521055
    when @Lead_Time2 = '162' then -0.343585522521055
    when @Lead_Time2 = '163' then -0.343585522521055
    when @Lead_Time2 = '164' then -0.343585522521055
    when @Lead_Time2 = '165' then -0.343585522521055
    when @Lead_Time2 = '166' then -0.343585522521055
    when @Lead_Time2 = '167' then -0.343585522521055
    when @Lead_Time2 = '168' then -0.343585522521055
    when @Lead_Time2 = '169' then -0.343585522521055
    when @Lead_Time2 = '170' then -0.343585522521055
    when @Lead_Time2 = '171' then -0.343585522521055
    when @Lead_Time2 = '172' then -0.343585522521055
    when @Lead_Time2 = '173' then -0.343585522521055
    when @Lead_Time2 = '174' then -0.343585522521055
    when @Lead_Time2 = '175' then -0.343585522521055
    when @Lead_Time2 = '176' then -0.343585522521055
    when @Lead_Time2 = '177' then -0.343585522521055
    when @Lead_Time2 = '178' then -0.343585522521055
    when @Lead_Time2 = '179' then -0.343585522521055
    when @Lead_Time2 = '180' then -0.343585522521055
    when @Lead_Time2 = '181' then -0.343585522521055
    when @Lead_Time2 = '188' then -0.343585522521055
    when @Lead_Time2 = '195' then -0.343585522521055
    when @Lead_Time2 = '202' then -0.343585522521055
    when @Lead_Time2 = '209' then -0.343585522521055
    when @Lead_Time2 = '216' then -0.343585522521055
    when @Lead_Time2 = '223' then -0.343585522521055
    when @Lead_Time2 = '230' then -0.343585522521055
    when @Lead_Time2 = '237' then -0.343585522521055
    when @Lead_Time2 = '244' then -0.343585522521055
    when @Lead_Time2 = '251' then -0.343585522521055
    when @Lead_Time2 = '258' then -0.343585522521055
    when @Lead_Time2 = '265' then -0.343585522521055
    when @Lead_Time2 = '272' then -0.343585522521055
    when @Lead_Time2 = '279' then -0.343585522521055
    when @Lead_Time2 = '286' then -0.343585522521055
    when @Lead_Time2 = '293' then -0.343585522521055
    when @Lead_Time2 = '300' then -0.343585522521055
    when @Lead_Time2 = '307' then -0.343585522521055
    when @Lead_Time2 = '314' then -0.343585522521055
    when @Lead_Time2 = '321' then -0.343585522521055
    when @Lead_Time2 = '328' then -0.343585522521055
    when @Lead_Time2 = '335' then -0.343585522521055
    when @Lead_Time2 = '342' then -0.343585522521055
    when @Lead_Time2 = '349' then -0.343585522521055
    when @Lead_Time2 = '356' then -0.343585522521055
    when @Lead_Time2 = '363' then -0.343585522521055
    when @Lead_Time2 = '370' then -0.343585522521055
    when @Lead_Time2 = '377' then -0.343585522521055
    when @Lead_Time2 = '384' then -0.343585522521055
    when @Lead_Time2 = '391' then -0.343585522521055
    when @Lead_Time2 = '398' then -0.343585522521055
    when @Lead_Time2 = '405' then -0.343585522521055
    when @Lead_Time2 = '412' then -0.343585522521055
    when @Lead_Time2 = '419' then -0.343585522521055
    when @Lead_Time2 = '426' then -0.343585522521055
    when @Lead_Time2 = '433' then -0.343585522521055
    when @Lead_Time2 = '440' then -0.343585522521055
    when @Lead_Time2 = '447' then -0.343585522521055
    when @Lead_Time2 = '454' then -0.343585522521055
    when @Lead_Time2 = '461' then -0.343585522521055
    when @Lead_Time2 = '468' then -0.343585522521055
    when @Lead_Time2 = '475' then -0.343585522521055
    when @Lead_Time2 = '482' then -0.343585522521055
    when @Lead_Time2 = '489' then -0.343585522521055
    when @Lead_Time2 = '496' then -0.343585522521055
    when @Lead_Time2 = '503' then -0.343585522521055
    when @Lead_Time2 = '510' then -0.343585522521055
    when @Lead_Time2 = '517' then -0.343585522521055
    when @Lead_Time2 = '524' then -0.343585522521055
    when @Lead_Time2 = '531' then -0.343585522521055
    when @Lead_Time2 = '538' then -0.343585522521055
    when @Lead_Time2 = '545' then -0.343585522521055
    when @Lead_Time2 = '552' then -0.343585522521055
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then 0.265523869855758
    when @OldestAge2 = '12' then -0.26065895616396
    when @OldestAge2 = '13' then -0.258989196906679
    when @OldestAge2 = '14' then -0.254708662437258
    when @OldestAge2 = '15' then -0.247603817527655
    when @OldestAge2 = '16' then -0.237461216361301
    when @OldestAge2 = '17' then -0.224190633590395
    when @OldestAge2 = '18' then -0.207917547493196
    when @OldestAge2 = '19' then -0.189013830868538
    when @OldestAge2 = '20' then -0.168062278031987
    when @OldestAge2 = '21' then -0.14577561887016
    when @OldestAge2 = '22' then -0.122902367722382
    when @OldestAge2 = '23' then -0.100147619351941
    when @OldestAge2 = '24' then -0.078122796568329
    when @OldestAge2 = '25' then -0.0573237727617668
    when @OldestAge2 = '26' then -0.0381282839979251
    when @OldestAge2 = '27' then -0.020802474624901
    when @OldestAge2 = '28' then -0.00551043868318763
    when @OldestAge2 = '29' then 0.00767422374569813
    when @OldestAge2 = '30' then 0.0187526715401615
    when @OldestAge2 = '31' then 0.027778864887118
    when @OldestAge2 = '32' then 0.0348323738893236
    when @OldestAge2 = '33' then 0.0399910681197405
    when @OldestAge2 = '34' then 0.0433119085496117
    when @OldestAge2 = '35' then 0.0448281643706343
    when @OldestAge2 = '36' then 0.0445678898239415
    when @OldestAge2 = '37' then 0.0425918328329536
    when @OldestAge2 = '38' then 0.0390413301505205
    when @OldestAge2 = '39' then 0.0341806383428951
    when @OldestAge2 = '40' then 0.0284160192116899
    when @OldestAge2 = '41' then 0.0222772481711387
    when @OldestAge2 = '42' then 0.0163561798180733
    when @OldestAge2 = '43' then 0.0112101662461539
    when @OldestAge2 = '44' then 0.00725164305729283
    when @OldestAge2 = '45' then 0.00465378346126233
    when @OldestAge2 = '46' then 0.00330082023834876
    when @OldestAge2 = '47' then 0.00279924240476165
    when @OldestAge2 = '48' then 0.0025472299355753
    when @OldestAge2 = '49' then 0.00184246699140464
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then -0.00354612309072252
    when @OldestAge2 = '52' then -0.0091742942580977
    when @OldestAge2 = '53' then -0.0170453107039376
    when @OldestAge2 = '54' then -0.0271070561007738
    when @OldestAge2 = '55' then -0.0391247179327099
    when @OldestAge2 = '56' then -0.0527257083835906
    when @OldestAge2 = '57' then -0.0674495356501801
    when @OldestAge2 = '58' then -0.0827953861619921
    when @OldestAge2 = '59' then -0.0982635006958147
    when @OldestAge2 = '60' then -0.113389485135522
    when @OldestAge2 = '61' then -0.12777293377056
    when @OldestAge2 = '62' then -0.141102507705475
    when @OldestAge2 = '63' then -0.15317833573979
    when @OldestAge2 = '64' then -0.163929653097115
    when @OldestAge2 = '65' then -0.173422085972399
    when @OldestAge2 = '66' then -0.181846818480679
    when @OldestAge2 = '67' then -0.189485418991602
    when @OldestAge2 = '68' then -0.196650392397742
    when @OldestAge2 = '69' then -0.203611468209385
    when @OldestAge2 = '70' then -0.210527987926137
    when @OldestAge2 = '71' then -0.217413540104257
    when @OldestAge2 = '72' then -0.224155670740821
    when @OldestAge2 = '73' then -0.230598841711778
    when @OldestAge2 = '74' then -0.236675061187258
    when @OldestAge2 = '75' then -0.242542084244503
    when @OldestAge2 = '76' then -0.248676114820024
    when @OldestAge2 = '77' then -0.255874740507592
    when @OldestAge2 = '78' then -0.265155473273753
    when @OldestAge2 = '79' then -0.277571903650875
    when @OldestAge2 = '80' then -0.29399514962476
    when @OldestAge2 = '81' then -0.314912996323544
    when @OldestAge2 = '82' then -0.340286031569541
    when @OldestAge2 = '83' then -0.369480014737001
    when @OldestAge2 = '84' then -0.40127669366001
    when @OldestAge2 = '85' then -0.433955766559373
    when @OldestAge2 = '86' then -0.465437953158182
    when @OldestAge2 = '87' then -0.493479384927682
    when @OldestAge2 = '88' then -0.515905413992136
    when @OldestAge2 = '89' then -0.530863890598085
    when @OldestAge2 = '90' then -0.537064442376712
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then -0.121214591055231
    when @JV_Description = 'Air New Zealand' then 0
    when @JV_Description = 'Australia Post' then -0.121214591055231
    when @JV_Description = 'CBA White Label' then 0
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then 0
    when @JV_Description = 'Helloworld' then 0
    when @JV_Description = 'Indep + Others' then 0
    when @JV_Description = 'Insurance Australia Ltd' then 0
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then -0.121214591055231
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
    when @Product_Indicator = 'International AMT' then -0.2300722355525
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then 0
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then -0.178767878594657
    when @Excess = '25' then -0.156946250462727
    when @Excess = '50' then -0.135590654306348
    when @Excess = '60' then -0.127174497705818
    when @Excess = '100' then -0.0942007953988267
    when @Excess = '150' then -0.0618044838925327
    when @Excess = '200' then -0.0304248441576087
    when @Excess = '250' then 0
    when @Excess = '300' then 0.0295264395819571
    when @Excess = '500' then 0.13961700404602
    when @Excess = '1000' then 0.13961700404602
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0.0441200236295377
    when @Departure_Month = '2' then 0.0441200236295377
    when @Departure_Month = '3' then 0
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then 0
    when @Departure_Month = '9' then 0
    when @Departure_Month = '10' then 0
    when @Departure_Month = '11' then 0
    when @Departure_Month = '12' then 0
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then -0.0945971417987001
    when @EMCBand = '1_>50%' then -0.0945971417987001
    when @EMCBand = '2_<50%' then -0.0945971417987001
    when @EMCBand = '2_>50%' then -0.0945971417987001
    when @EMCBand = '3_<50%' then -0.0945971417987001
    when @EMCBand = '3_>50%' then -0.0945971417987001
    when @EMCBand = '4_<50%' then -0.0945971417987001
    when @EMCBand = '4_>50%' then -0.0945971417987001
    when @EMCBand = '5_<50%' then -0.0945971417987001
    when @EMCBand = '5_>50%' then -0.0945971417987001
    when @EMCBand = '6_<50%' then -0.0945971417987001
    when @EMCBand = '6_>50%' then -0.0945971417987001
    when @EMCBand = '7_<50%' then -0.0945971417987001
    when @EMCBand = '7_>50%' then -0.0945971417987001
    when @EMCBand = '8_<50%' then -0.0945971417987001
    when @EMCBand = '8_>50%' then -0.0945971417987001
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.186667496895705
    when @Gender = 'FF' then -0.0806472997226147
    when @Gender = 'FM' then 0
    when @Gender = 'M' then 0.0808313807487489
    when @Gender = 'MM' then 0.0280108379691075
    when @Gender = 'O' then -0.142285741208642
    when @Gender = 'U' then 0
end

-- Start of Latest_product
set @LinearPredictor = @LinearPredictor +
case
    when @Latest_product = 'FCO' then 0.0675216646940441
    when @Latest_product = 'FCT' then -0.159759458828855
    when @Latest_product = 'NCC' then -0.0807708686436541
    when @Latest_product = 'Y' then 0
end

-- Start of Return_Mth
set @LinearPredictor = @LinearPredictor +
case
    when @Return_Mth = '01JUN2017' then 0
    when @Return_Mth = '01JUL2017' then 0
    when @Return_Mth = '01AUG2017' then 0
    when @Return_Mth = '01SEP2017' then 0
    when @Return_Mth = '01OCT2017' then -0.0400021909456552
    when @Return_Mth = '01NOV2017' then -0.0400021909456552
    when @Return_Mth = '01DEC2017' then -0.0400021909456552
    when @Return_Mth = '01JAN2018' then -0.0400021909456552
    when @Return_Mth = '01FEB2018' then -0.0400021909456552
    when @Return_Mth = '01MAR2018' then -0.0400021909456552
    when @Return_Mth = '01APR2018' then -0.0400021909456552
    when @Return_Mth = '01MAY2018' then -0.0400021909456552
    when @Return_Mth = '01JUN2018' then -0.0400021909456552
    when @Return_Mth = '01JUL2018' then -0.0400021909456552
    when @Return_Mth = '01AUG2018' then -0.0400021909456552
    when @Return_Mth = '01SEP2018' then -0.0400021909456552
    when @Return_Mth = '01OCT2018' then -0.0400021909456552
    when @Return_Mth = '01NOV2018' then 0
    when @Return_Mth = '01DEC2018' then 0
    when @Return_Mth = '01JAN2019' then 0
    when @Return_Mth = '01FEB2019' then 0
    when @Return_Mth = '01MAR2019' then 0
    when @Return_Mth = '01APR2019' then 0
    when @Return_Mth = '01MAY2019' then 0
    when @Return_Mth = '01JUN2019' then 0
    when @Return_Mth = '01JUL2019' then 0
    when @Return_Mth = '01AUG2019' then 0
    when @Return_Mth = '01SEP2019' then 0
    when @Return_Mth = '01OCT2019' then 0
    when @Return_Mth = '01NOV2019' then 0
    when @Return_Mth = '01DEC2019' then 0
    when @Return_Mth = '01JAN2020' then 0
    when @Return_Mth = '01FEB2020' then 0
    when @Return_Mth = '01MAR2020' then 0
    when @Return_Mth = '01APR2020' then 0
    when @Return_Mth = '01MAY2020' then 0
    when @Return_Mth = '01JUN2020' then 0
    when @Return_Mth = '01JUL2020' then 0
    when @Return_Mth = '01AUG2020' then 0
    when @Return_Mth = '01SEP2020' then 0
    when @Return_Mth = '01OCT2020' then 0
    when @Return_Mth = '01NOV2020' then 0
    when @Return_Mth = '01DEC2020' then 0
    when @Return_Mth = '01JAN2021' then 0
    when @Return_Mth = '01FEB2021' then 0
    when @Return_Mth = '01MAR2021' then 0
    when @Return_Mth = '01APR2021' then 0
    when @Return_Mth = '01MAY2021' then 0
    when @Return_Mth = '01JUN2021' then 0
    when @Return_Mth = '01JUL2021' then 0
    when @Return_Mth = '01AUG2021' then 0
    when @Return_Mth = '01SEP2021' then 0
    when @Return_Mth = '01OCT2021' then 0
    when @Return_Mth = '01NOV2021' then 0
    when @Return_Mth = '01DEC2021' then 0
    when @Return_Mth = '01JAN2022' then 0
    when @Return_Mth = '01FEB2022' then 0
    when @Return_Mth = '01MAR2022' then 0
    when @Return_Mth = '01APR2022' then 0
    when @Return_Mth = '01MAY2022' then 0
    when @Return_Mth = '01JUN2022' then 0
    when @Return_Mth = '01JUL2022' then 0
    when @Return_Mth = '01AUG2022' then 0
    when @Return_Mth = '01SEP2022' then 0
    when @Return_Mth = '01OCT2022' then 0
    when @Return_Mth = '01NOV2022' then 0
    when @Return_Mth = '01DEC2022' then 0
    when @Return_Mth = '01JAN2023' then 0
    when @Return_Mth = '01FEB2023' then 0
    when @Return_Mth = '01MAR2023' then 0
    when @Return_Mth = '01APR2023' then 0
    when @Return_Mth = '01MAY2023' then 0
    when @Return_Mth = '01JUN2023' then 0
    when @Return_Mth = '01JUL2023' then 0
    when @Return_Mth = '01AUG2023' then 0
    when @Return_Mth = '01SEP2023' then 0
    when @Return_Mth = '01OCT2023' then 0
    when @Return_Mth = '01NOV2023' then 0
    when @Return_Mth = '01DEC2023' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

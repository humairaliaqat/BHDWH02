USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Domestic_ACS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Domestic_ACS] (
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
set @LinearPredictor = @LinearPredictor + 6.52487148154825

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.184812471094207
    when @Trip_Length2 = '2' then -0.176486227781997
    when @Trip_Length2 = '3' then -0.157167085442829
    when @Trip_Length2 = '4' then -0.129971744570985
    when @Trip_Length2 = '5' then -0.0984178636546966
    when @Trip_Length2 = '6' then -0.06534100085321
    when @Trip_Length2 = '7' then -0.0323732689724299
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.0320492411586403
    when @Trip_Length2 = '10' then 0.0643514630154183
    when @Trip_Length2 = '11' then 0.0974444376173604
    when @Trip_Length2 = '12' then 0.131601547346044
    when @Trip_Length2 = '13' then 0.166673726233866
    when @Trip_Length2 = '14' then 0.201981897747531
    when @Trip_Length2 = '15' then 0.236324897315509
    when @Trip_Length2 = '16' then 0.268187228841186
    when @Trip_Length2 = '17' then 0.296143997860245
    when @Trip_Length2 = '18' then 0.319328013469913
    when @Trip_Length2 = '19' then 0.337748106807902
    when @Trip_Length2 = '20' then 0.352280629139941
    when @Trip_Length2 = '21' then 0.364285892990294
    when @Trip_Length2 = '22' then 0.374980637518945
    when @Trip_Length2 = '23' then 0.384850457287485
    when @Trip_Length2 = '24' then 0.393414392515408
    when @Trip_Length2 = '25' then 0.399510866264725
    when @Trip_Length2 = '26' then 0.402039216619662
    when @Trip_Length2 = '27' then 0.400906325815366
    when @Trip_Length2 = '28' then 0.397841212771458
    when @Trip_Length2 = '29' then 0.396680863671647
    when @Trip_Length2 = '30' then 0.402685067058717
    when @Trip_Length2 = '31' then 0.402685067058717
    when @Trip_Length2 = '32' then 0.402685067058717
    when @Trip_Length2 = '33' then 0.402685067058717
    when @Trip_Length2 = '34' then 0.402685067058717
    when @Trip_Length2 = '35' then 0.402685067058717
    when @Trip_Length2 = '36' then 0.402685067058717
    when @Trip_Length2 = '37' then 0.402685067058717
    when @Trip_Length2 = '38' then 0.402685067058717
    when @Trip_Length2 = '39' then 0.402685067058717
    when @Trip_Length2 = '40' then 0.402685067058717
    when @Trip_Length2 = '41' then 0.402685067058717
    when @Trip_Length2 = '42' then 0.402685067058717
    when @Trip_Length2 = '43' then 0.402685067058717
    when @Trip_Length2 = '44' then 0.402685067058717
    when @Trip_Length2 = '45' then 0.402685067058717
    when @Trip_Length2 = '46' then 0.402685067058717
    when @Trip_Length2 = '47' then 0.402685067058717
    when @Trip_Length2 = '48' then 0.402685067058717
    when @Trip_Length2 = '49' then 0.402685067058717
    when @Trip_Length2 = '50' then 0.402685067058717
    when @Trip_Length2 = '51' then 0.402685067058717
    when @Trip_Length2 = '52' then 0.402685067058717
    when @Trip_Length2 = '53' then 0.402685067058717
    when @Trip_Length2 = '54' then 0.402685067058717
    when @Trip_Length2 = '55' then 0.402685067058717
    when @Trip_Length2 = '56' then 0.402685067058717
    when @Trip_Length2 = '57' then 0.402685067058717
    when @Trip_Length2 = '58' then 0.402685067058717
    when @Trip_Length2 = '59' then 0.402685067058717
    when @Trip_Length2 = '60' then 0.402685067058717
    when @Trip_Length2 = '61' then 0.402685067058717
    when @Trip_Length2 = '62' then 0.402685067058717
    when @Trip_Length2 = '63' then 0.402685067058717
    when @Trip_Length2 = '64' then 0.402685067058717
    when @Trip_Length2 = '65' then 0.402685067058717
    when @Trip_Length2 = '66' then 0.402685067058717
    when @Trip_Length2 = '67' then 0.402685067058717
    when @Trip_Length2 = '68' then 0.402685067058717
    when @Trip_Length2 = '69' then 0.402685067058717
    when @Trip_Length2 = '70' then 0.402685067058717
    when @Trip_Length2 = '71' then 0.402685067058717
    when @Trip_Length2 = '72' then 0.402685067058717
    when @Trip_Length2 = '73' then 0.402685067058717
    when @Trip_Length2 = '74' then 0.402685067058717
    when @Trip_Length2 = '75' then 0.402685067058717
    when @Trip_Length2 = '76' then 0.402685067058717
    when @Trip_Length2 = '77' then 0.402685067058717
    when @Trip_Length2 = '78' then 0.402685067058717
    when @Trip_Length2 = '79' then 0.402685067058717
    when @Trip_Length2 = '80' then 0.402685067058717
    when @Trip_Length2 = '81' then 0.402685067058717
    when @Trip_Length2 = '82' then 0.402685067058717
    when @Trip_Length2 = '83' then 0.402685067058717
    when @Trip_Length2 = '84' then 0.402685067058717
    when @Trip_Length2 = '85' then 0.402685067058717
    when @Trip_Length2 = '86' then 0.402685067058717
    when @Trip_Length2 = '87' then 0.402685067058717
    when @Trip_Length2 = '88' then 0.402685067058717
    when @Trip_Length2 = '89' then 0.402685067058717
    when @Trip_Length2 = '90' then 0.402685067058717
    when @Trip_Length2 = '97' then 0.402685067058717
    when @Trip_Length2 = '104' then 0.402685067058717
    when @Trip_Length2 = '111' then 0.402685067058717
    when @Trip_Length2 = '118' then 0.402685067058717
    when @Trip_Length2 = '125' then 0.402685067058717
    when @Trip_Length2 = '132' then 0.402685067058717
    when @Trip_Length2 = '139' then 0.402685067058717
    when @Trip_Length2 = '146' then 0.402685067058717
    when @Trip_Length2 = '153' then 0.402685067058717
    when @Trip_Length2 = '160' then 0.402685067058717
    when @Trip_Length2 = '167' then 0.402685067058717
    when @Trip_Length2 = '174' then 0.402685067058717
    when @Trip_Length2 = '181' then 0.402685067058717
    when @Trip_Length2 = '188' then 0.402685067058717
    when @Trip_Length2 = '195' then 0.402685067058717
    when @Trip_Length2 = '202' then 0.402685067058717
    when @Trip_Length2 = '209' then 0.402685067058717
    when @Trip_Length2 = '216' then 0.402685067058717
    when @Trip_Length2 = '223' then 0.402685067058717
    when @Trip_Length2 = '230' then 0.402685067058717
    when @Trip_Length2 = '237' then 0.402685067058717
    when @Trip_Length2 = '244' then 0.402685067058717
    when @Trip_Length2 = '251' then 0.402685067058717
    when @Trip_Length2 = '258' then 0.402685067058717
    when @Trip_Length2 = '265' then 0.402685067058717
    when @Trip_Length2 = '272' then 0.402685067058717
    when @Trip_Length2 = '279' then 0.402685067058717
    when @Trip_Length2 = '286' then 0.402685067058717
    when @Trip_Length2 = '293' then 0.402685067058717
    when @Trip_Length2 = '300' then 0.402685067058717
    when @Trip_Length2 = '307' then 0.402685067058717
    when @Trip_Length2 = '314' then 0.402685067058717
    when @Trip_Length2 = '321' then 0.402685067058717
    when @Trip_Length2 = '328' then 0.402685067058717
    when @Trip_Length2 = '335' then 0.402685067058717
    when @Trip_Length2 = '342' then 0.402685067058717
    when @Trip_Length2 = '349' then 0.402685067058717
    when @Trip_Length2 = '356' then 0.402685067058717
    when @Trip_Length2 = '363' then 0.402685067058717
    when @Trip_Length2 = '365' then 0.402685067058717
    when @Trip_Length2 = '370' then 0.402685067058717
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then -0.00344604420760769
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then 0.00336543183687619
    when @Lead_Time2 = '3' then 0.00682200652512685
    when @Lead_Time2 = '4' then 0.0106457986181337
    when @Lead_Time2 = '5' then 0.0126812116536942
    when @Lead_Time2 = '6' then 0.0166081256323157
    when @Lead_Time2 = '7' then 0.0207063666982367
    when @Lead_Time2 = '8' then 0.0250031966896688
    when @Lead_Time2 = '9' then 0.0295098877312637
    when @Lead_Time2 = '10' then 0.0342123327761898
    when @Lead_Time2 = '11' then 0.039288329725383
    when @Lead_Time2 = '12' then 0.0445837261259313
    when @Lead_Time2 = '13' then 0.050097762713155
    when @Lead_Time2 = '14' then 0.0558259955044499
    when @Lead_Time2 = '15' then 0.0617616503410066
    when @Lead_Time2 = '16' then 0.0678978036906965
    when @Lead_Time2 = '17' then 0.0742103253750236
    when @Lead_Time2 = '18' then 0.080687453822165
    when @Lead_Time2 = '19' then 0.0873160781936795
    when @Lead_Time2 = '20' then 0.0940820403156497
    when @Lead_Time2 = '21' then 0.100970331482196
    when @Lead_Time2 = '22' then 0.107965104579981
    when @Lead_Time2 = '23' then 0.115051198691858
    when @Lead_Time2 = '24' then 0.122213044404699
    when @Lead_Time2 = '25' then 0.129434801559281
    when @Lead_Time2 = '26' then 0.1367004786144
    when @Lead_Time2 = '27' then 0.143994042047832
    when @Lead_Time2 = '28' then 0.151299538185611
    when @Lead_Time2 = '29' then 0.158601085040142
    when @Lead_Time2 = '30' then 0.16588297592451
    when @Lead_Time2 = '31' then 0.173129779278845
    when @Lead_Time2 = '32' then 0.180326433262689
    when @Lead_Time2 = '33' then 0.187458342286426
    when @Lead_Time2 = '34' then 0.194511470899894
    when @Lead_Time2 = '35' then 0.201472438370971
    when @Lead_Time2 = '36' then 0.208328617938806
    when @Lead_Time2 = '37' then 0.21506822218498
    when @Lead_Time2 = '38' then 0.22168038374595
    when @Lead_Time2 = '39' then 0.228155235726547
    when @Lead_Time2 = '40' then 0.234483967422859
    when @Lead_Time2 = '41' then 0.240658884629251
    when @Lead_Time2 = '42' then 0.246673445169705
    when @Lead_Time2 = '43' then 0.252522287736769
    when @Lead_Time2 = '44' then 0.25820123972623
    when @Lead_Time2 = '45' then 0.263707315239949
    when @Lead_Time2 = '46' then 0.269038692605214
    when @Lead_Time2 = '47' then 0.27419468012441
    when @Lead_Time2 = '48' then 0.279175659372547
    when @Lead_Time2 = '49' then 0.283983017980836
    when @Lead_Time2 = '50' then 0.288619067990256
    when @Lead_Time2 = '51' then 0.293086946600049
    when @Lead_Time2 = '52' then 0.297390507155009
    when @Lead_Time2 = '53' then 0.30153419895043
    when @Lead_Time2 = '54' then 0.305522939200375
    when @Lead_Time2 = '55' then 0.309361979005114
    when @Lead_Time2 = '56' then 0.313056761690564
    when @Lead_Time2 = '57' then 0.316612788130291
    when @Lead_Time2 = '58' then 0.320035474339557
    when @Lead_Time2 = '59' then 0.323330019917548
    when @Lead_Time2 = '60' then 0.326501282061686
    when @Lead_Time2 = '61' then 0.32955366006364
    when @Lead_Time2 = '62' then 0.332490991138421
    when @Lead_Time2 = '63' then 0.335316461780522
    when @Lead_Time2 = '64' then 0.338032540114732
    when @Lead_Time2 = '65' then 0.340640918170502
    when @Lead_Time2 = '66' then 0.34314248745625
    when @Lead_Time2 = '67' then 0.345537321605113
    when @Lead_Time2 = '68' then 0.347824690785135
    when @Lead_Time2 = '69' then 0.350003094279063
    when @Lead_Time2 = '70' then 0.352070310310328
    when @Lead_Time2 = '71' then 0.354023472644491
    when @Lead_Time2 = '72' then 0.355859157441824
    when @Lead_Time2 = '73' then 0.357573492647954
    when @Lead_Time2 = '74' then 0.359162276224572
    when @Lead_Time2 = '75' then 0.360621110442013
    when @Lead_Time2 = '76' then 0.361945540088407
    when @Lead_Time2 = '77' then 0.36313119876293
    when @Lead_Time2 = '78' then 0.364173955855963
    when @Lead_Time2 = '79' then 0.365070066587076
    when @Lead_Time2 = '80' then 0.365816311435533
    when @Lead_Time2 = '81' then 0.366410139015158
    when @Lead_Time2 = '82' then 0.366849787863242
    when @Lead_Time2 = '83' then 0.367134408887062
    when @Lead_Time2 = '84' then 0.367264167107811
    when @Lead_Time2 = '85' then 0.367264167107811
    when @Lead_Time2 = '86' then 0.367264167107811
    when @Lead_Time2 = '87' then 0.367264167107811
    when @Lead_Time2 = '88' then 0.367264167107811
    when @Lead_Time2 = '89' then 0.367264167107811
    when @Lead_Time2 = '90' then 0.367264167107811
    when @Lead_Time2 = '91' then 0.367264167107811
    when @Lead_Time2 = '92' then 0.367264167107811
    when @Lead_Time2 = '93' then 0.367264167107811
    when @Lead_Time2 = '94' then 0.367264167107811
    when @Lead_Time2 = '95' then 0.367264167107811
    when @Lead_Time2 = '96' then 0.367264167107811
    when @Lead_Time2 = '97' then 0.367264167107811
    when @Lead_Time2 = '98' then 0.367264167107811
    when @Lead_Time2 = '99' then 0.367264167107811
    when @Lead_Time2 = '100' then 0.367264167107811
    when @Lead_Time2 = '101' then 0.367264167107811
    when @Lead_Time2 = '102' then 0.367264167107811
    when @Lead_Time2 = '103' then 0.367264167107811
    when @Lead_Time2 = '104' then 0.367264167107811
    when @Lead_Time2 = '105' then 0.367264167107811
    when @Lead_Time2 = '106' then 0.367264167107811
    when @Lead_Time2 = '107' then 0.367264167107811
    when @Lead_Time2 = '108' then 0.367264167107811
    when @Lead_Time2 = '109' then 0.367264167107811
    when @Lead_Time2 = '110' then 0.367264167107811
    when @Lead_Time2 = '111' then 0.367264167107811
    when @Lead_Time2 = '112' then 0.367264167107811
    when @Lead_Time2 = '113' then 0.367264167107811
    when @Lead_Time2 = '114' then 0.367264167107811
    when @Lead_Time2 = '115' then 0.367264167107811
    when @Lead_Time2 = '116' then 0.367264167107811
    when @Lead_Time2 = '117' then 0.367264167107811
    when @Lead_Time2 = '118' then 0.367264167107811
    when @Lead_Time2 = '119' then 0.367264167107811
    when @Lead_Time2 = '120' then 0.367264167107811
    when @Lead_Time2 = '121' then 0.367264167107811
    when @Lead_Time2 = '122' then 0.367264167107811
    when @Lead_Time2 = '123' then 0.367264167107811
    when @Lead_Time2 = '124' then 0.367264167107811
    when @Lead_Time2 = '125' then 0.367264167107811
    when @Lead_Time2 = '126' then 0.367264167107811
    when @Lead_Time2 = '127' then 0.367264167107811
    when @Lead_Time2 = '128' then 0.367264167107811
    when @Lead_Time2 = '129' then 0.367264167107811
    when @Lead_Time2 = '130' then 0.367264167107811
    when @Lead_Time2 = '131' then 0.367264167107811
    when @Lead_Time2 = '132' then 0.367264167107811
    when @Lead_Time2 = '133' then 0.367264167107811
    when @Lead_Time2 = '134' then 0.364989739221291
    when @Lead_Time2 = '135' then 0.366436042623072
    when @Lead_Time2 = '136' then 0.367821982289934
    when @Lead_Time2 = '137' then 0.369140414776547
    when @Lead_Time2 = '138' then 0.370385889472763
    when @Lead_Time2 = '139' then 0.371554772963618
    when @Lead_Time2 = '140' then 0.372645356899952
    when @Lead_Time2 = '141' then 0.373657935276018
    when @Lead_Time2 = '142' then 0.374594862443734
    when @Lead_Time2 = '143' then 0.375460574280833
    when @Lead_Time2 = '144' then 0.376261584095543
    when @Lead_Time2 = '145' then 0.37700644358809
    when @Lead_Time2 = '146' then 0.377705669839506
    when @Lead_Time2 = '147' then 0.378371640377421
    when @Lead_Time2 = '148' then 0.379018449974907
    when @Lead_Time2 = '149' then 0.379661736092223
    when @Lead_Time2 = '150' then 0.380318465252376
    when @Lead_Time2 = '151' then 0.381006696152983
    when @Lead_Time2 = '152' then 0.381745303753015
    when @Lead_Time2 = '153' then 0.382553684261132
    when @Lead_Time2 = '154' then 0.383451433345756
    when @Lead_Time2 = '155' then 0.384458013616171
    when @Lead_Time2 = '156' then 0.385592405010438
    when @Lead_Time2 = '157' then 0.386872754824625
    when @Lead_Time2 = '158' then 0.388316031784231
    when @Lead_Time2 = '159' then 0.389937689468023
    when @Lead_Time2 = '160' then 0.391751348977593
    when @Lead_Time2 = '161' then 0.393768510153989
    when @Lead_Time2 = '162' then 0.395998296174774
    when @Lead_Time2 = '163' then 0.398447238674582
    when @Lead_Time2 = '164' then 0.401119111413842
    when @Lead_Time2 = '165' then 0.404014815046714
    when @Lead_Time2 = '166' then 0.407132318703045
    when @Lead_Time2 = '167' then 0.410466655411617
    when @Lead_Time2 = '168' then 0.414009980713144
    when @Lead_Time2 = '169' then 0.417751679746016
    when @Lead_Time2 = '170' then 0.421678535249733
    when @Lead_Time2 = '171' then 0.425774938372956
    when @Lead_Time2 = '172' then 0.43002314357905
    when @Lead_Time2 = '173' then 0.434403562600496
    when @Lead_Time2 = '174' then 0.438895081035541
    when @Lead_Time2 = '175' then 0.443475400157598
    when @Lead_Time2 = '176' then 0.448121388185784
    when @Lead_Time2 = '177' then 0.452809433721169
    when @Lead_Time2 = '178' then 0.45751579758687
    when @Lead_Time2 = '179' then 0.462216950510848
    when @Lead_Time2 = '180' then 0.466889893698477
    when @Lead_Time2 = '181' then 0.471512453526929
    when @Lead_Time2 = '188' then 0.476063549799372
    when @Lead_Time2 = '195' then 0.48052342705534
    when @Lead_Time2 = '202' then 0.484873852768927
    when @Lead_Time2 = '209' then 0.489098277795395
    when @Lead_Time2 = '216' then 0.493181959767975
    when @Lead_Time2 = '223' then 0.497112047305166
    when @Lead_Time2 = '230' then 0.500877620624602
    when @Lead_Time2 = '237' then 0.50446970257512
    when @Lead_Time2 = '244' then 0.507881237858853
    when @Lead_Time2 = '251' then 0.51110704803759
    when @Lead_Time2 = '258' then 0.514143759487682
    when @Lead_Time2 = '265' then 0.516989613458843
    when @Lead_Time2 = '272' then 0.51964439295001
    when @Lead_Time2 = '279' then 0.52210932484914
    when @Lead_Time2 = '286' then 0.524386971259495
    when @Lead_Time2 = '293' then 0.526481104340117
    when @Lead_Time2 = '300' then 0.528395442265607
    when @Lead_Time2 = '307' then 0.530135022462505
    when @Lead_Time2 = '314' then 0.531706003618416
    when @Lead_Time2 = '321' then 0.533115470955276
    when @Lead_Time2 = '328' then 0.534371237323906
    when @Lead_Time2 = '335' then 0.535468662714659
    when @Lead_Time2 = '342' then 0.536420687906398
    when @Lead_Time2 = '349' then 0.537239868645001
    when @Lead_Time2 = '356' then 0.537938222537114
    when @Lead_Time2 = '363' then 0.538527049455291
    when @Lead_Time2 = '370' then 0.538867709477263
    when @Lead_Time2 = '377' then 0.539165833566337
    when @Lead_Time2 = '384' then 0.539423346721292
    when @Lead_Time2 = '391' then 0.539641456838807
    when @Lead_Time2 = '398' then 0.539820153513004
    when @Lead_Time2 = '405' then 0.539820153513004
    when @Lead_Time2 = '412' then 0.539820153513004
    when @Lead_Time2 = '419' then 0.539820153513004
    when @Lead_Time2 = '426' then 0.539820153513004
    when @Lead_Time2 = '433' then 0.539820153513004
    when @Lead_Time2 = '440' then 0.539820153513004
    when @Lead_Time2 = '447' then 0.539820153513004
    when @Lead_Time2 = '454' then 0.539820153513004
    when @Lead_Time2 = '461' then 0.539820153513004
    when @Lead_Time2 = '468' then 0.539820153513004
    when @Lead_Time2 = '475' then 0.539820153513004
    when @Lead_Time2 = '482' then 0.539820153513004
    when @Lead_Time2 = '489' then 0.539820153513004
    when @Lead_Time2 = '496' then 0.539820153513004
    when @Lead_Time2 = '503' then 0.539820153513004
    when @Lead_Time2 = '510' then 0.539820153513004
    when @Lead_Time2 = '517' then 0.539820153513004
    when @Lead_Time2 = '524' then 0.539820153513004
    when @Lead_Time2 = '531' then 0.539820153513004
    when @Lead_Time2 = '538' then 0.539820153513004
    when @Lead_Time2 = '545' then 0.539820153513004
    when @Lead_Time2 = '552' then 0.539820153513004
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then 0
    when @OldestAge2 = '12' then -0.271283926642145
    when @OldestAge2 = '13' then -0.271283926642145
    when @OldestAge2 = '14' then -0.271283926642145
    when @OldestAge2 = '15' then -0.271283926642145
    when @OldestAge2 = '16' then -0.271283926642145
    when @OldestAge2 = '17' then -0.258900271026329
    when @OldestAge2 = '18' then -0.246668096361167
    when @OldestAge2 = '19' then -0.234330896954786
    when @OldestAge2 = '20' then -0.222019183652501
    when @OldestAge2 = '21' then -0.209610537031626
    when @OldestAge2 = '22' then -0.197353979627916
    when @OldestAge2 = '23' then -0.185005154423156
    when @OldestAge2 = '24' then -0.172688107825716
    when @OldestAge2 = '25' then -0.160286129933342
    when @OldestAge2 = '26' then -0.147920130076622
    when @OldestAge2 = '27' then -0.135590654306348
    when @OldestAge2 = '28' then -0.123298216344494
    when @OldestAge2 = '29' then -0.110931560707281
    when @OldestAge2 = '30' then -0.0986056037541223
    when @OldestAge2 = '31' then -0.0863207064665268
    when @OldestAge2 = '32' then -0.0739695202001744
    when @OldestAge2 = '33' then -0.0616626603921064
    when @OldestAge2 = '34' then -0.0492952917248779
    when @OldestAge2 = '35' then -0.0369752361248957
    when @OldestAge2 = '36' then -0.0247026126403718
    when @OldestAge2 = '37' then -0.0123762710680557
    when @OldestAge2 = '38' then 0
    when @OldestAge2 = '39' then 0
    when @OldestAge2 = '40' then 0
    when @OldestAge2 = '41' then 0
    when @OldestAge2 = '42' then 0
    when @OldestAge2 = '43' then 0
    when @OldestAge2 = '44' then 0
    when @OldestAge2 = '45' then 0
    when @OldestAge2 = '46' then 0
    when @OldestAge2 = '47' then 0
    when @OldestAge2 = '48' then 0
    when @OldestAge2 = '49' then 0
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0
    when @OldestAge2 = '52' then 0
    when @OldestAge2 = '53' then 0
    when @OldestAge2 = '54' then 0
    when @OldestAge2 = '55' then 0
    when @OldestAge2 = '56' then 0
    when @OldestAge2 = '57' then 0
    when @OldestAge2 = '58' then 0
    when @OldestAge2 = '59' then 0
    when @OldestAge2 = '60' then 0
    when @OldestAge2 = '61' then 0
    when @OldestAge2 = '62' then 0
    when @OldestAge2 = '63' then 0
    when @OldestAge2 = '64' then 0
    when @OldestAge2 = '65' then 0.0435383020144834
    when @OldestAge2 = '66' then 0.085718875402537
    when @OldestAge2 = '67' then 0.126896933188351
    when @OldestAge2 = '68' then 0.167377109408132
    when @OldestAge2 = '69' then 0.207095466892603
    when @OldestAge2 = '70' then 0.245843936834985
    when @OldestAge2 = '71' then 0.282996110461067
    when @OldestAge2 = '72' then 0.318017272247854
    when @OldestAge2 = '73' then 0.350093332573178
    when @OldestAge2 = '74' then 0.378573412639848
    when @OldestAge2 = '75' then 0.403329495977743
    when @OldestAge2 = '76' then 0.424352283826646
    when @OldestAge2 = '77' then 0.441925605110939
    when @OldestAge2 = '78' then 0.456728402045706
    when @OldestAge2 = '79' then 0.469128246209782
    when @OldestAge2 = '80' then 0.479582604026059
    when @OldestAge2 = '81' then 0.488334585930459
    when @OldestAge2 = '82' then 0.495366748703445
    when @OldestAge2 = '83' then 0.500775287912489
    when @OldestAge2 = '84' then 0.504767309182027
    when @OldestAge2 = '85' then 0.507660620422835
    when @OldestAge2 = '86' then 0.509825123432408
    when @OldestAge2 = '87' then 0.511625303936555
    when @OldestAge2 = '88' then 0.513122982814674
    when @OldestAge2 = '89' then 0.51419992440494
    when @OldestAge2 = '90' then 0.514678193081481
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then -0.320674103287391
    when @JV_Description = 'Air New Zealand' then 0
    when @JV_Description = 'Australia Post' then -0.320674103287391
    when @JV_Description = 'CBA White Label' then 0
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then 0.179925773750485
    when @JV_Description = 'Helloworld' then 0
    when @JV_Description = 'Indep + Others' then 0.179925773750485
    when @JV_Description = 'Insurance Australia Ltd' then 0
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then -0.320674103287391
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0
    when @JV_Description = 'Virgin' then -0.320674103287391
    when @JV_Description = 'Websales' then -0.320674103287391
    when @JV_Description = 'YouGo' then 0
end

-- Start of Product_Indicator
set @LinearPredictor = @LinearPredictor +
case
    when @Product_Indicator = 'Car Hire' then 0
    when @Product_Indicator = 'Corporate' then 0
    when @Product_Indicator = 'Domestic AMT' then -0.330506171729412
    when @Product_Indicator = 'Domestic Cancellation' then 0
    when @Product_Indicator = 'Domestic Inbound' then -0.876881901592157
    when @Product_Indicator = 'Domestic Single Trip' then 0
    when @Product_Indicator = 'Domestic Single Trip Integrated' then 0
    when @Product_Indicator = 'International AMT' then 0
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then 0
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.182393967501099
    when @EMCBand = '1_>50%' then 0.182393967501099
    when @EMCBand = '2_<50%' then 0.182393967501099
    when @EMCBand = '2_>50%' then 0.182393967501099
    when @EMCBand = '3_<50%' then 0.182393967501099
    when @EMCBand = '3_>50%' then 0.182393967501099
    when @EMCBand = '4_<50%' then 0.545790469498963
    when @EMCBand = '4_>50%' then 0.545790469498963
    when @EMCBand = '5_<50%' then 0.545790469498963
    when @EMCBand = '5_>50%' then 0.545790469498963
    when @EMCBand = '6_<50%' then 0.545790469498963
    when @EMCBand = '6_>50%' then 0.545790469498963
    when @EMCBand = '7_<50%' then 0.545790469498963
    when @EMCBand = '7_>50%' then 0.545790469498963
    when @EMCBand = '8_<50%' then 0.545790469498963
    when @EMCBand = '8_>50%' then 0.545790469498963
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then 0.553942582839396
    when @Excess = '25' then 0
    when @Excess = '50' then 0.259976801359559
    when @Excess = '60' then 0.38641819518793
    when @Excess = '100' then 0.775095763207113
    when @Excess = '150' then 0.775095763207113
    when @Excess = '200' then 0.775095763207113
    when @Excess = '250' then 0.775095763207113
    when @Excess = '300' then 0.775095763207113
    when @Excess = '500' then 0.775095763207113
    when @Excess = '1000' then 0.775095763207113
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.147055060214403
    when @Gender = 'FF' then -0.147055060214403
    when @Gender = 'FM' then 0
    when @Gender = 'M' then -0.147055060214403
    when @Gender = 'MM' then 0
    when @Gender = 'O' then -0.147055060214403
    when @Gender = 'U' then -0.147055060214403
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0
    when @Departure_Month = '2' then 0
    when @Departure_Month = '3' then -0.211209421108228
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then 0
    when @Departure_Month = '9' then 0
    when @Departure_Month = '10' then 0
    when @Departure_Month = '11' then 0
    when @Departure_Month = '12' then -0.211209421108228
end

-- Start of Return_Mth
set @LinearPredictor = @LinearPredictor +
case
    when @Return_Mth = '01JUN2017' then 0
    when @Return_Mth = '01JUL2017' then 0
    when @Return_Mth = '01AUG2017' then 0
    when @Return_Mth = '01SEP2017' then 0
    when @Return_Mth = '01OCT2017' then 0
    when @Return_Mth = '01NOV2017' then 0
    when @Return_Mth = '01DEC2017' then 0
    when @Return_Mth = '01JAN2018' then 0
    when @Return_Mth = '01FEB2018' then 0
    when @Return_Mth = '01MAR2018' then 0.107064167189425
    when @Return_Mth = '01APR2018' then 0.107064167189425
    when @Return_Mth = '01MAY2018' then 0.107064167189425
    when @Return_Mth = '01JUN2018' then 0.107064167189425
    when @Return_Mth = '01JUL2018' then 0.107064167189425
    when @Return_Mth = '01AUG2018' then 0.107064167189425
    when @Return_Mth = '01SEP2018' then 0.107064167189425
    when @Return_Mth = '01OCT2018' then 0.107064167189425
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

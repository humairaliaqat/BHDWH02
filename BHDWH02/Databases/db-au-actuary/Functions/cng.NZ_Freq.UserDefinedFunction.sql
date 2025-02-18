USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[NZ_Freq]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[NZ_Freq] (
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
,@AirNZ_Integrated nvarchar(30)
)

returns float
as
begin
declare @LinearPredictor float
declare @PredictedValue float

set @LinearPredictor = 0

-- Adding the base value
set @LinearPredictor = @LinearPredictor + -4.04639551169211

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.795200377232367
    when @Trip_Length2 = '2' then -0.76874843832924
    when @Trip_Length2 = '3' then -0.596198799056143
    when @Trip_Length2 = '4' then -0.330647346038312
    when @Trip_Length2 = '5' then -0.160339924394385
    when @Trip_Length2 = '6' then -0.110336738070868
    when @Trip_Length2 = '7' then -0.0564273450000394
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.0571318174131772
    when @Trip_Length2 = '10' then 0.113780241652739
    when @Trip_Length2 = '11' then 0.168995757582994
    when @Trip_Length2 = '12' then 0.222165287340052
    when @Trip_Length2 = '13' then 0.272916066275136
    when @Trip_Length2 = '14' then 0.321082162438821
    when @Trip_Length2 = '15' then 0.366646180892489
    when @Trip_Length2 = '16' then 0.409701047074657
    when @Trip_Length2 = '17' then 0.450414377050275
    when @Trip_Length2 = '18' then 0.488992617526113
    when @Trip_Length2 = '19' then 0.525661075454336
    when @Trip_Length2 = '20' then 0.560642059531749
    when @Trip_Length2 = '21' then 0.59414597627314
    when @Trip_Length2 = '22' then 0.626360602654652
    when @Trip_Length2 = '23' then 0.657451143096234
    when @Trip_Length2 = '24' then 0.687561632798033
    when @Trip_Length2 = '25' then 0.71681882158619
    when @Trip_Length2 = '26' then 0.74533491394465
    when @Trip_Length2 = '27' then 0.773211150252688
    when @Trip_Length2 = '28' then 0.800537385017267
    when @Trip_Length2 = '29' then 0.827390892338539
    when @Trip_Length2 = '30' then 0.853830508399334
    when @Trip_Length2 = '31' then 0.879892487679055
    when @Trip_Length2 = '32' then 0.905588205412711
    when @Trip_Length2 = '33' then 0.930903046744636
    when @Trip_Length2 = '34' then 0.955798845898397
    when @Trip_Length2 = '35' then 0.980225316072889
    when @Trip_Length2 = '36' then 1.00412849358106
    when @Trip_Length2 = '37' then 1.02746614313855
    when @Trip_Length2 = '38' then 1.05022070119485
    when @Trip_Length2 = '39' then 1.07240755983458
    when @Trip_Length2 = '40' then 1.09408102216342
    when @Trip_Length2 = '41' then 1.11532769909728
    when @Trip_Length2 = '42' then 1.13625735642526
    when @Trip_Length2 = '43' then 1.15698135717513
    when @Trip_Length2 = '44' then 1.17759036770364
    when @Trip_Length2 = '45' then 1.19812664948179
    when @Trip_Length2 = '46' then 1.21856031274176
    when @Trip_Length2 = '47' then 1.23877332651384
    when @Trip_Length2 = '48' then 1.25855428739066
    when @Trip_Length2 = '49' then 1.27760480384043
    when @Trip_Length2 = '50' then 1.29556229199864
    when @Trip_Length2 = '51' then 1.31203454601037
    when @Trip_Length2 = '52' then 1.32664331671692
    when @Trip_Length2 = '53' then 1.3390712700151
    when @Trip_Length2 = '54' then 1.34911006707336
    when @Trip_Length2 = '55' then 1.35670077678394
    when @Trip_Length2 = '56' then 1.3619638466781
    when @Trip_Length2 = '57' then 1.36521263761665
    when @Trip_Length2 = '58' then 1.36694663690789
    when @Trip_Length2 = '59' then 1.36782218605749
    when @Trip_Length2 = '60' then 1.36859932552712
    when @Trip_Length2 = '61' then 1.37007022232912
    when @Trip_Length2 = '62' then 1.372973054042
    when @Trip_Length2 = '63' then 1.3779093251315
    when @Trip_Length2 = '64' then 1.38527392874582
    when @Trip_Length2 = '65' then 1.39521542673034
    when @Trip_Length2 = '66' then 1.40763096157327
    when @Trip_Length2 = '67' then 1.42219787414735
    when @Trip_Length2 = '68' then 1.43843183127062
    when @Trip_Length2 = '69' then 1.45575847362688
    when @Trip_Length2 = '70' then 1.47358396872999
    when @Trip_Length2 = '71' then 1.49135256196523
    when @Trip_Length2 = '72' then 1.50858549179515
    when @Trip_Length2 = '73' then 1.52489924205541
    when @Trip_Length2 = '74' then 1.54000651668621
    when @Trip_Length2 = '75' then 1.55370618664858
    when @Trip_Length2 = '76' then 1.5658677232143
    when @Trip_Length2 = '77' then 1.57641629696949
    when @Trip_Length2 = '78' then 1.58532358294763
    when @Trip_Length2 = '79' then 1.59260630675545
    when @Trip_Length2 = '80' then 1.59833264722856
    when @Trip_Length2 = '81' then 1.60263587183269
    when @Trip_Length2 = '82' then 1.60573096650935
    when @Trip_Length2 = '83' then 1.60792991847004
    when @Trip_Length2 = '84' then 1.60965179797538
    when @Trip_Length2 = '85' then 1.61142058261232
    when @Trip_Length2 = '86' then 1.61385033045107
    when @Trip_Length2 = '87' then 1.61761064285757
    when @Trip_Length2 = '88' then 1.62337639643085
    when @Trip_Length2 = '89' then 1.63176477896176
    when @Trip_Length2 = '90' then 1.64326618924388
    when @Trip_Length2 = '97' then 1.65818307033103
    when @Trip_Length2 = '104' then 1.67658733307729
    when @Trip_Length2 = '111' then 1.69830764031231
    when @Trip_Length2 = '118' then 1.72295007345859
    when @Trip_Length2 = '125' then 1.74995214977672
    when @Trip_Length2 = '132' then 1.77865825195475
    when @Trip_Length2 = '139' then 1.80840466292492
    when @Trip_Length2 = '146' then 1.83860156497225
    when @Trip_Length2 = '153' then 1.86879632623372
    when @Trip_Length2 = '160' then 1.89871376613212
    when @Trip_Length2 = '167' then 1.92826604271159
    when @Trip_Length2 = '174' then 1.95753173723876
    when @Trip_Length2 = '181' then 1.98670845107877
    when @Trip_Length2 = '188' then 2.01604454344825
    when @Trip_Length2 = '195' then 2.04575899057935
    when @Trip_Length2 = '202' then 2.0759657892988
    when @Trip_Length2 = '209' then 2.10661364051992
    when @Trip_Length2 = '216' then 2.13745348868983
    when @Trip_Length2 = '223' then 2.16804055539797
    when @Trip_Length2 = '230' then 2.19776933180898
    when @Trip_Length2 = '237' then 2.22593537121956
    when @Trip_Length2 = '244' then 2.25181313569121
    when @Trip_Length2 = '251' then 2.27473802235011
    when @Trip_Length2 = '258' then 2.29418382118335
    when @Trip_Length2 = '265' then 2.30982949034765
    when @Trip_Length2 = '272' then 2.32161119720882
    when @Trip_Length2 = '279' then 2.32975763092288
    when @Trip_Length2 = '286' then 2.33480778067555
    when @Trip_Length2 = '293' then 2.33760044079153
    when @Trip_Length2 = '300' then 2.33924807279346
    when @Trip_Length2 = '307' then 2.34104171746512
    when @Trip_Length2 = '314' then 2.34440223518388
    when @Trip_Length2 = '321' then 2.35058162850395
    when @Trip_Length2 = '328' then 2.36088928868133
    when @Trip_Length2 = '335' then 2.37555001579051
    when @Trip_Length2 = '342' then 2.39607247230694
    when @Trip_Length2 = '349' then 2.41897684098367
    when @Trip_Length2 = '356' then 2.45139461213273
    when @Trip_Length2 = '363' then 2.47241419688818
    when @Trip_Length2 = '365' then 2.52945748195336
    when @Trip_Length2 = '370' then 2.49912259621584
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.33340650739141
    when @Destination3 = 'Africa-SOUTH AFRICA' then 0.481921173700755
    when @Destination3 = 'Asia Others' then 0.481921173700755
    when @Destination3 = 'Australia-AUSTRALIA' then 0
    when @Destination3 = 'Domestic' then 0
    when @Destination3 = 'East Asia' then 0.481921173700755
    when @Destination3 = 'East Asia-CHINA' then 0.33340650739141
    when @Destination3 = 'East Asia-HONG KONG' then 0.481921173700755
    when @Destination3 = 'East Asia-JAPAN' then 0.481921173700755
    when @Destination3 = 'Europe' then 0.481921173700755
    when @Destination3 = 'Europe-CROATIA' then 0.582143732647318
    when @Destination3 = 'Europe-ENGLAND' then 0.130741001372573
    when @Destination3 = 'Europe-FRANCE' then 0.481921173700755
    when @Destination3 = 'Europe-GERMANY' then 0.582143732647318
    when @Destination3 = 'Europe-GREECE' then 0.582143732647318
    when @Destination3 = 'Europe-ITALY' then 0.582143732647318
    when @Destination3 = 'Europe-NETHERLANDS' then 0.33340650739141
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then 0
    when @Destination3 = 'Europe-SCOTLAND' then 0.33340650739141
    when @Destination3 = 'Europe-SPAIN' then 0.582143732647318
    when @Destination3 = 'Europe-SWITZERLAND' then 0.33340650739141
    when @Destination3 = 'Europe-UNITED KINGDOM' then 0
    when @Destination3 = 'Mid East' then 0.481921173700755
    when @Destination3 = 'North America-CANADA' then 0.481921173700755
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 0.481921173700755
    when @Destination3 = 'Pacific Region' then 0.130741001372573
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then 0
    when @Destination3 = 'Pacific Region-FIJI' then 0.481921173700755
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then 0.33340650739141
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0.582143732647318
    when @Destination3 = 'Pacific Region-VANUATU' then 0.481921173700755
    when @Destination3 = 'SEA-INDONESIA' then 0.860517129738957
    when @Destination3 = 'SEA-MALAYSIA' then 0.481921173700755
    when @Destination3 = 'SEA-PHILIPPINES' then 0.33340650739141
    when @Destination3 = 'SEA-SINGAPORE' then 0.33340650739141
    when @Destination3 = 'South America' then 0.860517129738957
    when @Destination3 = 'South Asia' then 0.582143732647318
    when @Destination3 = 'South Asia-CAMBODIA' then 0.860517129738957
    when @Destination3 = 'South Asia-INDIA' then 0.860517129738957
    when @Destination3 = 'South Asia-NEPAL' then 1.63096997711587
    when @Destination3 = 'South Asia-SRI LANKA' then 0.33340650739141
    when @Destination3 = 'South Asia-THAILAND' then 0.582143732647318
    when @Destination3 = 'South Asia-VIETNAM' then 0.582143732647318
    when @Destination3 = 'World Others' then 0.481921173700755
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0.15091688531686
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then 0.00279608730200119
    when @Lead_Time2 = '3' then 0.00279608730200119
    when @Lead_Time2 = '4' then 0.00955421280481171
    when @Lead_Time2 = '5' then 0.0113355096637457
    when @Lead_Time2 = '6' then 0.0132123314721353
    when @Lead_Time2 = '7' then 0.015085637418041
    when @Lead_Time2 = '8' then 0.0169554406494132
    when @Lead_Time2 = '9' then 0.0188217542405872
    when @Lead_Time2 = '10' then 0.0206845911928326
    when @Lead_Time2 = '11' then 0.0225439644348944
    when @Lead_Time2 = '12' then 0.0243998868235353
    when @Lead_Time2 = '13' then 0.0262523711440661
    when @Lead_Time2 = '14' then 0.0281014301108743
    when @Lead_Time2 = '15' then 0.0300441213483769
    when @Lead_Time2 = '16' then 0.0318861888623215
    when @Lead_Time2 = '17' then 0.0337248694016213
    when @Lead_Time2 = '18' then 0.0355601753985511
    when @Lead_Time2 = '19' then 0.0374884444109914
    when @Lead_Time2 = '20' then 0.0393168623769506
    when @Lead_Time2 = '21' then 0.0411419433311754
    when @Lead_Time2 = '22' then 0.0430594894604468
    when @Lead_Time2 = '23' then 0.0448777587780853
    when @Lead_Time2 = '24' then 0.0467881614987592
    when @Lead_Time2 = '25' then 0.0485996698360624
    when @Lead_Time2 = '26' then 0.0505029821731066
    when @Lead_Time2 = '27' then 0.0523077796233449
    when @Lead_Time2 = '28' then 0.0542040540135122
    when @Lead_Time2 = '29' then 0.05609673935187
    when @Lead_Time2 = '30' then 0.0579858491986531
    when @Lead_Time2 = '31' then 0.0597772040358606
    when @Lead_Time2 = '32' then 0.0616593803867276
    when @Lead_Time2 = '33' then 0.0635380208039877
    when @Lead_Time2 = '34' then 0.0654131385482319
    when @Lead_Time2 = '35' then 0.0672847468055965
    when @Lead_Time2 = '36' then 0.0691528586883167
    when @Lead_Time2 = '37' then 0.0710174872352804
    when @Lead_Time2 = '38' then 0.0728786454125725
    when @Lead_Time2 = '39' then 0.0747363461140171
    when @Lead_Time2 = '40' then 0.0765906021617124
    when @Lead_Time2 = '41' then 0.0784414263065627
    when @Lead_Time2 = '42' then 0.0802888312288031
    when @Lead_Time2 = '43' then 0.0821328295385224
    when @Lead_Time2 = '44' then 0.0840653751176674
    when @Lead_Time2 = '45' then 0.0859024290007033
    when @Lead_Time2 = '46' then 0.0877361143040867
    when @Lead_Time2 = '47' then 0.0895664433590429
    when @Lead_Time2 = '48' then 0.0914846901221784
    when @Lead_Time2 = '49' then 0.0933081771336517
    when @Lead_Time2 = '50' then 0.095219266580934
    when @Lead_Time2 = '51' then 0.0970359625115944
    when @Lead_Time2 = '52' then 0.0989399478549036
    when @Lead_Time2 = '53' then 0.100749903100143
    when @Lead_Time2 = '54' then 0.102646836960143
    when @Lead_Time2 = '55' then 0.104540179273924
    when @Lead_Time2 = '56' then 0.106340035771327
    when @Lead_Time2 = '57' then 0.108226405070871
    when @Lead_Time2 = '58' then 0.11010922268003
    when @Lead_Time2 = '59' then 0.111988501948047
    when @Lead_Time2 = '60' then 0.113864256149047
    when @Lead_Time2 = '61' then 0.115647423525962
    when @Lead_Time2 = '62' then 0.117516333427839
    when @Lead_Time2 = '63' then 0.11938175702008
    when @Lead_Time2 = '64' then 0.121243707285364
    when @Lead_Time2 = '65' then 0.123102197133983
    when @Lead_Time2 = '66' then 0.124957239404384
    when @Lead_Time2 = '67' then 0.126896933188351
    when @Lead_Time2 = '68' then 0.128744955890562
    when @Lead_Time2 = '69' then 0.130589569703602
    when @Lead_Time2 = '70' then 0.13243078718049
    when @Lead_Time2 = '71' then 0.134268620805034
    when @Lead_Time2 = '72' then 0.136190354450266
    when @Lead_Time2 = '73' then 0.138021297897374
    when @Lead_Time2 = '74' then 0.139935840297517
    when @Lead_Time2 = '75' then 0.141759945037832
    when @Lead_Time2 = '76' then 0.143580728477524
    when @Lead_Time2 = '77' then 0.145484666741981
    when @Lead_Time2 = '78' then 0.147384986913058
    when @Lead_Time2 = '79' then 0.149195566361853
    when @Lead_Time2 = '80' then 0.151088854362856
    when @Lead_Time2 = '81' then 0.152978564597081
    when @Lead_Time2 = '82' then 0.154779053787554
    when @Lead_Time2 = '83' then 0.156661810013377
    when @Lead_Time2 = '84' then 0.158541028128551
    when @Lead_Time2 = '85' then 0.160416721405904
    when @Lead_Time2 = '86' then 0.162288903043719
    when @Lead_Time2 = '87' then 0.164072721737158
    when @Lead_Time2 = '88' then 0.16593807754343
    when @Lead_Time2 = '89' then 0.167799960274934
    when @Lead_Time2 = '90' then 0.169658382840557
    when @Lead_Time2 = '91' then 0.171597593430979
    when @Lead_Time2 = '92' then 0.173448978290356
    when @Lead_Time2 = '93' then 0.17529694185699
    when @Lead_Time2 = '94' then 0.177141496752412
    when @Lead_Time2 = '95' then 0.17898265552844
    when @Lead_Time2 = '96' then 0.180903885706334
    when @Lead_Time2 = '97' then 0.182738136679171
    when @Lead_Time2 = '98' then 0.184569029334434
    when @Lead_Time2 = '99' then 0.186479566942618
    when @Lead_Time2 = '100' then 0.188303628471502
    when @Lead_Time2 = '101' then 0.190207051067945
    when @Lead_Time2 = '102' then 0.19202433225534
    when @Lead_Time2 = '103' then 0.193920692637306
    when @Lead_Time2 = '104' then 0.195813463642254
    when @Lead_Time2 = '105' then 0.197620594083124
    when @Lead_Time2 = '106' then 0.199506381548056
    when @Lead_Time2 = '107' then 0.20138861951118
    when @Lead_Time2 = '108' then 0.203267321309417
    when @Lead_Time2 = '109' then 0.205061043763444
    when @Lead_Time2 = '110' then 0.206932865266228
    when @Lead_Time2 = '111' then 0.208801189598333
    when @Lead_Time2 = '112' then 0.210666029803097
    when @Lead_Time2 = '113' then 0.21252739885102
    when @Lead_Time2 = '114' then 0.21438530964031
    when @Lead_Time2 = '115' then 0.216239774997415
    when @Lead_Time2 = '116' then 0.218090807677558
    when @Lead_Time2 = '117' then 0.220018673966685
    when @Lead_Time2 = '118' then 0.221862731414487
    when @Lead_Time2 = '119' then 0.223703394572724
    when @Lead_Time2 = '120' then 0.225540675913931
    when @Lead_Time2 = '121' then 0.227454246901294
    when @Lead_Time2 = '122' then 0.229284656070973
    when @Lead_Time2 = '123' then 0.231191082893511
    when @Lead_Time2 = '124' then 0.233014671109473
    when @Lead_Time2 = '125' then 0.234914006913125
    when @Lead_Time2 = '126' then 0.236730824822725
    when @Lead_Time2 = '127' then 0.238623122162596
    when @Lead_Time2 = '128' then 0.240511845475302
    when @Lead_Time2 = '129' then 0.242318530700251
    when @Lead_Time2 = '130' then 0.24420029383982
    when @Lead_Time2 = '131' then 0.246078522596706
    when @Lead_Time2 = '132' then 0.247953230222784
    when @Lead_Time2 = '133' then 0.249824429895541
    when @Lead_Time2 = '134' then 0.251692134718626
    when @Lead_Time2 = '135' then 0.253556357722405
    when @Lead_Time2 = '136' then 0.255417111864505
    when @Lead_Time2 = '137' then 0.257274410030355
    when @Lead_Time2 = '138' then 0.25912826503372
    when @Lead_Time2 = '139' then 0.260978689617231
    when @Lead_Time2 = '140' then 0.262825696452914
    when @Lead_Time2 = '141' then 0.264669298142708
    when @Lead_Time2 = '142' then 0.266586109157047
    when @Lead_Time2 = '143' then 0.26842279751297
    when @Lead_Time2 = '144' then 0.270256118628403
    when @Lead_Time2 = '145' then 0.272162260793744
    when @Lead_Time2 = '146' then 0.273988745319779
    when @Lead_Time2 = '147' then 0.27588779256907
    when @Lead_Time2 = '148' then 0.277707491304577
    when @Lead_Time2 = '149' then 0.279599496258425
    when @Lead_Time2 = '150' then 0.281487928288454
    when @Lead_Time2 = '151' then 0.283297474133957
    when @Lead_Time2 = '152' then 0.285178942233662
    when @Lead_Time2 = '153' then 0.287056877057863
    when @Lead_Time2 = '154' then 0.288931291852213
    when @Lead_Time2 = '155' then 0.290802199788025
    when @Lead_Time2 = '156' then 0.29266961396282
    when @Lead_Time2 = '157' then 0.294533547400883
    when @Lead_Time2 = '158' then 0.296394013053802
    when @Lead_Time2 = '159' then 0.298251023801015
    when @Lead_Time2 = '160' then 0.300104592450338
    when @Lead_Time2 = '161' then 0.301954731738499
    when @Lead_Time2 = '162' then 0.303801454331664
    when @Lead_Time2 = '163' then 0.305644772825954
    when @Lead_Time2 = '164' then 0.307558226456571
    when @Lead_Time2 = '165' then 0.309394639357431
    when @Lead_Time2 = '166' then 0.311227686026795
    when @Lead_Time2 = '167' then 0.313130496905368
    when @Lead_Time2 = '168' then 0.314956714586662
    when @Lead_Time2 = '169' then 0.316852449751561
    when @Lead_Time2 = '170' then 0.318744597903599
    when @Lead_Time2 = '171' then 0.32056060101772
    when @Lead_Time2 = '172' then 0.322445752388072
    when @Lead_Time2 = '173' then 0.324327356648525
    when @Lead_Time2 = '174' then 0.326133258826033
    when @Lead_Time2 = '175' then 0.328007943923347
    when @Lead_Time2 = '176' then 0.329879121151569
    when @Lead_Time2 = '177' then 0.331746803613881
    when @Lead_Time2 = '178' then 0.33361100434018
    when @Lead_Time2 = '179' then 0.33547173628763
    when @Lead_Time2 = '180' then 0.337329012341195
    when @Lead_Time2 = '181' then 0.339182845314184
    when @Lead_Time2 = '188' then 0.352204968467281
    when @Lead_Time2 = '195' then 0.365267918356751
    when @Lead_Time2 = '202' then 0.378299440035395
    when @Lead_Time2 = '209' then 0.391366183728663
    when @Lead_Time2 = '216' then 0.404397872147742
    when @Lead_Time2 = '223' then 0.417459552956533
    when @Lead_Time2 = '230' then 0.430482871083452
    when @Lead_Time2 = '237' then 0.443531308914621
    when @Lead_Time2 = '244' then 0.456538378292165
    when @Lead_Time2 = '251' then 0.469566033514688
    when @Lead_Time2 = '258' then 0.482611317284818
    when @Lead_Time2 = '265' then 0.495671375994313
    when @Lead_Time2 = '272' then 0.508683330693957
    when @Lead_Time2 = '279' then 0.521765563804325
    when @Lead_Time2 = '286' then 0.53479602440457
    when @Lead_Time2 = '293' then 0.547832349395086
    when @Lead_Time2 = '300' then 0.560872141250127
    when @Lead_Time2 = '307' then 0.573913092636247
    when @Lead_Time2 = '314' then 0.586952984153541
    when @Lead_Time2 = '321' then 0.599989682073696
    when @Lead_Time2 = '328' then 0.61302113608066
    when @Lead_Time2 = '335' then 0.626045377019209
    when @Lead_Time2 = '342' then 0.63906051465618
    when @Lead_Time2 = '349' then 0.652116831001953
    when @Lead_Time2 = '356' then 0.665159144019777
    when @Lead_Time2 = '363' then 0.665159144019777
    when @Lead_Time2 = '370' then 0.665159144019777
    when @Lead_Time2 = '377' then 0.665159144019777
    when @Lead_Time2 = '384' then 0.665159144019777
    when @Lead_Time2 = '391' then 0.665159144019777
    when @Lead_Time2 = '398' then 0.665159144019777
    when @Lead_Time2 = '405' then 0.665159144019777
    when @Lead_Time2 = '412' then 0.665159144019777
    when @Lead_Time2 = '419' then 0.665159144019777
    when @Lead_Time2 = '426' then 0.665159144019777
    when @Lead_Time2 = '433' then 0.665159144019777
    when @Lead_Time2 = '440' then 0.665159144019777
    when @Lead_Time2 = '447' then 0.665159144019777
    when @Lead_Time2 = '454' then 0.665159144019777
    when @Lead_Time2 = '461' then 0.665159144019777
    when @Lead_Time2 = '468' then 0.665159144019777
    when @Lead_Time2 = '475' then 0.665159144019777
    when @Lead_Time2 = '482' then 0.665159144019777
    when @Lead_Time2 = '489' then 0.665159144019777
    when @Lead_Time2 = '496' then 0.665159144019777
    when @Lead_Time2 = '503' then 0.665159144019777
    when @Lead_Time2 = '510' then 0.665159144019777
    when @Lead_Time2 = '517' then 0.665159144019777
    when @Lead_Time2 = '524' then 0.665159144019777
    when @Lead_Time2 = '531' then 0.665159144019777
    when @Lead_Time2 = '538' then 0.665159144019777
    when @Lead_Time2 = '545' then 0.665159144019777
    when @Lead_Time2 = '552' then 0.665159144019777
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then -0.172537515935804
    when @OldestAge2 = '12' then -0.175565802424234
    when @OldestAge2 = '13' then -0.181650026595647
    when @OldestAge2 = '14' then -0.187157659390766
    when @OldestAge2 = '15' then -0.188139977740876
    when @OldestAge2 = '16' then -0.180917962141284
    when @OldestAge2 = '17' then -0.163866941384669
    when @OldestAge2 = '18' then -0.13759635003257
    when @OldestAge2 = '19' then -0.104512698735487
    when @OldestAge2 = '20' then -0.0680118915183714
    when @OldestAge2 = '21' then -0.0306953257023261
    when @OldestAge2 = '22' then 0.00527866417066564
    when @OldestAge2 = '23' then 0.0388291704701276
    when @OldestAge2 = '24' then 0.0695830280990797
    when @OldestAge2 = '25' then 0.0969281161332284
    when @OldestAge2 = '26' then 0.120482245038191
    when @OldestAge2 = '27' then 0.13934145349532
    when @OldestAge2 = '28' then 0.152535417432539
    when @OldestAge2 = '29' then 0.158980871329156
    when @OldestAge2 = '30' then 0.157938480685777
    when @OldestAge2 = '31' then 0.149384705916615
    when @OldestAge2 = '32' then 0.13383668952813
    when @OldestAge2 = '33' then 0.112692350573472
    when @OldestAge2 = '34' then 0.0876473070587559
    when @OldestAge2 = '35' then 0.0606186346708365
    when @OldestAge2 = '36' then 0.0334298543540826
    when @OldestAge2 = '37' then 0.00740255877436979
    when @OldestAge2 = '38' then -0.016108694914088
    when @OldestAge2 = '39' then -0.0362734067868349
    when @OldestAge2 = '40' then -0.0519095281471884
    when @OldestAge2 = '41' then -0.0621461349648342
    when @OldestAge2 = '42' then -0.0663790603712888
    when @OldestAge2 = '43' then -0.0645317357492265
    when @OldestAge2 = '44' then -0.0576075492618262
    when @OldestAge2 = '45' then -0.0469902582548105
    when @OldestAge2 = '46' then -0.0349023154999557
    when @OldestAge2 = '47' then -0.0230628980398384
    when @OldestAge2 = '48' then -0.0130104790721646
    when @OldestAge2 = '49' then -0.00530667639862599
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00365742559486728
    when @OldestAge2 = '52' then 0.00669509500237906
    when @OldestAge2 = '53' then 0.0102274194099241
    when @OldestAge2 = '54' then 0.0152520506224105
    when @OldestAge2 = '55' then 0.0225429693114966
    when @OldestAge2 = '56' then 0.0324450207113563
    when @OldestAge2 = '57' then 0.0448809214923117
    when @OldestAge2 = '58' then 0.0596602293837506
    when @OldestAge2 = '59' then 0.0761125048102892
    when @OldestAge2 = '60' then 0.0935042475221586
    when @OldestAge2 = '61' then 0.11114527832606
    when @OldestAge2 = '62' then 0.128569995809876
    when @OldestAge2 = '63' then 0.145520306236617
    when @OldestAge2 = '64' then 0.162274624848664
    when @OldestAge2 = '65' then 0.179348524236708
    when @OldestAge2 = '66' then 0.197640432235127
    when @OldestAge2 = '67' then 0.217816410161007
    when @OldestAge2 = '68' then 0.24071848335276
    when @OldestAge2 = '69' then 0.267011893368834
    when @OldestAge2 = '70' then 0.297254431497146
    when @OldestAge2 = '71' then 0.331735481545032
    when @OldestAge2 = '72' then 0.370843809892621
    when @OldestAge2 = '73' then 0.414482849951221
    when @OldestAge2 = '74' then 0.462148430314364
    when @OldestAge2 = '75' then 0.512838863014755
    when @OldestAge2 = '76' then 0.564908915618263
    when @OldestAge2 = '77' then 0.616656257908437
    when @OldestAge2 = '78' then 0.666484435147541
    when @OldestAge2 = '79' then 0.713149358867014
    when @OldestAge2 = '80' then 0.756301155869884
    when @OldestAge2 = '81' then 0.796383303888872
    when @OldestAge2 = '82' then 0.834611401524953
    when @OldestAge2 = '83' then 0.872368091380056
    when @OldestAge2 = '84' then 0.910513260129754
    when @OldestAge2 = '85' then 0.949070704857944
    when @OldestAge2 = '86' then 0.986727852551845
    when @OldestAge2 = '87' then 1.02107703690308
    when @OldestAge2 = '88' then 1.04916542036609
    when @OldestAge2 = '89' then 1.06823177486827
    when @OldestAge2 = '90' then 1.07624352177751
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.4479880558598
    when @Traveller_Count2 = '3' then 0.605217413533411
    when @Traveller_Count2 = '4' then 0.852988558113555
    when @Traveller_Count2 = '5' then 0.852988558113555
    when @Traveller_Count2 = '6' then 0.852988558113555
    when @Traveller_Count2 = '7' then 0.852988558113555
    when @Traveller_Count2 = '8' then 0.852988558113555
    when @Traveller_Count2 = '9' then 0.852988558113555
    when @Traveller_Count2 = '10' then 0.852988558113555
end

-- Start of Product_Indicator
set @LinearPredictor = @LinearPredictor +
case
    when @Product_Indicator = 'Domestic AMT' then -1.03035883790276
    when @Product_Indicator = 'Domestic Inbound' then 0.256700138849243
    when @Product_Indicator = 'Domestic Single Trip' then 0.112769564474525
    when @Product_Indicator = 'International AMT' then -0.987403879975947
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then -0.538256566736743
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then 0.179066264073282
    when @Excess = '20' then 0.111237213990557
    when @Excess = '25' then 0.0935358793911649
    when @Excess = '50' then 0
    when @Excess = '100' then -0.310200383882384
    when @Excess = '250' then -0.599839003426293
    when @Excess = '500' then -1.03704693300995
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then -0.0863132664001291
    when @Departure_Month = '2' then 0
    when @Departure_Month = '3' then -0.0863132664001291
    when @Departure_Month = '4' then -0.0863132664001291
    when @Departure_Month = '5' then -0.0863132664001291
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then -0.0863132664001291
    when @Departure_Month = '9' then -0.0863132664001291
    when @Departure_Month = '10' then -0.148690326423249
    when @Departure_Month = '11' then -0.148690326423249
    when @Departure_Month = '12' then -0.0863132664001291
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.225009231695444
    when @EMCBand = '1_>50%' then 0.225009231695444
    when @EMCBand = '2_<50%' then 0.225009231695444
    when @EMCBand = '2_>50%' then 0.225009231695444
    when @EMCBand = '3_<50%' then 0.225009231695444
    when @EMCBand = '3_>50%' then 0.225009231695444
    when @EMCBand = '4_<50%' then 0.35141325048774
    when @EMCBand = '4_>50%' then 0.35141325048774
    when @EMCBand = '5_<50%' then 0.35141325048774
    when @EMCBand = '5_>50%' then 0.35141325048774
    when @EMCBand = '6_<50%' then 0.35141325048774
    when @EMCBand = '6_>50%' then 0.35141325048774
    when @EMCBand = '7_<50%' then 0.35141325048774
    when @EMCBand = '7_>50%' then 0.35141325048774
    when @EMCBand = '8_<50%' then 0.35141325048774
    when @EMCBand = '8_>50%' then 0.35141325048774
end

-- Start of return_yr
return @PredictedValue
set @LinearPredictor = @LinearPredictor +
case
    when @return_yr = '2018' then 0.0600320239547712
    when @return_yr = '2019' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

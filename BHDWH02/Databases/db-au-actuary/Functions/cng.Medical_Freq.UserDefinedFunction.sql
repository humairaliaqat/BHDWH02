USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Medical_Freq]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Medical_Freq] (
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
set @LinearPredictor = @LinearPredictor + -6.85909723620944

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.877550903558225
    when @Trip_Length2 = '2' then -1.5769707222966
    when @Trip_Length2 = '3' then -1.5769707222966
    when @Trip_Length2 = '4' then -1.10201808180294
    when @Trip_Length2 = '5' then -0.706637770742445
    when @Trip_Length2 = '6' then -0.420071260497527
    when @Trip_Length2 = '7' then -0.191887161663655
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.166276859625099
    when @Trip_Length2 = '10' then 0.312472241259
    when @Trip_Length2 = '11' then 0.441089619081093
    when @Trip_Length2 = '12' then 0.553540226173528
    when @Trip_Length2 = '13' then 0.651126551297333
    when @Trip_Length2 = '14' then 0.735152474704975
    when @Trip_Length2 = '15' then 0.807814255538071
    when @Trip_Length2 = '16' then 0.871544380461744
    when @Trip_Length2 = '17' then 0.928970009031229
    when @Trip_Length2 = '18' then 0.982452934127823
    when @Trip_Length2 = '19' then 1.03371814875012
    when @Trip_Length2 = '20' then 1.08376934179834
    when @Trip_Length2 = '21' then 1.13298150874765
    when @Trip_Length2 = '22' then 1.18129765528672
    when @Trip_Length2 = '23' then 1.22826533689497
    when @Trip_Length2 = '24' then 1.27334960210376
    when @Trip_Length2 = '25' then 1.31595236568864
    when @Trip_Length2 = '26' then 1.35583515363518
    when @Trip_Length2 = '27' then 1.39319549343319
    when @Trip_Length2 = '28' then 1.42892272317551
    when @Trip_Length2 = '29' then 1.46441214038384
    when @Trip_Length2 = '30' then 1.50118432699385
    when @Trip_Length2 = '31' then 1.54038789645729
    when @Trip_Length2 = '32' then 1.58235444402436
    when @Trip_Length2 = '33' then 1.62645234259323
    when @Trip_Length2 = '34' then 1.67126651505703
    when @Trip_Length2 = '35' then 1.71507638945709
    when @Trip_Length2 = '36' then 1.7562186436423
    when @Trip_Length2 = '37' then 1.79350793976217
    when @Trip_Length2 = '38' then 1.82633801391447
    when @Trip_Length2 = '39' then 1.85468731893053
    when @Trip_Length2 = '40' then 1.87902220351368
    when @Trip_Length2 = '41' then 1.90015038857091
    when @Trip_Length2 = '42' then 1.91911139152653
    when @Trip_Length2 = '43' then 1.93705678773957
    when @Trip_Length2 = '44' then 1.95511055238991
    when @Trip_Length2 = '45' then 1.9741504680553
    when @Trip_Length2 = '46' then 1.99478194254604
    when @Trip_Length2 = '47' then 2.01730014514199
    when @Trip_Length2 = '48' then 2.04176563469883
    when @Trip_Length2 = '49' then 2.06807721160079
    when @Trip_Length2 = '50' then 2.09589297174665
    when @Trip_Length2 = '51' then 2.12435515410334
    when @Trip_Length2 = '52' then 2.13720324572587
    when @Trip_Length2 = '53' then 2.15611318909379
    when @Trip_Length2 = '54' then 2.17408104208355
    when @Trip_Length2 = '55' then 2.19121768312837
    when @Trip_Length2 = '56' then 2.20772481197009
    when @Trip_Length2 = '57' then 2.2239097833389
    when @Trip_Length2 = '58' then 2.24012441165144
    when @Trip_Length2 = '59' then 2.25675055665025
    when @Trip_Length2 = '60' then 2.27412388817201
    when @Trip_Length2 = '61' then 2.29248425081462
    when @Trip_Length2 = '62' then 2.31197090810254
    when @Trip_Length2 = '63' then 2.33255157911152
    when @Trip_Length2 = '64' then 2.35404787301809
    when @Trip_Length2 = '65' then 2.37618865223868
    when @Trip_Length2 = '66' then 2.39857685864777
    when @Trip_Length2 = '67' then 2.4208124743587
    when @Trip_Length2 = '68' then 2.44251223911362
    when @Trip_Length2 = '69' then 2.46336801650502
    when @Trip_Length2 = '70' then 2.4831801602623
    when @Trip_Length2 = '71' then 2.50186209043741
    when @Trip_Length2 = '72' then 2.51947714433816
    when @Trip_Length2 = '73' then 2.53616202679003
    when @Trip_Length2 = '74' then 2.55212906605473
    when @Trip_Length2 = '75' then 2.56759968838356
    when @Trip_Length2 = '76' then 2.58277416288688
    when @Trip_Length2 = '77' then 2.59777391913522
    when @Trip_Length2 = '78' then 2.61263268220392
    when @Trip_Length2 = '79' then 2.62733170958264
    when @Trip_Length2 = '80' then 2.64178218525048
    when @Trip_Length2 = '81' then 2.65590039966632
    when @Trip_Length2 = '82' then 2.66966274069742
    when @Trip_Length2 = '83' then 2.68314256539603
    when @Trip_Length2 = '84' then 2.69653751707735
    when @Trip_Length2 = '85' then 2.71018791456376
    when @Trip_Length2 = '86' then 2.72455327320122
    when @Trip_Length2 = '87' then 2.7401623750182
    when @Trip_Length2 = '88' then 2.75755122366305
    when @Trip_Length2 = '89' then 2.777209280998
    when @Trip_Length2 = '90' then 2.79948013520806
    when @Trip_Length2 = '97' then 2.82453461613794
    when @Trip_Length2 = '104' then 2.85236408648794
    when @Trip_Length2 = '111' then 2.88274832881713
    when @Trip_Length2 = '118' then 2.91532449925174
    when @Trip_Length2 = '125' then 2.9496150339368
    when @Trip_Length2 = '132' then 2.98507569336546
    when @Trip_Length2 = '139' then 3.02116120036436
    when @Trip_Length2 = '146' then 3.05737284970224
    when @Trip_Length2 = '153' then 3.09327632005554
    when @Trip_Length2 = '160' then 3.12855278856489
    when @Trip_Length2 = '167' then 3.16299518256568
    when @Trip_Length2 = '174' then 3.19650750900619
    when @Trip_Length2 = '181' then 3.22911126358911
    when @Trip_Length2 = '188' then 3.26090796686454
    when @Trip_Length2 = '195' then 3.29204078109357
    when @Trip_Length2 = '202' then 3.32267351995789
    when @Trip_Length2 = '209' then 3.35292408389427
    when @Trip_Length2 = '216' then 3.38284330471016
    when @Trip_Length2 = '223' then 3.41239116353202
    when @Trip_Length2 = '230' then 3.44142399898057
    when @Trip_Length2 = '237' then 3.4697061359833
    when @Trip_Length2 = '244' then 3.49694382992392
    when @Trip_Length2 = '251' then 3.52280716006387
    when @Trip_Length2 = '258' then 3.54696732674696
    when @Trip_Length2 = '265' then 3.56912979842744
    when @Trip_Length2 = '272' then 3.58903149414077
    when @Trip_Length2 = '279' then 3.60645119494038
    when @Trip_Length2 = '286' then 3.62118930514399
    when @Trip_Length2 = '293' then 3.63304956915327
    when @Trip_Length2 = '300' then 3.63763352702559
    when @Trip_Length2 = '307' then 3.63763352702559
    when @Trip_Length2 = '314' then 3.63763352702559
    when @Trip_Length2 = '321' then 3.63763352702559
    when @Trip_Length2 = '328' then 3.63763352702559
    when @Trip_Length2 = '335' then 3.63763352702559
    when @Trip_Length2 = '342' then 3.63763352702559
    when @Trip_Length2 = '349' then 3.63763352702559
    when @Trip_Length2 = '356' then 3.63763352702559
    when @Trip_Length2 = '363' then 3.63763352702559
    when @Trip_Length2 = '365' then 3.63763352702559
    when @Trip_Length2 = '370' then 3.63763352702559   
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then -0.292197485382213
    when @Destination3 = 'Africa-SOUTH AFRICA' then -0.162895856141108
    when @Destination3 = 'Asia Others' then 0.410141834799813
    when @Destination3 = 'Domestic' then -0.162895856141108
    when @Destination3 = 'East Asia' then 0.134229464809742
    when @Destination3 = 'East Asia-CHINA' then 0.410141834799813
    when @Destination3 = 'East Asia-HONG KONG' then 0.582585411562724
    when @Destination3 = 'East Asia-JAPAN' then 0.297138714942101
    when @Destination3 = 'Europe' then -0.162895856141108
    when @Destination3 = 'Europe-CROATIA' then 0
    when @Destination3 = 'Europe-ENGLAND' then -0.682452559959057
    when @Destination3 = 'Europe-FRANCE' then -0.162895856141108
    when @Destination3 = 'Europe-GERMANY' then 0.134229464809742
    when @Destination3 = 'Europe-GREECE' then 0
    when @Destination3 = 'Europe-ITALY' then -0.162895856141108
    when @Destination3 = 'Europe-NETHERLANDS' then 0
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then -0.682452559959057
    when @Destination3 = 'Europe-SCOTLAND' then -0.682452559959057
    when @Destination3 = 'Europe-SPAIN' then 0.134229464809742
    when @Destination3 = 'Europe-SWITZERLAND' then 0.410141834799813
    when @Destination3 = 'Europe-UNITED KINGDOM' then -0.682452559959057
    when @Destination3 = 'Mid East' then 0.410141834799813
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then 0.582585411562724
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 0.297138714942101
    when @Destination3 = 'Pacific Region' then -0.292197485382213
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then 0.297138714942101
    when @Destination3 = 'Pacific Region-FIJI' then 0
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then 0.134229464809742
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0.582585411562724
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then 0.410141834799813
    when @Destination3 = 'Pacific Region-VANUATU' then 0.410141834799813
    when @Destination3 = 'SEA-INDONESIA' then 0.750122799269332
    when @Destination3 = 'SEA-MALAYSIA' then 0.134229464809742
    when @Destination3 = 'SEA-PHILIPPINES' then 0
    when @Destination3 = 'SEA-SINGAPORE' then 0.582585411562724
    when @Destination3 = 'South America' then 0.297138714942101
    when @Destination3 = 'South Asia' then 0.134229464809742
    when @Destination3 = 'South Asia-CAMBODIA' then 0.297138714942101
    when @Destination3 = 'South Asia-INDIA' then -0.162895856141108
    when @Destination3 = 'South Asia-NEPAL' then 1.18059551472403
    when @Destination3 = 'South Asia-SRI LANKA' then -0.162895856141108
    when @Destination3 = 'South Asia-THAILAND' then 0.750122799269332
    when @Destination3 = 'South Asia-VIETNAM' then 0.134229464809742
    when @Destination3 = 'World Others' then 0.297138714942101
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0.040949986328954
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then 0.00149887612373595
    when @Lead_Time2 = '3' then 0.00299550897979815
    when @Lead_Time2 = '4' then 0.00439034830129263
    when @Lead_Time2 = '5' then 0.0057832447557278
    when @Lead_Time2 = '6' then 0.00717420374800067
    when @Lead_Time2 = '7' then 0.00846407841212936
    when @Lead_Time2 = '8' then 0.00985131605037464
    when @Lead_Time2 = '9' then 0.0111377444104556
    when @Lead_Time2 = '10' then 0.0123237496888321
    when @Lead_Time2 = '11' then 0.0136070034062169
    when @Lead_Time2 = '12' then 0.0147900854726358
    when @Lead_Time2 = '13' then 0.0159717695096991
    when @Lead_Time2 = '14' then 0.0170537545658274
    when @Lead_Time2 = '15' then 0.0181345701954827
    when @Lead_Time2 = '16' then 0.0193123110323725
    when @Lead_Time2 = '17' then 0.0203906896477344
    when @Lead_Time2 = '18' then 0.021467906615241
    when @Lead_Time2 = '19' then 0.0225439644348944
    when @Lead_Time2 = '20' then 0.0236188655986345
    when @Lead_Time2 = '21' then 0.0247901688072183
    when @Lead_Time2 = '22' then 0.0259601016695318
    when @Lead_Time2 = '23' then 0.0272259862535913
    when @Lead_Time2 = '24' then 0.0284902703996276
    when @Lead_Time2 = '25' then 0.0297529581493476
    when @Lead_Time2 = '26' then 0.0311109950250525
    when @Lead_Time2 = '27' then 0.0325639908732622
    when @Lead_Time2 = '28' then 0.0340148785872776
    when @Lead_Time2 = '29' then 0.0355601753985511
    when @Lead_Time2 = '30' then 0.0371030879515023
    when @Lead_Time2 = '31' then 0.0387398283159311
    when @Lead_Time2 = '32' then 0.0404699325537133
    when @Lead_Time2 = '33' then 0.0421970486997881
    when @Lead_Time2 = '34' then 0.0440168854167747
    when @Lead_Time2 = '35' then 0.0457378916738537
    when @Lead_Time2 = '36' then 0.0475513018582224
    when @Lead_Time2 = '37' then 0.0493614295377239
    when @Lead_Time2 = '38' then 0.0511682865743994
    when @Lead_Time2 = '39' then 0.0529718847661059
    when @Lead_Time2 = '40' then 0.0546775612906956
    when @Lead_Time2 = '41' then 0.0563803334361079
    when @Lead_Time2 = '42' then 0.0579858491986531
    when @Lead_Time2 = '43' then 0.0595887914116577
    when @Lead_Time2 = '44' then 0.061095099359811
    when @Lead_Time2 = '45' then 0.0625052053513971
    when @Lead_Time2 = '46' then 0.0638195127129543
    when @Lead_Time2 = '47' then 0.0650383961792221
    when @Lead_Time2 = '48' then 0.0661622022536692
    when @Lead_Time2 = '49' then 0.0670977435324938
    when @Lead_Time2 = '50' then 0.0680324103918268
    when @Lead_Time2 = '51' then 0.0687795153948256
    when @Lead_Time2 = '52' then 0.0694327747153372
    when @Lead_Time2 = '53' then 0.0699923718200352
    when @Lead_Time2 = '54' then 0.0703652626605632
    when @Lead_Time2 = '55' then 0.0707380145053414
    when @Lead_Time2 = '56' then 0.0709243383366988
    when @Lead_Time2 = '57' then 0.0711106274579531
    when @Lead_Time2 = '58' then 0.0712037590063321
    when @Lead_Time2 = '59' then 0.0712968818820334
    when @Lead_Time2 = '60' then 0.0712037590063321
    when @Lead_Time2 = '61' then 0.0712037590063321
    when @Lead_Time2 = '62' then 0.0711106274579531
    when @Lead_Time2 = '63' then 0.07101748723528
    when @Lead_Time2 = '64' then 0.07101748723528
    when @Lead_Time2 = '65' then 0.0709243383366988
    when @Lead_Time2 = '66' then 0.0709243383366988
    when @Lead_Time2 = '67' then 0.0709243383366988
    when @Lead_Time2 = '68' then 0.07101748723528
    when @Lead_Time2 = '69' then 0.0711106274579531
    when @Lead_Time2 = '70' then 0.0712968818820334
    when @Lead_Time2 = '71' then 0.0714831016218645
    when @Lead_Time2 = '72' then 0.0718554371004281
    when @Lead_Time2 = '73' then 0.0722276339968805
    when @Lead_Time2 = '74' then 0.0726926853934406
    when @Lead_Time2 = '75' then 0.0732504617395929
    when @Lead_Time2 = '76' then 0.0738079271447196
    when @Lead_Time2 = '77' then 0.0744579109180101
    when @Lead_Time2 = '78' then 0.0752002325629348
    when @Lead_Time2 = '79' then 0.0759420035751575
    when @Lead_Time2 = '80' then 0.0767758388020496
    when @Lead_Time2 = '81' then 0.0776089793269827
    when @Lead_Time2 = '82' then 0.0784414263065623
    when @Lead_Time2 = '83' then 0.0792731808945079
    when @Lead_Time2 = '84' then 0.0801042442416612
    when @Lead_Time2 = '85' then 0.0809346174959992
    when @Lead_Time2 = '86' then 0.0816721486440253
    when @Lead_Time2 = '87' then 0.0825012215117438
    when @Lead_Time2 = '88' then 0.0832375985700552
    when @Lead_Time2 = '89' then 0.0838814839807016
    when @Lead_Time2 = '90' then 0.0845249550696882
    when @Lead_Time2 = '91' then 0.0850761723551195
    when @Lead_Time2 = '92' then 0.0856270859674374
    when @Lead_Time2 = '93' then 0.0860859489131292
    when @Lead_Time2 = '94' then 0.0865446014001856
    when @Lead_Time2 = '95' then 0.086911371989296
    when @Lead_Time2 = '96' then 0.0872780081070604
    when @Lead_Time2 = '97' then 0.0875528970078615
    when @Lead_Time2 = '98' then 0.0878277103655201
    when @Lead_Time2 = '99' then 0.0881024482215453
    when @Lead_Time2 = '100' then 0.0882855648673608
    when @Lead_Time2 = '101' then 0.0885601769794802
    when @Lead_Time2 = '102' then 0.088743209834389
    when @Lead_Time2 = '103' then 0.0890176963176525
    when @Lead_Time2 = '104' then 0.0892921074787614
    when @Lead_Time2 = '105' then 0.0895664433590433
    when @Lead_Time2 = '106' then 0.0899321075006076
    when @Lead_Time2 = '107' then 0.0903889997276809
    when @Lead_Time2 = '108' then 0.0908456832995768
    when @Lead_Time2 = '109' then 0.0913934284292105
    when @Lead_Time2 = '110' then 0.0920320854464939
    when @Lead_Time2 = '111' then 0.0927614800813111
    when @Lead_Time2 = '112' then 0.0935814136215302
    when @Lead_Time2 = '113' then 0.0944916630927172
    when @Lead_Time2 = '114' then 0.0954919814592205
    when @Lead_Time2 = '115' then 0.0964913001887612
    when @Lead_Time2 = '116' then 0.0976710271734458
    when @Lead_Time2 = '117' then 0.0989399478549036
    when @Lead_Time2 = '118' then 0.100207260417026
    when @Lead_Time2 = '119' then 0.101653653726499
    when @Lead_Time2 = '120' then 0.103097958003567
    when @Lead_Time2 = '121' then 0.104630249078083
    when @Lead_Time2 = '122' then 0.106160195828391
    when @Lead_Time2 = '123' then 0.107777592173431
    when @Lead_Time2 = '124' then 0.109482010616997
    when @Lead_Time2 = '125' then 0.111094047505587
    when @Lead_Time2 = '126' then 0.112792827475122
    when @Lead_Time2 = '127' then 0.114488726484698
    when @Lead_Time2 = '128' then 0.11618175428941
    when @Lead_Time2 = '129' then 0.117783035656384
    when @Lead_Time2 = '130' then 0.119470499976167
    when @Lead_Time2 = '131' then 0.121066527979444
    when @Lead_Time2 = '132' then 0.12257155238818
    when @Lead_Time2 = '133' then 0.124074315101927
    when @Lead_Time2 = '134' then 0.125486620041416
    when @Lead_Time2 = '135' then 0.126808846863696
    when @Lead_Time2 = '136' then 0.128041349880884
    when @Lead_Time2 = '137' then 0.129184458380826
    when @Lead_Time2 = '138' then 0.130238476923729
    when @Lead_Time2 = '139' then 0.131115977857537
    when @Lead_Time2 = '140' then 0.131992709458497
    when @Lead_Time2 = '141' then 0.132693541725465
    when @Lead_Time2 = '142' then 0.133306367308225
    when @Lead_Time2 = '143' then 0.133743870049596
    when @Lead_Time2 = '144' then 0.134093734480699
    when @Lead_Time2 = '145' then 0.134356052499078
    when @Lead_Time2 = '146' then 0.134356052499078
    when @Lead_Time2 = '147' then 0.134356052499078
    when @Lead_Time2 = '148' then 0.134356052499078
    when @Lead_Time2 = '149' then 0.134356052499078
    when @Lead_Time2 = '150' then 0.134356052499078
    when @Lead_Time2 = '151' then 0.134356052499078
    when @Lead_Time2 = '152' then 0.134356052499078
    when @Lead_Time2 = '153' then 0.134356052499078
    when @Lead_Time2 = '154' then 0.134356052499078
    when @Lead_Time2 = '155' then 0.134356052499078
    when @Lead_Time2 = '156' then 0.134356052499078
    when @Lead_Time2 = '157' then 0.134356052499078
    when @Lead_Time2 = '158' then 0.134356052499078
    when @Lead_Time2 = '159' then 0.134356052499078
    when @Lead_Time2 = '160' then 0.134356052499078
    when @Lead_Time2 = '161' then 0.134356052499078
    when @Lead_Time2 = '162' then 0.134356052499078
    when @Lead_Time2 = '163' then 0.134356052499078
    when @Lead_Time2 = '164' then 0.134356052499078
    when @Lead_Time2 = '165' then 0.134356052499078
    when @Lead_Time2 = '166' then 0.134356052499078
    when @Lead_Time2 = '167' then 0.134356052499078
    when @Lead_Time2 = '168' then 0.134356052499078
    when @Lead_Time2 = '169' then 0.134356052499078
    when @Lead_Time2 = '170' then 0.134356052499078
    when @Lead_Time2 = '171' then 0.134356052499078
    when @Lead_Time2 = '172' then 0.134356052499078
    when @Lead_Time2 = '173' then 0.134356052499078
    when @Lead_Time2 = '174' then 0.134356052499078
    when @Lead_Time2 = '175' then 0.134356052499078
    when @Lead_Time2 = '176' then 0.134356052499078
    when @Lead_Time2 = '177' then 0.136103082992341
    when @Lead_Time2 = '178' then 0.138717919311823
    when @Lead_Time2 = '179' then 0.141586364061871
    when @Lead_Time2 = '180' then 0.144706220999258
    when @Lead_Time2 = '181' then 0.148075118065363
    when @Lead_Time2 = '188' then 0.151690513240433
    when @Lead_Time2 = '195' then 0.155464102624072
    when @Lead_Time2 = '202' then 0.159479314545322
    when @Lead_Time2 = '209' then 0.163733191982602
    when @Lead_Time2 = '216' then 0.16805358499625
    when @Lead_Time2 = '223' then 0.172523714313844
    when @Lead_Time2 = '230' then 0.177141496752412
    when @Lead_Time2 = '237' then 0.181821431752272
    when @Lead_Time2 = '244' then 0.186562551051209
    when @Lead_Time2 = '251' then 0.191363884778184
    when @Lead_Time2 = '258' then 0.196142275811266
    when @Lead_Time2 = '265' then 0.20089794236689
    when @Lead_Time2 = '272' then 0.205631099562911
    when @Lead_Time2 = '279' then 0.210260925483196
    when @Lead_Time2 = '286' then 0.214788746931456
    when @Lead_Time2 = '293' then 0.21921584797623
    when @Lead_Time2 = '300' then 0.223463500125129
    when @Lead_Time2 = '307' then 0.227454246901295
    when @Lead_Time2 = '314' then 0.231349787861309
    when @Lead_Time2 = '321' then 0.234993067671359
    when @Lead_Time2 = '328' then 0.238307987833982
    when @Lead_Time2 = '335' then 0.241454871085463
    when @Lead_Time2 = '342' then 0.244278623844168
    when @Lead_Time2 = '349' then 0.246860077931526
    when @Lead_Time2 = '356' then 0.249123140273158
    when @Lead_Time2 = '363' then 0.251069953955048
    when @Lead_Time2 = '370' then 0.252780020442517
    when @Lead_Time2 = '377' then 0.254176993894383
    when @Lead_Time2 = '384' then 0.25526218119567
    when @Lead_Time2 = '391' then 0.25619140536041
    when @Lead_Time2 = '398' then 0.256810408784694
    when @Lead_Time2 = '405' then 0.257197091439061
    when @Lead_Time2 = '412' then 0.25742902928076
    when @Lead_Time2 = '419' then 0.25750632994172
    when @Lead_Time2 = '426' then 0.25750632994172
    when @Lead_Time2 = '433' then 0.25750632994172
    when @Lead_Time2 = '440' then 0.25750632994172
    when @Lead_Time2 = '447' then 0.25750632994172
    when @Lead_Time2 = '454' then 0.25750632994172
    when @Lead_Time2 = '461' then 0.25750632994172
    when @Lead_Time2 = '468' then 0.25750632994172
    when @Lead_Time2 = '475' then 0.25750632994172
    when @Lead_Time2 = '482' then 0.25750632994172
    when @Lead_Time2 = '489' then 0.25750632994172
    when @Lead_Time2 = '496' then 0.25750632994172
    when @Lead_Time2 = '503' then 0.25750632994172
    when @Lead_Time2 = '510' then 0.25750632994172
    when @Lead_Time2 = '517' then 0.25750632994172
    when @Lead_Time2 = '524' then 0.25750632994172
    when @Lead_Time2 = '531' then 0.25750632994172
    when @Lead_Time2 = '538' then 0.25750632994172
    when @Lead_Time2 = '545' then 0.25750632994172
    when @Lead_Time2 = '552' then 0.25750632994172
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then 0.0159663037644356
    when @OldestAge2 = '12' then 0.69333973020834
    when @OldestAge2 = '13' then -0.65112334247622
    when @OldestAge2 = '14' then -0.65112334247622
    when @OldestAge2 = '15' then -0.65112334247622
    when @OldestAge2 = '16' then -0.65112334247622
    when @OldestAge2 = '17' then 0.340727374457638
    when @OldestAge2 = '18' then 0.346354510869149
    when @OldestAge2 = '19' then 0.352170910290195
    when @OldestAge2 = '20' then 0.358142930087961
    when @OldestAge2 = '21' then 0.363926903560634
    when @OldestAge2 = '22' then 0.369050196791071
    when @OldestAge2 = '23' then 0.373199296764822
    when @OldestAge2 = '24' then 0.376414954406763
    when @OldestAge2 = '25' then 0.379065311250541
    when @OldestAge2 = '26' then 0.381617004704566
    when @OldestAge2 = '27' then 0.384345301765641
    when @OldestAge2 = '28' then 0.387142046386174
    when @OldestAge2 = '29' then 0.389494449127707
    when @OldestAge2 = '30' then 0.390594412758706
    when @OldestAge2 = '31' then 0.389484415016444
    when @OldestAge2 = '32' then 0.385177320661751
    when @OldestAge2 = '33' then 0.376753282985875
    when @OldestAge2 = '34' then 0.363471447700527
    when @OldestAge2 = '35' then 0.344912648197376
    when @OldestAge2 = '36' then 0.321119808976888
    when @OldestAge2 = '37' then 0.29267058010135
    when @OldestAge2 = '38' then 0.260629805362592
    when @OldestAge2 = '39' then 0.226381427245058
    when @OldestAge2 = '40' then 0.191399461586981
    when @OldestAge2 = '41' then 0.157046414365303
    when @OldestAge2 = '42' then 0.124463842316709
    when @OldestAge2 = '43' then 0.0945591091451528
    when @OldestAge2 = '44' then 0.0680402418703752
    when @OldestAge2 = '45' then 0.0454450037687559
    when @OldestAge2 = '46' then 0.0271473116773037
    when @OldestAge2 = '47' then 0.0133651577153539
    when @OldestAge2 = '48' then 0.0042012875753673
    when @OldestAge2 = '49' then -0.000282840417960408
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00516899101334629
    when @OldestAge2 = '52' then 0.0152944521226574
    when @OldestAge2 = '53' then 0.0302600073152427
    when @OldestAge2 = '54' then 0.0496443297601141
    when @OldestAge2 = '55' then 0.0727018075794339
    when @OldestAge2 = '56' then 0.0984712969081096
    when @OldestAge2 = '57' then 0.125971009159006
    when @OldestAge2 = '58' then 0.154391178750206
    when @OldestAge2 = '59' then 0.183202583598285
    when @OldestAge2 = '60' then 0.212147673082931
    when @OldestAge2 = '61' then 0.241142209247108
    when @OldestAge2 = '62' then 0.270157318035172
    when @OldestAge2 = '63' then 0.29915678912445
    when @OldestAge2 = '64' then 0.328128790440449
    when @OldestAge2 = '65' then 0.357190250963538
    when @OldestAge2 = '66' then 0.386687364017349
    when @OldestAge2 = '67' then 0.41720243969508
    when @OldestAge2 = '68' then 0.44942435060182
    when @OldestAge2 = '69' then 0.483928925320296
    when @OldestAge2 = '70' then 0.520990788011269
    when @OldestAge2 = '71' then 0.560546332800607
    when @OldestAge2 = '72' then 0.602335866162043
    when @OldestAge2 = '73' then 0.646133907934082
    when @OldestAge2 = '74' then 0.691921502466002
    when @OldestAge2 = '75' then 0.739903370218958
    when @OldestAge2 = '76' then 0.790386517759768
    when @OldestAge2 = '77' then 0.843631053329587
    when @OldestAge2 = '78' then 0.899787638353854
    when @OldestAge2 = '79' then 0.958942308196871
    when @OldestAge2 = '80' then 1.02117027128132
    when @OldestAge2 = '81' then 1.08646177754733
    when @OldestAge2 = '82' then 1.15447800406405
    when @OldestAge2 = '83' then 1.22426422636698
    when @OldestAge2 = '84' then 1.29414818771828
    when @OldestAge2 = '85' then 1.36197758527959
    when @OldestAge2 = '86' then 1.42564670208158
    when @OldestAge2 = '87' then 1.48369070584278
    when @OldestAge2 = '88' then 1.53570023660594
    when @OldestAge2 = '89' then 1.58240503645462
    when @OldestAge2 = '90' then 1.62540421619854
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.692863397615188
    when @Traveller_Count2 = '3' then 1.12350060047756
    when @Traveller_Count2 = '4' then 1.35950254945825
    when @Traveller_Count2 = '5' then 1.39519894539676
    when @Traveller_Count2 = '6' then 1.39519894539676
    when @Traveller_Count2 = '7' then 1.39519894539676
    when @Traveller_Count2 = '8' then 1.39519894539676
    when @Traveller_Count2 = '9' then 1.39519894539676
    when @Traveller_Count2 = '10' then 1.39519894539676
    when @Traveller_Count2 = '11' then 1.39519894539676
    when @Traveller_Count2 = '12' then 1.39519894539676
    when @Traveller_Count2 = '13' then 1.39519894539676
    when @Traveller_Count2 = '14' then 1.39519894539676
    when @Traveller_Count2 = '15' then 1.39519894539676
    when @Traveller_Count2 = '16' then 1.39519894539676
    when @Traveller_Count2 = '17' then 1.39519894539676
    when @Traveller_Count2 = '18' then 1.39519894539676
    when @Traveller_Count2 = '19' then 1.39519894539676
    when @Traveller_Count2 = '20' then 1.39519894539676
    when @Traveller_Count2 = '21' then 1.39519894539676
    when @Traveller_Count2 = '22' then 1.39519894539676
    when @Traveller_Count2 = '23' then 1.39519894539676
    when @Traveller_Count2 = '24' then 1.39519894539676
    when @Traveller_Count2 = '25' then 1.39519894539676
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then 0.366561014870298
    when @JV_Description = 'Air New Zealand' then -0.224630240812706
    when @JV_Description = 'Australia Post' then 0
    when @JV_Description = 'CBA White Label' then 0
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then 0
    when @JV_Description = 'Helloworld' then 0
    when @JV_Description = 'Indep + Others' then 0
    when @JV_Description = 'Insurance Australia Ltd' then 0.198044431254178
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then 0.366561014870298
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0.198044431254178
    when @JV_Description = 'Virgin' then -0.224630240812706
    when @JV_Description = 'Websales' then 0.198044431254178
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
    when @Product_Indicator = 'International AMT' then -1.94757328824706
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then -0.39845322133697
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then 1.16627093714192
    when @Excess = '25' then 1.06471073699243
    when @Excess = '50' then 0.951657875711446
    when @Excess = '60' then 0.900161349944272
    when @Excess = '100' then 0.672944473242426
    when @Excess = '150' then 0.494696241836107
    when @Excess = '200' then 0.27763173659828
    when @Excess = '250' then 0
    when @Excess = '300' then -0.0618754037180871
    when @Excess = '500' then -0.342490308946776
    when @Excess = '1000' then -0.400477566597125
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0.200200717683192
    when @Departure_Month = '2' then 0.0944840216181325
    when @Departure_Month = '3' then 0
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0.0944840216181325
    when @Departure_Month = '8' then 0.0944840216181325
    when @Departure_Month = '9' then 0
    when @Departure_Month = '10' then 0
    when @Departure_Month = '11' then 0
    when @Departure_Month = '12' then 0.0944840216181325
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.200688896848498
    when @EMCBand = '1_>50%' then 0.370407074046133
    when @EMCBand = '2_<50%' then 0.200688896848498
    when @EMCBand = '2_>50%' then 0.370407074046133
    when @EMCBand = '3_<50%' then 0.200688896848498
    when @EMCBand = '3_>50%' then 0.370407074046133
    when @EMCBand = '4_<50%' then 0.380285539732286
    when @EMCBand = '4_>50%' then 0.540335698523038
    when @EMCBand = '5_<50%' then 0.380285539732286
    when @EMCBand = '5_>50%' then 0.540335698523038
    when @EMCBand = '6_<50%' then 0.380285539732286
    when @EMCBand = '6_>50%' then 0.540335698523038
    when @EMCBand = '7_<50%' then 0.49612043952401
    when @EMCBand = '7_>50%' then 0.601116230525908
    when @EMCBand = '8_<50%' then 0.49612043952401
    when @EMCBand = '8_>50%' then 0.601116230525908
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'FF' then 0
    when @Gender = 'FM' then 0
    when @Gender = 'M' then -0.0669544731132605
    when @Gender = 'MM' then 0
    when @Gender = 'O' then 0
    when @Gender = 'U' then 0
end

-- Start of Latest_product
set @LinearPredictor = @LinearPredictor +
case
    when @Latest_product = 'FCO' then 0
    when @Latest_product = 'FCT' then 0.0996429141618717
    when @Latest_product = 'NCC' then 0.0996429141618717
    when @Latest_product = 'Y' then 0
end

-- Start of Return_Mth
set @LinearPredictor = @LinearPredictor +
case
    when @Return_Mth = '201706' then 0
    when @Return_Mth = '201707' then 0
    when @Return_Mth = '201708' then 0
    when @Return_Mth = '201709' then 0
    when @Return_Mth = '201710' then 0
    when @Return_Mth = '201711' then 0
    when @Return_Mth = '201712' then 0
    when @Return_Mth = '201801' then 0
    when @Return_Mth = '201802' then 0
    when @Return_Mth = '201803' then -0.115060249923107
    when @Return_Mth = '201804' then -0.115060249923107
    when @Return_Mth = '201805' then -0.115060249923107
    when @Return_Mth = '201806' then -0.115060249923107
    when @Return_Mth = '201807' then -0.115060249923107
    when @Return_Mth = '201808' then -0.115060249923107
    when @Return_Mth = '201809' then -0.115060249923107
    when @Return_Mth = '201810' then -0.115060249923107
    when @Return_Mth = '201811' then -0.115060249923107
    when @Return_Mth = '201812' then -0.115060249923107
    when @Return_Mth = '201901' then 0
    when @Return_Mth = '201902' then 0
    when @Return_Mth = '201903' then 0
    when @Return_Mth = '201904' then 0
    when @Return_Mth = '201905' then 0
    when @Return_Mth = '201906' then 0
    when @Return_Mth = '201907' then 0
    when @Return_Mth = '201908' then 0
    when @Return_Mth = '201909' then 0
    when @Return_Mth = '201910' then 0
    when @Return_Mth = '201911' then 0
    when @Return_Mth = '201912' then 0
    when @Return_Mth = '202001' then 0
    when @Return_Mth = '202002' then 0
    when @Return_Mth = '202003' then 0
    when @Return_Mth = '202004' then 0
    when @Return_Mth = '202005' then 0
    when @Return_Mth = '202006' then 0
    when @Return_Mth = '202007' then 0
    when @Return_Mth = '202008' then 0
    when @Return_Mth = '202009' then 0
    when @Return_Mth = '202010' then 0
    when @Return_Mth = '202011' then 0
    when @Return_Mth = '202012' then 0
    when @Return_Mth = '202101' then 0
    when @Return_Mth = '202102' then 0
    when @Return_Mth = '202103' then 0
    when @Return_Mth = '202104' then 0
    when @Return_Mth = '202105' then 0
    when @Return_Mth = '202106' then 0
    when @Return_Mth = '202107' then 0
    when @Return_Mth = '202108' then 0
    when @Return_Mth = '202109' then 0
    when @Return_Mth = '202110' then 0
    when @Return_Mth = '202111' then 0
    when @Return_Mth = '202112' then 0
    when @Return_Mth = '202201' then 0
    when @Return_Mth = '202202' then 0
    when @Return_Mth = '202203' then 0
    when @Return_Mth = '202204' then 0
    when @Return_Mth = '202205' then 0
    when @Return_Mth = '202206' then 0
    when @Return_Mth = '202207' then 0
    when @Return_Mth = '202208' then 0
    when @Return_Mth = '202209' then 0
    when @Return_Mth = '202210' then 0
    when @Return_Mth = '202211' then 0
    when @Return_Mth = '202212' then 0
    when @Return_Mth = '202301' then 0
    when @Return_Mth = '202302' then 0
    when @Return_Mth = '202303' then 0
    when @Return_Mth = '202304' then 0
    when @Return_Mth = '202305' then 0
    when @Return_Mth = '202306' then 0
    when @Return_Mth = '202307' then 0
    when @Return_Mth = '202308' then 0
    when @Return_Mth = '202309' then 0
    when @Return_Mth = '202310' then 0
    when @Return_Mth = '202311' then 0
    when @Return_Mth = '202312' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

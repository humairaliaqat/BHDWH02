USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Cancellation_Freq]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Cancellation_Freq] (
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
set @LinearPredictor = @LinearPredictor + -5.91236305635704

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.526955005695874
    when @Trip_Length2 = '2' then -0.326561510512699
    when @Trip_Length2 = '3' then -0.326561510512699
    when @Trip_Length2 = '4' then -0.326561510512699
    when @Trip_Length2 = '5' then -0.152685087665648
    when @Trip_Length2 = '6' then -0.0849045070904441
    when @Trip_Length2 = '7' then -0.0293258293818291
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.0162669724638719
    when @Trip_Length2 = '10' then 0.0542987734073793
    when @Trip_Length2 = '11' then 0.087003043621574
    when @Trip_Length2 = '12' then 0.116003675756306
    when @Trip_Length2 = '13' then 0.14210701662483
    when @Trip_Length2 = '14' then 0.165429689123736
    when @Trip_Length2 = '15' then 0.185566286958844
    when @Trip_Length2 = '16' then 0.202287569434833
    when @Trip_Length2 = '17' then 0.21559513355688
    when @Trip_Length2 = '18' then 0.22578007263534
    when @Trip_Length2 = '19' then 0.233648183959295
    when @Trip_Length2 = '20' then 0.24027595005451
    when @Trip_Length2 = '21' then 0.246938199879927
    when @Trip_Length2 = '22' then 0.254642218373581
    when @Trip_Length2 = '23' then 0.264285494645385
    when @Trip_Length2 = '24' then 0.276039560667707
    when @Trip_Length2 = '25' then 0.289754922612711
    when @Trip_Length2 = '26' then 0.304686671267604
    when @Trip_Length2 = '27' then 0.320342854691329
    when @Trip_Length2 = '28' then 0.336400805498642
    when @Trip_Length2 = '29' then 0.352486183317278
    when @Trip_Length2 = '30' then 0.36866280158406
    when @Trip_Length2 = '31' then 0.384513821355232
    when @Trip_Length2 = '32' then 0.3996482227866
    when @Trip_Length2 = '33' then 0.413697793034641
    when @Trip_Length2 = '34' then 0.426443514493356
    when @Trip_Length2 = '35' then 0.437996833110649
    when @Trip_Length2 = '36' then 0.448779992794109
    when @Trip_Length2 = '37' then 0.459195430529132
    when @Trip_Length2 = '38' then 0.464676967740011
    when @Trip_Length2 = '39' then 0.474742383592909
    when @Trip_Length2 = '40' then 0.484461114334662
    when @Trip_Length2 = '41' then 0.493842218725577
    when @Trip_Length2 = '42' then 0.502833773836438
    when @Trip_Length2 = '43' then 0.511505392670748
    when @Trip_Length2 = '44' then 0.519686252198187
    when @Trip_Length2 = '45' then 0.527564739770267
    when @Trip_Length2 = '46' then 0.53508887590167
    when @Trip_Length2 = '47' then 0.542208004994659
    when @Trip_Length2 = '48' then 0.54898808486034
    when @Trip_Length2 = '49' then 0.55549301526115
    when @Trip_Length2 = '50' then 0.56172784169311
    when @Trip_Length2 = '51' then 0.567810689248647
    when @Trip_Length2 = '52' then 0.573687740522617
    when @Trip_Length2 = '53' then 0.579586468336779
    when @Trip_Length2 = '54' then 0.585394918065715
    when @Trip_Length2 = '55' then 0.591335914413261
    when @Trip_Length2 = '56' then 0.597406908279109
    when @Trip_Length2 = '57' then 0.603714693228393
    when @Trip_Length2 = '58' then 0.610363219081024
    when @Trip_Length2 = '59' then 0.617399403121671
    when @Trip_Length2 = '60' then 0.624921871564379
    when @Trip_Length2 = '61' then 0.632919355009459
    when @Trip_Length2 = '62' then 0.641432744873266
    when @Trip_Length2 = '63' then 0.65044842602683
    when @Trip_Length2 = '64' then 0.65990058676631
    when @Trip_Length2 = '65' then 0.669878553620591
    when @Trip_Length2 = '66' then 0.68016325300165
    when @Trip_Length2 = '67' then 0.69084453149727
    when @Trip_Length2 = '68' then 0.70166083632515
    when @Trip_Length2 = '69' then 0.712557574079769
    when @Trip_Length2 = '70' then 0.723433873164818
    when @Trip_Length2 = '71' then 0.734193149995947
    when @Trip_Length2 = '72' then 0.744742929203595
    when @Trip_Length2 = '73' then 0.754853569995924
    when @Trip_Length2 = '74' then 0.764490620628081
    when @Trip_Length2 = '75' then 0.773620564709822
    when @Trip_Length2 = '76' then 0.782119134362209
    when @Trip_Length2 = '77' then 0.789910848992253
    when @Trip_Length2 = '78' then 0.797056643950457
    when @Trip_Length2 = '79' then 0.803480312244292
    when @Trip_Length2 = '80' then 0.809284418188987
    when @Trip_Length2 = '81' then 0.81439088784531
    when @Trip_Length2 = '82' then 0.818942476604253
    when @Trip_Length2 = '83' then 0.82294661809479
    when @Trip_Length2 = '84' then 0.826584818789662
    when @Trip_Length2 = '85' then 0.829861003875767
    when @Trip_Length2 = '86' then 0.833039549211836
    when @Trip_Length2 = '87' then 0.836121349511052
    when @Trip_Length2 = '88' then 0.839280089507907
    when @Trip_Length2 = '89' then 0.842644191705856
    when @Trip_Length2 = '90' then 0.846383156458803
    when @Trip_Length2 = '97' then 0.850620904384135
    when @Trip_Length2 = '104' then 0.855393572922849
    when @Trip_Length2 = '111' then 0.860862584964538
    when @Trip_Length2 = '118' then 0.86705846999393
    when @Trip_Length2 = '125' then 0.874051066266279
    when @Trip_Length2 = '132' then 0.881864904859138
    when @Trip_Length2 = '139' then 0.890480494974338
    when @Trip_Length2 = '146' then 0.899876756605901
    when @Trip_Length2 = '153' then 0.910031181703011
    when @Trip_Length2 = '160' then 0.920800547351983
    when @Trip_Length2 = '167' then 0.932164081030445
    when @Trip_Length2 = '174' then 0.943905898907128
    when @Trip_Length2 = '181' then 0.955934432478706
    when @Trip_Length2 = '188' then 0.968123880514172
    when @Trip_Length2 = '195' then 0.980316621638713
    when @Trip_Length2 = '202' then 0.992325418150153
    when @Trip_Length2 = '209' then 1.00404516606173
    when @Trip_Length2 = '216' then 1.01537559676431
    when @Trip_Length2 = '223' then 1.02611327785187
    when @Trip_Length2 = '230' then 1.03627578575232
    when @Trip_Length2 = '237' then 1.04566851017369
    when @Trip_Length2 = '244' then 1.05427718595892
    when @Trip_Length2 = '251' then 1.06205203335631
    when @Trip_Length2 = '258' then 1.06901181889182
    when @Trip_Length2 = '265' then 1.07513893248247
    when @Trip_Length2 = '272' then 1.08041437313302
    when @Trip_Length2 = '279' then 1.08491896153611
    when @Trip_Length2 = '286' then 1.08862929061471
    when @Trip_Length2 = '293' then 1.09172193796336
    when @Trip_Length2 = '300' then 1.09416909897073
    when @Trip_Length2 = '307' then 1.09604232246547
    when @Trip_Length2 = '314' then 1.09747831262691
    when @Trip_Length2 = '321' then 1.0984789464451
    when @Trip_Length2 = '328' then 1.09914547982977
    when @Trip_Length2 = '335' then 1.09954518671671
    when @Trip_Length2 = '342' then 1.09977827530808
    when @Trip_Length2 = '349' then 1.09977827530808
    when @Trip_Length2 = '356' then 1.09977827530808
    when @Trip_Length2 = '363' then 1.09977827530808
    when @Trip_Length2 = '365' then 1.09977827530808
    when @Trip_Length2 = '370' then 1.09977827530808
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.0774195497320286
    when @Destination3 = 'Africa-SOUTH AFRICA' then -0.0637104645219937
    when @Destination3 = 'Asia Others' then 0.342590533163674
    when @Destination3 = 'Domestic' then -0.209369263927629
    when @Destination3 = 'East Asia' then 0
    when @Destination3 = 'East Asia-CHINA' then 0.156601578835782
    when @Destination3 = 'East Asia-HONG KONG' then -0.209369263927629
    when @Destination3 = 'East Asia-JAPAN' then 0
    when @Destination3 = 'Europe' then 0
    when @Destination3 = 'Europe-CROATIA' then 0
    when @Destination3 = 'Europe-ENGLAND' then -0.209369263927629
    when @Destination3 = 'Europe-FRANCE' then -0.0637104645219937
    when @Destination3 = 'Europe-GERMANY' then 0
    when @Destination3 = 'Europe-GREECE' then 0.156601578835782
    when @Destination3 = 'Europe-ITALY' then 0.0774195497320286
    when @Destination3 = 'Europe-NETHERLANDS' then -0.0637104645219937
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then -0.209369263927629
    when @Destination3 = 'Europe-SCOTLAND' then -0.0637104645219937
    when @Destination3 = 'Europe-SPAIN' then 0
    when @Destination3 = 'Europe-SWITZERLAND' then 0
    when @Destination3 = 'Europe-UNITED KINGDOM' then -0.209369263927629
    when @Destination3 = 'Mid East' then 0
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then 0
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then -0.0637104645219937
    when @Destination3 = 'Pacific Region' then 0
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then -0.0637104645219937
    when @Destination3 = 'Pacific Region-FIJI' then 0.0774195497320286
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then -0.0637104645219937
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0.156601578835782
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then -0.209369263927629
    when @Destination3 = 'Pacific Region-VANUATU' then -0.0637104645219937
    when @Destination3 = 'SEA-INDONESIA' then -0.0637104645219937
    when @Destination3 = 'SEA-MALAYSIA' then -0.0637104645219937
    when @Destination3 = 'SEA-PHILIPPINES' then -0.209369263927629
    when @Destination3 = 'SEA-SINGAPORE' then 0
    when @Destination3 = 'South America' then 0.342590533163674
    when @Destination3 = 'South Asia' then 0.156601578835782
    when @Destination3 = 'South Asia-CAMBODIA' then 0.342590533163674
    when @Destination3 = 'South Asia-INDIA' then 0.156601578835782
    when @Destination3 = 'South Asia-NEPAL' then 0.850731098081729
    when @Destination3 = 'South Asia-SRI LANKA' then -0.0637104645219937
    when @Destination3 = 'South Asia-THAILAND' then -0.0637104645219937
    when @Destination3 = 'South Asia-VIETNAM' then 0
    when @Destination3 = 'World Others' then 0
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0.19062035960865
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then 0.0813034510640352
    when @Lead_Time2 = '3' then 0.156063135631587
    when @Lead_Time2 = '4' then 0.224742272677907
    when @Lead_Time2 = '5' then 0.287807064639931
    when @Lead_Time2 = '6' then 0.345785872606563
    when @Lead_Time2 = '7' then 0.39891033913749
    when @Lead_Time2 = '8' then 0.447566284126799
    when @Lead_Time2 = '9' then 0.492070847282343
    when @Lead_Time2 = '10' then 0.532567545884395
    when @Lead_Time2 = '11' then 0.569452958213614
    when @Lead_Time2 = '12' then 0.602784740479554
    when @Lead_Time2 = '13' then 0.632919355009459
    when @Lead_Time2 = '14' then 0.660003961966691
    when @Lead_Time2 = '15' then 0.684308231892741
    when @Lead_Time2 = '16' then 0.706063405826492
    when @Lead_Time2 = '17' then 0.725565966815446
    when @Lead_Time2 = '18' then 0.743127112864966
    when @Lead_Time2 = '19' then 0.759075360674052
    when @Lead_Time2 = '20' then 0.773758957052333
    when @Lead_Time2 = '21' then 0.787593350851891
    when @Lead_Time2 = '22' then 0.800969663088691
    when @Lead_Time2 = '23' then 0.814169408807395
    when @Lead_Time2 = '24' then 0.8275469460396
    when @Lead_Time2 = '25' then 0.841351645209661
    when @Lead_Time2 = '26' then 0.855691109745226
    when @Lead_Time2 = '27' then 0.8706236856907
    when @Lead_Time2 = '28' then 0.886078916465916
    when @Lead_Time2 = '29' then 0.90186721120843
    when @Lead_Time2 = '30' then 0.917809577843425
    when @Lead_Time2 = '31' then 0.933541085280683
    when @Lead_Time2 = '32' then 0.948835363349882
    when @Lead_Time2 = '33' then 0.963326977875584
    when @Lead_Time2 = '34' then 0.976783580302977
    when @Lead_Time2 = '35' then 0.989094997428759
    when @Lead_Time2 = '36' then 1.00015382488115
    when @Lead_Time2 = '37' then 1.00989035860731
    when @Lead_Time2 = '38' then 1.01848624418882
    when @Lead_Time2 = '39' then 1.02600575289702
    when @Lead_Time2 = '40' then 1.03265053299035
    when @Lead_Time2 = '41' then 1.03864994749543
    when @Lead_Time2 = '42' then 1.04426169391803
    when @Lead_Time2 = '43' then 1.04973712088597
    when @Lead_Time2 = '44' then 1.05521754301559
    when @Lead_Time2 = '45' then 1.0609104214841
    when @Lead_Time2 = '46' then 1.06701841707693
    when @Lead_Time2 = '47' then 1.07356794756185
    when @Lead_Time2 = '48' then 1.08071983582652
    when @Lead_Time2 = '49' then 1.08846093761173
    when @Lead_Time2 = '50' then 1.09687745137439
    when @Lead_Time2 = '51' then 1.10591886385055
    when @Lead_Time2 = '52' then 1.11563327300241
    when @Lead_Time2 = '53' then 1.12587071243894
    when @Lead_Time2 = '54' then 1.1366464006527
    when @Lead_Time2 = '55' then 1.14781506611367
    when @Lead_Time2 = '56' then 1.15923691048454
    when @Lead_Time2 = '57' then 1.17071587242448
    when @Lead_Time2 = '58' then 1.18209522580662
    when @Lead_Time2 = '59' then 1.19322525577917
    when @Lead_Time2 = '60' then 1.20396280427594
    when @Lead_Time2 = '61' then 1.21414093324156
    when @Lead_Time2 = '62' then 1.22377543162212
    when @Lead_Time2 = '63' then 1.23282261742999
    when @Lead_Time2 = '64' then 1.24132639086729
    when @Lead_Time2 = '65' then 1.24938584385243
    when @Lead_Time2 = '66' then 1.25709642264821
    when @Lead_Time2 = '67' then 1.26455036621154
    when @Lead_Time2 = '68' then 1.27183703914207
    when @Lead_Time2 = '69' then 1.27895967584872
    when @Lead_Time2 = '70' then 1.28600430227517
    when @Lead_Time2 = '71' then 1.29286241632734
    when @Lead_Time2 = '72' then 1.29948296413293
    when @Lead_Time2 = '73' then 1.30578904646024
    when @Lead_Time2 = '74' then 1.3116785677391
    when @Lead_Time2 = '75' then 1.31707825043121
    when @Lead_Time2 = '76' then 1.3218625009605
    when @Lead_Time2 = '77' then 1.32601343023496
    when @Lead_Time2 = '78' then 1.32959172575009
    when @Lead_Time2 = '79' then 1.33260345792197
    when @Lead_Time2 = '80' then 1.33518526029398
    when @Lead_Time2 = '81' then 1.33747169642232
    when @Lead_Time2 = '82' then 1.33964814704612
    when @Lead_Time2 = '83' then 1.34184600763415
    when @Lead_Time2 = '84' then 1.34424765861755
    when @Lead_Time2 = '85' then 1.34692963759761
    when @Lead_Time2 = '86' then 1.34991560577618
    when @Lead_Time2 = '87' then 1.35317698465706
    when @Lead_Time2 = '88' then 1.35660805074953
    when @Lead_Time2 = '89' then 1.36002738486917
    when @Lead_Time2 = '90' then 1.36330716847388
    when @Lead_Time2 = '91' then 1.3662957146132
    when @Lead_Time2 = '92' then 1.36919906569125
    when @Lead_Time2 = '93' then 1.37189113080915
    when @Lead_Time2 = '94' then 1.3743735902242
    when @Lead_Time2 = '95' then 1.37659749814103
    when @Lead_Time2 = '96' then 1.37856456305795
    when @Lead_Time2 = '97' then 1.38030143938348
    when @Lead_Time2 = '98' then 1.38175909231813
    when @Lead_Time2 = '99' then 1.38301398656975
    when @Lead_Time2 = '100' then 1.38406688212954
    when @Lead_Time2 = '101' then 1.38494344904893
    when @Lead_Time2 = '102' then 1.38574420981441
    when @Lead_Time2 = '103' then 1.38644434987102
    when @Lead_Time2 = '104' then 1.38716897853055
    when @Lead_Time2 = '105' then 1.38791804223599
    when @Lead_Time2 = '106' then 1.38879124131848
    when @Lead_Time2 = '107' then 1.38983807474326
    when @Lead_Time2 = '108' then 1.39110775811542
    when @Lead_Time2 = '109' then 1.3926491267579
    when @Lead_Time2 = '110' then 1.39451051589123
    when @Lead_Time2 = '111' then 1.39671487844777
    when @Lead_Time2 = '112' then 1.39928462115814
    when @Lead_Time2 = '113' then 1.40224152644934
    when @Lead_Time2 = '114' then 1.40563119367603
    when @Lead_Time2 = '115' then 1.40937592056321
    when @Lead_Time2 = '116' then 1.41352034737348
    when @Lead_Time2 = '117' then 1.41801102767146
    when @Lead_Time2 = '118' then 1.42284323886697
    when @Lead_Time2 = '119' then 1.42794001633852
    when @Lead_Time2 = '120' then 1.43332106654765
    when @Lead_Time2 = '121' then 1.43886309179267
    when @Lead_Time2 = '122' then 1.44458685387141
    when @Lead_Time2 = '123' then 1.45039528652641
    when @Lead_Time2 = '124' then 1.45626342264493
    when @Lead_Time2 = '125' then 1.46214367340333
    when @Lead_Time2 = '126' then 1.46796650976392
    when @Lead_Time2 = '127' then 1.47370982312284
    when @Lead_Time2 = '128' then 1.47935200587092
    when @Lead_Time2 = '129' then 1.48482661718414
    when @Lead_Time2 = '130' then 1.49011368975889
    when @Lead_Time2 = '131' then 1.4952160283438
    when @Lead_Time2 = '132' then 1.50009168659793
    when @Lead_Time2 = '133' then 1.50472163365557
    when @Lead_Time2 = '134' then 1.5091091606373
    when @Lead_Time2 = '135' then 1.51327937287438
    when @Lead_Time2 = '136' then 1.51719103592166
    when @Lead_Time2 = '137' then 1.52086895941611
    when @Lead_Time2 = '138' then 1.52433743578363
    when @Lead_Time2 = '139' then 1.52762029721033
    when @Lead_Time2 = '140' then 1.53074096548492
    when @Lead_Time2 = '141' then 1.53372249518632
    when @Lead_Time2 = '142' then 1.53658761061984
    when @Lead_Time2 = '143' then 1.53938018847866
    when @Lead_Time2 = '144' then 1.54214359758273
    when @Lead_Time2 = '145' then 1.54489939129653
    when @Lead_Time2 = '146' then 1.54769016014269
    when @Lead_Time2 = '147' then 1.55055801769581
    when @Lead_Time2 = '148' then 1.5534811292879
    when @Lead_Time2 = '149' then 1.55652225008749
    when @Lead_Time2 = '150' then 1.55965925987095
    when @Lead_Time2 = '151' then 1.56291218249717
    when @Lead_Time2 = '152' then 1.5662798581163
    when @Lead_Time2 = '153' then 1.56971947543685
    when @Lead_Time2 = '154' then 1.57325099267233
    when @Lead_Time2 = '155' then 1.57679074610185
    when @Lead_Time2 = '156' then 1.58035919493343
    when @Lead_Time2 = '157' then 1.5838944379634
    when @Lead_Time2 = '158' then 1.5873558892879
    when @Lead_Time2 = '159' then 1.59070351437785
    when @Lead_Time2 = '160' then 1.59389778775237
    when @Lead_Time2 = '161' then 1.59691988787513
    when @Lead_Time2 = '162' then 1.59973095196396
    when @Lead_Time2 = '163' then 1.60231258749151
    when @Lead_Time2 = '164' then 1.60466654755521
    when @Lead_Time2 = '165' then 1.60679442148868
    when @Lead_Time2 = '166' then 1.60867762348769
    when @Lead_Time2 = '167' then 1.61035748949348
    when @Lead_Time2 = '168' then 1.61187494046752
    when @Lead_Time2 = '169' then 1.6132307106728
    when @Lead_Time2 = '170' then 1.61450505276712
    when @Lead_Time2 = '171' then 1.61573802498258
    when @Lead_Time2 = '172' then 1.61696947884945
    when @Lead_Time2 = '173' then 1.61825889293988
    when @Lead_Time2 = '174' then 1.61966543258954
    when @Lead_Time2 = '175' then 1.62124789919346
    when @Lead_Time2 = '176' then 1.62302518594262
    when @Lead_Time2 = '177' then 1.62503563305715
    when @Lead_Time2 = '178' then 1.62733676792186
    when @Lead_Time2 = '179' then 1.62992657886142
    when @Lead_Time2 = '180' then 1.63284189021312
    when @Lead_Time2 = '181' then 1.63606036899421
    when @Lead_Time2 = '188' then 1.63957906934609
    when @Lead_Time2 = '195' then 1.64339479591228
    when @Lead_Time2 = '202' then 1.647484860071
    when @Lead_Time2 = '209' then 1.65178833830783
    when @Lead_Time2 = '216' then 1.65630241418138
    when @Lead_Time2 = '223' then 1.66100516929051
    when @Lead_Time2 = '230' then 1.66579934209985
    when @Lead_Time2 = '237' then 1.67070232953787
    when @Lead_Time2 = '244' then 1.6756375531483
    when @Lead_Time2 = '251' then 1.68058579355223
    when @Lead_Time2 = '258' then 1.6854911342195
    when @Lead_Time2 = '265' then 1.69031719315972
    when @Lead_Time2 = '272' then 1.69504663950344
    when @Lead_Time2 = '279' then 1.69962590529946
    when @Lead_Time2 = '286' then 1.70402055492005
    when @Lead_Time2 = '293' then 1.70821480351771
    when @Lead_Time2 = '300' then 1.71215694243847
    when @Lead_Time2 = '307' then 1.71579593042102
    when @Lead_Time2 = '314' then 1.71909916664362
    when @Lead_Time2 = '321' then 1.72203418673649
    when @Lead_Time2 = '328' then 1.72455071953461
    when @Lead_Time2 = '335' then 1.72661632089585
    when @Lead_Time2 = '342' then 1.72814496549932
    when @Lead_Time2 = '349' then 1.72912136337911
    when @Lead_Time2 = '356' then 1.72949391849053
    when @Lead_Time2 = '363' then 1.72949391849053
    when @Lead_Time2 = '370' then 1.72949391849053
    when @Lead_Time2 = '377' then 1.72949391849053
    when @Lead_Time2 = '384' then 1.72949391849053
    when @Lead_Time2 = '391' then 1.72949391849053
    when @Lead_Time2 = '398' then 1.72949391849053
    when @Lead_Time2 = '405' then 1.72949391849053
    when @Lead_Time2 = '412' then 1.72949391849053
    when @Lead_Time2 = '419' then 1.72949391849053
    when @Lead_Time2 = '426' then 1.72949391849053
    when @Lead_Time2 = '433' then 1.72949391849053
    when @Lead_Time2 = '440' then 1.72949391849053
    when @Lead_Time2 = '447' then 1.72949391849053
    when @Lead_Time2 = '454' then 1.72949391849053
    when @Lead_Time2 = '461' then 1.72949391849053
    when @Lead_Time2 = '468' then 1.72949391849053
    when @Lead_Time2 = '475' then 1.72949391849053
    when @Lead_Time2 = '482' then 1.72949391849053
    when @Lead_Time2 = '489' then 1.72949391849053
    when @Lead_Time2 = '496' then 1.72949391849053
    when @Lead_Time2 = '503' then 1.72949391849053
    when @Lead_Time2 = '510' then 1.72949391849053
    when @Lead_Time2 = '517' then 1.72949391849053
    when @Lead_Time2 = '524' then 1.72949391849053
    when @Lead_Time2 = '531' then 1.72949391849053
    when @Lead_Time2 = '538' then 1.72949391849053
    when @Lead_Time2 = '545' then 1.72949391849053
    when @Lead_Time2 = '552' then 1.72949391849053
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then -0.0367104824665381
    when @OldestAge2 = '12' then -0.0182813469981706
    when @OldestAge2 = '13' then -0.592272000073921
    when @OldestAge2 = '14' then -0.537944045821179
    when @OldestAge2 = '15' then -0.486631482835882
    when @OldestAge2 = '16' then -0.43837707358368
    when @OldestAge2 = '17' then -0.393369519388931
    when @OldestAge2 = '18' then -0.351797985942094
    when @OldestAge2 = '19' then -0.313650092999332
    when @OldestAge2 = '20' then -0.278562511077411
    when @OldestAge2 = '21' then -0.245800823093601
    when @OldestAge2 = '22' then -0.214385346279476
    when @OldestAge2 = '23' then -0.183322652064639
    when @OldestAge2 = '24' then -0.151867124989801
    when @OldestAge2 = '25' then -0.11973019385493
    when @OldestAge2 = '26' then -0.0871762130636932
    when @OldestAge2 = '27' then -0.0549839580713307
    when @OldestAge2 = '28' then -0.0242952326178649
    when @OldestAge2 = '29' then 0.00359902331379385
    when @OldestAge2 = '30' then 0.027477564449617
    when @OldestAge2 = '31' then 0.04636685390631
    when @OldestAge2 = '32' then 0.059654328291736
    when @OldestAge2 = '33' then 0.0671353448298398
    when @OldestAge2 = '34' then 0.0690083686814571
    when @OldestAge2 = '35' then 0.0658391690113893
    when @OldestAge2 = '36' then 0.0585099660393266
    when @OldestAge2 = '37' then 0.0481565074677457
    when @OldestAge2 = '38' then 0.0360824917419623
    when @OldestAge2 = '39' then 0.0236371343993326
    when @OldestAge2 = '40' then 0.0120556290326786
    when @OldestAge2 = '41' then 0.00229034497519018
    when @OldestAge2 = '42' then -0.00511427752848184
    when @OldestAge2 = '43' then -0.0100502352321649
    when @OldestAge2 = '44' then -0.0127587686641464
    when @OldestAge2 = '45' then -0.0136593226644477
    when @OldestAge2 = '46' then -0.0131628832025816
    when @OldestAge2 = '47' then -0.0115380250201262
    when @OldestAge2 = '48' then -0.00886508804687301
    when @OldestAge2 = '49' then -0.00507015780542022
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00650595732023982
    when @OldestAge2 = '52' then 0.0145730326231952
    when @OldestAge2 = '53' then 0.0242794552021692
    when @OldestAge2 = '54' then 0.0356602550685691
    when @OldestAge2 = '55' then 0.0487121801845242
    when @OldestAge2 = '56' then 0.0633971429888982
    when @OldestAge2 = '57' then 0.0796533020848419
    when @OldestAge2 = '58' then 0.0974235721457618
    when @OldestAge2 = '59' then 0.116700127290696
    when @OldestAge2 = '60' then 0.137568694244713
    when @OldestAge2 = '61' then 0.160229217571138
    when @OldestAge2 = '62' then 0.184975748271692
    when @OldestAge2 = '63' then 0.21213573428483
    when @OldestAge2 = '64' then 0.241987829834573
    when @OldestAge2 = '65' then 0.27468733120186
    when @OldestAge2 = '66' then 0.310223908035205
    when @OldestAge2 = '67' then 0.348420695429045
    when @OldestAge2 = '68' then 0.38896733550912
    when @OldestAge2 = '69' then 0.431471829186798
    when @OldestAge2 = '70' then 0.475519551054242
    when @OldestAge2 = '71' then 0.520736129363731
    when @OldestAge2 = '72' then 0.566855031829446
    when @OldestAge2 = '73' then 0.613785604707929
    when @OldestAge2 = '74' then 0.66166508970221
    when @OldestAge2 = '75' then 0.710866211675265
    when @OldestAge2 = '76' then 0.761929270031419
    when @OldestAge2 = '77' then 0.815401551739149
    when @OldestAge2 = '78' then 0.871599769922674
    when @OldestAge2 = '79' then 0.930354696537205
    when @OldestAge2 = '80' then 0.990829299127927
    when @OldestAge2 = '81' then 1.05149604523919
    when @OldestAge2 = '82' then 1.11030736276819
    when @OldestAge2 = '83' then 1.16502010977963
    when @OldestAge2 = '84' then 1.21358222172246
    when @OldestAge2 = '85' then 1.25448292628444
    when @OldestAge2 = '86' then 1.28699917610189
    when @OldestAge2 = '87' then 1.31131324746923
    when @OldestAge2 = '88' then 1.32850693751907
    when @OldestAge2 = '89' then 1.34044849254
    when @OldestAge2 = '90' then 1.34958387865335
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.182144008624663
    when @Traveller_Count2 = '3' then 0.223732867801847
    when @Traveller_Count2 = '4' then 0.223732867801847
    when @Traveller_Count2 = '5' then 0.223732867801847
    when @Traveller_Count2 = '6' then 0.223732867801847
    when @Traveller_Count2 = '7' then 0.223732867801847
    when @Traveller_Count2 = '8' then 0.223732867801847
    when @Traveller_Count2 = '9' then 0.223732867801847
    when @Traveller_Count2 = '10' then 0.223732867801847
    when @Traveller_Count2 = '11' then 0.223732867801847
    when @Traveller_Count2 = '12' then 0.223732867801847
    when @Traveller_Count2 = '13' then 0.223732867801847
    when @Traveller_Count2 = '14' then 0.223732867801847
    when @Traveller_Count2 = '15' then 0.223732867801847
    when @Traveller_Count2 = '16' then 0.223732867801847
    when @Traveller_Count2 = '17' then 0.223732867801847
    when @Traveller_Count2 = '18' then 0.223732867801847
    when @Traveller_Count2 = '19' then 0.223732867801847
    when @Traveller_Count2 = '20' then 0.223732867801847
    when @Traveller_Count2 = '21' then 0.223732867801847
    when @Traveller_Count2 = '22' then 0.223732867801847
    when @Traveller_Count2 = '23' then 0.223732867801847
    when @Traveller_Count2 = '24' then 0.223732867801847
    when @Traveller_Count2 = '25' then 0.223732867801847
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then -0.458051763545978
    when @JV_Description = 'AHM - Medibank' then -0.334626427265734
    when @JV_Description = 'Air New Zealand' then 0
    when @JV_Description = 'Australia Post' then -0.458051763545978
    when @JV_Description = 'CBA White Label' then -0.458051763545978
    when @JV_Description = 'Coles' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0
    when @JV_Description = 'Gold Coast Suns' then 0
    when @JV_Description = 'HIF' then -0.334626427265734
    when @JV_Description = 'Helloworld' then -0.0703143367927543
    when @JV_Description = 'Indep + Others' then 0
    when @JV_Description = 'Insurance Australia Ltd' then -0.334626427265734
    when @JV_Description = 'Integration' then 0
    when @JV_Description = 'Medibank' then -0.334626427265734
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then -0.458051763545978
    when @JV_Description = 'Phone Sales' then -0.0703143367927543
    when @JV_Description = 'Virgin' then -0.458051763545978
    when @JV_Description = 'Websales' then -0.334626427265734
    when @JV_Description = 'YouGo' then 0
end

-- Start of Product_Indicator
set @LinearPredictor = @LinearPredictor +
case
    when @Product_Indicator  = 'Car Hire' then 0
    when @Product_Indicator  = 'Corporate' then 0
    when @Product_Indicator  = 'Domestic AMT' then 0
    when @Product_Indicator  = 'Domestic Cancellation' then 0
    when @Product_Indicator  = 'Domestic Inbound' then 0
    when @Product_Indicator  = 'Domestic Single Trip' then 0
    when @Product_Indicator  = 'Domestic Single Trip Integrated' then 0
    when @Product_Indicator  = 'International AMT' then 0.152365275376767
    when @Product_Indicator  = 'International Single Trip' then 0
    when @Product_Indicator  = 'International Single Trip Integrated' then -0.659574911284171
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then 0.231111720963387
    when @Excess = '25' then 0.22314355131421
    when @Excess = '50' then 0.207014169384326
    when @Excess = '60' then 0.207014169384326
    when @Excess = '100' then 0.182321556793955
    when @Excess = '150' then 0.122217632724249
    when @Excess = '200' then 0.0676586484738149
    when @Excess = '250' then 0
    when @Excess = '300' then -0.0618754037180871
    when @Excess = '500' then -0.356674943938732
    when @Excess = '1000' then -0.400477566597125
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0
    when @Departure_Month = '2' then 0.0595271428621568
    when @Departure_Month = '3' then 0.0595271428621568
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0.0595271428621568
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then 0
    when @Departure_Month = '9' then 0.0595271428621568
    when @Departure_Month = '10' then 0.0595271428621568
    when @Departure_Month = '11' then 0
    when @Departure_Month = '12' then -0.074748757581883
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand  = '0_<50%' then 0
    when @EMCBand  = '1_<50%' then 0.271124751091252
    when @EMCBand  = '1_>50%' then 0.271124751091252
    when @EMCBand  = '2_<50%' then 0.271124751091252
    when @EMCBand  = '2_>50%' then 0.271124751091252
    when @EMCBand  = '3_<50%' then 0.271124751091252
    when @EMCBand  = '3_>50%' then 0.271124751091252
    when @EMCBand  = '4_<50%' then 0.534997623252
    when @EMCBand  = '4_>50%' then 0.534997623252
    when @EMCBand  = '5_<50%' then 0.534997623252
    when @EMCBand  = '5_>50%' then 0.534997623252
    when @EMCBand  = '6_<50%' then 0.534997623252
    when @EMCBand  = '6_>50%' then 0.534997623252
    when @EMCBand  = '7_<50%' then 0.534997623252
    when @EMCBand  = '7_>50%' then 0.534997623252
    when @EMCBand  = '8_<50%' then 0.534997623252
    when @EMCBand  = '8_>50%' then 0.534997623252
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.061859201726409
    when @Gender = 'FF' then 0
    when @Gender = 'FM' then 0
    when @Gender = 'M' then -0.222003000650677
    when @Gender = 'MM' then 0
    when @Gender = 'O' then 0
    when @Gender = 'U' then 0
end

-- Start of Latest_product
set @LinearPredictor = @LinearPredictor +
case
    when @Latest_product = 'FCO' then -0.114403999113252
    when @Latest_product = 'FCT' then -0.114403999113252
    when @Latest_product = 'NCC' then 0
    when @Latest_product = 'Y' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

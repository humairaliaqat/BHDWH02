USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Additional_Freq]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Additional_Freq] (
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
set @LinearPredictor = @LinearPredictor + -6.66518453971584

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.963641282216496
    when @Trip_Length2 = '2' then -0.772917263570431
    when @Trip_Length2 = '3' then -0.61067614194279
    when @Trip_Length2 = '4' then -0.46752203617379
    when @Trip_Length2 = '5' then -0.337789609318763
    when @Trip_Length2 = '6' then -0.21795347874011
    when @Trip_Length2 = '7' then -0.105808906628027
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.100276608794091
    when @Trip_Length2 = '10' then 0.195469314710202
    when @Trip_Length2 = '11' then 0.285807647148824
    when @Trip_Length2 = '12' then 0.371397006172549
    when @Trip_Length2 = '13' then 0.452284122149893
    when @Trip_Length2 = '14' then 0.528501361374806
    when @Trip_Length2 = '15' then 0.600095656310461
    when @Trip_Length2 = '16' then 0.667146290954538
    when @Trip_Length2 = '17' then 0.729774613467836
    when @Trip_Length2 = '18' then 0.788147836901535
    when @Trip_Length2 = '19' then 0.842478449607012
    when @Trip_Length2 = '20' then 0.893020288785432
    when @Trip_Length2 = '21' then 0.940062060304448
    when @Trip_Length2 = '22' then 0.983918945058713
    when @Trip_Length2 = '23' then 1.02492286689878
    when @Trip_Length2 = '24' then 1.06341200199326
    when @Trip_Length2 = '25' then 1.09972009378803
    when @Trip_Length2 = '26' then 1.13416613653674
    when @Trip_Length2 = '27' then 1.16704496490999
    when @Trip_Length2 = '28' then 1.19861922680832
    when @Trip_Length2 = '29' then 1.22911317806062
    when @Trip_Length2 = '30' then 1.25870865534509
    when @Trip_Length2 = '31' then 1.28754351152088
    when @Trip_Length2 = '32' then 1.31571267986267
    when @Trip_Length2 = '33' then 1.34327186310765
    when @Trip_Length2 = '34' then 1.37024362138952
    when @Trip_Length2 = '35' then 1.39662534654967
    when @Trip_Length2 = '36' then 1.42239831985758
    when @Trip_Length2 = '37' then 1.44753678525478
    when @Trip_Length2 = '38' then 1.47201583754793
    when @Trip_Length2 = '39' then 1.49581694388116
    when @Trip_Length2 = '40' then 1.51893016849501
    when @Trip_Length2 = '41' then 1.54135262260601
    when @Trip_Length2 = '42' then 1.56308329904804
    when @Trip_Length2 = '43' then 1.58411514749568
    when @Trip_Length2 = '44' then 1.6044258940857
    when @Trip_Length2 = '45' then 1.62396954031953
    when @Trip_Length2 = '46' then 1.64267057130854
    when @Trip_Length2 = '47' then 1.66042259363537
    when @Trip_Length2 = '48' then 1.67709243858426
    when @Trip_Length2 = '49' then 1.69252982758858
    when @Trip_Length2 = '50' then 1.70658170134132
    when @Trip_Length2 = '51' then 1.71910946032079
    when @Trip_Length2 = '52' then 1.73000680491199
    when @Trip_Length2 = '53' then 1.73921569479686
    when @Trip_Length2 = '54' then 1.74673813667487
    when @Trip_Length2 = '55' then 1.75264202790719
    when @Trip_Length2 = '56' then 1.757060024313
    when @Trip_Length2 = '57' then 1.76018129301163
    when @Trip_Length2 = '58' then 1.76223695809803
    when @Trip_Length2 = '59' then 1.76348096466789
    when @Trip_Length2 = '60' then 1.76416883980371
    when @Trip_Length2 = '61' then 1.76453728130706
    when @Trip_Length2 = '62' then 1.76478752129839
    when @Trip_Length2 = '63' then 1.76507491016597
    when @Trip_Length2 = '64' then 1.76570739922664
    when @Trip_Length2 = '65' then 1.76638115201266
    when @Trip_Length2 = '66' then 1.76727898304973
    when @Trip_Length2 = '67' then 1.7693578055638
    when @Trip_Length2 = '68' then 1.7748241275611
    when @Trip_Length2 = '69' then 1.78367846020812
    when @Trip_Length2 = '70' then 1.79586573986848
    when @Trip_Length2 = '71' then 1.81127756037109
    when @Trip_Length2 = '72' then 1.82887577950159
    when @Trip_Length2 = '73' then 1.84626892516204
    when @Trip_Length2 = '74' then 1.86385795355633
    when @Trip_Length2 = '75' then 1.88126277623633
    when @Trip_Length2 = '76' then 1.89836984601252
    when @Trip_Length2 = '77' then 1.91515057058373
    when @Trip_Length2 = '78' then 1.93155306485276
    when @Trip_Length2 = '79' then 1.94752888879516
    when @Trip_Length2 = '80' then 1.9630940307323
    when @Trip_Length2 = '81' then 1.97828770999221
    when @Trip_Length2 = '82' then 1.99313495577137
    when @Trip_Length2 = '83' then 2.00771805514689
    when @Trip_Length2 = '84' then 2.0221262340006
    when @Trip_Length2 = '85' then 2.03646656597137
    when @Trip_Length2 = '86' then 2.0508626316588
    when @Trip_Length2 = '87' then 2.06544205185199
    when @Trip_Length2 = '88' then 2.08034670235429
    when @Trip_Length2 = '89' then 2.09569880700478
    when @Trip_Length2 = '90' then 2.11164389243959
    when @Trip_Length2 = '97' then 2.12828551467846
    when @Trip_Length2 = '104' then 2.14571813712217
    when @Trip_Length2 = '111' then 2.16402676769998
    when @Trip_Length2 = '118' then 2.18324723516681
    when @Trip_Length2 = '125' then 2.20339875604164
    when @Trip_Length2 = '132' then 2.2244660325946
    when @Trip_Length2 = '139' then 2.24640243224657
    when @Trip_Length2 = '146' then 2.26911531637754
    when @Trip_Length2 = '153' then 2.29248929363586
    when @Trip_Length2 = '160' then 2.31638112577244
    when @Trip_Length2 = '167' then 2.34061570827721
    when @Trip_Length2 = '174' then 2.36500756670272
    when @Trip_Length2 = '181' then 2.38935541114625
    when @Trip_Length2 = '188' then 2.4134451434751
    when @Trip_Length2 = '195' then 2.43703692034775
    when @Trip_Length2 = '202' then 2.45993565866099
    when @Trip_Length2 = '209' then 2.48194214963954
    when @Trip_Length2 = '216' then 2.50284571238407
    when @Trip_Length2 = '223' then 2.52248021706056
    when @Trip_Length2 = '230' then 2.54071129990657
    when @Trip_Length2 = '237' then 2.55740469663451
    when @Trip_Length2 = '244' then 2.57246430125638
    when @Trip_Length2 = '251' then 2.58584712478068
    when @Trip_Length2 = '258' then 2.59751928891021
    when @Trip_Length2 = '265' then 2.60748662189147
    when @Trip_Length2 = '272' then 2.61578563760351
    when @Trip_Length2 = '279' then 2.62248854914208
    when @Trip_Length2 = '286' then 2.62768997322331
    when @Trip_Length2 = '293' then 2.63148219930426
    when @Trip_Length2 = '300' then 2.63360510232242
    when @Trip_Length2 = '307' then 2.63360510232242
    when @Trip_Length2 = '314' then 2.63360510232242
    when @Trip_Length2 = '321' then 2.63360510232242
    when @Trip_Length2 = '328' then 2.63360510232242
    when @Trip_Length2 = '335' then 2.63360510232242
    when @Trip_Length2 = '342' then 2.63360510232242
    when @Trip_Length2 = '349' then 2.63360510232242
    when @Trip_Length2 = '356' then 2.63360510232242
    when @Trip_Length2 = '363' then 2.63360510232242
    when @Trip_Length2 = '365' then 2.63360510232242
    when @Trip_Length2 = '370' then 2.63360510232242
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.338202449889359
    when @Destination3 = 'Africa-SOUTH AFRICA' then 0
    when @Destination3 = 'Asia Others' then 0.17645436132888
    when @Destination3 = 'Domestic' then 0
    when @Destination3 = 'East Asia' then 0
    when @Destination3 = 'East Asia-CHINA' then 0.17645436132888
    when @Destination3 = 'East Asia-HONG KONG' then 0
    when @Destination3 = 'East Asia-JAPAN' then 0.541810131968504
    when @Destination3 = 'Europe' then 0.17645436132888
    when @Destination3 = 'Europe-CROATIA' then 0.338202449889359
    when @Destination3 = 'Europe-ENGLAND' then 0
    when @Destination3 = 'Europe-FRANCE' then 0.338202449889359
    when @Destination3 = 'Europe-GERMANY' then 0.17645436132888
    when @Destination3 = 'Europe-GREECE' then 0.541810131968504
    when @Destination3 = 'Europe-ITALY' then 0.338202449889359
    when @Destination3 = 'Europe-NETHERLANDS' then 0.17645436132888
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then -0.461469268572622
    when @Destination3 = 'Europe-SCOTLAND' then 0
    when @Destination3 = 'Europe-SPAIN' then 0.541810131968504
    when @Destination3 = 'Europe-SWITZERLAND' then 0.338202449889359
    when @Destination3 = 'Europe-UNITED KINGDOM' then 0
    when @Destination3 = 'Mid East' then 0.541810131968504
    when @Destination3 = 'New Zealand-NEW ZEALAND' then 0
    when @Destination3 = 'North America-CANADA' then 0.338202449889359
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 0.17645436132888
    when @Destination3 = 'Pacific Region' then 0
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then -0.461469268572622
    when @Destination3 = 'Pacific Region-FIJI' then 0.338202449889359
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then -0.461469268572622
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0.541810131968504
    when @Destination3 = 'Pacific Region-SOUTH WEST PACIFIC CRUISE' then -0.461469268572622
    when @Destination3 = 'Pacific Region-VANUATU' then 0
    when @Destination3 = 'SEA-INDONESIA' then 0.17645436132888
    when @Destination3 = 'SEA-MALAYSIA' then 0
    when @Destination3 = 'SEA-PHILIPPINES' then 0.17645436132888
    when @Destination3 = 'SEA-SINGAPORE' then 0
    when @Destination3 = 'South America' then 0.541810131968504
    when @Destination3 = 'South Asia' then 0.17645436132888
    when @Destination3 = 'South Asia-CAMBODIA' then 0.17645436132888
    when @Destination3 = 'South Asia-INDIA' then 0.338202449889359
    when @Destination3 = 'South Asia-NEPAL' then 2.24773475138461
    when @Destination3 = 'South Asia-SRI LANKA' then 0
    when @Destination3 = 'South Asia-THAILAND' then 0.338202449889359
    when @Destination3 = 'South Asia-VIETNAM' then 0.338202449889359
    when @Destination3 = 'World Others' then 0.541810131968504
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then 0.00611225482900578
    when @OldestAge2 = '12' then -0.466454656819894
    when @OldestAge2 = '13' then -0.428148132973241
    when @OldestAge2 = '14' then -0.38589910813903
    when @OldestAge2 = '15' then -0.33654989986832
    when @OldestAge2 = '16' then -0.279904793877789
    when @OldestAge2 = '17' then -0.218320240566838
    when @OldestAge2 = '18' then -0.155495940101658
    when @OldestAge2 = '19' then -0.095123953046138
    when @OldestAge2 = '20' then -0.0399425151446735
    when @OldestAge2 = '21' then 0.00862669198070159
    when @OldestAge2 = '22' then 0.0503627244461206
    when @OldestAge2 = '23' then 0.0858574905698468
    when @OldestAge2 = '24' then 0.116053385632478
    when @OldestAge2 = '25' then 0.141857063664534
    when @OldestAge2 = '26' then 0.16391674791465
    when @OldestAge2 = '27' then 0.182574931856978
    when @OldestAge2 = '28' then 0.197939516416888
    when @OldestAge2 = '29' then 0.209984131402778
    when @OldestAge2 = '30' then 0.218607193580112
    when @OldestAge2 = '31' then 0.223633523490634
    when @OldestAge2 = '32' then 0.224796124529624
    when @OldestAge2 = '33' then 0.221756269183785
    when @OldestAge2 = '34' then 0.21419723686763
    when @OldestAge2 = '35' then 0.201978442560233
    when @OldestAge2 = '36' then 0.185293735072108
    when @OldestAge2 = '37' then 0.164765102102389
    when @OldestAge2 = '38' then 0.141426044913993
    when @OldestAge2 = '39' then 0.116594632528704
    when @OldestAge2 = '40' then 0.0916826850700029
    when @OldestAge2 = '41' then 0.0680109644155094
    when @OldestAge2 = '42' then 0.046686147214472
    when @OldestAge2 = '43' then 0.0285505576396714
    when @OldestAge2 = '44' then 0.0141705751763918
    when @OldestAge2 = '45' then 0.00381881290045084
    when @OldestAge2 = '46' then -0.00256229956313801
    when @OldestAge2 = '47' then -0.00537978847228968
    when @OldestAge2 = '48' then -0.0053368001903689
    when @OldestAge2 = '49' then -0.00328221130558413
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00397887879977247
    when @OldestAge2 = '52' then 0.00846171069482613
    when @OldestAge2 = '53' then 0.0135442261860774
    when @OldestAge2 = '54' then 0.019458056126501
    when @OldestAge2 = '55' then 0.0263922955962173
    when @OldestAge2 = '56' then 0.0343683108067561
    when @OldestAge2 = '57' then 0.0432092828276698
    when @OldestAge2 = '58' then 0.05259455888919
    when @OldestAge2 = '59' then 0.0621558226812616
    when @OldestAge2 = '60' then 0.0715718422797379
    when @OldestAge2 = '61' then 0.0806403572870593
    when @OldestAge2 = '62' then 0.0893266860346387
    when @OldestAge2 = '63' then 0.0977936978152787
    when @OldestAge2 = '64' then 0.106408489937928
    when @OldestAge2 = '65' then 0.115710847338786
    when @OldestAge2 = '66' then 0.126331286370049
    when @OldestAge2 = '67' then 0.138866019804506
    when @OldestAge2 = '68' then 0.153743191818339
    when @OldestAge2 = '69' then 0.171130642327532
    when @OldestAge2 = '70' then 0.190925301948336
    when @OldestAge2 = '71' then 0.212828986487183
    when @OldestAge2 = '72' then 0.236475031117618
    when @OldestAge2 = '73' then 0.261550074457416
    when @OldestAge2 = '74' then 0.287867414029486
    when @OldestAge2 = '75' then 0.315383607561561
    when @OldestAge2 = '76' then 0.344186469027236
    when @OldestAge2 = '77' then 0.37450073534879
    when @OldestAge2 = '78' then 0.406750512414643
    when @OldestAge2 = '79' then 0.441690526055433
    when @OldestAge2 = '80' then 0.480579868155496
    when @OldestAge2 = '81' then 0.525325540007105
    when @OldestAge2 = '82' then 0.578472329967439
    when @OldestAge2 = '83' then 0.642887741415524
    when @OldestAge2 = '84' then 0.721052333233062
    when @OldestAge2 = '85' then 0.81407506420089
    when @OldestAge2 = '86' then 0.92083427331546
    when @OldestAge2 = '87' then 1.03774063554804
    when @OldestAge2 = '88' then 1.15933377637887
    when @OldestAge2 = '89' then 1.27944556789504
    when @OldestAge2 = '90' then 1.3924066159489
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.257593625026446
    when @Traveller_Count2 = '3' then 0.395220914256863
    when @Traveller_Count2 = '4' then 0.570486068546666
    when @Traveller_Count2 = '5' then 0.570486068546666
    when @Traveller_Count2 = '6' then 0.570486068546666
    when @Traveller_Count2 = '7' then 0.570486068546666
    when @Traveller_Count2 = '8' then 0.570486068546666
    when @Traveller_Count2 = '9' then 0.570486068546666
    when @Traveller_Count2 = '10' then 0.570486068546666
    when @Traveller_Count2 = '11' then 0.570486068546669
    when @Traveller_Count2 = '12' then 0.570486068546669
    when @Traveller_Count2 = '13' then 0.570486068546669
    when @Traveller_Count2 = '14' then 0.570486068546669
    when @Traveller_Count2 = '15' then 0.570486068546669
    when @Traveller_Count2 = '16' then 0.570486068546669
    when @Traveller_Count2 = '17' then 0.570486068546669
    when @Traveller_Count2 = '18' then 0.570486068546669
    when @Traveller_Count2 = '19' then 0.570486068546669
    when @Traveller_Count2 = '20' then 0.570486068546669
    when @Traveller_Count2 = '21' then 0.570486068546669
    when @Traveller_Count2 = '22' then 0.570486068546669
    when @Traveller_Count2 = '23' then 0.570486068546669
    when @Traveller_Count2 = '24' then 0.570486068546669
    when @Traveller_Count2 = '25' then 0.570486068546669
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then 0
    when @JV_Description = 'Air New Zealand' then 0.416435247423237
    when @JV_Description = 'Australia Post' then 0
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
    when @JV_Description = 'Medibank' then 0
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0.169187043945948
    when @JV_Description = 'Virgin' then 0
    when @JV_Description = 'Websales' then 0.169187043945948
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
    when @Product_Indicator = 'International AMT' then -1.05151997356544
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then -0.579727935147435
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then 0.506817602368452
    when @Excess = '25' then 0.470003629245736
    when @Excess = '50' then 0.431782416425538
    when @Excess = '60' then 0.412109650826833
    when @Excess = '100' then 0.350656871613169
    when @Excess = '150' then 0.246860077931526
    when @Excess = '200' then 0.131028262406404
    when @Excess = '250' then 0
    when @Excess = '300' then -0.0408219945202548
    when @Excess = '500' then -0.210721031315653
    when @Excess = '1000' then -0.261364764134408
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0.097788927425782
    when @Departure_Month = '2' then 0.097788927425782
    when @Departure_Month = '3' then 0
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then 0
    when @Departure_Month = '9' then 0
    when @Departure_Month = '10' then 0
    when @Departure_Month = '11' then 0
    when @Departure_Month = '12' then 0.097788927425782
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.29128850750465
    when @EMCBand = '1_>50%' then 0.29128850750465
    when @EMCBand = '2_<50%' then 0.29128850750465
    when @EMCBand = '2_>50%' then 0.29128850750465
    when @EMCBand = '3_<50%' then 0.29128850750465
    when @EMCBand = '3_>50%' then 0.29128850750465
    when @EMCBand = '4_<50%' then 0.402659434025783
    when @EMCBand = '4_>50%' then 0.402659434025783
    when @EMCBand = '5_<50%' then 0.402659434025783
    when @EMCBand = '5_>50%' then 0.402659434025783
    when @EMCBand = '6_<50%' then 0.402659434025783
    when @EMCBand = '6_>50%' then 0.402659434025783
    when @EMCBand = '7_<50%' then 0.402659434025783
    when @EMCBand = '7_>50%' then 0.402659434025783
    when @EMCBand = '8_<50%' then 0.402659434025783
    when @EMCBand = '8_>50%' then 0.402659434025783
end

-- Start of Gender
set @LinearPredictor = @LinearPredictor +
case
    when @Gender = 'F' then -0.11066009257078
    when @Gender = 'FF' then 0.167162903347133
    when @Gender = 'FM' then 0
    when @Gender = 'M' then -0.229587467379155
    when @Gender = 'MM' then 0.0746637937695551
    when @Gender = 'O' then -0.17452007430224
    when @Gender = 'U' then 0
end

-- Start of Issue_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Issue_Month = '1' then 0
    when @Issue_Month = '2' then 0.0801483488905044
    when @Issue_Month = '3' then 0
    when @Issue_Month = '4' then 0
    when @Issue_Month = '5' then 0
    when @Issue_Month = '6' then 0
    when @Issue_Month = '7' then 0
    when @Issue_Month = '8' then 0
    when @Issue_Month = '9' then 0
    when @Issue_Month = '10' then 0
    when @Issue_Month = '11' then 0
    when @Issue_Month = '12' then 0.0801483488905044
end

-- Start of Latest_product
set @LinearPredictor = @LinearPredictor +
case
    when @Latest_product = 'FCO' then 0.122502811495761
    when @Latest_product = 'FCT' then 0.174335592571814
    when @Latest_product = 'NCC' then 0.0953100545528259
    when @Latest_product = 'Y' then 0
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
    when @Return_Mth = '01JAN2018' then 0.0671280766283714
    when @Return_Mth = '01FEB2018' then 0.0671280766283714
    when @Return_Mth = '01MAR2018' then 0.0671280766283714
    when @Return_Mth = '01APR2018' then 0.0671280766283714
    when @Return_Mth = '01MAY2018' then 0.0671280766283714
    when @Return_Mth = '01JUN2018' then 0.0671280766283714
    when @Return_Mth = '01JUL2018' then 0.0671280766283714
    when @Return_Mth = '01AUG2018' then 0.0671280766283714
    when @Return_Mth = '01SEP2018' then 0
    when @Return_Mth = '01OCT2018' then 0
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

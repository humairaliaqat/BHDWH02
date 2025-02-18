USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[NZ_ACS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[NZ_ACS] (
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
set @LinearPredictor = @LinearPredictor +  6.40951857587165

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.111490376033363
    when @Trip_Length2 = '2' then -0.111490376033363
    when @Trip_Length2 = '3' then -0.111490376033363
    when @Trip_Length2 = '4' then -0.0891591363198181
    when @Trip_Length2 = '5' then -0.066887945541632
    when @Trip_Length2 = '6' then -0.0445790433979676
    when @Trip_Length2 = '7' then -0.0223478636639074
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.022348403663762
    when @Trip_Length2 = '10' then 0.0445908833278752
    when @Trip_Length2 = '11' then 0.066910705282627
    when @Trip_Length2 = '12' then 0.0892006454583018
    when @Trip_Length2 = '13' then 0.111541374732908
    when @Trip_Length2 = '14' then 0.133831347633521
    when @Trip_Length2 = '15' then 0.156148682489931
    when @Trip_Length2 = '16' then 0.178397199901799
    when @Trip_Length2 = '17' then 0.20073432980108
    when @Trip_Length2 = '18' then 0.222983538512844
    when @Trip_Length2 = '19' then 0.222983538512844
    when @Trip_Length2 = '20' then 0.222983538512844
    when @Trip_Length2 = '21' then 0.222983538512844
    when @Trip_Length2 = '22' then 0.222983538512844
    when @Trip_Length2 = '23' then 0.222983538512844
    when @Trip_Length2 = '24' then 0.222983538512844
    when @Trip_Length2 = '25' then 0.222983538512844
    when @Trip_Length2 = '26' then 0.222983538512844
    when @Trip_Length2 = '27' then 0.222983538512844
    when @Trip_Length2 = '28' then 0.222983538512844
    when @Trip_Length2 = '29' then 0.222983538512844
    when @Trip_Length2 = '30' then 0.222983538512844
    when @Trip_Length2 = '31' then 0.222983538512844
    when @Trip_Length2 = '32' then 0.222983538512844
    when @Trip_Length2 = '33' then 0.222983538512844
    when @Trip_Length2 = '34' then 0.222983538512844
    when @Trip_Length2 = '35' then 0.222983538512844
    when @Trip_Length2 = '36' then 0.222983538512844
    when @Trip_Length2 = '37' then 0.222983538512844
    when @Trip_Length2 = '38' then 0.222983538512844
    when @Trip_Length2 = '39' then 0.222983538512844
    when @Trip_Length2 = '40' then 0.222983538512844
    when @Trip_Length2 = '41' then 0.222983538512844
    when @Trip_Length2 = '42' then 0.222983538512844
    when @Trip_Length2 = '43' then 0.222983538512844
    when @Trip_Length2 = '44' then 0.222983538512844
    when @Trip_Length2 = '45' then 0.222983538512844
    when @Trip_Length2 = '46' then 0.222983538512844
    when @Trip_Length2 = '47' then 0.222983538512844
    when @Trip_Length2 = '48' then 0.222983538512844
    when @Trip_Length2 = '49' then 0.222983538512844
    when @Trip_Length2 = '50' then 0.222983538512844
    when @Trip_Length2 = '51' then 0.222983538512844
    when @Trip_Length2 = '52' then 0.222983538512844
    when @Trip_Length2 = '53' then 0.222983538512844
    when @Trip_Length2 = '54' then 0.222983538512844
    when @Trip_Length2 = '55' then 0.222983538512844
    when @Trip_Length2 = '56' then 0.222983538512844
    when @Trip_Length2 = '57' then 0.222983538512844
    when @Trip_Length2 = '58' then 0.222983538512844
    when @Trip_Length2 = '59' then 0.222983538512844
    when @Trip_Length2 = '60' then 0.222983538512844
    when @Trip_Length2 = '61' then 0.222983538512844
    when @Trip_Length2 = '62' then 0.222983538512844
    when @Trip_Length2 = '63' then 0.222983538512844
    when @Trip_Length2 = '64' then 0.222983538512844
    when @Trip_Length2 = '65' then 0.222983538512844
    when @Trip_Length2 = '66' then 0.222983538512844
    when @Trip_Length2 = '67' then 0.222983538512844
    when @Trip_Length2 = '68' then 0.222983538512844
    when @Trip_Length2 = '69' then 0.222983538512844
    when @Trip_Length2 = '70' then 0.222983538512844
    when @Trip_Length2 = '71' then 0.222983538512844
    when @Trip_Length2 = '72' then 0.222983538512844
    when @Trip_Length2 = '73' then 0.222983538512844
    when @Trip_Length2 = '74' then 0.222983538512844
    when @Trip_Length2 = '75' then 0.222983538512844
    when @Trip_Length2 = '76' then 0.222983538512844
    when @Trip_Length2 = '77' then 0.222983538512844
    when @Trip_Length2 = '78' then 0.222983538512844
    when @Trip_Length2 = '79' then 0.222983538512844
    when @Trip_Length2 = '80' then 0.222983538512844
    when @Trip_Length2 = '81' then 0.222983538512844
    when @Trip_Length2 = '82' then 0.222983538512844
    when @Trip_Length2 = '83' then 0.222983538512844
    when @Trip_Length2 = '84' then 0.222983538512844
    when @Trip_Length2 = '85' then 0.222983538512844
    when @Trip_Length2 = '86' then 0.222983538512844
    when @Trip_Length2 = '87' then 0.222983538512844
    when @Trip_Length2 = '88' then 0.222983538512844
    when @Trip_Length2 = '89' then 0.222983538512844
    when @Trip_Length2 = '90' then 0.222983538512844
    when @Trip_Length2 = '97' then 0.222983538512844
    when @Trip_Length2 = '104' then 0.222983538512844
    when @Trip_Length2 = '111' then 0.222983538512844
    when @Trip_Length2 = '118' then 0.222983538512844
    when @Trip_Length2 = '125' then 0.222983538512844
    when @Trip_Length2 = '132' then 0.222983538512844
    when @Trip_Length2 = '139' then 0.222983538512844
    when @Trip_Length2 = '146' then 0.222983538512844
    when @Trip_Length2 = '153' then 0.222983538512844
    when @Trip_Length2 = '160' then 0.222983538512844
    when @Trip_Length2 = '167' then 0.222983538512844
    when @Trip_Length2 = '174' then 0.222983538512844
    when @Trip_Length2 = '181' then 0.222983538512844
    when @Trip_Length2 = '188' then 0.222983538512844
    when @Trip_Length2 = '195' then 0.222983538512844
    when @Trip_Length2 = '202' then 0.222983538512844
    when @Trip_Length2 = '209' then 0.222983538512844
    when @Trip_Length2 = '216' then 0.222983538512844
    when @Trip_Length2 = '223' then 0.222983538512844
    when @Trip_Length2 = '230' then 0.222983538512844
    when @Trip_Length2 = '237' then 0.222983538512844
    when @Trip_Length2 = '244' then 0.222983538512844
    when @Trip_Length2 = '251' then 0.222983538512844
    when @Trip_Length2 = '258' then 0.222983538512844
    when @Trip_Length2 = '265' then 0.222983538512844
    when @Trip_Length2 = '272' then 0.222983538512844
    when @Trip_Length2 = '279' then 0.222983538512844
    when @Trip_Length2 = '286' then 0.222983538512844
    when @Trip_Length2 = '293' then 0.222983538512844
    when @Trip_Length2 = '300' then 0.222983538512844
    when @Trip_Length2 = '307' then 0.222983538512844
    when @Trip_Length2 = '314' then 0.222983538512844
    when @Trip_Length2 = '321' then 0.222983538512844
    when @Trip_Length2 = '328' then 0.222983538512844
    when @Trip_Length2 = '335' then 0.222983538512844
    when @Trip_Length2 = '342' then 0.222983538512844
    when @Trip_Length2 = '349' then 0.222983538512844
    when @Trip_Length2 = '356' then 0.222983538512844
    when @Trip_Length2 = '363' then 0.222983538512844
    when @Trip_Length2 = '365' then 0.222983538512844
    when @Trip_Length2 = '370' then 0.222983538512844
end

-- Start of Destination3
set @LinearPredictor = @LinearPredictor +
case
    when @Destination3 = 'Africa' then 0.217883786100846
    when @Destination3 = 'Africa-SOUTH AFRICA' then 0.217883786100846
    when @Destination3 = 'Asia Others' then 0
    when @Destination3 = 'Australia-AUSTRALIA' then 0
    when @Destination3 = 'Domestic' then 0
    when @Destination3 = 'East Asia' then 0.217883786100846
    when @Destination3 = 'East Asia-CHINA' then 0.217883786100846
    when @Destination3 = 'East Asia-HONG KONG' then 0
    when @Destination3 = 'East Asia-JAPAN' then 0.423854127405667
    when @Destination3 = 'Europe' then 0.423854127405667
    when @Destination3 = 'Europe-CROATIA' then 0.708471006533491
    when @Destination3 = 'Europe-ENGLAND' then 0.708471006533491
    when @Destination3 = 'Europe-FRANCE' then 0.423854127405667
    when @Destination3 = 'Europe-GERMANY' then 0.217883786100846
    when @Destination3 = 'Europe-GREECE' then 0
    when @Destination3 = 'Europe-ITALY' then 0.423854127405667
    when @Destination3 = 'Europe-NETHERLANDS' then 0.423854127405667
    when @Destination3 = 'Europe-REPUBLIC OF IRELAND' then 0.217883786100846
    when @Destination3 = 'Europe-SCOTLAND' then 0.708471006533491
    when @Destination3 = 'Europe-SPAIN' then 0.217883786100846
    when @Destination3 = 'Europe-SWITZERLAND' then 0.708471006533491
    when @Destination3 = 'Europe-UNITED KINGDOM' then 0.423854127405667
    when @Destination3 = 'Mid East' then 0.423854127405667
    when @Destination3 = 'North America-CANADA' then 0.708471006533491
    when @Destination3 = 'North America-UNITED STATES OF AMERICA' then 0.708471006533491
    when @Destination3 = 'Pacific Region' then 0.423854127405667
    when @Destination3 = 'Pacific Region-DOMESTIC CRUISE' then 0
    when @Destination3 = 'Pacific Region-FIJI' then 0.217883786100846
    when @Destination3 = 'Pacific Region-NEW CALEDONIA' then 0
    when @Destination3 = 'Pacific Region-PAPUA NEW GUINEA' then 0
    when @Destination3 = 'Pacific Region-VANUATU' then 0.217883786100846
    when @Destination3 = 'SEA-INDONESIA' then 0.423854127405667
    when @Destination3 = 'SEA-MALAYSIA' then 0.217883786100846
    when @Destination3 = 'SEA-PHILIPPINES' then 0.423854127405667
    when @Destination3 = 'SEA-SINGAPORE' then 0.423854127405667
    when @Destination3 = 'South America' then 0.423854127405667
    when @Destination3 = 'South Asia' then 0
    when @Destination3 = 'South Asia-CAMBODIA' then 0.217883786100846
    when @Destination3 = 'South Asia-INDIA' then 0.423854127405667
    when @Destination3 = 'South Asia-NEPAL' then 1.16937914940263
    when @Destination3 = 'South Asia-SRI LANKA' then 0.423854127405667
    when @Destination3 = 'South Asia-THAILAND' then 0.423854127405667
    when @Destination3 = 'South Asia-VIETNAM' then 0.423854127405667
    when @Destination3 = 'World Others' then 0.423854127405667
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then 0.280322493092033
    when @OldestAge2 = '12' then -0.0772815054682647
    when @OldestAge2 = '13' then -0.0803510335405795
    when @OldestAge2 = '14' then -0.0843105561283383
    when @OldestAge2 = '15' then -0.092167957321558
    when @OldestAge2 = '16' then -0.102163354385818
    when @OldestAge2 = '17' then -0.114197331800475
    when @OldestAge2 = '18' then -0.127322527469311
    when @OldestAge2 = '19' then -0.140798882555628
    when @OldestAge2 = '20' then -0.15374327016915
    when @OldestAge2 = '21' then -0.165350804056339
    when @OldestAge2 = '22' then -0.174892537372036
    when @OldestAge2 = '23' then -0.18179937021312
    when @OldestAge2 = '24' then -0.185698385530396
    when @OldestAge2 = '25' then -0.186445466379289
    when @OldestAge2 = '26' then -0.1841293666075
    when @OldestAge2 = '27' then -0.179054049520159
    when @OldestAge2 = '28' then -0.17169862876047
    when @OldestAge2 = '29' then -0.162661831448752
    when @OldestAge2 = '30' then -0.152597905412304
    when @OldestAge2 = '31' then -0.142151872807442
    when @OldestAge2 = '32' then -0.131900720104438
    when @OldestAge2 = '33' then -0.122305626084505
    when @OldestAge2 = '34' then -0.113678556309827
    when @OldestAge2 = '35' then -0.106165119630831
    when @OldestAge2 = '36' then -0.0997444045344578
    when @OldestAge2 = '37' then -0.0942454866209142
    when @OldestAge2 = '38' then -0.089379166116192
    when @OldestAge2 = '39' then -0.0847820417276903
    when @OldestAge2 = '40' then -0.0800684061188024
    when @OldestAge2 = '41' then -0.0748837919583103
    when @OldestAge2 = '42' then -0.0689531114314157
    when @OldestAge2 = '43' then -0.0621165028157247
    when @OldestAge2 = '44' then -0.054347742989231
    when @OldestAge2 = '45' then -0.0457530614342918
    when @OldestAge2 = '46' then -0.0365517043173806
    when @OldestAge2 = '47' then -0.0270426921556996
    when @OldestAge2 = '48' then -0.0175640535371144
    when @OldestAge2 = '49' then -0.00845119424779116
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00756143651278492
    when @OldestAge2 = '52' then 0.014090542855251
    when @OldestAge2 = '53' then 0.0195371965281846
    when @OldestAge2 = '54' then 0.0239408541255486
    when @OldestAge2 = '55' then 0.0274197029488717
    when @OldestAge2 = '56' then 0.0301541392188432
    when @OldestAge2 = '57' then 0.0323671721435232
    when @OldestAge2 = '58' then 0.034304387385795
    when @OldestAge2 = '59' then 0.0362160097199836
    when @OldestAge2 = '60' then 0.0383431137363974
    when @OldestAge2 = '61' then 0.040909339777155
    when @OldestAge2 = '62' then 0.0441183648181652
    when @OldestAge2 = '63' then 0.0481562005816131
    when @OldestAge2 = '64' then 0.0531962618732641
    when @OldestAge2 = '65' then 0.0594043415520753
    when @OldestAge2 = '66' then 0.0669404267011427
    when @OldestAge2 = '67' then 0.0759548027070744
    when @OldestAge2 = '68' then 0.0865771628144146
    when @OldestAge2 = '69' then 0.0988992353720271
    when @OldestAge2 = '70' then 0.112953403870837
    when @OldestAge2 = '71' then 0.128691488941419
    when @OldestAge2 = '72' then 0.145968633710019
    when @OldestAge2 = '73' then 0.164536832848356
    when @OldestAge2 = '74' then 0.184051020979369
    when @OldestAge2 = '75' then 0.204088156564642
    when @OldestAge2 = '76' then 0.224177091588009
    when @OldestAge2 = '77' then 0.243834958024375
    when @OldestAge2 = '78' then 0.262604787462672
    when @OldestAge2 = '79' then 0.28008915438961
    when @OldestAge2 = '80' then 0.295975903588999
    when @OldestAge2 = '81' then 0.310053048112843
    when @OldestAge2 = '82' then 0.322213144515457
    when @OldestAge2 = '83' then 0.332444879424934
    when @OldestAge2 = '84' then 0.340821777874737
    when @OldestAge2 = '85' then 0.347468810348394
    when @OldestAge2 = '86' then 0.352569005334608
    when @OldestAge2 = '87' then 0.356252465594076
    when @OldestAge2 = '88' then 0.358804474478151
    when @OldestAge2 = '89' then 0.360020831051073
    when @OldestAge2 = '90' then 0.360879819801172
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.189095397776608
    when @Traveller_Count2 = '3' then 0.189095397776608
    when @Traveller_Count2 = '4' then 0.189095397776608
    when @Traveller_Count2 = '5' then 0.189095397776608
    when @Traveller_Count2 = '6' then 0.189095397776608
    when @Traveller_Count2 = '7' then 0.189095397776608
    when @Traveller_Count2 = '8' then 0.189095397776608
    when @Traveller_Count2 = '9' then 0.189095397776608
    when @Traveller_Count2 = '10' then 0.189095397776608
end

-- Start of Product_Indicator
set @LinearPredictor = @LinearPredictor +
case
    when @Product_Indicator = 'Domestic AMT' then -0.954012573264942
    when @Product_Indicator = 'Domestic Inbound' then 0.436623201446298
    when @Product_Indicator = 'Domestic Single Trip' then 0.39241956949033
    when @Product_Indicator = 'International AMT' then -0.384271814946167
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then 0.144462054972993
end

-- Start of Excess
set @LinearPredictor = @LinearPredictor +
case
    when @Excess = '0' then 0.0456423578787008
    when @Excess = '20' then 0.0456423578787008
    when @Excess = '25' then 0.0456423578787008
    when @Excess = '50' then 0
    when @Excess = '100' then 0.167799960274934
    when @Excess = '250' then 0.324905600249747
    when @Excess = '500' then 0.481993957097288
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then 0.157861134265064
    when @Departure_Month = '2' then -0.0636092320848496
    when @Departure_Month = '3' then -0.0636092320848496
    when @Departure_Month = '4' then 0
    when @Departure_Month = '5' then 0
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then 0
    when @Departure_Month = '8' then -0.0636092320848496
    when @Departure_Month = '9' then -0.0636092320848496
    when @Departure_Month = '10' then 0
    when @Departure_Month = '11' then 0
    when @Departure_Month = '12' then 0
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.301553178960285
    when @EMCBand = '1_>50%' then 0.301553178960285
    when @EMCBand = '2_<50%' then 0.301553178960285
    when @EMCBand = '2_>50%' then 0.301553178960285
    when @EMCBand = '3_<50%' then 0.301553178960285
    when @EMCBand = '3_>50%' then 0.301553178960285
    when @EMCBand = '4_<50%' then 0.488291076949802
    when @EMCBand = '4_>50%' then 0.488291076949802
    when @EMCBand = '5_<50%' then 0.488291076949802
    when @EMCBand = '5_>50%' then 0.488291076949802
    when @EMCBand = '6_<50%' then 0.488291076949802
    when @EMCBand = '6_>50%' then 0.488291076949802
    when @EMCBand = '7_<50%' then 0.488291076949802
    when @EMCBand = '7_>50%' then 0.488291076949802
    when @EMCBand = '8_<50%' then 0.488291076949802
    when @EMCBand = '8_>50%' then 0.488291076949802
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'Air New Zealand' then 0
    when @JV_Description = 'Cruise Republic' then 0
    when @JV_Description = 'Flight Centre' then 0.252102535067436
    when @JV_Description = 'Helloworld' then 0
    when @JV_Description = 'IAG NZ' then 0.252102535067436
    when @JV_Description = 'Indep + Others' then 0.252102535067436
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0
    when @JV_Description = 'Virgin' then 0
    when @JV_Description = 'Websales' then 0
    when @JV_Description = 'Westpac NZ' then 0
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then -0.0205088766315402
    when @Lead_Time2 = '3' then -0.0410303495579916
    when @Lead_Time2 = '4' then -0.0613436302410522
    when @Lead_Time2 = '5' then -0.0811016014370418
    when @Lead_Time2 = '6' then -0.0999308386250491
    when @Lead_Time2 = '7' then -0.117658043468232
    when @Lead_Time2 = '8' then -0.13410298452348
    when @Lead_Time2 = '9' then -0.148964153139958
    when @Lead_Time2 = '10' then -0.162401289358824
    when @Lead_Time2 = '11' then -0.174115320246855
    when @Lead_Time2 = '12' then -0.184163251673326
    when @Lead_Time2 = '13' then -0.192735595142827
    when @Lead_Time2 = '14' then -0.199793302705994
    when @Lead_Time2 = '15' then -0.205426430509052
    when @Lead_Time2 = '16' then -0.209980564787929
    when @Lead_Time2 = '17' then -0.213316990496474
    when @Lead_Time2 = '18' then -0.21591970622489
    when @Lead_Time2 = '19' then -0.217782945072114
    when @Lead_Time2 = '20' then -0.21927603978772
    when @Lead_Time2 = '21' then -0.220397325646185
    when @Lead_Time2 = '22' then -0.221519870198112
    when @Lead_Time2 = '23' then -0.222518746545368
    when @Lead_Time2 = '24' then -0.223768746708128
    when @Lead_Time2 = '25' then -0.225145553984883
    when @Lead_Time2 = '26' then -0.22677513754826
    when @Lead_Time2 = '27' then -0.22865873200232
    when @Lead_Time2 = '28' then -0.230923738633172
    when @Lead_Time2 = '29' then -0.23332015776577
    when @Lead_Time2 = '30' then -0.236102152478602
    when @Lead_Time2 = '31' then -0.2390189004725
    when @Lead_Time2 = '32' then -0.242071561199729
    when @Lead_Time2 = '33' then -0.245261356567829
    when @Lead_Time2 = '34' then -0.248461359298499
    when @Lead_Time2 = '35' then -0.251671634928748
    when @Lead_Time2 = '36' then -0.25489224962879
    when @Lead_Time2 = '37' then -0.258252728427777
    when @Lead_Time2 = '38' then -0.261754450441865
    when @Lead_Time2 = '39' then -0.265529267810647
    when @Lead_Time2 = '40' then -0.269449304190721
    when @Lead_Time2 = '41' then -0.273647683487978
    when @Lead_Time2 = '42' then -0.27799580286236
    when @Lead_Time2 = '43' then -0.282495545764481
    when @Lead_Time2 = '44' then -0.287015627908621
    when @Lead_Time2 = '45' then -0.291422392067505
    when @Lead_Time2 = '46' then -0.295445463069615
    when @Lead_Time2 = '47' then -0.299214988265505
    when @Lead_Time2 = '48' then -0.302728030657052
    when @Lead_Time2 = '49' then -0.305710274971172
    when @Lead_Time2 = '50' then -0.30842914559657
    when @Lead_Time2 = '51' then -0.310882465622217
    when @Lead_Time2 = '52' then -0.313205029682867
    when @Lead_Time2 = '53' then -0.315533000607557
    when @Lead_Time2 = '54' then -0.31800383233817
    when @Lead_Time2 = '55' then -0.32075638018121
    when @Lead_Time2 = '56' then -0.323516525460997
    when @Lead_Time2 = '57' then -0.32670013947251
    when @Lead_Time2 = '58' then -0.329893921261091
    when @Lead_Time2 = '59' then -0.33337703171391
    when @Lead_Time2 = '60' then -0.336872316642553
    when @Lead_Time2 = '61' then -0.336872316642553
    when @Lead_Time2 = '62' then -0.336872316642553
    when @Lead_Time2 = '63' then -0.336872316642553
    when @Lead_Time2 = '64' then -0.336872316642553
    when @Lead_Time2 = '65' then -0.336872316642553
    when @Lead_Time2 = '66' then -0.336872316642553
    when @Lead_Time2 = '67' then -0.336872316642553
    when @Lead_Time2 = '68' then -0.336872316642553
    when @Lead_Time2 = '69' then -0.336872316642553
    when @Lead_Time2 = '70' then -0.336872316642553
    when @Lead_Time2 = '71' then -0.336872316642553
    when @Lead_Time2 = '72' then -0.336872316642553
    when @Lead_Time2 = '73' then -0.336872316642553
    when @Lead_Time2 = '74' then -0.336872316642553
    when @Lead_Time2 = '75' then -0.336872316642553
    when @Lead_Time2 = '76' then -0.336872316642553
    when @Lead_Time2 = '77' then -0.336872316642553
    when @Lead_Time2 = '78' then -0.336872316642553
    when @Lead_Time2 = '79' then -0.336872316642553
    when @Lead_Time2 = '80' then -0.336872316642553
    when @Lead_Time2 = '81' then -0.336872316642553
    when @Lead_Time2 = '82' then -0.336872316642553
    when @Lead_Time2 = '83' then -0.336872316642553
    when @Lead_Time2 = '84' then -0.336872316642553
    when @Lead_Time2 = '85' then -0.336872316642553
    when @Lead_Time2 = '86' then -0.336872316642553
    when @Lead_Time2 = '87' then -0.336872316642553
    when @Lead_Time2 = '88' then -0.336872316642553
    when @Lead_Time2 = '89' then -0.336872316642553
    when @Lead_Time2 = '90' then -0.336872316642553
    when @Lead_Time2 = '91' then -0.336872316642553
    when @Lead_Time2 = '92' then -0.336872316642553
    when @Lead_Time2 = '93' then -0.336872316642553
    when @Lead_Time2 = '94' then -0.336872316642553
    when @Lead_Time2 = '95' then -0.336872316642553
    when @Lead_Time2 = '96' then -0.336872316642553
    when @Lead_Time2 = '97' then -0.336872316642553
    when @Lead_Time2 = '98' then -0.336872316642553
    when @Lead_Time2 = '99' then -0.336872316642553
    when @Lead_Time2 = '100' then -0.336872316642553
    when @Lead_Time2 = '101' then -0.336872316642553
    when @Lead_Time2 = '102' then -0.336872316642553
    when @Lead_Time2 = '103' then -0.336872316642553
    when @Lead_Time2 = '104' then -0.336872316642553
    when @Lead_Time2 = '105' then -0.336872316642553
    when @Lead_Time2 = '106' then -0.336872316642553
    when @Lead_Time2 = '107' then -0.336872316642553
    when @Lead_Time2 = '108' then -0.336872316642553
    when @Lead_Time2 = '109' then -0.336872316642553
    when @Lead_Time2 = '110' then -0.336872316642553
    when @Lead_Time2 = '111' then -0.336872316642553
    when @Lead_Time2 = '112' then -0.336872316642553
    when @Lead_Time2 = '113' then -0.336872316642553
    when @Lead_Time2 = '114' then -0.336872316642553
    when @Lead_Time2 = '115' then -0.336872316642553
    when @Lead_Time2 = '116' then -0.336872316642553
    when @Lead_Time2 = '117' then -0.336872316642553
    when @Lead_Time2 = '118' then -0.336872316642553
    when @Lead_Time2 = '119' then -0.336872316642553
    when @Lead_Time2 = '120' then -0.336872316642553
    when @Lead_Time2 = '121' then -0.336872316642553
    when @Lead_Time2 = '122' then -0.336872316642553
    when @Lead_Time2 = '123' then -0.336872316642553
    when @Lead_Time2 = '124' then -0.336872316642553
    when @Lead_Time2 = '125' then -0.336872316642553
    when @Lead_Time2 = '126' then -0.336872316642553
    when @Lead_Time2 = '127' then -0.336872316642553
    when @Lead_Time2 = '128' then -0.336872316642553
    when @Lead_Time2 = '129' then -0.336872316642553
    when @Lead_Time2 = '130' then -0.336872316642553
    when @Lead_Time2 = '131' then -0.336872316642553
    when @Lead_Time2 = '132' then -0.336872316642553
    when @Lead_Time2 = '133' then -0.336872316642553
    when @Lead_Time2 = '134' then -0.336872316642553
    when @Lead_Time2 = '135' then -0.336872316642553
    when @Lead_Time2 = '136' then -0.336872316642553
    when @Lead_Time2 = '137' then -0.336872316642553
    when @Lead_Time2 = '138' then -0.336872316642553
    when @Lead_Time2 = '139' then -0.336872316642553
    when @Lead_Time2 = '140' then -0.336872316642553
    when @Lead_Time2 = '141' then -0.336872316642553
    when @Lead_Time2 = '142' then -0.336872316642553
    when @Lead_Time2 = '143' then -0.336872316642553
    when @Lead_Time2 = '144' then -0.336872316642553
    when @Lead_Time2 = '145' then -0.336872316642553
    when @Lead_Time2 = '146' then -0.336872316642553
    when @Lead_Time2 = '147' then -0.336872316642553
    when @Lead_Time2 = '148' then -0.336872316642553
    when @Lead_Time2 = '149' then -0.336872316642553
    when @Lead_Time2 = '150' then -0.336872316642553
    when @Lead_Time2 = '151' then -0.336872316642553
    when @Lead_Time2 = '152' then -0.336872316642553
    when @Lead_Time2 = '153' then -0.336872316642553
    when @Lead_Time2 = '154' then -0.336872316642553
    when @Lead_Time2 = '155' then -0.336872316642553
    when @Lead_Time2 = '156' then -0.336872316642553
    when @Lead_Time2 = '157' then -0.336872316642553
    when @Lead_Time2 = '158' then -0.336872316642553
    when @Lead_Time2 = '159' then -0.336872316642553
    when @Lead_Time2 = '160' then -0.336872316642553
    when @Lead_Time2 = '161' then -0.336872316642553
    when @Lead_Time2 = '162' then -0.336872316642553
    when @Lead_Time2 = '163' then -0.336872316642553
    when @Lead_Time2 = '164' then -0.336872316642553
    when @Lead_Time2 = '165' then -0.336872316642553
    when @Lead_Time2 = '166' then -0.336872316642553
    when @Lead_Time2 = '167' then -0.336872316642553
    when @Lead_Time2 = '168' then -0.336872316642553
    when @Lead_Time2 = '169' then -0.336872316642553
    when @Lead_Time2 = '170' then -0.336872316642553
    when @Lead_Time2 = '171' then -0.336872316642553
    when @Lead_Time2 = '172' then -0.336872316642553
    when @Lead_Time2 = '173' then -0.336872316642553
    when @Lead_Time2 = '174' then -0.336872316642553
    when @Lead_Time2 = '175' then -0.336872316642553
    when @Lead_Time2 = '176' then -0.336872316642553
    when @Lead_Time2 = '177' then -0.336872316642553
    when @Lead_Time2 = '178' then -0.336872316642553
    when @Lead_Time2 = '179' then -0.336872316642553
    when @Lead_Time2 = '180' then -0.336872316642553
    when @Lead_Time2 = '181' then -0.336872316642553
    when @Lead_Time2 = '188' then -0.336872316642553
    when @Lead_Time2 = '195' then -0.336872316642553
    when @Lead_Time2 = '202' then -0.336872316642553
    when @Lead_Time2 = '209' then -0.336872316642553
    when @Lead_Time2 = '216' then -0.336872316642553
    when @Lead_Time2 = '223' then -0.336872316642553
    when @Lead_Time2 = '230' then -0.336872316642553
    when @Lead_Time2 = '237' then -0.336872316642553
    when @Lead_Time2 = '244' then -0.336872316642553
    when @Lead_Time2 = '251' then -0.336872316642553
    when @Lead_Time2 = '258' then -0.336872316642553
    when @Lead_Time2 = '265' then -0.336872316642553
    when @Lead_Time2 = '272' then -0.336872316642553
    when @Lead_Time2 = '279' then -0.336872316642553
    when @Lead_Time2 = '286' then -0.336872316642553
    when @Lead_Time2 = '293' then -0.336872316642553
    when @Lead_Time2 = '300' then -0.336872316642553
    when @Lead_Time2 = '307' then -0.336872316642553
    when @Lead_Time2 = '314' then -0.336872316642553
    when @Lead_Time2 = '321' then -0.336872316642553
    when @Lead_Time2 = '328' then -0.336872316642553
    when @Lead_Time2 = '335' then -0.336872316642553
    when @Lead_Time2 = '342' then -0.336872316642553
    when @Lead_Time2 = '349' then -0.336872316642553
    when @Lead_Time2 = '356' then -0.336872316642553
    when @Lead_Time2 = '363' then -0.336872316642553
    when @Lead_Time2 = '370' then -0.336872316642553
    when @Lead_Time2 = '377' then -0.336872316642553
    when @Lead_Time2 = '384' then -0.336872316642553
    when @Lead_Time2 = '391' then -0.336872316642553
    when @Lead_Time2 = '398' then -0.336872316642553
    when @Lead_Time2 = '405' then -0.336872316642553
    when @Lead_Time2 = '412' then -0.336872316642553
    when @Lead_Time2 = '419' then -0.336872316642553
    when @Lead_Time2 = '426' then -0.336872316642553
    when @Lead_Time2 = '433' then -0.336872316642553
    when @Lead_Time2 = '440' then -0.336872316642553
    when @Lead_Time2 = '447' then -0.336872316642553
    when @Lead_Time2 = '454' then -0.336872316642553
    when @Lead_Time2 = '461' then -0.336872316642553
    when @Lead_Time2 = '468' then -0.336872316642553
    when @Lead_Time2 = '475' then -0.336872316642553
    when @Lead_Time2 = '482' then -0.336872316642553
    when @Lead_Time2 = '489' then -0.336872316642553
    when @Lead_Time2 = '496' then -0.336872316642553
    when @Lead_Time2 = '503' then -0.336872316642553
    when @Lead_Time2 = '510' then -0.336872316642553
    when @Lead_Time2 = '517' then -0.336872316642553
    when @Lead_Time2 = '524' then -0.336872316642553
    when @Lead_Time2 = '531' then -0.336872316642553
    when @Lead_Time2 = '538' then -0.336872316642553
    when @Lead_Time2 = '545' then -0.336872316642553
    when @Lead_Time2 = '552' then -0.336872316642553
end

-- Start of return_yr
set @LinearPredictor = @LinearPredictor +
case
    when @return_yr = '2018' then -0.0632164458852235
    when @return_yr = '2019' then 0
end

set @PredictedValue = exp(@LinearPredictor)
return @PredictedValue

end
GO

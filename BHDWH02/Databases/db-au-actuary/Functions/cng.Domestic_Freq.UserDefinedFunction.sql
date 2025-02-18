USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [cng].[Domestic_Freq]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [cng].[Domestic_Freq] (
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
set @LinearPredictor = @LinearPredictor + -4.09647515304084

-- Start of Trip_Length2
set @LinearPredictor = @LinearPredictor +
case
    when @Trip_Length2 = '1' then -0.26696903085424
    when @Trip_Length2 = '2' then -0.224457036616886
    when @Trip_Length2 = '3' then -0.183416008035958
    when @Trip_Length2 = '4' then -0.143614244681277
    when @Trip_Length2 = '5' then -0.104971665919046
    when @Trip_Length2 = '6' then -0.067884007490278
    when @Trip_Length2 = '7' then -0.0326877351295733
    when @Trip_Length2 = '8' then 0
    when @Trip_Length2 = '9' then 0.0300620601569782
    when @Trip_Length2 = '10' then 0.0574925907198418
    when @Trip_Length2 = '11' then 0.082379137698032
    when @Trip_Length2 = '12' then 0.105382392469501
    when @Trip_Length2 = '13' then 0.127290673411764
    when @Trip_Length2 = '14' then 0.148729253533954
    when @Trip_Length2 = '15' then 0.170640530580492
    when @Trip_Length2 = '16' then 0.193705503102978
    when @Trip_Length2 = '17' then 0.218275013879201
    when @Trip_Length2 = '18' then 0.244570623645408
    when @Trip_Length2 = '19' then 0.272527344920098
    when @Trip_Length2 = '20' then 0.301505362698045
    when @Trip_Length2 = '21' then 0.330532199251011
    when @Trip_Length2 = '22' then 0.358510929766585
    when @Trip_Length2 = '23' then 0.384313945607007
    when @Trip_Length2 = '24' then 0.406849695685893
    when @Trip_Length2 = '25' then 0.425749486414152
    when @Trip_Length2 = '26' then 0.441066762199457
    when @Trip_Length2 = '27' then 0.453515345923825
    when @Trip_Length2 = '28' then 0.464161834318312
    when @Trip_Length2 = '29' then 0.474151653968582
    when @Trip_Length2 = '30' then 0.484649193733075
    when @Trip_Length2 = '31' then 0.496170521525741
    when @Trip_Length2 = '32' then 0.508942425276576
    when @Trip_Length2 = '33' then 0.522526751202513
    when @Trip_Length2 = '34' then 0.536184997283271
    when @Trip_Length2 = '35' then 0.549217189609744
    when @Trip_Length2 = '36' then 0.560958761730661
    when @Trip_Length2 = '37' then 0.571329271042271
    when @Trip_Length2 = '38' then 0.580369645026531
    when @Trip_Length2 = '39' then 0.588722078890986
    when @Trip_Length2 = '40' then 0.597125743715651
    when @Trip_Length2 = '41' then 0.606414200008639
    when @Trip_Length2 = '42' then 0.617447649226797
    when @Trip_Length2 = '43' then 0.630633880666927
    when @Trip_Length2 = '44' then 0.646059242126445
    when @Trip_Length2 = '45' then 0.660798447637132
    when @Trip_Length2 = '46' then 0.670664261338105
    when @Trip_Length2 = '47' then 0.680109735240901
    when @Trip_Length2 = '48' then 0.689144552631663
    when @Trip_Length2 = '49' then 0.697756815499999
    when @Trip_Length2 = '50' then 0.705937524954423
    when @Trip_Length2 = '51' then 0.713681508153376
    when @Trip_Length2 = '52' then 0.720988303167902
    when @Trip_Length2 = '53' then 0.727862990260551
    when @Trip_Length2 = '54' then 0.734316960581373
    when @Trip_Length2 = '55' then 0.740368616402774
    when @Trip_Length2 = '56' then 0.746044002272306
    when @Trip_Length2 = '57' then 0.751377355234203
    when @Trip_Length2 = '58' then 0.756411576586812
    when @Trip_Length2 = '59' then 0.761198610561291
    when @Trip_Length2 = '60' then 0.765799718399139
    when @Trip_Length2 = '61' then 0.770285618715423
    when @Trip_Length2 = '62' then 0.774736470800631
    when @Trip_Length2 = '63' then 0.779241654240435
    when @Trip_Length2 = '64' then 0.783899298181569
    when @Trip_Length2 = '65' then 0.788815509065184
    when @Trip_Length2 = '66' then 0.794103234329177
    when @Trip_Length2 = '67' then 0.799880717314394
    when @Trip_Length2 = '68' then 0.806269498569588
    when @Trip_Length2 = '69' then 0.813391945577444
    when @Trip_Length2 = '70' then 0.821368315208579
    when @Trip_Length2 = '71' then 0.830313404426892
    when @Trip_Length2 = '72' then 0.840332871147109
    when @Trip_Length2 = '73' then 0.851519364669931
    when @Trip_Length2 = '74' then 0.863948646727839
    when @Trip_Length2 = '75' then 0.877675915618317
    when @Trip_Length2 = '76' then 0.892732564028737
    when @Trip_Length2 = '77' then 0.909123600156803
    when @Trip_Length2 = '78' then 0.926825940746226
    when @Trip_Length2 = '79' then 0.945787724226544
    when @Trip_Length2 = '80' then 0.965928739375182
    when @Trip_Length2 = '81' then 0.987141979236884
    when @Trip_Length2 = '82' then 1.00929624329181
    when @Trip_Length2 = '83' then 1.03223965194432
    when @Trip_Length2 = '84' then 1.05580386660688
    when @Trip_Length2 = '85' then 1.07980877978539
    when @Trip_Length2 = '86' then 1.10406742099024
    when @Trip_Length2 = '87' then 1.12839084085577
    when @Trip_Length2 = '88' then 1.15259275779616
    when @Trip_Length2 = '89' then 1.17649379282495
    when @Trip_Length2 = '90' then 1.19992516590139
    when @Trip_Length2 = '97' then 1.22273177461195
    when @Trip_Length2 = '104' then 1.24477461231998
    when @Trip_Length2 = '111' then 1.26593253253499
    when @Trip_Length2 = '118' then 1.28610338046118
    when @Trip_Length2 = '125' then 1.30520454038524
    when @Trip_Length2 = '132' then 1.32317296387897
    when @Trip_Length2 = '139' then 1.3399647388299
    when @Trip_Length2 = '146' then 1.35555427318851
    when @Trip_Length2 = '153' then 1.36993316035373
    when @Trip_Length2 = '160' then 1.38310878939762
    when @Trip_Length2 = '167' then 1.39510276320723
    when @Trip_Length2 = '174' then 1.40594917736944
    when @Trip_Length2 = '181' then 1.415692814821
    when @Trip_Length2 = '188' then 1.42438730109346
    when @Trip_Length2 = '195' then 1.43209326706827
    when @Trip_Length2 = '202' then 1.43887655268646
    when @Trip_Length2 = '209' then 1.44480649544185
    when @Trip_Length2 = '216' then 1.44995432734516
    when @Trip_Length2 = '223' then 1.45439171178858
    when @Trip_Length2 = '230' then 1.4581894405546
    when @Trip_Length2 = '237' then 1.46141630497841
    when @Trip_Length2 = '244' then 1.46413815412121
    when @Trip_Length2 = '251' then 1.4664171418206
    when @Trip_Length2 = '258' then 1.46831116033952
    when @Trip_Length2 = '265' then 1.46987345426581
    when @Trip_Length2 = '272' then 1.4711524004806
    when @Trip_Length2 = '279' then 1.47219143778748
    when @Trip_Length2 = '286' then 1.47302912721533
    when @Trip_Length2 = '293' then 1.47369932003854
    when @Trip_Length2 = '300' then 1.47423141294131
    when @Trip_Length2 = '307' then 1.47465066789535
    when @Trip_Length2 = '314' then 1.47497857519766
    when @Trip_Length2 = '321' then 1.47523324311123
    when @Trip_Length2 = '328' then 1.47542979876421
    when @Trip_Length2 = '335' then 1.47558078548129
    when @Trip_Length2 = '342' then 1.47569655083511
    when @Trip_Length2 = '349' then 1.47578561541683
    when @Trip_Length2 = '356' then 1.47585502090563
    when @Trip_Length2 = '363' then 1.4759106594391
    when @Trip_Length2 = '365' then 1.47595757879295
    when @Trip_Length2 = '370' then 1.47600027420438
end

-- Start of Lead_Time2
set @LinearPredictor = @LinearPredictor +
case
    when @Lead_Time2 = '0' then 0.0955360376082783
    when @Lead_Time2 = '1' then 0
    when @Lead_Time2 = '2' then 0
    when @Lead_Time2 = '3' then 0
    when @Lead_Time2 = '4' then 0
    when @Lead_Time2 = '5' then 0
    when @Lead_Time2 = '6' then 0
    when @Lead_Time2 = '7' then 0
    when @Lead_Time2 = '8' then 0
    when @Lead_Time2 = '9' then 0
    when @Lead_Time2 = '10' then 0.000733951702384697
    when @Lead_Time2 = '11' then 0.00200718429943078
    when @Lead_Time2 = '12' then 0.00374031495829823
    when @Lead_Time2 = '13' then 0.00581798487451487
    when @Lead_Time2 = '14' then 0.00810449745337657
    when @Lead_Time2 = '15' then 0.0104591729697194
    when @Lead_Time2 = '16' then 0.0127504205959682
    when @Lead_Time2 = '17' then 0.0148672423995047
    when @Lead_Time2 = '18' then 0.0167277972496666
    when @Lead_Time2 = '19' then 0.018284838380362
    when @Lead_Time2 = '20' then 0.0195281152301243
    when @Lead_Time2 = '21' then 0.0204838835473806
    when @Lead_Time2 = '22' then 0.0212117457514447
    when @Lead_Time2 = '23' then 0.0217991661266454
    when @Lead_Time2 = '24' then 0.022354163416506
    when @Lead_Time2 = '25' then 0.0229968098698094
    when @Lead_Time2 = '26' then 0.0238502907276503
    when @Lead_Time2 = '27' then 0.0250322459704194
    when @Lead_Time2 = '28' then 0.0266469507355173
    when @Lead_Time2 = '29' then 0.0287786694493138
    when @Lead_Time2 = '30' then 0.0314862791401048
    when @Lead_Time2 = '31' then 0.0347990664808958
    when @Lead_Time2 = '32' then 0.0387136469532746
    when @Lead_Time2 = '33' then 0.0431920366850499
    when @Lead_Time2 = '34' then 0.0481611834649421
    when @Lead_Time2 = '35' then 0.0535144311329034
    when @Lead_Time2 = '36' then 0.059115457221492
    when @Lead_Time2 = '37' then 0.0648050560829487
    when @Lead_Time2 = '38' then 0.0704107823665704
    when @Lead_Time2 = '39' then 0.0757589223666634
    when @Lead_Time2 = '40' then 0.0806877392119035
    when @Lead_Time2 = '41' then 0.0850605255215858
    when @Lead_Time2 = '42' then 0.0887767761830042
    when @Lead_Time2 = '43' then 0.0917798820802301
    when @Lead_Time2 = '44' then 0.0940601279893106
    when @Lead_Time2 = '45' then 0.0956523468440968
    when @Lead_Time2 = '46' then 0.0966284047579768
    when @Lead_Time2 = '47' then 0.0970855025672056
    when @Lead_Time2 = '48' then 0.0971320942320033
    when @Lead_Time2 = '49' then 0.0972078333786537
    when @Lead_Time2 = '50' then 0.0972835667893194
    when @Lead_Time2 = '51' then 0.0973592944648702
    when @Lead_Time2 = '52' then 0.0974350164061746
    when @Lead_Time2 = '53' then 0.0975107326141007
    when @Lead_Time2 = '54' then 0.0975864430895169
    when @Lead_Time2 = '55' then 0.0976621468354141
    when @Lead_Time2 = '56' then 0.0977378458484895
    when @Lead_Time2 = '57' then 0.0978135391316575
    when @Lead_Time2 = '58' then 0.097889226685786
    when @Lead_Time2 = '59' then 0.0979649085117424
    when @Lead_Time2 = '60' then 0.0980405846103935
    when @Lead_Time2 = '61' then 0.0981162549826058
    when @Lead_Time2 = '62' then 0.0981919196292464
    when @Lead_Time2 = '63' then 0.0982675785511815
    when @Lead_Time2 = '64' then 0.10259523275734
    when @Lead_Time2 = '65' then 0.107960650444152
    when @Lead_Time2 = '66' then 0.114277147772883
    when @Lead_Time2 = '67' then 0.121405794165926
    when @Lead_Time2 = '68' then 0.129174490243109
    when @Lead_Time2 = '69' then 0.137399088441312
    when @Lead_Time2 = '70' then 0.145901883548446
    when @Lead_Time2 = '71' then 0.154523842924112
    when @Lead_Time2 = '72' then 0.163128743721028
    when @Lead_Time2 = '73' then 0.171599676199167
    when @Lead_Time2 = '74' then 0.179830347628951
    when @Lead_Time2 = '75' then 0.187714991145449
    when @Lead_Time2 = '76' then 0.195140980790277
    when @Lead_Time2 = '77' then 0.201987478790408
    when @Lead_Time2 = '78' then 0.208131757039983
    when @Lead_Time2 = '79' then 0.213462743832441
    when @Lead_Time2 = '80' then 0.217899300435914
    when @Lead_Time2 = '81' then 0.221409373903517
    when @Lead_Time2 = '82' then 0.224025618885431
    when @Lead_Time2 = '83' then 0.225853556268105
    when @Lead_Time2 = '84' then 0.227069551301121
    when @Lead_Time2 = '85' then 0.227907697252403
    when @Lead_Time2 = '86' then 0.228636649460086
    when @Lead_Time2 = '87' then 0.22952933066537
    when @Lead_Time2 = '88' then 0.230829847512687
    when @Lead_Time2 = '89' then 0.232722623118681
    when @Lead_Time2 = '90' then 0.235308550362353
    when @Lead_Time2 = '91' then 0.238591858768789
    when @Lead_Time2 = '92' then 0.242479630953077
    when @Lead_Time2 = '93' then 0.246793927636514
    when @Lead_Time2 = '94' then 0.251294627768882
    when @Lead_Time2 = '95' then 0.255709816388467
    when @Lead_Time2 = '96' then 0.259769810621083
    when @Lead_Time2 = '97' then 0.263240806914884
    when @Lead_Time2 = '98' then 0.265954351899527
    when @Lead_Time2 = '99' then 0.267829305443744
    when @Lead_Time2 = '100' then 0.268883565486195
    when @Lead_Time2 = '101' then 0.269233632208123
    when @Lead_Time2 = '102' then 0.269345464633572
    when @Lead_Time2 = '103' then 0.269457283713566
    when @Lead_Time2 = '104' then 0.26956909113172
    when @Lead_Time2 = '105' then 0.269680886050372
    when @Lead_Time2 = '106' then 0.269792668472318
    when @Lead_Time2 = '107' then 0.269904438400351
    when @Lead_Time2 = '108' then 0.271685522962541
    when @Lead_Time2 = '109' then 0.274026348710943
    when @Lead_Time2 = '110' then 0.276737932815075
    when @Lead_Time2 = '111' then 0.279569697084298
    when @Lead_Time2 = '112' then 0.282249356481897
    when @Lead_Time2 = '113' then 0.284524425779793
    when @Lead_Time2 = '114' then 0.286198638473514
    when @Lead_Time2 = '115' then 0.287158130851404
    when @Lead_Time2 = '116' then 0.287384574103792
    when @Lead_Time2 = '117' then 0.287510330648486
    when @Lead_Time2 = '118' then 0.287636072205683
    when @Lead_Time2 = '119' then 0.287761797128809
    when @Lead_Time2 = '120' then 0.287887506247166
    when @Lead_Time2 = '121' then 0.28801320038964
    when @Lead_Time2 = '122' then 0.288138877910272
    when @Lead_Time2 = '123' then 0.28826453963805
    when @Lead_Time2 = '124' then 0.288390186401544
    when @Lead_Time2 = '125' then 0.288515816555414
    when @Lead_Time2 = '126' then 0.288641431752726
    when @Lead_Time2 = '127' then 0.292770500525358
    when @Lead_Time2 = '128' then 0.29786936567596
    when @Lead_Time2 = '129' then 0.303836857764173
    when @Lead_Time2 = '130' then 0.310533106659762
    when @Lead_Time2 = '131' then 0.317787286138742
    when @Lead_Time2 = '132' then 0.325406486130727
    when @Lead_Time2 = '133' then 0.333185714090095
    when @Lead_Time2 = '134' then 0.340918738818548
    when @Lead_Time2 = '135' then 0.348409085721102
    when @Lead_Time2 = '136' then 0.355480162822905
    when @Lead_Time2 = '137' then 0.361983263126801
    when @Lead_Time2 = '138' then 0.367802239526465
    when @Lead_Time2 = '139' then 0.37285389616412
    when @Lead_Time2 = '140' then 0.377083710546216
    when @Lead_Time2 = '141' then 0.380457275962457
    when @Lead_Time2 = '142' then 0.382948767290552
    when @Lead_Time2 = '143' then 0.384528605485699
    when @Lead_Time2 = '144' then 0.385153044865734
    when @Lead_Time2 = '145' then 0.38535706910528
    when @Lead_Time2 = '146' then 0.385561051727427
    when @Lead_Time2 = '147' then 0.385764992001057
    when @Lead_Time2 = '148' then 0.385968891439473
    when @Lead_Time2 = '149' then 0.386172749311382
    when @Lead_Time2 = '150' then 0.386376564886095
    when @Lead_Time2 = '151' then 0.386580339675966
    when @Lead_Time2 = '152' then 0.386784072202802
    when @Lead_Time2 = '153' then 0.386987763978328
    when @Lead_Time2 = '154' then 0.387191414271964
    when @Lead_Time2 = '155' then 0.387395022353728
    when @Lead_Time2 = '156' then 0.387598589734402
    when @Lead_Time2 = '157' then 0.387802114937261
    when @Lead_Time2 = '158' then 0.388005599472459
    when @Lead_Time2 = '159' then 0.388209042610125
    when @Lead_Time2 = '160' then 0.388412443620985
    when @Lead_Time2 = '161' then 0.388615804014249
    when @Lead_Time2 = '162' then 0.388819123060471
    when @Lead_Time2 = '163' then 0.389022400030803
    when @Lead_Time2 = '164' then 0.389225636433514
    when @Lead_Time2 = '165' then 0.389428830794226
    when @Lead_Time2 = '166' then 0.389631984620583
    when @Lead_Time2 = '167' then 0.389835097183844
    when @Lead_Time2 = '168' then 0.390038167755868
    when @Lead_Time2 = '169' then 0.390241197843358
    when @Lead_Time2 = '170' then 0.390444186717998
    when @Lead_Time2 = '171' then 0.390647133652069
    when @Lead_Time2 = '172' then 0.394762832314287
    when @Lead_Time2 = '173' then 0.397047710767197
    when @Lead_Time2 = '174' then 0.3979624111562
    when @Lead_Time2 = '175' then 0.398131414367192
    when @Lead_Time2 = '176' then 0.398275855540661
    when @Lead_Time2 = '177' then 0.399133074000049
    when @Lead_Time2 = '178' then 0.401372249198902
    when @Lead_Time2 = '179' then 0.405517852995609
    when @Lead_Time2 = '180' then 0.411892875053858
    when @Lead_Time2 = '181' then 0.420590873054728
    when @Lead_Time2 = '188' then 0.431480357048592
    when @Lead_Time2 = '195' then 0.444238402529713
    when @Lead_Time2 = '202' then 0.458404871147411
    when @Lead_Time2 = '209' then 0.473445866887468
    when @Lead_Time2 = '216' then 0.488815535827469
    when @Lead_Time2 = '223' then 0.504008127545017
    when @Lead_Time2 = '230' then 0.518596065269258
    when @Lead_Time2 = '237' then 0.53225326106661
    when @Lead_Time2 = '244' then 0.544765354875142
    when @Lead_Time2 = '251' then 0.556029747449236
    when @Lead_Time2 = '258' then 0.566048410546993
    when @Lead_Time2 = '265' then 0.574915941260384
    when @Lead_Time2 = '272' then 0.582804389505642
    when @Lead_Time2 = '279' then 0.589945559075736
    when @Lead_Time2 = '286' then 0.596610829149926
    when @Lead_Time2 = '293' then 0.603088395279134
    when @Lead_Time2 = '300' then 0.609658200812534
    when @Lead_Time2 = '307' then 0.61656564342159
    when @Lead_Time2 = '314' then 0.623996233666166
    when @Lead_Time2 = '321' then 0.632054269802097
    when @Lead_Time2 = '328' then 0.640748895527119
    when @Lead_Time2 = '335' then 0.649990280229164
    when @Lead_Time2 = '342' then 0.659597101505243
    when @Lead_Time2 = '349' then 0.669314347615113
    when @Lead_Time2 = '356' then 0.67883831822786
    when @Lead_Time2 = '363' then 0.687844234405516
    when @Lead_Time2 = '370' then 0.696011565088747
    when @Lead_Time2 = '377' then 0.703043072066204
    when @Lead_Time2 = '384' then 0.708675509590545
    when @Lead_Time2 = '391' then 0.712682289116945
    when @Lead_Time2 = '398' then 0.712682289116945
    when @Lead_Time2 = '405' then 0.712682289116945
    when @Lead_Time2 = '412' then 0.712682289116945
    when @Lead_Time2 = '419' then 0.712682289116945
    when @Lead_Time2 = '426' then 0.712682289116945
    when @Lead_Time2 = '433' then 0.712682289116945
    when @Lead_Time2 = '440' then 0.712682289116945
    when @Lead_Time2 = '447' then 0.712682289116945
    when @Lead_Time2 = '454' then 0.712682289116945
    when @Lead_Time2 = '461' then 0.712682289116945
    when @Lead_Time2 = '468' then 0.712682289116945
    when @Lead_Time2 = '475' then 0.712682289116945
    when @Lead_Time2 = '482' then 0.712682289116945
    when @Lead_Time2 = '489' then 0.712682289116945
    when @Lead_Time2 = '496' then 0.712682289116945
    when @Lead_Time2 = '503' then 0.712682289116945
    when @Lead_Time2 = '510' then 0.712682289116945
    when @Lead_Time2 = '517' then 0.712682289116945
    when @Lead_Time2 = '524' then 0.712682289116945
    when @Lead_Time2 = '531' then 0.712682289116945
    when @Lead_Time2 = '538' then 0.712682289116945
    when @Lead_Time2 = '545' then 0.712682289116945
    when @Lead_Time2 = '552' then 0.712682289116945
end

-- Start of OldestAge2
set @LinearPredictor = @LinearPredictor +
case
    when @OldestAge2 = '-1' then -2.17993411952423
    when @OldestAge2 = '12' then -0.596065986473728
    when @OldestAge2 = '13' then -0.584543140816524
    when @OldestAge2 = '14' then -0.576111363378975
    when @OldestAge2 = '15' then -0.558833712283172
    when @OldestAge2 = '16' then -0.537546546874351
    when @OldestAge2 = '17' then -0.510933583474007
    when @OldestAge2 = '18' then -0.480157466939391
    when @OldestAge2 = '19' then -0.44563251430275
    when @OldestAge2 = '20' then -0.408207722175451
    when @OldestAge2 = '21' then -0.368696177881401
    when @OldestAge2 = '22' then -0.328002099647403
    when @OldestAge2 = '23' then -0.287021043688596
    when @OldestAge2 = '24' then -0.2466226239523
    when @OldestAge2 = '25' then -0.207608274654186
    when @OldestAge2 = '26' then -0.170687080935153
    when @OldestAge2 = '27' then -0.136455768972926
    when @OldestAge2 = '28' then -0.105387819841253
    when @OldestAge2 = '29' then -0.0778286153808558
    when @OldestAge2 = '30' then -0.0539959038877739
    when @OldestAge2 = '31' then -0.0339840178474437
    when @OldestAge2 = '32' then -0.0177709480279917
    when @OldestAge2 = '33' then -0.00522761557171764
    when @OldestAge2 = '34' then 0.00387088149171067
    when @OldestAge2 = '35' then 0.00983209290796081
    when @OldestAge2 = '36' then 0.013031138696494
    when @OldestAge2 = '37' then 0.0138938600360623
    when @OldestAge2 = '38' then 0.0128786656742265
    when @OldestAge2 = '39' then 0.0104578751252333
    when @OldestAge2 = '40' then 0.00709970172222094
    when @OldestAge2 = '41' then 0.00325214131379695
    when @OldestAge2 = '42' then -0.000670049924555566
    when @OldestAge2 = '43' then -0.00429449647283149
    when @OldestAge2 = '44' then -0.00729625614074434
    when @OldestAge2 = '45' then -0.00939928186781547
    when @OldestAge2 = '46' then -0.0103753320566345
    when @OldestAge2 = '47' then -0.0100416775801761
    when @OldestAge2 = '48' then -0.00825894020236713
    when @OldestAge2 = '49' then -0.0049299543312324
    when @OldestAge2 = '50' then 0
    when @OldestAge2 = '51' then 0.00654198049389792
    when @OldestAge2 = '52' then 0.014662045013262
    when @OldestAge2 = '53' then 0.0242810254510797
    when @OldestAge2 = '54' then 0.0352765559242618
    when @OldestAge2 = '55' then 0.0474882723832621
    when @OldestAge2 = '56' then 0.0607265645592142
    when @OldestAge2 = '57' then 0.0747847421789886
    when @OldestAge2 = '58' then 0.0894539738028754
    when @OldestAge2 = '59' then 0.104539918428729
    when @OldestAge2 = '60' then 0.119879743714605
    when @OldestAge2 = '61' then 0.135358049438942
    when @OldestAge2 = '62' then 0.150920149339083
    when @OldestAge2 = '63' then 0.16658120171253
    when @OldestAge2 = '64' then 0.182429800651471
    when @OldestAge2 = '65' then 0.198624903744452
    when @OldestAge2 = '66' then 0.215385479410067
    when @OldestAge2 = '67' then 0.232972981853126
    when @OldestAge2 = '68' then 0.251667736808603
    when @OldestAge2 = '69' then 0.271741358694633
    when @OldestAge2 = '70' then 0.293428244637687
    when @OldestAge2 = '71' then 0.316899683710821
    when @OldestAge2 = '72' then 0.342243915527783
    when @OldestAge2 = '73' then 0.369454526579805
    when @OldestAge2 = '74' then 0.398428058936696
    when @OldestAge2 = '75' then 0.428969896996911
    when @OldestAge2 = '76' then 0.46080620497807
    when @OldestAge2 = '77' then 0.493598525877505
    when @OldestAge2 = '78' then 0.526958730259464
    when @OldestAge2 = '79' then 0.560460508793678
    when @OldestAge2 = '80' then 0.593650649074056
    when @OldestAge2 = '81' then 0.62605045716042
    when @OldestAge2 = '82' then 0.657173713017539
    when @OldestAge2 = '83' then 0.686501135325193
    when @OldestAge2 = '84' then 0.713566521953495
    when @OldestAge2 = '85' then 0.737773431811669
    when @OldestAge2 = '86' then 0.758896456512121
    when @OldestAge2 = '87' then 0.775876680319181
    when @OldestAge2 = '88' then 0.789919005953895
    when @OldestAge2 = '89' then 0.796714004195244
    when @OldestAge2 = '90' then 0.806278573236552
end

-- Start of Traveller_Count2
set @LinearPredictor = @LinearPredictor +
case
    when @Traveller_Count2 = '1' then 0
    when @Traveller_Count2 = '2' then 0.290767206765159
    when @Traveller_Count2 = '3' then 0.290767206765159
    when @Traveller_Count2 = '4' then 0.290767206765159
    when @Traveller_Count2 = '5' then 0.290767206765159
    when @Traveller_Count2 = '6' then 0.290767206765159
    when @Traveller_Count2 = '7' then 0.290767206765159
    when @Traveller_Count2 = '8' then 0.290767206765159
    when @Traveller_Count2 = '9' then 0.290767206765159
    when @Traveller_Count2 = '10' then 0.290767206765159
end

-- Start of JV_Description
set @LinearPredictor = @LinearPredictor +
case
    when @JV_Description = 'AAA' then 0
    when @JV_Description = 'AHM - Medibank' then -0.134540882325048
    when @JV_Description = 'Air New Zealand' then 0
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
    when @JV_Description = 'Medibank' then -0.134540882325048
    when @JV_Description = 'Non Travel Agency - Dist' then 0
    when @JV_Description = 'P&O Cruises' then 0
    when @JV_Description = 'Phone Sales' then 0.213904174747027
    when @JV_Description = 'Virgin' then -0.518621813670085
    when @JV_Description = 'Websales' then 0
    when @JV_Description = 'YouGo' then 0
end

-- Start of Product_Indicator
set @LinearPredictor = @LinearPredictor +
case
    when @Product_Indicator = 'Car Hire' then 0
    when @Product_Indicator = 'Corporate' then 0
    when @Product_Indicator = 'Domestic AMT' then -0.782720344736527
    when @Product_Indicator = 'Domestic Cancellation' then 0
    when @Product_Indicator = 'Domestic Inbound' then 0.510325607929171
    when @Product_Indicator = 'Domestic Single Trip' then 0
    when @Product_Indicator = 'Domestic Single Trip Integrated' then 0
    when @Product_Indicator = 'International AMT' then 0
    when @Product_Indicator = 'International Single Trip' then 0
    when @Product_Indicator = 'International Single Trip Integrated' then 0
end

-- Start of Departure_Month
set @LinearPredictor = @LinearPredictor +
case
    when @Departure_Month = '1' then -0.0787932709140078
    when @Departure_Month = '2' then -0.0787932709140078
    when @Departure_Month = '3' then 0.151053159610073
    when @Departure_Month = '4' then -0.1270181902628
    when @Departure_Month = '5' then -0.0787932709140078
    when @Departure_Month = '6' then 0
    when @Departure_Month = '7' then -0.0787932709140078
    when @Departure_Month = '8' then 0.151053159610073
    when @Departure_Month = '9' then -0.0787932709140078
    when @Departure_Month = '10' then -0.1270181902628
    when @Departure_Month = '11' then -0.0787932709140078
    when @Departure_Month = '12' then -0.0787932709140078
end

-- Start of EMCBand
set @LinearPredictor = @LinearPredictor +
case
    when @EMCBand = '0_<50%' then 0
    when @EMCBand = '1_<50%' then 0.249504631333768
    when @EMCBand = '1_>50%' then 0.249504631333768
    when @EMCBand = '2_<50%' then 0.249504631333768
    when @EMCBand = '2_>50%' then 0.249504631333768
    when @EMCBand = '3_<50%' then 0.249504631333768
    when @EMCBand = '3_>50%' then 0.249504631333768
    when @EMCBand = '4_<50%' then 0.249504631333768
    when @EMCBand = '4_>50%' then 0.249504631333768
    when @EMCBand = '5_<50%' then 0.64145251460055
    when @EMCBand = '5_>50%' then 0.64145251460055
    when @EMCBand = '6_<50%' then 0.64145251460055
    when @EMCBand = '6_>50%' then 0.64145251460055
    when @EMCBand = '7_<50%' then 0.64145251460055
    when @EMCBand = '7_>50%' then 0.64145251460055
    when @EMCBand = '8_<50%' then 0.64145251460055
    when @EMCBand = '8_>50%' then 0.64145251460055
end

-- Start of Latest_product
set @LinearPredictor = @LinearPredictor +
case
    when @Latest_product = 'FCO' then -0.0210229732792167
    when @Latest_product = 'FCT' then 0
    when @Latest_product = 'NCC' then -0.0397258305070185
    when @Latest_product = 'Y' then 0
end

-- Start of Return_Mth
set @LinearPredictor = @LinearPredictor +
case
    when @Return_Mth = '01JUN2017' then 0.0344739545385755
    when @Return_Mth = '01JUL2017' then 0.0344739545385755
    when @Return_Mth = '01AUG2017' then 0.0344739545385755
    when @Return_Mth = '01SEP2017' then 0.0344739545385755
    when @Return_Mth = '01OCT2017' then 0.0344739545385755
    when @Return_Mth = '01NOV2017' then 0.0344739545385755
    when @Return_Mth = '01DEC2017' then 0.0344739545385755
    when @Return_Mth = '01JAN2018' then 0.0344739545385755
    when @Return_Mth = '01FEB2018' then -0.104222879144798
    when @Return_Mth = '01MAR2018' then -0.104222879144798
    when @Return_Mth = '01APR2018' then -0.104222879144798
    when @Return_Mth = '01MAY2018' then -0.104222879144798
    when @Return_Mth = '01JUN2018' then -0.104222879144798
    when @Return_Mth = '01JUL2018' then -0.104222879144798
    when @Return_Mth = '01AUG2018' then -0.104222879144798
    when @Return_Mth = '01SEP2018' then -0.104222879144798
    when @Return_Mth = '01OCT2018' then -0.104222879144798
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

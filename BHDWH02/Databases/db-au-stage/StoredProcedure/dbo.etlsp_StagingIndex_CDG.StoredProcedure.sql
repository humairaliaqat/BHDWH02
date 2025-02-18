USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_CDG]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[etlsp_StagingIndex_CDG]
as
begin

    set nocount on

    if not exists(select name from sys.indexes where name = 'idx_cdg_BusinessUnit_AU_BusinessUnitId')
        create index idx_cdg_BusinessUnit_AU_BusinessUnitId on cdg_BusinessUnit_AU(BusinessUnitId) include(Domain, BusinessUnit)

    if not exists(select name from sys.indexes where name = 'idx_cdg_Campaign_AU_CampaignId')
        create index idx_cdg_Campaign_AU_CampaignId on cdg_Campaign_AU(CampaignId) include(Campaign)

    if not exists(select name from sys.indexes where name = 'idx_cdg_Channel_AU_ChannelId')
        create index idx_cdg_Campaign_AU_CampaignId on cdg_Channel_AU(ChannelId) include(Channel, Currency)
        
    if not exists(select name from sys.indexes where name = 'idx_cdg_Construct_AU_ConstructId')
        create index idx_cdg_Construct_AU_ConstructId on cdg_Construct_AU(ConstructId) include(Construct)

    if not exists(select name from sys.indexes where name = 'idx_cdg_Country_AU_CountryId')
        create index idx_cdg_Country_AU_CountryId on cdg_Country_AU(CountryId) include(Country, Code)
        
    if not exists(select name from sys.indexes where name = 'idx_cdg_Offer_AU_OfferId')
        create index idx_cdg_Offer_AU_OfferId on cdg_Offer_AU(OfferId) include(Offer)
        
    if not exists(select name from sys.indexes where name = 'idx_cdg_Product_AU_ProductId')
        create index idx_cdg_Product_AU_ProductId on cdg_Product_AU(ProductId) include(Code, PlanCode, Product)
        
    if not exists(select name from sys.indexes where name = 'idx_cdg_Region_AU_RegionId')
        create index idx_cdg_Region_AU_RegionId on cdg_Region_AU(RegionId) include(Region)

    if not exists(select name from sys.indexes where name = 'idx_cdg_Policy_AU_PolicyId')
        create index idx_cdg_Policy_AU_PolicyId on cdg_Policy_AU(PolicyId) include(Number)
        
end

GO

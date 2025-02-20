USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_e5]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_StagingIndex_e5]
as
begin
/*
20130813 - LS - start optimising e5
*/

    set nocount on

    if not exists(select name from sys.indexes where  name = 'e5_WorkProperty_au1')
        create nonclustered index e5_WorkProperty_au1 on e5_WorkProperty_au(Work_Id,Property_Id) include(PropertyValue)

    if not exists(select name from sys.indexes where  name = 'e5_WorkClass_au1')
        create nonclustered index e5_WorkClass_au1 on e5_WorkClass_au(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_Category1_au1')
        create nonclustered index e5_Category1_au1 on e5_Category1_au(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_Category2_au1')
        create nonclustered index e5_Category2_au1 on e5_Category2_au(Id) include(Name)
        
    if not exists(select name from sys.indexes where  name = 'e5_Category3_au1')
        create nonclustered index e5_Category3_au1 on e5_Category3_au(Id) include(Name)
        
    if not exists(select name from sys.indexes where  name = 'e5_Status_au1')
        create nonclustered index e5_Status_au1 on e5_Status_au(Id) include(Name)
        
end
GO

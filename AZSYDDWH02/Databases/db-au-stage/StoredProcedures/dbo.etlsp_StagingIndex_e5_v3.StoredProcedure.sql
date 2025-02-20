USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_e5_v3]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_StagingIndex_e5_v3]
as
begin
/*
20130813 - LS - start optimising e5
*/

    set nocount on

    if not exists(select name from sys.indexes where  name = 'e5_WorkProperty_v31')
        create nonclustered index e5_WorkProperty_v31 on e5_WorkProperty_v3(Work_Id,Property_Id) include(PropertyValue)

    if not exists(select name from sys.indexes where  name = 'e5_WorkClass_v31')
        create nonclustered index e5_WorkClass_v31 on e5_WorkClass_v3(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_Category1_v31')
        create nonclustered index e5_Category1_v31 on e5_Category1_v3(Id) include(Name,Code)

    if not exists(select name from sys.indexes where  name = 'e5_Category2_v31')
        create nonclustered index e5_Category2_v31 on e5_Category2_v3(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_Category3_v31')
        create nonclustered index e5_Category3_v31 on e5_Category3_v3(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_Status_v31')
        create nonclustered index e5_Status_v31 on e5_Status_v3(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_WorkProperty_v31')
        create nonclustered index e5_WorkProperty_v31 on e5_WorkProperty_v3(Work_Id,Property_Id) include(PropertyValue)

    if not exists(select name from sys.indexes where  name = 'e5_WorkActivityProperty_v31')
        create nonclustered index e5_WorkActivityProperty_v31 on e5_WorkActivityProperty_v3(Work_Id,WorkActivity_Id,Property_Id) include(PropertyValue)

    if not exists(select name from sys.indexes where  name = 'e5_Work_v31')
        create nonclustered index e5_Work_v31 on e5_Work_v3(Id) include(Category1_Id)

    if not exists(select name from sys.indexes where  name = 'e5_ListItem_v31')
        create nonclustered index e5_ListItem_v31 on e5_ListItem_v3(Id) include(Code,Name)

    if not exists(select name from sys.indexes where  name = 'e5_CategoryActivity_v31')
        create nonclustered index e5_CategoryActivity_v31 on e5_CategoryActivity_v3(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_Event_v31')
        create nonclustered index e5_Event_v31 on e5_Event_v3(Id) include(Name)

    if not exists(select name from sys.indexes where  name = 'e5_Property_v31')
        create nonclustered index e5_Property_v31 on e5_Property_v3(PropertyLabel,Id)

end

GO

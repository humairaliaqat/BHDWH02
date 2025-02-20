USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_Carebase]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[etlsp_StagingIndex_Carebase]
as
begin
/*
20130903 - LS - start optimising carebase
*/

    set nocount on

    if not exists(select name from  sys.indexes where  name = 'idx_carebase_ADM_USER_aucm_USERID')
        create index idx_carebase_ADM_USER_aucm_USERID on carebase_ADM_USER_aucm(USERID) include(SURNAME, PREF_NAME)

    if not exists(select name from  sys.indexes where  name = 'idx_carebase_CBL_BILLING_EXT_aucm_RECID')
        create index idx_carebase_CBL_BILLING_EXT_aucm_RECID on carebase_CBL_BILLING_EXT_aucm(RECID) include(Diagnosis, PPO_US_STATE, NET_SAVING)

    if not exists(select name from  sys.indexes where  name = 'idx_carebase_UCR_CURRENCY_aucm_CURRENCY')
        create index idx_carebase_UCR_CURRENCY_aucm_CURRENCY on carebase_UCR_CURRENCY_aucm(CURRENCY) include(DESCRIPT)

    if not exists(select name from  sys.indexes where  name = 'idx_carebase_AUDIT_CBL_BILLING_aucm_ROWID')
        create index idx_carebase_AUDIT_CBL_BILLING_aucm_ROWID on carebase_AUDIT_CBL_BILLING_aucm(ROWID) include(AUDIT_DATETIME,AUDIT_ACTION)

end

GO

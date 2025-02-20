USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt0059a]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[rptsp_rpt0059a]
    @Country varchar(2) = null
    
as
begin


/****************************************************************************************************/
--  Name:           dbo.rptsp_rpt0059a
--  Author:         Leonardus Setyabudi
--  Date Created:   20111221
--  Description:    This stored procedure returns customer care open cases
--  Parameters:
--
--  Change History: 20111221 - LS - Migrated from OXLEY.RPTDB.dbo.rptsp_rpt0059a
--                  20130910 - LS - Carebase FFG, read from BI's data (we have hourly refresh)
--                  20131030 - LS - bug fix, ambiguous DOB (new column on cbAddress)
--                  20140715 - LS - TFS12109, unicode
--                  20140821 - LS - optional Country parameter
--					20170831 - SD - Added columns RiskLevel, CaseType, Customer Location and Last CaseNote
--					20171107 - LT - Changed contact details to 'CONTACT ADDRESS' address type.
--									Added Open_Date and Email columns to output.
--					20180301 - SD - Added Residential address details such as as Company, phone, fax, telex, mobile and email
--
/****************************************************************************************************/

    set nocount on

	--uncomment to debug
/*	
	declare @Country varchar(2)
	select @Country = 'AU'
*/

    select distinct
        c.CaseNo CASE_NO,
        c.Surname SURNAME,
        c.FirstName FIRST,
        c.ClientCode CLI_CODE,
		c.OpenDate OPEN_DATE,
        p.ProductCode POL_CODE,
        convert(datetime, decryptbykeyautocert(cert_id('EMCCertificate'), null, c.DOB, 0, null)) DOB,
        p.PolicyNo POLICY_NO,
        p.IssueDate ISSUED,
        p.DepartureDate DEP_DATE,
        p.ExpiryDate EXPIRES,
        p.PolicyType [TYPE],
        '' CONTACT,
		a.COMPANY,
		a.PHONE,
		a.FAX,
		a.TELEX,
		a.MOBILE,
		a.EMAIL,
		home.COMPANY [HomeCompany],
		home.PHONE [HomePhone],
		home.FAX [HomeFax],
		home.TELEX [HomeTelex],
		home.MOBILE [HomeMobile],
		home.EMAIL [HomeEmail],
        c.CountryKey Country,
		c.Country [Customer Location],
		c.RiskLevel,
		c.CaseType,
		cn.Notes [Last Case Note]
    from
        cbCase c
        left join cbPolicy p on
            p.CaseKey = c.CaseKey and
            p.IsMainPolicy = 1
		outer apply
		(
			select top 1
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, COMPANY, 0, null)) COMPANY,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, PHONE, 0, null)) PHONE,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, FAX, 0, null)) FAX,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, TELEX, 0, null)) TELEX,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, MOBILE, 0, null)) MOBILE,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, EMAIL, 0, null)) EMAIL
			from
				cbAddress
			where
				CaseKey = c.CaseKey and
				AddressType = 'CONTACT ADDRESS'
		) a
		outer apply
		(
			select top 1
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, COMPANY, 0, null)) COMPANY,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, PHONE, 0, null)) PHONE,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, FAX, 0, null)) FAX,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, TELEX, 0, null)) TELEX,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, MOBILE, 0, null)) MOBILE,
				convert(nvarchar, decryptbykeyautocert(cert_id('EMCCertificate'), null, EMAIL, 0, null)) EMAIL
			from
				cbAddress
			where
				CaseKey = c.CaseKey and
				AddressType = 'RESIDENTIAL ADDRESS'
		) home
		Outer apply
		(
			select 
				top 1 cn.Notes 
			from 
				cbNote cn 
			where 
				cn.CaseKey= c.CaseKey 
				and NoteType = 'CASE NOTE' 
			order by 
				CreateDate Desc
		) cn
    where
        (
            isnull(@Country, '') = '' or
            c.CountryKey = @Country
        ) and
        c.CaseStatus = 'Open' and
        c.Surname <> 'delete' and
        c.IsDeleted = 0
    order by
        c.Surname,
        c.FirstName,
        c.CaseNo

end
GO

declare @AktOfNum int = 201423514 ;

DECLARE @uuid uniqueidentifier;
select @uuid = hardcopy_uuid from aof_oper.dbo.aof_ecp where id = @AktOfNum


select *
from arg.dbo.aktof
where AktOfNum = @AktOfNum



select *
from aof_oper.dbo.aof_ecp
where id = @AktOfNum

select *
from arg.dbo.aofsendEdo
where aofid = @AktOfNum



select *
from arg.dbo.AktOfSign
where AktOfNum = @AktOfNum

select p.*, u.login
from tau.hardcopy.dbo.paper_signs as p
	left join admin.dbo.D_User as u
		on u.Code = p.user_code
where paper_uuid = @uuid


select p.*, u.login
from tau.hardcopy.dbo.paper_external_signs as p
	left join admin.dbo.D_User as u
		on u.Code = p.user_code
where paper_uuid = @uuid

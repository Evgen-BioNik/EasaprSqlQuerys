select * from admin.dbo.WhoSaved
where NumRecord = 45552

select * from admin.dbo.D_User
where Code in (45552)
 /*
update admin.dbo.D_User
set system='easapr', soapAofCarrier = null, soapDirection = null, soapPosition = null
where Code in (45552)



update aof_oper.dbo.aof set UserName = 'easapr'
where AktOfNum in (

select distinct numrecord from aof_oper.dbo.WhoSaved
where UserId in (63496,60911,59825) and DateTimeSaving > '2018' and TableName = 'aktof'


)
*/


select * from admin.dbo.D_User
where system='stTst' and Del is null and Station is not null and Rail is not null
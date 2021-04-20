
declare @aofid int = 164955291;
update aof_oper.dbo.aof set Status = 1, ReasonDelay = 324 where AktOfNum = @aofid

/*
	insert into arg.dbo.aofsendEtran (typedoc,datewrite,aofid) values('aof',getdate(),166215396 )
*/

update aof_oper.dbo.aof_alb_json
set aof_json = '{"dropNumEnd":"234","dropSignEnd":"Д Кобзев С В","IsServiceOrderEnd":null,"dropTrackEnd":"01\/04","ClaimIDEnd":"858519364","ClientNameEnd":"Общество с ограниченной ответственностью \"ПЕРВЫЙ ЗАВОД\"","ClaimNumEnd":"27602","ContractNumEnd":"821\/ОПС-16","dropEndDate":"13.01.19","dropEndTime":"12:10","ClaimEndDate":"11.01.19","ClaimEndTime":"00:00","ContractEndDate":"26.10.16","ContractEndTime":"00:00"}'
where AktOfNum = @aofid
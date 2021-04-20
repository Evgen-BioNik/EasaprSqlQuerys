
declare @memoid int = 44165775
select * from memo.dbo.memo
--where memoNum = 803260 and memoStation = '91110'
where memoId = @memoid

select *
from memo.dbo.memo_car
where memoId = @memoid
/*
select * from arg.dbo.AktOfSend
where AktOfNum in (151056965)

select * from arg.dbo.AktOfcarriage
where AktOfNum in (151385180)

*/
select * from arg.dbo.logMess
where docId = @memoid --and system!='stTst  '
order by id
/*
select *
from arg.dbo.logMess
where textMess like '%5544461B-F1EA-488B-BB4B-646FC6B504B0%' and dateMess between '2020-09-07 00:00' and '2020-09-08' and typemess = 'gu45'
*/
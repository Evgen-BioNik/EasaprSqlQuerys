select * from arg.dbo.port_station_working
where carnum = 55354831  


declare @memoid int = 31051050
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
where docId = @memoid
order by id
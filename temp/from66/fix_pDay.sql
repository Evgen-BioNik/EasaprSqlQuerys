
delete arg.dbo.tempprolong
insert into arg.dbo.tempprolong

select aktofnum from aof_oper.dbo.aof 
where TypeAdd = 498 and AktDate > GETDATE()-20 and ProlongDay is null
	and Status =1


select * from arg.dbo.tempprolong

update ao 
set ProlongDay = sumDay
from aof_oper.dbo.aof as ao
	inner join (
select pl.aofIdfinal, SUM (pl.dayFakt) as sumDay
from arg.dbo.tempprolong as ao
	inner join arg.dbo.ProlongLink as pl
		on pl.aofIdfinal = ao.aofid
		
where dayFakt > 0
group by pl.aofIdfinal
) as t on t.aofIdfinal = ao.AktOfNum


insert into arg.dbo.aofsendEtran (typedoc,datewrite,aofid) 
select 'aof',getdate(),aofid
from arg.dbo.tempprolong

/*
select ao.Station, ds.Name, COUNT(tp.aofid) 
from arg.dbo.tempprolong as tp
	inner join arg.dbo.aktof as ao on ao.AktOfNum = tp.aofid
	left join nsi.dbo.D_Station as ds on ds.Code = ao.Station
group by ao.Station, ds.Name
order by 3 desc
*/
declare 
	@aofBegin int = 190232376,
	@aofEnd   int = 190284290;



update link
set link.AktOfNumEnd = tab.e_AktOfNum, link.AktOfCarriageNumEnd = tab.e_AktOfCarriageNum
from aof_oper.dbo.aof_carriage_downtime_link as link
	inner join (
		select *
		from (

			select
				dtc.Id,
				aoc.AktOfNum as b_aofid,
				aoc.AktOfCarriageNum as b_AktOfCarriageNum,
				CarriageNum as b_CarriageNum,
				dtc.AktOfNumEnd,
				dtc.AktOfCarriageNumEnd
			from arg.dbo.AktOfDownTimeCar as dtc
				inner join arg.dbo.AktOfCarriage as aoc
					on aoc.AktOfNum = dtc.AktOfNum and aoc.AktOfCarriageNum = dtc.AktOfCarriageNum

			where dtc.aktofnum = @aofBegin
				and (AktOfCarriageNumEnd is null or AktOfCarriageNumEnd < 0)
		) as b
		inner join (
			select aoc.AktOfNum as e_AktOfNum, aoc.AktOfCarriageNum as e_AktOfCarriageNum, CarriageNum as e_CarriageNum
			from arg.dbo.AktOfCarriage as aoc

			where aoc.aktofnum = @aofEnd
		) as e
			on e.e_CarriageNum = b.b_CarriageNum
	) as tab
		on tab.Id = link.Id
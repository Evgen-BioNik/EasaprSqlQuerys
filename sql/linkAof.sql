declare 
	@aofBegin int = 181333443,
	@aofEnd   int = 181954682;



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
				and isnull(AktOfCarriageNumEnd,-1) < 0
		) as b
		inner join (
			select aoc.AktOfNum as e_AktOfNum, aoc.AktOfCarriageNum as e_AktOfCarriageNum, CarriageNum as e_CarriageNum
			from arg.dbo.AktOfCarriage as aoc

			where aoc.aktofnum = @aofEnd
		) as e
			on e.e_CarriageNum = b.b_CarriageNum
	) as tab
		on tab.Id = link.Id
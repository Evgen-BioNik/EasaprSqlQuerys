select pl.uno, pl.sendNum, pl.aofIdfinal, SUM(pl.dayFakt) as sumDay
from arg.dbo.ProlongLink as pl
	inner join arg.dbo.aktof as ao
		on ao.aktofnum = pl.aofIdfoll

where ao.ReasonDelay = 215
	and pl.aofIdfinal in (
	select AktOfNum
	from arg.dbo.aktof apl

	where apl.aktdate between '2020-02-14 17:00' and '2020-02-14 18:00'
		and apl.TypeAdd = 498
)

group by pl.uno, pl.sendNum, pl.aofIdfinal
order by pl.uno

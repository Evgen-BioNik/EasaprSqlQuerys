select AktOfNum,AktNum,AktDate,Status, TypeAdd,ReasonDelay, e.*
from aof_oper.dbo.aof a
	left join arg.dbo.aofsendEtran e
		on e.aofId = a.AktOfNum
where AktOfNum in (131684982,131686170,131692119,131692171,131692924,131703089,131706111,131710497,131711814,131716711,131719056,131723028,131728506,131731176,131731351,131731427,131731496,131732591,131732740,131737653,131744138,131746073,131749788)
	and ReasonDelay = 215
--	and sendedEtran is null
--	and AktNum is null 
order by AktNum
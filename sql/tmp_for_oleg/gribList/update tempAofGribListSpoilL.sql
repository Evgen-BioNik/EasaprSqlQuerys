 

select distinct ao.* , aom.aktofnum, aom.AktDate

--update ao set  ao.aofIDManual = aom.aktofnum

from arg.dbo.tempAofGribListSpoilL as ao
	INNER JOIN arg.dbo.AktOfCarriage AS aoc ON aoc.AktOfNum = ao.AktOfNum
	LEFT JOIN (
		SELECT ao.*, aoc.CarriageNum
		FROM arg.dbo.tempAofGribListSpoilL as ao
			INNER JOIN arg.dbo.AktOfCarriage AS aoc ON aoc.AktOfNum = ao.AktOfNum
				
		WHERE ao.[Status] < 2
			and ao.CreateBy != 72068
	) AS aom
		ON aom.Station = ao.Station AND aom.AktOfNum != ao.AktOfNum
			AND aom.TypeAdd = ao.TypeAdd
			AND CASE WHEN ao.TypeAdd IN (1130,1131) THEN ao.ReasonDelay ELSE 1 END = CASE WHEN aom.TypeAdd IN (1130,1131) THEN aom.ReasonDelay ELSE 1 END
			AND aoc.CarriageNum = aom.CarriageNum
			and aom.aofDT = ao.aofDT
			and ao.aktdate between DATEADD(d,-30, aom.aktdate) and DATEADD(d,30, aom.aktdate)
	left join nsi.dbo.D_Station as ds on ds.Code = ao.Station
where ao.createby = 72068
	and ao.status in (3)
	and ao.aofidmanual is null
	and aom.aktofnum is not null
	
	
--order by ao.aktofnum
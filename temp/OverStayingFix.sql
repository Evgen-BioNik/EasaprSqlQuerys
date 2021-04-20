SELECT top 100 ao.AktOfNum, ao.AktDate, ao.Station, ao.Status, viol.downtimeElements
	,aoc.CarriageNum
	,mav.idModelArrive, mav.carNum, mav.station, mav.aktFeed, mav.aktGruz,
	mav.aktClear, mav.aktDep, mav.aofIdFeed, mav.aofIdGruz, mav.aofIdClear,
	mav.aofIdDep
	, vg.*
FROM arg.dbo.AktOf AS ao
	INNER JOIN vag.dbo.aofViolation AS viol
		ON viol.AktOfNum = ao.AktOfNum
	INNER JOIN arg.dbo.AktOfCarriage AS aoc
		ON aoc.AktOfNum = ao.AktOfNum
	--INNER JOIN arg.dbo.AktOfDescription AS aod
	--	ON aod.AktOfNum = ao.AktOfNum
	LEFT JOIN vag.dbo.modelArrive_violation AS mav
		ON ao.AktOfNum = CASE
			WHEN viol.downtimeElements = 1 THEN mav.aofIdFeed
			WHEN viol.downtimeElements = 2 THEN mav.aofIdGruz 
			WHEN viol.downtimeElements = 3 THEN mav.aofIdClear 
			WHEN viol.downtimeElements = 4 THEN mav.aofIdDep 
		END and mav.carNum = aoc.CarriageNum
	
	LEFT JOIN vag.dbo.modelArrive AS vg
		ON vg.station = ao.Station
			AND vg.carNum = aoc.CarriageNum
	
			
WHERE ao.AktDate > '2018-01-01' AND ao.TypeAdd = 1253 AND ao.[Status] < 4
	AND mav.idModelArrive IS NULL AND vg.id IS NOT NULL

order by ao.AktOfNum desc, aoc.AktOfCarriageNum

/*
INSERT INTO vag.dbo.modelArrive_violation(
	idModelArrive, carNum, station, aktFeed, aofIdFeed, dateWrite
)
SELECT top 100 
	
	
	
	vg.id,aoc.CarriageNum, ao.Station, 2, ao.AktOfNum, getdate()
FROM arg.dbo.AktOf AS ao
	INNER JOIN vag.dbo.aofViolation AS viol
		ON viol.AktOfNum = ao.AktOfNum
	INNER JOIN arg.dbo.AktOfCarriage AS aoc
		ON aoc.AktOfNum = ao.AktOfNum
	--INNER JOIN arg.dbo.AktOfDescription AS aod
	--	ON aod.AktOfNum = ao.AktOfNum
	LEFT JOIN vag.dbo.modelArrive_violation AS mav
		ON ao.AktOfNum = CASE
			WHEN viol.downtimeElements = 1 THEN mav.aofIdFeed
			WHEN viol.downtimeElements = 2 THEN mav.aofIdGruz 
			WHEN viol.downtimeElements = 3 THEN mav.aofIdClear 
			WHEN viol.downtimeElements = 4 THEN mav.aofIdDep 
		END and mav.carNum = aoc.CarriageNum
	
	inner JOIN vag.dbo.modelArrive AS vg
		ON vg.station = ao.Station
			AND vg.carNum = aoc.CarriageNum
	
			
WHERE ao.AktDate > '2018-01-01' AND ao.TypeAdd = 1253 AND ao.[Status] < 4
	AND mav.idModelArrive IS NULL 
	and ao.AktOfNum = 142673785
order by ao.AktOfNum desc, aoc.AktOfCarriageNum

*/
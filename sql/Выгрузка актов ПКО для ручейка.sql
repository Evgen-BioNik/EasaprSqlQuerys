

--SELECT uhv.AktOfNum, uhv.AktNum, uhv.AktDate, uhv.Station, car.CarriageNum, sends.SendNum

SELECT car.CarriageNum, sends.SendNum
,aoc.Cargo
,uhv.StationFrom
,uhv.StationTo
	,COUNT( DISTINCT uhv.Station) c_st


FROM uhv.dbo.AktOf AS uhv WITH(NOLOCK)
	INNER JOIN uhv.dbo.AktOfCarriage AS car WITH(NOLOCK)
		ON car.AktOfNum = uhv.AktOfNum
	INNER JOIN uhv.dbo.AktOfSend AS sends WITH(NOLOCK) 
		ON sends.AktOfNum = uhv.AktOfNum
	LEFT JOIN uhv.dbo.AktOfCargo AS aoc with(NOLOCK)
		ON aoc.AktOfNum = uhv.AktOfNum 
WHERE uhv.AktOfNum IN (
	SELECT 
		uhv.AktOfNum --, COUNT (DISTINCT sends.SendNum) AS c_send
	FROM uhv.dbo.AktOf AS uhv WITH(NOLOCK)
		INNER JOIN uhv.dbo.AktOfSend AS sends WITH(NOLOCK) 
			ON sends.AktOfNum = uhv.AktOfNum
	WHERE uhv.DateLock IS NOT NULL
		AND uhv.AktDate > '2017-07-01'
	GROUP BY  uhv.AktOfNum
	HAVING COUNT (DISTINCT sends.SendNum) = 1

)

GROUP BY car.CarriageNum , sends.SendNum
,aoc.Cargo
,uhv.StationFrom
,uhv.StationTo
HAVING COUNT( DISTINCT uhv.Station) > 2
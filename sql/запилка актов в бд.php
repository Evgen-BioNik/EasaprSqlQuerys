// Инсерт!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

DECLARE	@d1 DATETIME;
DECLARE	@d2 DATETIME;
	
SET @d1 = '2017-06-01 00:00:00';
SET @d2 = '2017-07-01 00:00:00';


INSERT INTO arg.dbo.temp_AofEnd
(
	-- id -- this column value is auto-generated
	AktOfNum,
	AktDate,
	Station,
	TypeAdd,
	ReasonDelay,
	c_sends
)
SELECT aof.AktOfNum, aof.AktDate, aof.Station, aof.TypeAdd, aof.ReasonDelay
		,COUNT(DISTINCT (sends.SendNum)) AS c_sends
FROM (
	SELECT top 50000 aof.AktOfNum, aof.AktDate, aof.Station, aof.TypeAdd, aof.ReasonDelay
	FROM aof_arg.dbo.aof AS aof WITH(NOLOCK)
		INNER JOIN aof_arg.dbo.aof_extension_downtime AS down WITH(NOLOCK)
			ON down.AktOfNum = aof.AktOfNum AND down.DateTimeBegin IS NULL
	WHERE aof.AktDate BETWEEN @d1 AND @d2
		AND aof.AktOfNum not in (select AktOfNum from arg.dbo.temp_AofEnd WHERE AktDate BETWEEN @d1 AND @d2)
		AND aof.[Status] = 1 AND aof.schema_aof = 2 AND aof.OwnerDoc = 0
		AND aof.ReasonDelay != 203
) AS aof
	INNER JOIN aof_arg.dbo.aof_send AS sends WITH(NOLOCK)
		ON sends.AktOfNum = aof.AktOfNum

GROUP BY aof.AktOfNum, aof.AktDate, aof.Station, aof.TypeAdd, aof.ReasonDelay


 
SELECT @@ROWCOUNT, COUNT(*) FROM [arg].[dbo].[temp_AofEnd]
	
	
	
	
	
	
// Апдейт!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
declare @tab TABLE (AktOfNum int);

INSERT INTO @tab
(
	AktOfNum
)
SELECT top 10000 AktOfNum
FROM arg.dbo.temp_AofEnd
WHERE counted = 0


update upd
set upd.c_cars = ISNULL(sel.c_cars,0), upd.sum_delay = ISNULL(sel.sum_delay,0), counted = 1

from arg.dbo.temp_AofEnd AS upd
    left join (
		SELECT link.AktOfNumEnd
			,count(link.AktOfCarriageNum) AS c_cars
			,SUM (DATEDIFF(n,a.AktDate, tae.AktDate)) AS sum_delay

		FROM arg.dbo.temp_AofEnd AS tae WITH(NOLOCK)
			INNER JOIN aof_arg.dbo.aof_carriage_downtime_link AS link WITH(NOLOCK)
				ON link.AktOfNumEnd = tae.AktOfNum
			INNER JOIN aof_arg.dbo.aof AS a WITH(NOLOCK)
				ON a.AktOfNum = link.AktOfNum
			INNER JOIN aof_arg.dbo.aof_cargo AS ac WITH(NOLOCK)
				ON ac.AktOfNum = tae.AktOfNum AND link.AktOfCarriageNumEnd = ac.idCar
					AND ac.cargoCode NOT like '421%'
		WHERE tae.counted = 0 AND tae.AktOfNum IN (SELECT AktOfNum FROM @tab)
		GROUP BY link.AktOfNumEnd 
	) as sel ON sel.AktOfNumEnd = upd.AktOfNum
WHERE upd.counted = 0 AND upd.AktOfNum IN (SELECT AktOfNum FROM @tab)

UPDATE arg.dbo.temp_AofEnd 
SET isEmptyCargo = 1
WHERE counted = 1 AND sum_delay = 0 AND c_cars = 0
	AND AktOfNum IN (SELECT AktOfNum FROM @tab)
/*
update arg.dbo.temp_AofEnd  set counted = 0, isEmptyCargo = 0
UPDATE arg.dbo.temp_AofEnd SET isEmptyCargo = 0,counted = 0 WHERE counted = 1 AND sum_delay = 0 AND c_cars = 0 and isEmptyCargo = 1
*/
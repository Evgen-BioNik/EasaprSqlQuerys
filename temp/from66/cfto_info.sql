DECLARE @c INT = 0, @cnt INT = 0, @total INT = 0, @sDate varchar(30);

DECLARE @d DATETIME = DATEADD(DAY, DATEDIFF(day, 0, GETDATE()), 0);

-- обьявляем две таблицы. первая - испорченные акты, вторая - их теоретическая замена
DECLARE @tabSpoiled TABLE (AktOfNum INT, Station CHAR(5), AktDate DATETIME, [Status] INT, TypeAdd INT, ReasonDelay INT, aofDT BIT, carNum VARCHAR(12))
DECLARE @tabManual TABLE (AktOfNum INT, Station CHAR(5), AktDate DATETIME, [Status] INT, TypeAdd INT, ReasonDelay INT, aofDT BIT, carNum VARCHAR(12))


--тут будет цикл
move10:
select @c = @c +1

-- ищем испорченные акты за прошедшие 15 дней, у которых не указана замена
INSERT INTO @tabSpoiled
SELECT ao.AktOfNum, ao.Station, ao.AktDate, ao.[Status], ao.TypeAdd, ao.ReasonDelay, ao.aofDT, aoc.CarriageNum
FROM interface_buff.dbo.Quality_aof as ao
	INNER JOIN arg.dbo.AktOfCarriage AS aoc with(nolock) ON aoc.AktOfNum = ao.AktOfNum
WHERE ao.aktdate BETWEEN @d-5 AND @d+1 
	AND ao.CreateBy = 72068
	AND ao.[Status] IN (2,3)
	AND ao.aofIDManual IS NULL

-- ищем ручные акты за чуть больший период
INSERT INTO @tabManual
SELECT ao.AktOfNum, ao.Station, ao.AktDate, ao.[Status], ao.TypeAdd, ao.ReasonDelay, ao.aofDT, aoc.CarriageNum
FROM interface_buff.dbo.Quality_aof as ao
	INNER JOIN arg.dbo.AktOfCarriage AS aoc with(nolock) ON aoc.AktOfNum = ao.AktOfNum
WHERE ao.aktdate BETWEEN @d-5 AND @d+20 
	AND ao.CreateBy != 72068
	AND ao.[Status] < 2

-- джойним массив на массив и смотрим те у кого совпали данные о станции, причине, вагону, в промежуток 0 +15 дней от даты испорченного акта
--SELECT upd.*, tab.*
UPDATE upd SET  upd.aofIDManual = tab.aofNewID
FROM interface_buff.dbo.Quality_aof AS upd
	INNER JOIN(
		SELECT DISTINCT ao.AktOfNum AS aofOldID,aom.AktOfNum AS aofNewID
		FROM @tabSpoiled AS ao
			LEFT JOIN (
				SELECT ao.* FROM @tabManual as ao
			) AS aom
				ON aom.Station = ao.Station AND aom.AktOfNum != ao.AktOfNum
					AND aom.TypeAdd = ao.TypeAdd
					AND CASE WHEN ao.TypeAdd IN (1130,1131) THEN ao.ReasonDelay ELSE 1 END = CASE WHEN aom.TypeAdd IN (1130,1131) THEN aom.ReasonDelay ELSE 1 END
					AND ao.carNum= aom.carNum
					AND aom.aofDT = ao.aofDT
					AND aom.AktDate BETWEEN ao.aktdate AND DATEADD(d,15, ao.aktdate)
		WHERE aom.AktOfNum IS NOT NULL
	) AS tab on tab.aofOldID = upd.AktOfNum
	
	
select @cnt = @@ROWCOUNT, @total = @total + @@ROWCOUNT;



select @d = DATEADD(d,5,@d);
select @sDate = cast(@d as varchar)
RAISERROR( N'date changed to %s ' ,0,1, @sDate ) WITH NOWAIT
if (@d < GETDATE()) goto move10
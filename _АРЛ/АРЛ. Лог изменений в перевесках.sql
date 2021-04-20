--Ебашить на 10.246.101.18
DECLARE @StationName VARCHAR(100), @StationCode CHAR(5), @NumRecord INT, @CarNum VARCHAR(12)

	SET @CarNum = '94501236'
	SET @StationName = 'Решоты КРС%'
	SET @StationCode = '89000'

IF (@StationCode IS NULL) SELECT TOP 1 @StationCode = Code FROM nsi.dbo.D_Station WHERE [Name] LIKE RTRIM(@StationName)

SELECT * 
FROM arg.dbo.Weighing 
WHERE carnum = @Carnum and Station = @StationCode


--------------------------------------------------------------------------------------------------
	SET @NumRecord = 13958829 -- WeightingNum

SELECT h.*,u.Login 'Кто Это Сделал?!'
FROM (
	SELECT [code] LogId,[date] LogDate,[NumRecord],[UserId],UserIP,
		case 
			when statusstart = 0 and statusend = 1 then 'Чер->Док'
			when statusstart = 0 and statusend = 2 then 'Чер->Исп'
			when statusstart = 1 and statusend = 0 then 'Док->Чер'
			when statusstart = 1 and statusend = 2 then 'Док->Исп'
			when statusstart = 2 and statusend = 1 then 'Исп->Док'
		end as [AktLog]
	FROM arg.dbo.statuslog 
	UNION
	SELECT [WhoSavedNum] LogId,[DateTimeSaving] LogDate,[NumRecord],[UserId], wh.IPAdress UserIP,'Сохранение' AktLog
	FROM (
		SELECT*FROM aof_oper.dbo.whosaved UNION 
		SELECT*FROM arg.dbo.whosaved UNION 
		SELECT*FROM aof_arch.dbo.whosaved
	) wh 
	WHERE  TableName like 'Weighing%'
) h
	LEFT JOIN (select code, Login from tau.[admin].[dbo].[d_user]) u on u.Code=h.UserID
 
WHERE NumRecord = @NumRecord
ORDER BY LogDate

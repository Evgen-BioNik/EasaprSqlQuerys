-- Идентификатор договора
DECLARE @docId int = '618702097'

-- Основные сведения о договоре
SELECT	distinct 
		recPP.ContractNum AS 'Номер договора',
		recPP.dateBegin AS 'Дата начала действия', 
		recPP.dateEnd AS 'Дата окончания действия',
		CASE 
			WHEN (recPP.actual = 0) THEN 'Потрачен'
			WHEN (recPP.actual = 1) THEN 'Актуален'
		END AS 'Статус договора',
		recPP.[state] AS 'Статус договора цифрой',
		recPP.station AS 'Код основной станции договора',
		ds.Name AS 'Название основной станции договора'
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
INNER JOIN nsi.dbo.D_Station AS ds ON ds.code = recPP.station
WHERE	recPP.pcalid = @docId
		AND recPP.ContractNum IS NOT NULL
		
IF (@@ROWCOUNT = 0)
	SELECT	distinct 
			recPP.ContractNum AS 'Номер договора',
			recPP.dateBegin AS 'Дата начала действия', 
			recPP.dateEnd AS 'Дата окончания действия',
			CASE 
				WHEN (recPP.actual = 0) THEN 'Потрачен'
				WHEN (recPP.actual = 1) THEN 'Актуален'
			END AS 'Статус договора',
			recPP.station AS 'Код основной станции договора',
			ds.Name AS 'Название основной станции договора'
	FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
	INNER JOIN nsi.dbo.D_Station AS ds ON ds.code = recPP.station
	WHERE	recPP.pcalid = @docId

--Дополнительные станции, на которых действует договор
SELECT	stPP.station2 AS 'Код дополнительной станции договора',
		dsPP.Name AS 'Имя дополнительной станции договора'
FROM [arg].[dbo].[D_StationPP] AS stPP
INNER JOIN nsi.dbo.D_Station AS dsPP ON dsPP.Code = stPP.station2
WHERE stPP.pcalid = @docId

--Сведения о владельце пути
--по идее тут поле 'ID владельца' должно быть пустым
SELECT	recPP.id AS 'ID записи',
		recPP.Name AS 'Название организации - владельца',
		recPP.par AS 'ID владельца путей',
		CASE 
			WHEN (recPP.actual = 0) THEN 'Отключён'
			WHEN (recPP.actual = 1) THEN 'Ок'
		END AS 'Статус договора',
		recPP.[state] AS 'Статус договора цифрой'
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
WHERE	recPP.pcalid = @docId
		AND recPP.typeClient = 'owner'

--Сведения о получателях
--по идее тут поле 'ID владельца' должно совпадать с ID в запросе выше
SELECT 	recPP.id AS 'ID получателя',
		recPP.Name AS 'Название организации - получателя',
		recPP.par AS 'ID владельца путей',
		CASE 
			WHEN (recPP.actual = 0) THEN 'Отключён'
			WHEN (recPP.actual = 1) THEN 'Ок'
		END AS 'Статус договора',
		recPP.[state] AS 'Статус договора цифрой'
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
WHERE	recPP.pcalid = @docId
		AND recPP.typeClient != 'owner'
		
/*
* 
--апдейт статуса получателя
UPDATE [arg].[dbo].[T_ReceiverPP] set [state] = '85' WHERE id = '32809'

-- поиск по ID владельца путей
SELECT 	*
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
WHERE recPP.pcalid = '350777241'


--удаление данных по договору
DELETE  arg.dbo.T_ReceiverPP WHERE pcalid   in ('350777241')
*/
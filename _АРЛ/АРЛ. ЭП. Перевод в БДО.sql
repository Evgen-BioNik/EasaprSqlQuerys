Найти непарные акты в норм статусе, у которых акт на замену тоже в норм статусе

SELECT TOP 100 ae.*
	,ao.[Status], ao.dt, ao.Station
	,aoNew.[Status]
	
FROM aof_oper.dbo.aof_ecp AS ae
	INNER JOIN arg.dbo.AktOf AS ao
		ON ao.AktOfNum = ae.id
	LEFT JOIN arg.dbo.AktOf AS aoNew
		ON aoNew.AktOfNum = ae.newAofId
WHERE ae.spoiled = 1 AND isnull(ae.userspoiled,72068) = 72068 
	and ao.Status < 2
	and aoNew.[Status] < 2
	and ao.dt is null
	and ae.dateWrite > '2019-07-01'
ORDER BY ae.id DESC

непарные акты без актов на замену

DECLARE @startDate DATE = '2019-07-01'

DECLARE @tabAofChange TABLE (aofIdMain INT, aofIdSecond INT)
/*
SELECT TOP 100 ae.*
	,ao.[Status], ao.dt, ao.Station,ao.AktNum
	,aof2.[Status], aof2.AktNum
	,ae2.status_ep, ae2.spoiled
	*/
INSERT INTO @tabAofChange
SELECT ao.AktOfNum, aof2.AktOfNum
FROM aof_oper.dbo.aof_ecp AS ae
	INNER JOIN arg.dbo.AktOf AS ao
		ON ao.AktOfNum = ae.id
	LEFT JOIN arg.dbo.AktOf AS aof2
		ON aof2.AktOfNum = ae.newAofId
	LEFT JOIN aof_oper.dbo.aof_ecp as ae2
		ON ae2.id = ae.newAofId
WHERE ae.spoiled = 1 AND isnull(ae.userspoiled,72068) = 72068 
	AND ao.[Status] < 2
	AND ((aof2.[Status] > 1 AND ae2.status_ep is null) or ae.newAofId is null)
	AND ao.dt is null
	AND ae.dateWrite > @startDate
ORDER BY ae.id DESC

SELECT * FROM @tabAofChange
/*
UPDATE aof_oper.dbo.aof SET [Status] = 4 
WHERE AktOfNum IN (SELECT aofIdSecond FROM @tabAofChange WHERE aofIdSecond IS NOT NULL)

UPDATE aof_oper.dbo.aof_ecp
SET status_ep = 10,toPaper = 1, spoiled = NULL, reqSpoiled = NULL, newAofId = NULL
WHERE id IN (SELECT aofIdMain FROM @tabAofChange)
*/

парные акты без замен
DECLARE @startDate DATE = '2019-07-01'

DECLARE @tabAofChange TABLE (aofIdMain INT, aofIdSecond INT)
/*
SELECT TOP 1 ae.id, ae.dateWrite, ae.status_ep, ae.spoiled, ae.userSpoiled
	,ao.[Status], ao.dt, ao.Station,ao.AktNum
	
	,(
		SELECT COUNT(*)
		FROM arg.dbo.AktOfDownTimeCar AS dtc WITH(NOLOCK)
		
		WHERE ao.AktOfNum = dtc.AktOfNum AND ISNULL(dtc.AktOfCarriageNumEnd,-1) > 0
	) as haveLinks
	,aof2.AktofNum, aof2.[Status], aof2.AktNum
	*/
INSERT INTO @tabAofChange
SELECT ao.AktOfNum, aof2.AktOfNum
FROM aof_oper.dbo.aof_ecp AS ae WITH(NOLOCK)
	INNER JOIN arg.dbo.AktOf AS ao WITH(NOLOCK)
		ON ao.AktOfNum = ae.id
	
	LEFT JOIN arg.dbo.AktOf AS aof2 WITH(NOLOCK)
		ON aof2.AktOfNum = ae.newAofId
WHERE ae.spoiled = 1 AND isnull(ae.userspoiled,72068) = 72068 
	AND ao.[Status] < 2
	AND ae.newAofId is null
	AND ao.dt is not null
	AND ae.dateWrite > @startDate
ORDER BY ae.id DESC

SELECT * FROM @tabAofChange
/*
UPDATE aof_oper.dbo.aof_ecp
SET status_ep = 10,toPaper = 1, spoiled = NULL, reqSpoiled = NULL, newAofId = NULL
  OUTPUT INSERTED.id, 'aof','db', GETDATE(), 'arg','aof','Status_ep changed to BDO by Support'
  INTO arg.dbo.logMess (docId, typeMess,scriptName,dateMess,[system],typeDoc, textMess)
WHERE id IN (SELECT aofIdMain FROM @tabAofChange)
*/

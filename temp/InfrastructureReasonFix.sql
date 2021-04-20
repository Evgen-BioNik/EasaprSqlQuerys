SELECT ao.AktOfNum, ao.ReasonDelay, inf.reasonDelayID, d_inf.id as n_id,ao.dt, ao.Station
FROM aof_arg.dbo.infrastructure_working AS inf
	INNER JOIN aof_oper.dbo.aof AS ao
		ON ao.AktOfNum = inf.AktOfNum
	LEFT JOIN arg_nsi.dbo.D_ReasonDelay_Infr AS d_inf
		ON d_inf.TypeAdd = inf.typeAdd AND d_inf.Name = inf.reasonDelayText
WHERE ao.AktDate > '2018-01-01' AND ao.ReasonDelay IS NULL 
	AND d_inf.id IS NOT NULL
										   

DECLARE @aofList TABLE (aofID INT ,idDelay INT);
INSERT INTO @aofList
SELECT ao.AktOfNum, d_inf.id as n_id
FROM aof_arg.dbo.infrastructure_working AS inf
	INNER JOIN aof_oper.dbo.aof AS ao
		ON ao.AktOfNum = inf.AktOfNum
	LEFT JOIN arg_nsi.dbo.D_ReasonDelay_Infr AS d_inf
		ON d_inf.TypeAdd = inf.typeAdd AND d_inf.Name = inf.reasonDelayText
WHERE ao.AktDate > '2018-01-01' AND ao.ReasonDelay IS NULL 
	AND d_inf.id IS NOT NULL
	


UPDATE inf
SET inf.reasonDelayID = l.idDelay
FROM aof_arg.dbo.infrastructure_working AS inf
	INNER JOIN @aofList AS l
		ON l.aofID = inf.AktOfNum

UPDATE ao
SET ao.ReasonDelay = l.idDelay, ao.do = 1
FROM aof_oper.dbo.aof AS ao
	INNER JOIN @aofList AS l
		ON l.aofID = ao.AktOfNum
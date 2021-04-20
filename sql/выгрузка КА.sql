SELECT *
FROM arg.dbo.komakt

WHERE DateSost IS NOT NULL

GROUP BY CONVERT(char(4),DateSost,120)
ORDER BY CONVERT(char(4),DateSost,120) DESC




SELECT t.DateSost, COUNT(*) AS c_total
	,SUM(CASE WHEN t.KomAktType = 'E' THEN 1 ELSE 0 END) AS c_smgs
FROM (
	SELECT 
		CONVERT(char(7),DateSost,120) AS DateSost
		,KomAktType
	FROM arg.dbo.komakt

	WHERE DateSost IS NOT NULL AND [Status] = 1
		AND DateSost BETWEEN '2016-01-01 00:00' AND '2016-07-31'
) AS t
GROUP BY t.DateSost
ORDER BY t.DateSost



SELECT drv.Code, drv.Name AS reasonName, COUNT(*) AS c_total
	,SUM(CASE WHEN t.KomAktType = 'E' THEN 1 ELSE 0 END) AS c_smgs
FROM (
	SELECT 
		CONVERT(char(4),DateSost,120) AS DateSost
		,ReasonView
		,KomAktType
	FROM arg.dbo.komakt

	WHERE ISNULL(DateSost,0) > '2017' AND [Status] < 2
	
) AS t
LEFT JOIN nsi.dbo.D_ReasonView AS drv ON drv.Code = t.ReasonView
WHERE t.DateSost BETWEEN 2010 AND 2018
GROUP BY drv.Code, drv.Name
ORDER BY drv.Code DESC



/*SELECT t.DateSost, COUNT(*) AS c_total
	,SUM(CASE WHEN t.KomAktType = 'E' THEN 1 ELSE 0 END) AS c_smgs
FROM (
	SELECT 
		CONVERT(char(4),DateSost,120) AS DateSost
		,KomAktType
	FROM arg.dbo.komakt

	WHERE DateSost IS NOT NULL AND [Status] = 1
) AS t
WHERE t.DateSost BETWEEN 2010 AND 2018
GROUP BY t.DateSost
ORDER BY t.DateSost DESC



SELECT drv.Code, drv.Name AS reasonName, COUNT(*) AS c_total
	,SUM(CASE WHEN t.KomAktType = 'E' THEN 1 ELSE 0 END) AS c_smgs
FROM (
	SELECT 
		CONVERT(char(4),DateSost,120) AS DateSost
		,ReasonView
		,KomAktType
	FROM arg.dbo.komakt

	WHERE DateSost between '2017-01-01' and GETDATE() AND [Status] = 1
	
) AS t
LEFT JOIN nsi.dbo.D_ReasonView AS drv ON drv.Code = t.ReasonView
GROUP BY drv.Code, drv.Name
ORDER BY drv.Code DESC
*/


select ka.ReasonView, COUNT(*)
from arg.dbo.komakt as ka
inner join nsi.dbo.d_station as stFrom on stFrom.code = ka.StationFrom
inner join nsi.dbo.d_station as stTo on stTo.code = ka.StationTo
WHERE ka.DateSost between '2017-01-01' and GETDATE()
AND ka.[Status] = 1
and ka.KomAktType = 'E'
/*
and stFrom.CodeRail in (select code from nsi.dbo.D_Rail where SOB = '20') 
and (stFrom.export is null or stFrom.export = '')
and (stTo.CodeRail in (select code from nsi.dbo.D_Rail where SOB != '20') or stTo.export = 1  or stTo.CodeRail = '')
*/

/*
and (stFrom.CodeRail in (select code from nsi.dbo.D_Rail where SOB != '20') or stFrom.export = 1  or stFrom.CodeRail = '')
and stTo.CodeRail in (select code from nsi.dbo.D_Rail where SOB = '20') 
and (stTo.export is null or stTo.export = '')
*/

--and (stFrom.CodeRail in (select code from nsi.dbo.D_Rail where SOB != '20') or stFrom.export = 1 or stFrom.CodeRail = '')
--and (stTo.CodeRail in (select code from nsi.dbo.D_Rail where SOB != '20') or stTo.export = 1 or stTo.CodeRail = '')

and (stFrom.CodeRail = '10' or stTo.CodeRail = '10')

group by ka.ReasonView
order by ka.ReasonView desc 




select stFrom.Name, stFrom.export, stTo.Name, stTo.export
from arg.dbo.komakt as ka
inner join nsi.dbo.d_station as stFrom on stFrom.code = ka.StationFrom
inner join nsi.dbo.d_station as stTo on stTo.code = ka.StationTo
WHERE ka.DateSost between '2017-01-01' and GETDATE()
AND ka.[Status] = 1
and ka.KomAktType = 'E'
and ka.ReasonView = 1



select * from nsi.dbo.D_Station
where Code  in ('70180', '51010', '46720', '48560', '71300', '51010', '10000', '15590')


 select * from nsi.dbo.D_Station
where Code  in ('24850', '39120', '43590', '59710', '98020', '39120', '83120', '69610')



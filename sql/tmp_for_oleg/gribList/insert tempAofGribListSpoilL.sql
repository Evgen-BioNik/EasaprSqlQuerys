
DECLARE @d1 DATETIME;

SET @d1 = '2018-01-01 00:00:00'; 
insert into arg.dbo.tempAofGribListSpoilL	(AktOfNum , AktDate , Station , TypeAdd , ReasonDelay  , CreateBy , SpoilBy , [Status])
SELECT AktOfNum , AktDate , Station , TypeAdd , CASE WHEN ao.TypeAdd IN (1130,1131) THEN ao.ReasonDelay ELSE NULL END , CreateBy , SpoilBy , ao.[Status]
FROM interface_buff.dbo.Quality_aof AS ao WITH (NOLOCK)
	INNER JOIN nsi.dbo.D_Station AS ds
		ON ds.Code = ao.Station
	INNER JOIN nsi.dbo.D_Rail AS dr
		ON dr.Code = ds.CodeRail
	INNER JOIN nsi.dbo.D_NOD AS dn
		ON dn.Code = ds.CodeRail + ds.CodeNOD

WHERE ao.AktDate >= @d1 AND ao.AktDate < DATEADD(DAY,181,@d1)
	AND ao.[Status] < 4
	AND (
		 ao.TypeAdd IN (1221)
		 OR ao.TypeAdd BETWEEN 1213 AND 1215
		 OR (ao.TypeAdd = 1131 AND ao.ReasonDelay IN (215,324))
	)
	
	AND dr.Code in ('96', '61') 
ORDER BY ao.AktOfNum


update ao
set ao.aofDT = t.dt
from arg.dbo.tempAofGribListSpoilL as ao
	inner join arg.dbo.AktOf as t
		on t.AktOfNum = ao.AktOfNum
where ao.aofDT is null
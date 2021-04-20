
DECLARE @d1 DATETIME;

SET @d1 = '2018-01-01 00:00:00'; 
insert into arg.dbo.tempGribList_20181210 (AktOfNum , AktDate , Station, [Status], TypeAdd, ReasonDelay , CreateBy , SpoilBy)	
SELECT ao.AktOfNum, ao.AktDate, ao.Station, ao.[Status] ao.TypeAdd, ao.ReasonDelay, ao.CreateBy, ao.SpoilBy
FROM interface_buff.dbo.Quality_aof AS ao WITH (NOLOCK)

WHERE ao.AktDate >= @d1 AND ao.AktDate < DATEADD(DAY,181,@d1)
	AND (
		 ao.TypeAdd IN (584, 1188, 1189, 1190)
		 OR ao.TypeAdd BETWEEN 1213 AND 1220
		 OR ao.TypeAdd BETWEEN 1223 AND 1229
		 OR (ao.TypeAdd = 1131 AND ao.ReasonDelay IN (215,324))
	)
	AND ao.[Status] < 4

update ao
set ao.aofDT = t.dt
from arg.dbo.tempGribList_20181210 as ao
	inner join arg.dbo.AktOf as t
		on t.AktOfNum = ao.AktOfNum
where ao.aofDT is null
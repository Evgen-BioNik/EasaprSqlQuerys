SELECT TOP 1000 *
FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'errnot'
ORDER BY lm.id DESC 

SELECT TOP 1000 *
FROM arg.dbo.logMess AS lm
WHERE lm.typeDoc = 'all_notice' AND lm.typeMess = 'notice'
ORDER BY lm.id DESC 




SELECT TOP 100 m.memoId, mc.cleanDate
FROM arg.dbo.memo AS m
INNER JOIN arg.dbo.memo_car AS mc ON mc.memoId = m.memoId
INNER JOIN nsi.dbo.D_Station AS ds ON ds.code = m.memoStation
WHERE m.memoType = 2 AND ds.CodeRail = '01' AND ds.priport = 1
ORDER BY m.memoId DESC 


SELECT TOP 100 *
FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'memoErr'
ORDER BY lm.docId DESC 


--они вообще есть???
SELECT TOP 100 *
from arg.dbo.memo_car AS mc WITH (NOLOCK)
INNER JOIN arg.dbo.memo AS m WITH (NOLOCK) ON m.memoId = mc.memoId
INNER JOIN nsi.dbo.D_Station AS ds WITH (NOLOCK) ON ds.code = m.memoStation
WHERE mc.cleanDate > '08.12.16' AND m.memoType = 2 AND ds.priport = 1 --AND ds.CodeRail = '01'
 

/*
-- долго работает
SELECT TOP 100 *
FROM arg.dbo.memo AS m
INNER JOIN nsi.dbo.D_Station AS ds ON ds.code = m.memoStation
INNER JOIN arg.dbo.memo_car AS mc ON mc.memoId = m.memoId
WHERE m.memoType = 2 AND ds.CodeRail = '01' AND ds.priport = 1 AND mc.cleanDate IS NOT NULL AND mc.cleanDate > '08.15.16'
AND m.memoId NOT IN 
(
	SELECT lm.docId
	FROM arg.dbo.logMess AS lm
	WHERE lm.typeMess = 'memoErr'
)
 
 */

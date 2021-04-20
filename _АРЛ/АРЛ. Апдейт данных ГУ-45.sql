

SELECT DISTINCT nd.ID ,nd.Gu45Num, nd.Gu45DateTime,psw.carNum, psw.gu45ID, m.cleanDate  
FROM aof_arg.dbo.aof_port_no_doc nd
	INNER JOIN arg.dbo.port_station_working AS psw ON psw.aofNoDocID = nd.AktOfNum
	INNER JOIN  arg.dbo.memo_car  m ON psw.gu45ID = m.memoId AND psw.carNum = m.carNum
WHERE Gu45Num IS NOT NULL AND Gu45DateTime IS NULL




/*


UPDATE  a
SET a.Gu45DateTime = b.cleanDate
from arg.dbo.aof_port_no_doc a
	INNER JOIN (
		SELECT DISTINCT nd.ID ,nd.Gu45Num, nd.Gu45DateTime,psw.carNum, psw.gu45ID, m.cleanDate  
		FROM aof_arg.dbo.aof_port_no_doc nd
			INNER JOIN arg.dbo.port_station_working AS psw ON psw.aofNoDocID = nd.AktOfNum
			INNER JOIN  arg.dbo.memo_car  m ON psw.gu45ID = m.memoId AND psw.carNum = m.carNum
		WHERE Gu45Num IS NOT NULL AND Gu45DateTime IS NULL
	) b ON a.ID = b.ID


 */





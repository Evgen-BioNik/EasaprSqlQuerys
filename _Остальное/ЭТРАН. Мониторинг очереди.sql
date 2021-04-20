DECLARE @date DATE;

SET @date = '2018-05-21'
IF (@date IS NULL) SET @date = convert(CHAR(10), getdate(),120);


select put_time as q_time, cq as [in], co as [out]
from (SELECT TOP 100 CONVERT(char(13),datewrite,120) + ' час' AS put_time, count(*) as cq
	FROM arg.dbo.aofsendEtran
	where dateWrite BETWEEN @date AND DATEADD(dd,1,@date)
	GROUP BY CONVERT(char(13),datewrite,120)
	ORDER BY CONVERT(char(13),datewrite,120) desc
	
	
) as put_q
left join (
	SELECT TOP 100 CONVERT(char(13),dateOut,120) + ' час' AS out_time, count(*) as co
	FROM arg.dbo.aofsendEtran
	where dateWrite BETWEEN @date AND DATEADD(dd,1,@date)
	GROUP BY CONVERT(char(13),dateOut,120)
	ORDER BY CONVERT(char(13),dateOut,120) desc
) as out_q
	on put_q.put_time = out_q.out_time
order by put_time desc



declare @offset int = 1, @date date = '2019-03-09';

SELECT TOP 100 *
FROM [que].[dbo].[etran_log]
where [timestamp] between @date and DATEADD(day,@offset,@date) and (
	1!=1
	or topic like 'etran.in.1[0-9]' 
--	or topic like 'etran.in.[0-9]'
)
and (
	1 != 1
	or body like '{"id":"15381%'
--	or body like '%ЭД354123%'
--	or body like '%94241%'
)

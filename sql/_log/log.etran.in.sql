

declare @offset int = 10, @date date = '2018-09-08';
SELECT TOP 100 *
FROM [que].[dbo].[etran_log]
where [timestamp] between @date and DATEADD(day,@offset,@date) and (
	1!=1
	or topic like 'etran.in.1[0-9]' 
--	or topic like 'etran.in.[0-9]'
)
and (
	body like '%52613379%'
--	or body like '%97080%'
--	or body like '%94241%'
)

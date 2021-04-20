declare @offset int = 3, @date date = '2020-08-02';

SELECT TOP 100 *
FROM [que].[dbo].[etran_log]
where [timestamp] between @date and DATEADD(day,@offset,@date) and (
	1!=1
	or topic like 'etran.in.1[0-9]' 
--	or topic like 'etran.in.[0-9]'
)
and (
	1 != 1
	or body like '{"id":"97662%'
--	or body like '%51550986%'
--	or body like '%94241%'

)

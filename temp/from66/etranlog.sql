DECLARE @offset INT = 1, @date DATE = '2021-04-22';

SELECT TOP 100 *
FROM [que].[dbo].[etran_log]
WHERE [timestamp] between DATEADD(day,-@offset,@date) AND DATEADD(day,1,@date) 
	AND (
		1!=1
	--	or topic like 'etran.in.1[0-9]' 
		or topic like 'etran.in.2[0-9]%' 
	--	or topic like 'etran.in.[0-9]'
	)
	AND (
		1 != 1
	--	or body like '{"id":"35801%'
	--	or body like '%51550986%'
		or body like '%Д0352246%'

	)

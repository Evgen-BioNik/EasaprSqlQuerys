/*
*		Ебашить на 10.246.101.42
	0 - сообщение только пришло
	1 - сообщение встало в очередь обработки
	2 - сообщение обработано
*/
SELECT TOP 100 CONVERT(char(13),[date],120) + ' час' AS 'Промежуток, +1 час',
	sum( CASE WHEN processed = 0 THEN 1 END ) AS '0',
	sum( CASE WHEN processed = 1 THEN 1 END ) AS '1',
	sum( CASE WHEN processed = 2 THEN 1 END ) AS '2'
FROM que.dbo.input_que
GROUP BY CONVERT(char(13),[date],120)
ORDER BY CONVERT(char(13),[date],120) desc
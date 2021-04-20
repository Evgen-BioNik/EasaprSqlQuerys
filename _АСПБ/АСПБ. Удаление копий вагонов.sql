
SELECT t.id, c.* 
FROM dt.dbo.Trains AS t
	INNER JOIN dt.dbo.carriage c ON c.TrainId = t.id
WHERE t.trainIndex = '9271-188-9468'
	AND t.OrderId = 308158
/*	
	DELETE dt.dbo.carriage WHERE TrainId = 581577 AND AktOfNum IS NULL
*/
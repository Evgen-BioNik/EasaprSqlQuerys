
-- ¬се записи в базу
SELECT TOP 100 *
FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'tmpFail' AND lm.scriptName = 'notice_service.php'
ORDER BY lm.id DESC 


-- записи, которые теоретически не записались
SELECT TOP 100 lm.docId
FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'tmpFail'
AND lm.docId NOT IN
(
	SELECT cars.aofIdBegin
	FROM aof_arg.dbo.aof_carriage_failure AS cars
	WHERE cars.aofIdBegin IS NOT NULL
)



/*
	
	-- “ак, просто поискать
	SELECT * FROM aof_arg.dbo.aof_carriage_failure AS acf
	WHERE acf.aofIdFailure = '108011234'
	
	SELECT TOP 100 *
	FROM arg.dbo.logMess AS lm
	WHERE lm.typeMess = 'tmpFail'AND docId = 108011616
	ORDER BY lm.id DESC 
	
*/

/*UPDATEEEEE!

	UPDATE arg.dbo.FailureReg 
	SET aofIdBegin = 108175703
	WHERE failureId = 1000053508

	UPDATE aof_arg.dbo.aof_carriage_failure
	SET aofIdBegin = 108175703
	WHERE failureId = 1000053508

 */

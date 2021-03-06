
--Ебашить на 10.246.101.18
Declare @NumRec INT, @SendNum char(8);
/*
	Если запись по отправке ровно одна, id строки для поиска логов будет выбран автоматически.
	Если записей больше, то необходимо скопировать [key] строки и вставить к переменной @NumRec
*/
SET @SendNum = 'ЭИ184355';
--SET @NumRec = 6187428;


---------------------------------------
SELECT * FROM arg.dbo.ProlongSend
WHERE sendNum = @SendNum

IF @@ROWCOUNT = 1
	SELECT @NumRec = [key] FROM arg.dbo.ProlongSend
	WHERE sendNum = @SendNum

SELECT 
	t.ID,NumRecord,CONVERT(char(19),LogDate,120)LogDate, t.UserIP, t.UserID,t.StatusLog,du.Name,du.[Login]
FROM (
	SELECT 
		WhoSavedNum ID,NumRecord,DateTimeSaving LogDate,UserID,IPAdress UserIP,'Сохранение'StatusLog
	FROM arg.dbo.WhoSaved WHERE TableName='ProlongSend' AND NumRecord=@NumRec
		UNION
	SELECT Code ID,NumRecord,[Date] LogDate,UserID,UserIP,
		CASE WHEN StatusStart=0	THEN 'Ничего' WHEN StatusStart=1 THEN 'Акт' ELSE 'Отказ'
		END+'->'+
		CASE WHEN StatusEnd=0	THEN 'Ничего' WHEN StatusEnd=1 THEN 'Акт' ELSE 'Отказ'
		END AS StatusLog
	FROM arg.dbo.StatusLog AS sl
	WHERE TableName='ProlongResult' AND NumRecord=@NumRec
)t
	LEFT JOIN admin.dbo.D_User AS du ON du.Code = t.UserID
WHERE t.NumRecord=@NumRec
ORDER BY LogDate


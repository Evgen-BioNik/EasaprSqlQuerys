--Ебашить на 10.246.101.18
Declare @mess BIT = 0, @NumRec INT = 118042015 

/*
	DELETE arg.dbo.StatusLog WHERE TableName='AktOf' AND NumRecord = 111757319 AND Code >10295203
	DELETE aof_oper.dbo.whosaved WHERE TableName='AktOf' AND NumRecord = 112137531 AND WhoSavedNum > 117311582
	DELETE arg.dbo.logMess WHERE docId=101987452 AND [system]='aof'
	UPDATE arg.dbo.aof SET STATUS=1 WHERE aktofnum = 111725316
	
	
	INSERT INTO arg.dbo.aofsendEtran (aofId,typedoc,dateWrite) values(117346875,'aof',GETDATE()) 
*/

SELECT AktOfNum,AktNum,AktDate,Station,OwnerDoc,[Status],schema_aof,ProlongDay,TypeAdd,ReasonDelay,dt,storage FROM arg.dbo.AktOfAll WHERE AktOfNum=@NumRec

SELECT 
	t.ID,CONVERT(char(19),LogDate,120)LogDate, t.UserIP,t.StatusLog,du.Name,
	CASE WHEN du.[Login] = 'NULL' THEN 'автомат по созданию актов' ELSE du.[Login] END AS [Login], t.UserID
FROM (
	SELECT 
		WhoSavedNum ID,NumRecord,DateTimeSaving LogDate,UserID,IPAdress UserIP,'Сохранение'StatusLog
	FROM arg.dbo.AktOfWhoSavedAll AS wh
	WHERE wh.NumRecord = @NumRec
		UNION
	SELECT Code ID,NumRecord,[Date] LogDate,UserID,UserIP,
		CASE WHEN StatusStart=0	THEN 'Чер' WHEN StatusStart=1 THEN 'Док' ELSE  'Исп'
		END+'->'+
		CASE WHEN StatusEnd=0	THEN 'Чер' WHEN StatusEnd=1 THEN 'Док' ELSE  'Исп'
		END AS StatusLog
	FROM arg.dbo.StatusLog AS sl
	WHERE TableName='AktOf' AND NumRecord=@NumRec
)t
	LEFT JOIN admin.dbo.D_User AS du ON du.Code = t.UserID
WHERE t.NumRecord=@NumRec
ORDER BY LogDate
	
IF @mess > 0 BEGIN 
	SELECT * FROM arg.dbo.logMess WHERE docId = @NumRec AND typeDoc = 'aof' ORDER BY id
	SELECT * FROM arg.dbo.aofsendEtran AS ase
		LEFT JOIN arg.dbo.aofsendEtranRenum AS aer ON aer.paymentId = ase.paymentId
	WHERE aofId = @NumRec
END 
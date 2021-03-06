--	Ебашить на 10.246.101.18
-- Выбирается последняя заявка на вагон!!
DECLARE @FailId INT,@CarNum INT,@StCode INT

	SET @CarNum = '64201148'
--	SET @FailId='1000014467'

/*
	UPDATE arg.dbo.FailureReg SET aofIdFailure = null, sendToEtran = 0 WHERE failureId=2
 
	UPDATE aof_arg.dbo.aof_carriage_failure SET aofIdFailure = null WHERE Id=1
	
	UPDATE aof_oper.dbo.aof SET STATUS=2 WHERE AktOfNum = '87783721'
 
	INSERT INTO arg.dbo.aofsendEtran (aofId,typedoc,dateWrite)
	VALUES ('1000008549','notice',GETDATE())
	UPDATE arg.dbo.FailureReg SET sendToEtran = 1 WHERE failureId= '1000008561'
 
*/
SELECT @FailId = acf.failureid,@StCode = fr.stationReg
FROM   aof_arg.dbo.aof_carriage_failure AS acf
INNER JOIN arg.dbo.FailureReg AS fr ON fr.failureId = acf.failureId
WHERE  acf.carNum = @CarNum AND fr.[status]!=2
ORDER BY acf.failureId desc

--	Если возникает вопрос про ВУ-23, селектим строку с общим запросом
--	SELECT * FROM arg.dbo.Vu_23 WHERE wagon_number=@CarNum and rw_station_id=@StCode

SELECT fr.failureId,fr.numReg,stationReg+' ('+RTRIM(ds.Name)+')' 'Станция'
      ,fr.dateReg'ДатаЗаявки',ae.dateWrite'Отправлено',fr.sendedDateTime'МнениеЭТРАНаКогдаПришелОтвет'
      -- Реальная дата ответа от ЭТРАНА равна дате создания акта на начало. Используем "Изменение в актах"
      --,ae.sendedEtran,fr.sendToEtran
      ,fr.aofIdFailure,fr.aofIdBegin,fr.[status]
FROM   arg.dbo.FailureReg              AS fr
       LEFT JOIN arg.dbo.aofsendEtran  AS ae ON  ae.aofId = fr.failureId AND ae.typedoc = 'notice'
       INNER JOIN nsi.dbo.D_Station    AS ds ON  fr.stationReg = ds.Code
WHERE  fr.failureId = @FailId 

SELECT *
FROM   aof_arg.dbo.aof_carriage_failure AS acf
WHERE  acf.failureid = @FailId
/*
SELECT * FROM arg.dbo.logMess AS lm
WHERE lm.docId=1000032319 AND lm.typeMess='failure'
*/
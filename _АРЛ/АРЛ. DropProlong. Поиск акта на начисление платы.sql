--Ебашить на 10.246.101.18
DECLARE @aofIdFinal INT, @aofIdDropProlong INT;

  SET @aofIdFinal       = 112150128  -- итоговый акт
--SET @aofIdDropProlong = 111762194  -- итоговый акт на начисление платы

/*
    UPDATE prolong.dbo.DropProlong SET [state] = 0 WHERE aofIdfinal = 120990984
 
*/
SELECT TOP 100 dp.idProlong
      ,dp.stationReq
      ,CONVERT(char(19),dateReq,120)dateReq
      ,dp.aofIdfinal
      ,dp.aofIdDropProlong
      ,dp.carNum
      ,dp.sendNum
      ,dp.sendUno
      ,dp.stationFrom
      ,dp.stationTo
      ,dp.sender
      ,dp.receiver
      ,dp.carOwner
      ,dp.aofIdReceiveRejection
      ,dp.responceType
      ,dp.responceName
      ,dp.dropStation
      ,dp.dropOrderId
      ,dp.dropOrderNum
      ,dp.dropOrderDate
      ,dp.dateBegin
      ,dp.aofIdBegin
      ,dp.upOrderId
      ,dp.upOrderNum
      ,dp.upOrderDate
      ,dp.dateEnd
      ,dp.aofIdEnd
      ,dp.delayTime
      ,dp.doTrainNum
      ,dp.doTrainIndex
      ,dp.upTrainNum
      ,dp.upTrainIndex
FROM   prolong.dbo.DropProlong AS dp
WHERE dp.[state] = 1
    AND CASE 
        WHEN @aofIdFinal IS NOT NULL THEN dp.aofIdfinal
        WHEN @aofIdDropProlong IS NOT NULL THEN dp.aofIdDropProlong
        ELSE 1 
    END = CASE 
        WHEN @aofIdFinal IS NOT NULL THEN @aofIdFinal
        WHEN @aofIdDropProlong IS NOT NULL THEN @aofIdDropProlong
        ELSE 1 
    END

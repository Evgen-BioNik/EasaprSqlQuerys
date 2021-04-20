/*
75088389 aofId min (2015)
56371433 aofId min (2014)
39610126 aofId min (2013)
 */
DECLARE @CarNum       VARCHAR(8)
       ,@MinAofId     INT
       ,@date1        DATETIME
       ,@date2        DATETIME
       ,@SendNum      VARCHAR(8)


SET @CarNum = '67491845'
SET @MinAofId = 75088389
SET @date1 = '20140501'
SET @date2 = GETDATE()
SET @SendNum = 'ÝÎ905120'

USE arg 
SELECT DISTINCT 
       ao.AktOfNum
      ,MAX(aoc.CarriageNum) CarriageNum
      ,aos.SendNum
      ,ao.[Site]
      ,ao.AktNum
      ,ao.AktDate
      ,ao.Station
      ,ao.StationInput
      ,ao.TrainNum
      ,ao.TrainInd
      ,ao.OwnerDoc
      ,ao.[Status]
      ,ao.schema_aof
      ,ao.TypeAdd
      ,ao.ReasonDelay
      ,ao.ProlongDay
--      ,aoc.storage 's_aoc',aos.storage 's_aos', ao.storage 's_ao'
FROM   AktOfCarriage         AS aoc
       LEFT JOIN AktOfSend   AS aos
            ON  aos.AktOfNum = aoc.AktOfNum
                AND aos.idCar = aoc.AktOfCarriageNum
       INNER JOIN AktOf      AS ao
            ON  ao.AktOfNum = aoc.AktOfNum
                AND ao.AktDate BETWEEN @date1 AND @date2
WHERE  aoc.AktOfNum>= @MinAofId
 --      AND aoc.CarriageNum = @CarNum
       AND aos.SendNum = @SendNum
GROUP BY
       ao.AktOfNum
      ,aos.SendNum
      ,ao.[Site]
      ,ao.AktNum
      ,ao.AktDate
      ,ao.Station
      ,ao.StationInput
      ,ao.TrainNum
      ,ao.TrainInd
      ,ao.OwnerDoc
      ,ao.[Status]
      ,ao.schema_aof
      ,ao.TypeAdd
      ,ao.ReasonDelay
      ,ao.ProlongDay
      ,aoc.storage
      ,aos.storage
      ,ao.storage
ORDER BY
       ao.aktofnum
           
SELECT dp.carNum, dp.sendNum, dp.stationReq, dp.aofIdfinal, dp.aofIdDropProlong, dp.[state],
       dp.aofIdReceiveRejection, dp.dropOrderId, dp.aofIdBegin, dp.upOrderId, dp.aofIdEnd,count(*)
FROM prolong.dbo.DropProlong AS dp

GROUP BY dp.carNum, dp.sendNum, dp.stationReq, dp.aofIdfinal, dp.aofIdDropProlong, dp.[state],
       dp.aofIdReceiveRejection, dp.dropOrderId, dp.aofIdBegin, dp.upOrderId, dp.aofIdEnd
HAVING count(*) > 1

ORDER BY dp.aofIdDropProlong,dp.carNum




-------

declare @aofID int = 133137855;
SELECT * FROM prolong.dbo.DropProlongAll AS dp
WHERE dp.aofIdDropProlong = @aofID --and idProlong %2 = 0
--	and carNum = 57134710
--order by carnum
SELECT distinct [carNum]
      ,[carSpan]
      ,[carOwner]
      ,[stationReq]
      ,[aofIdfinal]
      ,[aofIdDropProlong]
      ,[aofDropProlongType]
      ,[sendUno]
      ,[sendNum]
      ,[stationFrom]
      ,[stationTo]
      ,[dateReady]
      ,[dateNorm]
      ,[dateFact]
      ,[sender]
      ,[receiver]
      ,[aofIdReceiveRejection]
      ,[responceType]
      ,[responceName]
      ,[dropStation]
      ,[dropOrderId]
      ,[dropOrderNum]
      ,[dropOrderDate]
      ,[dropOrderSign]
      ,[dateBegin]
      ,[aofIdBegin]
      ,[upOrderId]
      ,[upOrderNum]
      ,[upOrderDate]
      ,[upOrderSign]
      ,[dateEnd]
      ,[aofIdEnd]
      ,[delayTime]
      ,[doTrainNum]
      ,[doTrainIndex]
      ,[upTrainNum]
      ,[upTrainIndex]
      ,[state]
      ,[responceID]
      ,[responceTGNL] FROM prolong.dbo.DropProlong AS dp
WHERE dp.aofIdDropProlong = @aofID
--	and carNum = 57134710
/*
declare @aofID int = 133137855;
DELETE prolong.dbo.DropProlong WHERE aofIdDropProlong =@aofID
--	 and cargocode is null
--	 and datefact < '2016'
	 and idProlong > 319568
--	 and carNum = 57134710

UPDATE prolong.dbo.DropProlong SET carSpan = 1 WHERE aofIdDropProlong = @aofID -- and carNum = 57134710

UPDATE prolong.dbo.DropProlong SET aofIdDropProlong =131938919 ,carSpan = 1 WHERE idProlong %2 = 0 and aofIdDropProlong = 131938923 
*/
/*
select * from arg.dbo.AktOfCarriage
where AktOfNum = 99888202


select * from arg.dbo.AktOfCont
where AktOfNum = 99888202

select * from arg.dbo.AktOfcargo
where AktOfNum = 99888202
*/
--Ебашить на 10.246.101.18

DECLARE @CarNum VARCHAR(8)='95075545'; --Номер вагона для поиска

/*
 *  Место для UPDATE-ов, будет наполнятся в процессе
      UPDATE arg.dbo.tech_processing SET aofIdTechBegin = 101989833 WHERE id=1291456
      DELETE arg.dbo.tech_processing WHERE id=1611032
      UPDATE aof_oper.dbo.aof SET [Status] = 3 WHERE AktOfNum=105072766
*/

SELECT tp.id
      ,tp.dateDetect,tp.station,rtrim(s23.Name) 'СтанцияОбнаружения',tp.aofIdTechBegin ,tp.vu23EtdId
      ,tp.dateRepair ,tp.stationRepair,rtrim(s36.Name) 'СтанцияРемонта',tp.aofIdTechEnd,tp.vu36EtdId
      ,tp.[status] 'Вкладка',tp.aof_before_vu
      ,tp.vu23Num,tp.vu36Num, tp.vu36Date
FROM   arg.dbo.tech_processing tp
      LEFT JOIN nsi.dbo.D_Station s23 ON tp.station = s23.Code
      LEFT JOIN nsi.dbo.D_Station s36 ON tp.stationRepair = s36.Code
WHERE  tp.carNum = @CarNum
ORDER BY tp.id DESC

SELECT v23.id
      ,v23.etdId,v23.number VuNum,v23.etdDate,v23.detect_date 'ДатаОбнаружения'
      ,v23.rw_station_id 'КодСт',rtrim(ds.Name) 'Станция'
      ,v23.disrepair_item1_id,v23.disrepair_item2_id,v23.disrepair_item3_id
FROM   arg.dbo.Vu_23 v23
      LEFT JOIN nsi.dbo.D_Station ds ON v23.rw_station_id = ds.Code
WHERE  v23.wagon_number = @CarNum
ORDER BY v23.id DESC

SELECT v36.id
      ,v36.etdId,v36.num_yvedoml VuNum,v36.etdDate,v36.repair_date 'ДатаРемонта'
      ,v36.station_id 'КодСт',rtrim(ds.Name) 'Станция'
      ,v36.repair_pred_name
FROM   vu.dbo.Vu_36 v36
      LEFT JOIN vu.dbo.Vu_36_car  vc ON  vc.vu36Id = v36.id  
      LEFT JOIN nsi.dbo.D_Station ds ON v36.station_id = ds.Code
WHERE  vc.vagon_id = @CarNum
ORDER BY v36.id DESC


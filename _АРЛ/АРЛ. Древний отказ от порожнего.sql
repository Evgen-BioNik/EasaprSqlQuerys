
/*
-- поменять причину акта на актуальную
UPDATE arg.dbo.aof
SET    [TypeAdd] = '1130',
       ReasonDelay = '247'
WHERE  aktofnum = '58237830'
*/


-- проверить, есть ли эти вагоны во вьюхе простаивающих вагонов
-- запускается только в aof_oper!!!!!!
SELECT aof.AktOfNum, dtc.AktOfCarriageNum, car.CarriageNum, aof.AktNum, aof.Site, aof.AktDate, dtc.AktOfNumEnd, aofend.AktNum AS AktNumEnd, aofend.Site AS SiteEnd, aofend.AktDate AS AktDateEnd,
       dt.DateTimeBegin, dtend.DateTimeEnd, aofend.Status, car.Owner, dt.OwnerWay, dt.WayNum,
       CASE 
            WHEN sf1.Name <> '' THEN sf1.Name
            ELSE sf2.Name
       END                                AS StationFrom,
       CASE 
            WHEN st1.Name <> '' THEN st1.Name
            ELSE st2.Name
       END                                AS StationTo,
       CASE 
            WHEN aof.Sender <> '' THEN aof.Sender
            ELSE dtc.Sender
       END                                AS Sender,
       CASE 
            WHEN aof.Receiver <> '' THEN aof.Receiver
            ELSE dtc.Receiver
       END                                AS Receiver,
       aof.Type, aof.Station, dtc.Type AS TypeCar, aof.Status AS statusaof, aof.TypeAdd, cont.ContNum, aof.OwnerDoc, dtc.DateForcibly, aof.ReasonDelay
FROM   dbo.aof_carriage_downtime_link     AS dtc
       INNER JOIN arg.dbo.AktOfDownTime   AS dt WITH (NOLOCK) ON  dtc.AktOfNum = dt.AktOfNum
       LEFT OUTER JOIN dbo.aof_extension_downtime AS dtend ON  dtc.AktOfNumEnd = dtend.AktOfNum
       INNER JOIN (
                SELECT  AktOfNum, FolderNum, AktNum, AktDate, Station, Type, TrainNum, Stage, Description, OpMesNum, StationFrom, StationTo, StationVL, TrainInd, TrainDateTime, VLDate, StationFromText, 
                        StationToText, Carrier, DateReception, Site, SaveInd, Netto, UserName, id, StationInput, OwnerDoc, Status, CasesNum, Sender, Receiver, StationText, schema_aof, ReasonDelay, ProlongDay, 
                        InActive, CaseId, TypeAdd
                FROM   arg.dbo.AktOf AS aof_2 WITH (NOLOCK)
                WHERE  (schema_aof = '2')
                       AND (STATUS NOT IN (2, 3))
            )  AS aof  ON  dtc.AktOfNum = aof.AktOfNum
       LEFT OUTER JOIN (
                SELECT  AktOfNum, FolderNum, AktNum, AktDate, Station, Type, TrainNum, Stage, Description, OpMesNum, StationFrom, StationTo, StationVL, TrainInd, TrainDateTime, VLDate, StationFromText, 
                        StationToText, Carrier, DateReception, Site, SaveInd, Netto, UserName, id, StationInput, OwnerDoc, Status, CasesNum, Sender, Receiver, StationText, schema_aof, ReasonDelay, ProlongDay, 
                        InActive, CaseId
                FROM   dbo.aof AS aof_1 WITH (NOLOCK)
                WHERE  (schema_aof = '2')
                       AND (STATUS NOT IN (2, 3))
       )  AS aofend ON  dtc.AktOfNumEnd = aofend.AktOfNum
       INNER JOIN dbo.aof_carriage AS car WITH (NOLOCK) ON  dtc.AktOfCarriageNum = car.AktOfCarriageNum
       LEFT OUTER JOIN dbo.aof_cont       AS cont ON  cont.AktOfNum = car.AktOfNum AND dtc.AktOfCarriageNum = cont.idCar
       LEFT OUTER JOIN nsi.dbo.D_Station  AS st1 ON  dtc.StationTo = st1.Code
       LEFT OUTER JOIN nsi.dbo.D_Station  AS sf1 ON  dtc.StationFrom = sf1.Code
       LEFT OUTER JOIN nsi.dbo.D_Station  AS st2 ON  aof.StationTo = st2.Code
       LEFT OUTER JOIN nsi.dbo.D_Station  AS sf2 ON  aof.StationFrom = sf2.Code
WHERE  aof.AktOfNum = '70310349'


/*
		-- вернуть вагоны во вьюху из арг
		SET IDENTITY_INSERT aof_oper.dbo.aof_carriage ON
		delete [aof_arg].[dbo].[aof_carriage] output deleted.* into aof_oper.dbo.aof_carriage
				([AktOfCarriageNum]
				,[AktOfNum]
				,[CarriageNum]
				,[Owner]
				,[OwnerAlt]
				,[carLength]) 
		 where aktofcarriagenum in ('596939255', '596939254')
		--where AktOfNum = '70310349'
		SET IDENTITY_INSERT aof_oper.dbo.aof_carriage OFF
*/
 
 
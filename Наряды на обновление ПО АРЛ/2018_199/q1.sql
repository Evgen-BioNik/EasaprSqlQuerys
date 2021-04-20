USE arg
GO 

ALTER VIEW dbo.Flex_SPFAofList
AS
SELECT t.AktOfNum
      ,dr.Code                            AS RailCode
      ,dr.NameShort                       AS RailName
      ,dn.Code                            AS NodCode
      ,dn.Name                            AS NodName
      ,t.StationCode
      ,ds.Name                            AS StationName
      ,t.AOF_Site
      ,t.AOF_Num
      ,t.AOF_Date
      ,t.AOF_Status
      ,t.ReasonCode
      ,ta.fullname                        AS ReasonName
      ,t.CarNum
      ,t.SendNum
      ,t.uno
      ,t.StationFromCode
      ,dsfrom.Name                        AS StationFromName
      ,t.StationToCode
      ,dsto.Name                          AS StationToName
      ,t.Downtime
      ,t.isDT
      ,t.CarLocoType
FROM   (
           SELECT aof.AktOfNum
                 ,aof.Station      AS StationCode
                 ,aof.Site         AS AOF_Site
                 ,aof.AktNum       AS AOF_Num
                 ,aof.AktDate      AS AOF_Date
                 ,aof.Status       AS AOF_Status
                 ,aof.TypeAdd      AS ReasonCode
                 ,car.CarriageNum  AS CarNum
                 ,aos.SendNum
                 ,aos.uno
                 ,aof.StationFrom  AS StationFromCode
                 ,aof.StationTo    AS StationToCode
                 ,0                AS Downtime
                 ,0                AS isDT
                 ,1                AS CarLocoType
           FROM   dbo.AktOf        AS aof WITH (NOLOCK)
                  INNER JOIN dbo.AktOfCarriage AS car WITH (NOLOCK)
                       ON  car.AktOfNum = aof.AktOfNum
                  LEFT OUTER JOIN dbo.AktOfSend AS aos
                       ON  aos.AktOfNum = aof.AktOfNum
                           AND aos.idCar = car.AktOfCarriageNum
           WHERE  (aof.TypeAdd IN (1259 ,1263 ,1264 ,1266 ,1267 ,1269 ,1270, 1280))
				AND aof.[Status] < 2
           UNION
           SELECT aof.AktOfNum
                 ,aof.Station           AS StationCode
                 ,aof.Site              AS AOF_Site
                 ,aof.AktNum            AS AOF_Num
                 ,aof.AktDate           AS AOF_Date
                 ,aof.Status            AS AOF_Status
                 ,aof.TypeAdd           AS ReasonCode
                 ,car.CarriageNum       AS CarNum
                 ,aos.SendNum
                 ,aos.uno
                 ,dt.StationFrom        AS StationFromCode
                 ,dt.StationTo          AS StationToCode
                 ,DATEDIFF(hh ,aB.AktDate ,aof.AktDate) AS Downtime
                 ,1                     AS isDT
                 ,CASE 
                       WHEN aof.TypeAdd IN (1260 ,1261 ,1262) THEN 1
                       WHEN aof.TypeAdd IN (1272 ,1273) THEN 2
                  END                   AS CarLocoType
           FROM   dbo.AktOf             AS aof WITH (NOLOCK)
                  INNER JOIN dbo.AktOfDownTimeCar AS dt WITH (NOLOCK)
                       ON  dt.AktOfNumEnd = aof.AktOfNum
                  INNER JOIN dbo.AktOfCarriage AS car WITH (NOLOCK)
                       ON  car.AktOfCarriageNum = dt.AktOfCarriageNumEnd
                           AND car.AktOfNum = aof.AktOfNum
                  LEFT OUTER JOIN dbo.AktOfSend AS aos
                       ON  aos.AktOfNum = aof.AktOfNum
                           AND aos.idCar = car.AktOfCarriageNum
                  INNER JOIN dbo.AktOf  AS aB WITH (NOLOCK)
                       ON  dt.AktOfNum = aB.AktOfNum
           WHERE  (aof.TypeAdd IN (1260 ,1261 ,1262 ,1272 ,1273))
				  AND aof.[Status] < 2
                  AND (aof.dt=1)
                  AND (dt.AktOfNumEnd IS NOT NULL)
       )                                  AS t
       LEFT OUTER JOIN nsi.dbo.D_Station  AS ds
            ON  ds.Code = t.StationCode
       LEFT OUTER JOIN nsi.dbo.D_Rail     AS dr
            ON  dr.Code = ds.CodeRail
       LEFT OUTER JOIN nsi.dbo.D_NOD      AS dn
            ON  dn.Code = ds.CodeRail+ds.CodeNOD
       LEFT OUTER JOIN nsi.dbo.D_Station  AS dsfrom
            ON  dsfrom.Code = t.StationFromCode
       LEFT OUTER JOIN nsi.dbo.D_Station  AS dsto
            ON  dsto.Code = t.StationToCode
       LEFT OUTER JOIN nsi.dbo.T_aofType  AS ta
            ON  ta.id = t.ReasonCode
SELECT
	rtrim(dr.NameShort) AS roadName,
	rtrim(dn.Name) AS Nod,
	ds.[code] AS stationCode,
    rtrim(ds.Name) AS stationName
  FROM [VagModel].[dbo].[MonitoringStations]
  INNER JOIN nsi.dbo.D_Station AS ds ON  ds.code = [VagModel].[dbo].[MonitoringStations].code
  INNER JOIN nsi.dbo.D_Rail AS dr ON dr.Code= ds.CodeRail 
  INNER JOIN nsi.dbo.D_NOD AS dn ON dn.code = (ds.CodeRail + ds.CodeNOD)
ORDER BY dr.code, dn.code 
 

  
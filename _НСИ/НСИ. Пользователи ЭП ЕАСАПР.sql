/* Запускать на 43-ем */

SELECT	DISTINCT
		du.Code AS userCode, 
		du.Name AS userName,
		du.[Login] AS use5rLogin,
		du.Station AS userStationCode, 
		ds.Name AS userStationName,
		du.Rail AS userRailCode,
		dr.NameShort AS userRailName
FROM [hardcopy].[dbo].[paper_signs] AS pap
INNER JOIN [admin].dbo.D_User AS du ON du.Code = pap.user_code
LEFT JOIN nsi.dbo.D_Station AS ds ON  ds.Code = du.Station
LEFT JOIN nsi.dbo.D_Rail AS dr ON dr.Code = du.Rail
ORDER BY du.Name

  
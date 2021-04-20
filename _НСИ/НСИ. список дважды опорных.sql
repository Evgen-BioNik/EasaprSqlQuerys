SELECT 
	 l1.StationMain AS stMain_1, ds_1.Name AS stMainName
	 ,l1.Code AS stInCode_1, ds_2.Name AS stInName_1
	--,l2.StationMain AS stMain_2
	, l2.Code AS stInCode_2, ds_3.Name AS stInName_2
FROM nsi.dbo.D_StationInActive AS l1
	INNER JOIN nsi.dbo.D_StationInActive AS l2
		ON l1.Code = l2.StationMain
	LEFT JOIN nsi.dbo.D_Station AS ds_1
		ON l1.StationMain = ds_1.Code
	LEFT JOIN nsi.dbo.D_Station AS ds_2
		ON l2.StationMain = ds_2.Code
	LEFT JOIN nsi.dbo.D_Station AS ds_3
		ON l2.Code = ds_3.Code
--where l1.StationMain = '94340'

order by l1.StationMain, l1.Code
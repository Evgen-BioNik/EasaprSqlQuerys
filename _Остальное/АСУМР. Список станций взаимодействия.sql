

-- количество актов на сети, которые находятся в рабочем состоянии (Черновик или Документ)
SELECT COUNT (*)
FROM [aof_arg].[dbo].[infrastructure_working] AS infr
INNER JOIN  arg.dbo.AktOf AS ao ON ao.AktOfNum = infr.AktOfNum
WHERE infr.asumrType IS NOT NULL AND ao.[Status] IN (0,1)


-- количество черновиков по станциям
SELECT infr.stationReg, ds.name AS stationName, COUNT (*) AS aofCount
FROM [aof_arg].[dbo].[infrastructure_working] AS infr
INNER JOIN  arg.dbo.AktOf AS ao ON ao.AktOfNum = infr.AktOfNum
LEFT JOIN nsi.dbo.D_Station AS ds ON ds.Code = infr.stationReg
WHERE infr.asumrType IS NOT NULL AND ao.[Status] IN (0)
GROUP BY infr.stationReg, ds.name


-- количество документов по станциям
SELECT infr.stationReg, ds.name AS stationName, COUNT (*) AS aofCount
FROM [aof_arg].[dbo].[infrastructure_working] AS infr
INNER JOIN  arg.dbo.AktOf AS ao ON ao.AktOfNum = infr.AktOfNum
LEFT JOIN nsi.dbo.D_Station AS ds ON ds.Code = infr.stationReg
WHERE infr.asumrType IS NOT NULL AND ao.[Status] IN (1)
GROUP BY infr.stationReg, ds.name


-- количество испорченных заготовок по станциям
SELECT infr.stationReg, ds.name AS stationName, COUNT (*) AS aofCount
FROM [aof_arg].[dbo].[infrastructure_working] AS infr
INNER JOIN  arg.dbo.AktOf AS ao ON ao.AktOfNum = infr.AktOfNum
LEFT JOIN nsi.dbo.D_Station AS ds ON ds.Code = infr.stationReg
WHERE infr.asumrType IS NOT NULL AND ao.[Status] IN (2,3)
GROUP BY infr.stationReg, ds.name
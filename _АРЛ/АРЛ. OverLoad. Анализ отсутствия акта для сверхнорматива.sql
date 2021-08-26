
-- первый норматив, от прибытия до подачи
SELECT id, dateArrive, dateArrive, dateFeed, controlFeedDate,
	datediff(mi,dateArrive, dateFeed)/60.0 AS factDiff,
	datediff(mi,dateArrive, dateFeed)/60.0 AS controlDiff,
	normFeedOper, factFeedOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 AS overcap,
	
	controlFeed, aktFeed, aofidFeed,
	
	'' AS t1,'' t2, m.sendnumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
FROM vag.dbo.modelArrive AS m 
	LEFT JOIN vag.dbo.modelArrive_violation AS mv
		ON mv.idModelArrive = m.id 
WHERE 1=1
	AND m.carnum IN ( '62206529' )
	AND m.sendnumArrive IN ( 'ЭР059461' )
ORDER BY dateArrive DESC


-- второй норматив, от подачи до окончания грузовой операции
SELECT id, dateArrive, DATEDIFF(d, dateArrive, '2021-03-29 13:08:52.380') AS diff,
	dateFeed, controlFeeddate, dateGruz, controlGruzDate,
	datediff(mi,dateFeed, dateGruz)/60.0 AS factDiff,
	datediff(mi,controlFeeddate, dateGruz)/60.0 AS controlDiff,
	normGruzOper, factGruzOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 AS overcap,
	
	controlGruz, aktGruz, aofidGruz,
	
	'' AS t1,'' t2, m.sendnumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
FROM vag.dbo.modelArrive AS m 
	LEFT JOIN vag.dbo.modelArrive_violation AS mv
		ON mv.idModelArrive = m.id
WHERE 1=1
	AND m.carnum IN ( '52990330' )
	AND m.sendnumArrive IN ( 'ЭЧ213300' )
ORDER BY dateArrive DESC


-- третий норматив, от окончания грузовой операции до уборки
SELECT id, dateArrive, DATEDIFF(d, dateArrive, '2021-03-19 13:08:52.380') AS diff,
	dateGruz, controlGruzdate, dateClear, controlClearDate,
	datediff(mi,dateGruz, dateClear)/60.0 AS factDiff,
	datediff(mi,controlGruzdate, dateClear)/60.0 AS controlDiff,
	normClearOper, factClearOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 AS overcap,
	
	controlClear, aktClear, aofidClear,
	
	'' AS t1,'' t2, m.sendnumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
FROM vag.dbo.modelArrive AS m 
	LEFT JOIN vag.dbo.modelArrive_violation AS mv
		ON mv.idModelArrive = m.id
WHERE 1=1
	AND m.carnum IN ( '62206529' )
	AND m.sendnumArrive IN ( 'ЭР059461' )
ORDER BY dateArrive DESC


-- четвертый норматив, от уборки до отправления
SELECT id, dateClear, controlCleardate, dateDep, controlDepDate,
	datediff(mi,dateClear, dateDep)/60.0 AS factDiff,
	datediff(mi,controlCleardate, dateDep)/60.0 AS controlDiff,
	normDepOper, factDepOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 AS overcap,
	
	controlDep, aktDep, aofidDep,
	
	'' AS t1,'' t2, m.sendnumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
FROM vag.dbo.modelArrive AS m 
	LEFT jOin vag.dbo.modelArrive_violation AS mv
		ON mv.idModelArrive = m.id
WHERE 1=1
	AND m.carnum IN ( '62206529' )
	AND m.sendnumArrive IN ( 'ЭР059461' )
ORDER BY dateArrive DESC

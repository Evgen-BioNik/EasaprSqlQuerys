
-- первый норматив, от прибытия до подачи
select dateArrive, dateArrive, dateFeed, controlFeedDate,
	datediff(mi,dateArrive, dateFeed)/60.0 as factDiff,
	datediff(mi,dateArrive, dateFeed)/60.0 as controlDiff,
	normFeedOper, factFeedOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 as overcap,
	
	controlFeed, aktFeed, aofidFeed,
	
 '' as t1,'' t2, sendNumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
from vag.dbo.modelArrive as m 
	left join vag.dbo.modelArrive_violation as mv 
		on mv.idModelArrive = m.id 
where sendnumarrive = 'ЭР059461'  and m.carnum = '63109433'


-- второй норматив, от подачи до окончания грузовой операции
SELECT id,dateArrive, DATEDIFF(d, dateArrive, '2021-03-29 13:08:52.380') AS diff,
	dateFeed, controlFeeddate, dateGruz, controlGruzDate,
	datediff(mi,dateFeed, dateGruz)/60.0 as factDiff,
	datediff(mi,controlFeeddate, dateGruz)/60.0 as controlDiff,
	normGruzOper, factGruzOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 as overcap,
	
	controlGruz, aktGruz, aofidGruz,
	
 '' AS t1,'' t2, sendNumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
FROM vag.dbo.modelArrive AS m 
	LEFT JOIN vag.dbo.modelArrive_violation AS mv 
		ON mv.idModelArrive = m.id 
WHERE 1=1
	AND m.carnum IN ( '52990330' )
	AND sendnumarrive IN ( 'ЭЧ213300' )
ORDER BY dateArrive DESC


-- третий норматив, от окончания грузовой операции до уборки
SELECT dateArrive, DATEDIFF(d, dateArrive, '2021-03-19 13:08:52.380') AS diff,
	dateGruz, controlGruzdate, dateClear, controlClearDate,
	datediff(mi,dateGruz, dateClear)/60.0 AS factDiff,
	datediff(mi,controlGruzdate, dateClear)/60.0 AS controlDiff,
	normClearOper, factClearOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 AS overcap,
	
	controlClear, aktClear, aofidClear,
	
 '' AS t1,'' t2, sendNumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
FROM vag.dbo.modelArrive AS m 
	LEFT JOIN vag.dbo.modelArrive_violation AS mv 
		ON mv.idModelArrive = m.id 
WHERE 1=1
	AND m.carnum IN ( '62206529' )
	AND sendnumarrive IN ( 'ЭР059461' )
ORDER BY dateArrive DESC


-- четвертый норматив, от уборки до отправления
select  dateClear, controlCleardate, dateDep, controlDepDate,
	datediff(mi,dateClear, dateDep)/60.0 as factDiff,
	datediff(mi,controlCleardate, dateDep)/60.0 as controlDiff,
	normDepOper, factDepOper,
	datediff(mi,dateArrive, datedep)/60.0 cap,
	datediff(mi,dateArrive, datedep)/60.0 - 24 as overcap,
	
	controlDep, aktDep, aofidDep,
	
 '' as t1,'' t2, sendNumArrive, m.carnum, privateCar, BreakStone, innerdelivery, InsideShipping
from vag.dbo.modelArrive as m 
	left join vag.dbo.modelArrive_violation as mv 
		on mv.idModelArrive = m.id 
where sendnumarrive = 'ЭР059461'  and m.carnum = '30508386'

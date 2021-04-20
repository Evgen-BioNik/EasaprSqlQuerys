
DECLARE @normAll INT = 24
		,@d1 DATETIME = '2018-01-29 18:01:00'
		,@d2 DATETIME = '2018-05-30 18:00:00'

		


SELECT dr.Code as RailCode, RTRIM(dr.NameShort) AS RailName
	,COUNT(DISTINCT(t.idModelArrive)) AS CarCount
	,SUM(CASE WHEN t.Staying > @normAll THEN t.Staying - @normAll ELSE 0 END) AS SumOverStaying
	
	,SUM( CASE WHEN t.depCode = 1 THEN t.ElementViol ELSE 0 END) AS dep1
	,SUM( CASE WHEN t.depCode = 2 THEN t.ElementViol ELSE 0 END) AS dep2
	,SUM( CASE WHEN t.depCode = 3 THEN t.ElementViol ELSE 0 END) AS dep3
	,SUM( CASE WHEN t.depCode = 9 THEN t.ElementViol ELSE 0 END) AS dep9
	,SUM( CASE WHEN t.depCode = 5 THEN t.ElementViol ELSE 0 END) AS dep5
	,SUM( CASE WHEN t.depCode = 7 THEN t.ElementViol ELSE 0 END) AS dep7
	,SUM( CASE WHEN t.depCode = 6 THEN t.ElementViol ELSE 0 END) AS dep6
	,SUM( CASE WHEN t.depCode = 4 THEN t.ElementViol ELSE 0 END) AS dep4
	,SUM( CASE WHEN t.depCode = 8 THEN t.ElementViol ELSE 0 END) AS dep8
	,SUM( CASE WHEN t.depCode =10 THEN t.ElementViol ELSE 0 END) AS dep10
	
FROM nsi.dbo.D_Rail AS dr
	LEFT JOIN (				
		SELECT 
			mav.carNum
			,mav.idModelArrive
			,av.dtDepartmentID AS depCode
			,ds.CodeRail
			,DATEDIFF(hh, ma.dateArrive, ISNULL(ma.dateDep, @d2)) as Staying
			,CASE 
				WHEN av.downtimeElements = 1 THEN ma.factFeedOper - ma.normFeedOper
				WHEN av.downtimeElements = 2 THEN ma.factGruzOper - ma.normGruzOper
				WHEN av.downtimeElements = 3 THEN ma.factClearOper - ma.normClearOper
				WHEN av.downtimeElements = 4 THEN ma.factDepOper - ma.normDepOper
			END AS ElementViol
	

		FROM vag.dbo.aofViolation AS av
			INNER JOIN vag.dbo.modelArrive_violation AS mav
				ON av.AktOfNum = CASE 
					WHEN av.downtimeElements = 1 THEN mav.aofIdFeed
					WHEN av.downtimeElements = 2 THEN mav.aofIdGruz
					WHEN av.downtimeElements = 3 THEN mav.aofIdClear
					WHEN av.downtimeElements = 4 THEN mav.aofIdDep
				END
			INNER JOIN vag.dbo.modelArrive AS ma
				ON ma.id = mav.idModelArrive
			INNER JOIN nsi.dbo.D_Station AS ds
				ON ds.Code = ma.stationTo

		WHERE av.aofReasonDelayID IS NOT NULL AND av.dtDepartmentID IS NOT NULL
			AND ma.privateCar = 1
			AND ma.notView IS NULL
			AND (ma.controlFeed < 4 OR ma.controlGruz < 4 OR ma.controlClear < 4 OR ma.controlDep < 4)
			AND DATEDIFF(hh, ma.dateArrive, ISNULL(ma.dateDep, @d2)) > @normAll
			AND (ma.dateDep IS NULL OR ma.dateDep BETWEEN @d1 AND @d2)
	) AS t ON t.CodeRail = dr.Code

WHERE dr.SOB = '20' AND dr.Code NOT IN ('ZZ','99','20')

GROUP BY dr.Code, dr.NameShort
ORDER BY dr.Code
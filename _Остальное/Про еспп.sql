DECLARE @StartDate date = '2020-01-01'
       ,@EndDate   date = '2020-05-01'
;
DECLARE @dateTab TABLE (theDate DATE);
DECLARE @sys INT =8; -- 1 ЕАСАПР М
                      -- 2 тескад
                      -- 3 сд
                      -- 4 сфто
                      -- 5 аскм
                      -- 6 ржд
                      -- 7 рждс
                      -- 8 нтп
                      


WITH theDates AS
     (SELECT @StartDate as theDate
      UNION ALL
      SELECT DATEADD(day, 1, theDate)
        FROM theDates
       WHERE DATEADD(day, 1, theDate) <= @EndDate
     )
 
INSERT @dateTab
SELECT theDate
FROM theDates


SELECT	 td.theDate AS 'дата'
		,isnull(lb.LeftBefore,0) 'остаток на начало'
		,isnull(inc.incoming,0)'пришло за день'
		,isnull(sh.shitDone,0)'сделано за день'
		,isnull(lb.LeftBefore,0)+isnull(inc.incoming,0)-isnull(sh.shitDone,0) 'остаток на конец'
		,ISNULL(w.wasted,0)'просрочено'
FROM @dateTab AS td
	LEFT JOIN (
		SELECT td.theDate, COUNT(1) AS leftBefore
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON pe.dateOpen < td.theDate AND (pe.dateClose IS NULL OR pe.dateClose >= td.theDate)

		WHERE pe.systemcode = CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate
	) AS lb ON lb.theDate = td.theDate
	LEFT JOIN (
		SELECT td.theDate, COUNT(1) AS incoming
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON pe.dateOpen = td.theDate

		WHERE pe.dateOpen >=@StartDate AND pe.systemcode = CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate
	) AS inc ON inc.theDate = td.theDate
	LEFT JOIN (
		SELECT td.theDate, COUNT(1) AS shitDone
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON pe.dateClose = td.theDate

		WHERE pe.systemcode = CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate 
	) AS sh ON sh.theDate = td.theDate
	
	LEFT JOIN (
		SELECT td.theDate, COUNT(DISTINCT vpnum) AS wasted
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON td.theDate > pe.dateOpen AND (td.theDate<pe.dateClose OR pe.dateClose IS NULL)

		WHERE pe.isitSNAFU ='1' AND pe.systemcode= CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate 
	) AS w ON w.theDate = td.theDate

 /* 
UPDATE analyze.dbo.Pro_ESPP2 SET systemcode = CASE WHEN (system like 'ОТР_АИСГ' or system like 'ОТР_АПО' or system like 'ОТР_АРЛ' or system like 'ОТР_АРМ_ПКО' or system like 'ОТР_АРНОД' or system like 'ОТР_ЕАСАПР_М' or system like 'ОТР_ПОГРАНПЕРЕХОДЫ' or system like 'ОТР_УКН') THEN 1 --easapr M
WHEN (system like 'ОТР_АС_ТЕСКАД' or system like 'ОТР_АСВХ') THEN 2 --teskad
WHEN (system like 'ОТР_ЕАСАПР_СД' or system like 'ОТР_АС_ПБ') THEN 3--sd
WHEN (system like 'ОТР_ЕАСАПР_СФТО') THEN 4--sfto
WHEN (system like 'ОТР_АСКМ' or system like 'ОТР_АСКМ_ЗПУ') THEN 5 --askm
WHEN (system like 'ОТР_ЕАСАПР_РЖД') THEN 6-- rzd
WHEN (system like 'ОТР_ЕАСАПР_РЖДС') THEN 7--rzdS
WHEN (system like 'ОТР-ЕАСАПР-НТП') THEN 8-- cust
                                              end
                                              
                             */
/*
delete analyze.dbo.pro_espp2
*/                             
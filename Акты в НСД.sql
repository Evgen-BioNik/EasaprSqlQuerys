declare @temp_kih_sends table(id int NOT NULL identity(1,1), uno bigint, number varchar(8), loaded datetime, fact_vyd datetime, vagnum varchar(8), has_final int,
	primary key clustered (id))

	INSERT INTO @temp_kih_sends (uno , number, loaded, fact_vyd,vagnum, has_final)
	SELECT * FROM OPENQUERY([xi], 'SELECT TOP 2000 uno, number, loaded, ISNULL(fact_vyd, fact_uved) as fact_vyd,vagnum, 0
			 FROM delay.dbo.kih_invoice WITH (NOLOCK)
			 WHERE uno = 505984087
			 ORDER BY uploaded_fakt desc')

UPDATE @temp_kih_sends 
	SET has_final = ISNULL(ps.resultProlong,0)
	FROM 
	 @temp_kih_sends ts
	 LEFT JOIN  arg.dbo.ProlongSend ps ON  ps.uno = ts.uno


	select distinct uno,tks.has_final,tks.vagnum, t.* from
	@temp_kih_sends as tks
	left outer join (
            SELECT DISTINCT tks.id,
                        CASE WHEN (ao.StationTo = ao.Station AND (ao.Type = 130 OR TypeAdd = 498)) THEN 1 WHEN (ao.ProlongDay > 0) THEN 0 ELSE 2 END AS type,
                        CASE WHEN (ao.StationTo = ao.Station AND (ao.Type = 130 OR TypeAdd = 498)) THEN ao.ProlongDay WHEN tks.has_final = 1 THEN pln.dayFakt ELSE ao.ProlongDay END as ProlongDay,
                        case when (ao.Status not in (2,3)
                         AND(
                                tks.has_final = 1 AND
                                (
                                        isnull(pln.dayFakt,0) > 0
                                        OR
                                        (
                                            (ao.Type = 130 OR TypeAdd = 498) AND Station = ao.StationTo 
                                        )
                                )
                            OR     tks.has_final = 0 AND ao.ProlongDay > 0 AND rd.Department is null 
                            )
                        
                        ) then 1 else 0 end as CanUse,
                        ao.Station,
                        ds.CodeRail + ds.CodeNod as Region,
                        ds.CodeRail,
                        ao.AktOfNum,
                        rd.Department,
                        schema_aof,
                        ao.AktNum,
                        ao.Site,
                        ao.AktDate,
                        ao.reasonDelay,
						ao.TypeAdd,
						0 as pko,
						ao.ProlongDay as origProlongDay,
						ISNULL(DATEDIFF(hh, aodtb.DateTimeBegin, aodte.DateTimeEnd),0) as Delay

                        FROM @temp_kih_sends tks
                        LEFT JOIN arg.dbo.aof_send aos On tks.number = aos.SendNum
                        LEFT JOIN arg.dbo.aof ao ON ao.AktOfNum = aos.AktOfNum AND ao.aktdate between tks.loaded AND tks.fact_vyd AND ao.status in (0,1)
                        LEFT JOIN nsi.dbo.D_Station ds ON ds.Code = ao.station
                        LEFT JOIN nsi.dbo.T_ReasonDelay rd ON rd.id = ao.ReasonDelay
                        LEFT JOIN arg.dbo.prolonglink pln on pln.sendnum=aos.sendnum and pln.aofidfoll=ao.aktofnum and pln.cancel=0
                        LEFT JOIN [arg].[dbo].[AktOfDownTimeCar] aodtc ON aodtc.AktOfNumEnd = ao.AktOfNum
						LEFT JOIN arg.dbo.AktOfCarriage aoc ON aoc.AktOfCarriageNum = aodtc.AktOfCarriageNumEnd
						LEFT JOIN arg.dbo.AktOfDownTime aodte ON aodte.AktOfNum = aodtc.AktOfNumEnd AND aoc.AktOfCarriageNum is not null
						LEFT JOIN arg.dbo.AktOfDownTime aodtb ON aodtb.AktOfNum = aodtc.AktOfNum AND aoc.AktOfCarriageNum is not null
						WHERE ao.AktNum is not null AND (aoc.CarriageNum = tks.vagnum OR aoc.CarriageNum is null)

                    UNION ALL

                    SELECT DISTINCT tks.id,
                        CASE WHEN (ao.StationTo = ao.Station AND (ao.Type = 130 OR TypeAdd = 498)) THEN 1 WHEN (ao.ProlongDay > 0) THEN 0 ELSE 2 END AS type,
						CASE WHEN (ao.StationTo = ao.Station AND (ao.Type = 130 OR TypeAdd = 498)) THEN ao.ProlongDay WHEN tks.has_final = 1 THEN pln.dayFakt ELSE ao.ProlongDay END as ProlongDay,
                        case when (ao.Status not in (2,3)
                      
                         AND(
                                tks.has_final = 1 AND
                                (
                                        isnull(pln.dayFakt,0) > 0
                                        OR
                                        (
                                            (ao.Type = 130 OR TypeAdd = 498) AND Station = ao.StationTo
                                        )
                                )
                            OR     tks.has_final = 0 AND ao.ProlongDay > 0 AND rd.Department is null
                            )
                        
                        ) then 1 else 0 end as CanUse,
                        ao.Station,
                        ds.CodeRail + ds.CodeNod as Region,
                        ds.CodeRail,
                        ao.AktOfNum,
                        rd.Department,
                        schema_aof,
                        ao.AktNum,
                        ao.Site,
                        ao.AktDate,
                        ao.reasonDelay,
						ao.TypeAdd,
						0 as pko,
						ao.ProlongDay as origProlongDay,
						ISNULL(DATEDIFF(hh, aodtb.DateTimeBegin, aodte.DateTimeEnd),0) as Delay


                       FROM @temp_kih_sends tks
                        LEFT JOIN aof_oper.dbo.aof_send aos On tks.number = aos.SendNum
                        LEFT JOIN aof_oper.dbo.aof ao ON ao.AktOfNum = aos.AktOfNum AND ao.aktdate between tks.loaded AND tks.fact_vyd AND ao.status in (0,1)
                        LEFT JOIN nsi.dbo.D_Station ds ON ds.Code = ao.station
                        LEFT JOIN nsi.dbo.T_ReasonDelay rd ON rd.id = ao.ReasonDelay
                        LEFT JOIN arg.dbo.prolonglink pln on pln.sendnum=aos.sendnum and pln.aofidfoll=ao.aktofnum and pln.cancel=0
						LEFT JOIN [arg].[dbo].[AktOfDownTimeCar] aodtc ON aodtc.AktOfNumEnd = ao.AktOfNum
						LEFT JOIN arg.dbo.AktOfCarriage aoc ON aoc.AktOfCarriageNum = aodtc.AktOfCarriageNumEnd
						LEFT JOIN arg.dbo.AktOfDownTime aodte ON aodte.AktOfNum = aodtc.AktOfNumEnd AND aoc.AktOfCarriageNum is not null
						LEFT JOIN arg.dbo.AktOfDownTime aodtb ON aodtb.AktOfNum = aodtc.AktOfNum AND aoc.AktOfCarriageNum is not null
						WHERE ao.AktOfNum is not null AND (aoc.CarriageNum = tks.vagnum OR aoc.CarriageNum is null)
						UNION ALL

                    SELECT DISTINCT tks.id,
                        CASE WHEN (ao.StationTo = ao.Station AND (ao.Type = 130 OR TypeAdd = 498)) THEN 1 WHEN (ao.ProlongDay > 0) THEN 0 ELSE 2 END AS type,
						CASE WHEN (ao.StationTo = ao.Station AND (ao.Type = 130 OR TypeAdd = 498)) THEN ao.ProlongDay WHEN tks.has_final = 1 THEN pln.dayFakt ELSE ao.ProlongDay END as ProlongDay,
                        case when (ao.Status not in (2,3)
                       
                         AND(
                                tks.has_final = 1 AND
                                (
                                        isnull(pln.dayFakt,0) > 0
                                        OR
                                        (
                                            (ao.Type = 130 OR TypeAdd = 498) AND Station = ao.StationTo
                                        )
                                )
                            OR     tks.has_final = 0 AND ao.ProlongDay > 0 AND rd.Department is null
                            )
                        
                        ) then 1 else 0 end as CanUse,
                        ao.Station,
                        ds.CodeRail + ds.CodeNod as Region,
                        ds.CodeRail,
                        ao.AktOfNum,
                        rd.Department,
                        schema_aof,
                        ao.AktNum,
                        ao.Site,
                        ao.AktDate,
                        ao.reasonDelay,
						ao.TypeAdd,
						0 as pko,
						ao.ProlongDay as origProlongDay,
						ISNULL(DATEDIFF(hh, aodtb.DateTimeBegin, aodte.DateTimeEnd),0) as Delay


                       FROM @temp_kih_sends tks
                        inner remote JOIN aof_arch.dbo.aof_send aos On tks.number = aos.SendNum
						inner remote JOIN aof_arch.dbo.aof ao ON ao.AktOfNum = aos.AktOfNum AND ao.aktdate between tks.loaded AND tks.fact_vyd AND ao.status in (0,1)
						LEFT JOIN nsi.dbo.D_Station ds ON ds.Code = ao.station
                        LEFT JOIN nsi.dbo.T_ReasonDelay rd ON rd.id = ao.ReasonDelay
                        LEFT JOIN arg.dbo.prolonglink pln on pln.sendnum=aos.sendnum and pln.aofidfoll=ao.aktofnum and pln.cancel=0
                        LEFT JOIN [arg].[dbo].[AktOfDownTimeCar] aodtc ON aodtc.AktOfNumEnd = ao.AktOfNum
						LEFT JOIN arg.dbo.AktOfCarriage aoc ON aoc.AktOfCarriageNum = aodtc.AktOfCarriageNumEnd
						LEFT JOIN arg.dbo.AktOfDownTime aodte ON aodte.AktOfNum = aodtc.AktOfNumEnd AND aoc.AktOfCarriageNum is not null
						LEFT JOIN arg.dbo.AktOfDownTime aodtb ON aodtb.AktOfNum = aodtc.AktOfNum AND aoc.AktOfCarriageNum is not null
						WHERE tks.loaded < '01-01-2014' AND ao.AktNum is not null AND (aoc.CarriageNum = tks.vagnum OR aoc.CarriageNum is null)

						
                         UNION ALL

                         SELECT DISTINCT tks.id,
                         2 as type,
                         ProlongDay,
                         0 as CanUse,
                         ao.Station,
                         ds.CodeRail + ds.CodeNod as Region,
                         ds.CodeRail,
                         ao.AktOfNum,
                         -1 as Department,
                         null as schema_aof,
                         ao.AktNum,
                         ao.Site,
                         ao.AktDate,
                         ao.reasonDelay,
                         null as TypeAdd,
                         1 as pko,
                         ao.ProlongDay as origProlongDay,
                         0 as Delay
                     FROM @temp_kih_sends tks
                     left JOIN  uhv.dbo.AktOfSend aos ON aos.SendNum = tks.number
                     left JOIN uhv.dbo.AktOf ao ON ao.AktOfNum = aos.AktOfNum AND ao.aktdate between tks.loaded AND tks.fact_vyd
                     INNER JOIN nsi.dbo.D_Station ds ON ds.Code = ao.station
                     WHERE ao.AktNum is not null
                    ) t on t.id= tks.id
                     ORDER BY uno
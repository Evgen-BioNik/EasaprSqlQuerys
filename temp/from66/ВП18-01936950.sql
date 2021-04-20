			
				SELECT  blank.*
				FROM aof_arg.dbo.BlankType AS blank WITH (NOLOCK)
				
				WHERE	blank.dateReg BETWEEN '2018-10-23T00:00:00' AND '2018-10-26T23:59:00'
						AND blank.stationReg = '01490'
						AND blank.messageID IS NOT NULL
						
						
						AND blank.carNum = '96695069'
						
						
				ORDER BY blank.carNum 
				
				
				
			DECLARE @stCode CHAR(5) = '01490',
					@beginDate DATETIME = '2018-10-23T00:00:00',
					@endDate   DATETIME = '2018-10-26T23:59:00',
					@carriageNum CHAR(8) = '96695069';
		
			DECLARE @tab TABLE (aofID INT)

			INSERT INTO @tab 
			SELECT ba.aktofnum
			FROM aof_arg.dbo.BlankType AS ba WITH (NOLOCK)
			WHERE ba.stationReg = @stCode AND ba.carNum = @carriageNum
				AND ba.dateReg BETWEEN @beginDate AND @endDate 

select * from @tab

			SELECT * FROM (
				SELECT  dt.AktOfNum, dt.AktOfNumEnd
				FROM arg.dbo.AktOfDownTimeCar AS dt WITH (NOLOCK)
					INNER JOIN arg.dbo.AktOfCarriage AS ac
						ON ac.AktOfNum = dt.AktOfNum AND ac.AktOfCarriageNum = dt.AktOfCarriageNum
				WHERE dt.AktOfNum IN (SELECT aofid FROM @tab) AND ac.CarriageNum = @carriageNum

				UNION 
				
				SELECT  dt.AktOfNum, dt.AktOfNumEnd
				FROM arg.dbo.AktOfDownTimeCar AS dt WITH (NOLOCK)
					INNER JOIN arg.dbo.AktOfCarriage AS ac
						ON ac.AktOfNum = dt.AktOfNumEnd AND ac.AktOfCarriageNum = dt.AktOfCarriageNumEnd
				WHERE dt.AktOfNumEnd IN (SELECT aofid FROM @tab) AND ac.CarriageNum = @carriageNum
			) AS aofBase
			ORDER BY aofBase.AktOfNum, aofBase.AktOfNumEnd
		
		
		select * from arg.dbo.AktOfDownTimeCar where AktOfNumEnd = 159829540 or AktOfNum = 159829540
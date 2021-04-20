DECLARE	 @aofIdfinal INT = 137850654 
		,@sendNum CHAR(15) = 'ÝÌ267941';


SELECT DISTINCT
		carFinal.AktOfCarriageNum,
		carFinal.CarriageNum AS carNum,
		dov.Name AS carOwner,
		
		ps.uno AS sendUno,
		ps.sendNum,
		ps.dateReady AS dateReady,
		ps.dateArrive AS dateFact,
		ps.dateExpire AS dateNorm,
		
		ps.sender,
		ps.reciever as receiver,
		ps.stationFrom,
		ps.stationTo,
		
		aofEnd.Station AS dropStation,

		dtc.AktOfNum AS aofIdBegin,
		aofEnd.AktOfNum AS aofIdEnd,
		

		DATEDIFF(minute, aofBeg.AktDate, aofEnd.AktDate) AS delayTime, 
		aofBeg.AktDate AS dateBegin,
		aofEnd.AktDate AS dateEnd,
		dtData.*
       
FROM arg.dbo.ProlongLink AS pl WITH (NOLOCK)
	INNER JOIN arg.dbo.ProlongSend AS ps WITH (NOLOCK)
		ON ps.uno = pl.uno AND pl.sendNum = ps.sendNum
	INNER JOIN arg.dbo.AktOfCarriage AS carFinal WITH (NOLOCK)
		ON carFinal.AktOfNum = pl.aofIdfinal
	LEFT JOIN nsi.dbo.D_OwnerVag AS dov ON dov.Code = carFinal.[Owner]
		
	INNER JOIN arg.dbo.AktOf AS aofEnd WITH (NOLOCK)
		ON aofEnd.AktOfNum = pl.aofIdfoll

	INNER JOIN arg.dbo.AktOfDownTimeCar AS dtc WITH (NOLOCK)
		ON dtc.AktOfNumEnd = pl.aofIdfoll

	INNER JOIN arg.dbo.AktOfCarriage AS carBeg WITH (NOLOCK)
		ON carBeg.AktOfNum = dtc.AktOfNum
			AND carBeg.AktOfCarriageNum = dtc.AktOfCarriageNum
			AND carBeg.CarriageNum = carFinal.CarriageNum
	INNER JOIN arg.dbo.AktOfSend AS sendBeg WITH (NOLOCK)
		ON sendBeg.AktOfNum = dtc.AktOfNum
			AND sendBeg.idCar = carBeg.AktOfCarriageNum
			AND sendBeg.SendNum = pl.sendNum
	
	INNER JOIN arg.dbo.aktof AS aofBeg WITH (NOLOCK)
		ON aofBeg.AktOfNum = dtc.AktOfNum
		
	INNER JOIN (
		SELECT DISTINCT 
			upakt.aktid AS UpAofID,
			[order].id AS dropOrderId,
			[order].[aktnum] AS dropOrderNum,
			[order].[date] AS dropOrderDate,
			[order].[sign] AS dropOrderSign,
		
			[uporder].id AS upOrderId,
			[uporder].[OrderNum] AS upOrderNum,
			[uporder].[date] AS upOrderDate,
			[uporder].[sign] AS upOrderSign,
		
			[order].[trainNum] AS doTrainNum,
			[order].[trainIndex] AS doTrainIndex,
			[uporder].[trainNum] AS upTrainNum,
			[uporder].[trainIndex] AS upTrainIndex,
			
			diar.AktIDFrom AS aofIdReceiveRejection,
			diar.ResponseType AS responceType,
			rec.ResponseName AS responceName,
			rec.id AS responceID,
			diar.ResponseTGNL AS responceTGNL
				
		FROM pi.dt.dbo.UpOrder_Akt AS upakt WITH (NOLOCK)
			INNER JOIN pi.dt.dbo.DtUpOrder AS uporder WITH (NOLOCK)
				ON uporder.id = upakt.OrderId
			INNER JOIN pi.dt.dbo.DtOrder AS [order] WITH (NOLOCK)
				ON [order].id = uporder.DropOrderId 
			
			INNER JOIN pi.dt.dbo.DtOrder_AffectedReceiver AS rec WITH (NOLOCK)
				ON rec.OrderID = [order].id AND rec.InqID = [order].Inquiry
			INNER JOIN pi.dt.dbo.shipment2 AS dtShip WITH (NOLOCK)
				ON dtShip.ResponseID = rec.id  AND dtShip.AktOfNumEnd = upakt.aktid
			inner JOIN pi.dt.dbo.DtInquiry_AffectedReceiver AS diar WITH (NOLOCK)
				ON diar.InqID = rec.InqID --AND diar.ResponseName = rec.ResponseName
		WHERE [order].[ReasonNum] = '01'
	
	) as dtData on dtData.UpAofID = pl.aofIdfoll
		
		
		
WHERE	ps.sendNum = @sendNum 
		AND pl.aofIdfinal = @aofIdfinal 
		--AND pl.aofIdfoll IN (132498146)
		AND pl.reasonDelay = 215
		AND pl.solution IS NULL
		AND ps.resultProlong = 1
ORDER BY carFinal.CarriageNum, dtData.dropOrderDate


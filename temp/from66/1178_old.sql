DECLARE	 @aofIdfinal INT = 132509350
		,@sendNum CHAR(15) = 'ÝÇ992030';


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
		
			aofRR.AktOfNum AS aofIdReceiveRejection,
			aofRR.Response AS responceType,
			CASE WHEN aofRR.Response = 'owner' THEN aofRR.pnpOwner ELSE aofRR.pnpReceiver END AS responceName,
			CASE WHEN aofRR.Response = 'owner' THEN aofRR.pnpOwnerCode ELSE aofRR.pnpReceiverCode END AS responceCode
		FROM pi.dt.dbo.UpOrder_Akt AS upakt WITH (NOLOCK)
			INNER JOIN pi.dt.dbo.DtUpOrder AS uporder WITH (NOLOCK)
				ON uporder.id = upakt.OrderId
			INNER JOIN pi.dt.dbo.DtOrder AS [order] WITH (NOLOCK)
				ON [order].id = uporder.DropOrderId 
			LEFT JOIN  pi.dt.dbo.DtInquiryAkts AS inqAof WITH (NOLOCK)
				ON inqAof.InqId = [order].Inquiry
			LEFT JOIN arg.dbo.AktOfReceiveRejection AS aofRR WITH (NOLOCK)
				ON aofRR.AktOfNum = inqAof.AktId
		WHERE upakt.aktid IN (132498146)
			AND [order].[ReasonNum] = '01'
	
	) as dtData on dtData.UpAofID = pl.aofIdfoll
		
		
		
WHERE	ps.sendNum = @sendNum 
		AND pl.aofIdfinal = @aofIdfinal 
		AND pl.aofIdfoll IN (132498146)
		AND pl.reasonDelay = 215
		AND pl.solution IS NULL
		AND ps.resultProlong = 1
ORDER BY carFinal.CarriageNum, dtData.dropOrderDate


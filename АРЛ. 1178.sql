DECLARE @aofIdfinal INT = 112148654
SELECT DISTINCT
		'new' q,
		GETDATE() as currDate,
		carEnd.AktOfCarriageNum,
		carEnd.CarriageNum AS carNum,
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
		[order].id AS dropOrderId,
		[order].[aktnum] AS dropOrderNum,
		[order].[date] AS dropOrderDate,
		[order].[sign] AS dropOrderSign,

		dtc.AktOfNum AS aofIdBegin,
		aofEnd.AktOfNum AS aofIdEnd,
				
		[uporder].id AS upOrderId,
		[uporder].[OrderNum] AS upOrderNum,
		[uporder].[date] AS upOrderDate,
		[uporder].[sign] AS upOrderSign,
				
		[order].[trainNum] AS doTrainNum,
		[order].[trainIndex] AS doTrainIndex,
		[uporder].[trainNum] AS upTrainNum,
		[uporder].[trainIndex] AS upTrainIndex,

		DATEDIFF(minute, aofBeg.AktDate, aofEnd.AktDate) AS delayTime,
		aofRR.AktOfNum AS aofIdReceiveRejection,
		aofRR.Response AS responceType,
		CASE WHEN aofRR.Response = 'owner' THEN aofRR.pnpOwner ELSE aofRR.pnpReceiver END AS responceName
				
FROM    [arg].[dbo].[ProlongLink] AS pl WITH (NOLOCK)
		INNER JOIN arg.dbo.ProlongSend AS ps WITH (NOLOCK) ON ps.uno = pl.uno
		INNER JOIN arg.dbo.AktOfCarriage AS carEnd WITH (NOLOCK) ON carEnd.AktOfNum = pl.aofIdfinal
				
		INNER JOIN arg.dbo.aktof AS aofEnd WITH (NOLOCK) ON aofEnd.AktOfNum = pl.aofIdfoll
		INNER JOIN arg.dbo.AktOfDownTimeCar AS dtc WITH (NOLOCK) ON dtc.aktofnumend = pl.aofIdfoll
		INNER JOIN arg.dbo.AktOfCarriage AS carBeg WITH (NOLOCK) ON carBeg.AktOfNum = dtc.AktOfNum AND carBeg.CarriageNum = carEnd.CarriageNum
				 
		INNER JOIN arg.dbo.aktof AS aofBeg WITH (NOLOCK) ON aofBeg.AktOfNum = dtc.AktOfNum
				
		INNER JOIN [pi].dt.dbo.UpOrder_Akt AS upakt ON upakt.aktid = pl.aofIdfoll
		INNER JOIN [pi].dt.dbo.DtUpOrder AS uporder ON uporder.id = upakt.OrderId
		INNER JOIN [pi].dt.dbo.DtOrder AS [order] ON [order].id = uporder.DropOrderId
				  
		LEFT JOIN  [pi].dt.dbo.DtInquiryAkts AS inqAof ON inqAof.InqId = [order].Inquiry
		LEFT JOIN arg.dbo.AktOfReceiveRejection AS aofRR ON aofRR.AktOfNum = inqAof.AktId
				
		LEFT JOIN nsi.dbo.D_OwnerVag AS dov ON dov.Code = carEnd.[Owner]
WHERE	aofIdfinal = @aofIdfinal
		AND [order].[ReasonNum] = '01'
		AND pl.solution IS NULL
		AND ps.resultProlong = 1
ORDER BY carEnd.CarriageNum, [order].[date]
/*	
SELECT DISTINCT
		'old' q,
		GETDATE() as currDate,
		car.AktOfCarriageNum,
		car.CarriageNum AS carNum,
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
		[order].id AS dropOrderId,
		[order].[aktnum] AS dropOrderNum,
		[order].[date] AS dropOrderDate,
		[order].[sign] AS dropOrderSign,

		dtc.AktOfNum AS aofIdBegin,
		aofEnd.AktOfNum AS aofIdEnd,
					   
		[uporder].id AS upOrderId,
		[uporder].[OrderNum] AS upOrderNum,
		[uporder].[date] AS upOrderDate,
		[uporder].[sign] AS upOrderSign,
						   
		[order].[trainNum] AS doTrainNum,
		[order].[trainIndex] AS doTrainIndex,
		[uporder].[trainNum] AS upTrainNum,
		[uporder].[trainIndex] AS upTrainIndex,

		DATEDIFF(minute, aofBeg.AktDate, aofEnd.AktDate) AS delayTime,
		aofRR.AktOfNum AS aofIdReceiveRejection,
		aofRR.Response AS responceType,
		CASE WHEN aofRR.Response = 'owner' THEN aofRR.pnpOwner ELSE aofRR.pnpReceiver END AS responceName
					   
FROM   [arg].[dbo].[ProlongLink] AS pl WITH (NOLOCK)
		INNER JOIN arg.dbo.ProlongSend AS ps WITH (NOLOCK) ON ps.uno = pl.uno
		INNER JOIN arg.dbo.AktOfCarriage AS car WITH (NOLOCK) ON car.AktOfNum = pl.aofIdfinal
									
		INNER JOIN arg.dbo.aktof AS aofEnd WITH (NOLOCK) ON aofEnd.AktOfNum = pl.aofIdfoll
		INNER JOIN arg.dbo.aktofdowntimecar AS dtc WITH (NOLOCK) ON dtc.aktofnumend = pl.aofIdfoll
					   
		INNER JOIN arg.dbo.aktof AS aofBeg WITH (NOLOCK) ON aofBeg.AktOfNum = dtc.AktOfNum
						   
		INNER JOIN [pi].dt.dbo.UpOrder_Akt AS upakt ON upakt.aktid = pl.aofIdfoll
		INNER JOIN [pi].dt.dbo.DtUpOrder AS uporder ON uporder.id = upakt.OrderId
		INNER JOIN [pi].dt.dbo.DtOrder AS [order] ON [order].id = uporder.DropOrderId
					   
		LEFT JOIN  [pi].dt.dbo.DtInquiryAkts AS inqAof ON inqAof.InqId = [order].Inquiry
		LEFT JOIN arg.dbo.AktOfReceiveRejection AS aofRR ON aofRR.AktOfNum = inqAof.AktId
					   
		LEFT JOIN nsi.dbo.D_OwnerVag AS dov ON dov.Code = car.[Owner]
WHERE	aofIdfinal = @aofIdfinal
		AND [order].[ReasonNum] = '01'
		AND pl.solution IS NULL
		AND ps.resultProlong = 1
ORDER BY car.CarriageNum, [order].[date]
*/
DECLARE
  @aofIdfinal INT   = 190270638,			-- ИД итогового АОФ
  @sendNum CHAR(15) = 'ЭЫ549007';			-- Номер отправки, на которую составляется вся фигня

DECLARE @sendList TABLE (SendNum CHAR(8));
DECLARE @aofList TABLE (aofId INT);

-- Список ИД попутных АОФ на окончание
INSERT INTO @aofList VALUES (190005674);
-- Список отправок (досылка+основная/основная)
INSERT INTO @sendList VALUES (@sendNum),('ЭЫ062143');

SELECT DISTINCT
		carFinal.AktOfCarriageNum,
		carFinal.CarriageNum AS carNum,
		dov.Name AS carOwner,

		--ps.uno AS sendUno,
		sendBeg.uno as sendUno,
		sendBeg.sendNum,
		sendBeg.SendDate AS dateReady,
		ps.dateArrive AS dateFact,
		ps.dateExpire AS dateNorm,

		dtc.sender,
		dtc.receiver,
		dtc.stationFrom,
		dtc.stationTo,
		
		aofEnd.Station AS dropStation,

		dtc.AktOfNum AS aofIdBegin,
		aofEnd.AktOfNum AS aofIdEnd,

		DATEDIFF(minute, aofBeg.AktDate, aofEnd.AktDate) AS delayTime, 
		aofBeg.AktDate AS dateBegin,
		aofEnd.AktDate AS dateEnd,

		-- Data from dt
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
			AND sendBeg.SendNum IN ( SELECT SendNum FROM @sendList )
	
	INNER JOIN arg.dbo.aktof AS aofBeg WITH (NOLOCK)
		ON aofBeg.AktOfNum = dtc.AktOfNum
		
	INNER JOIN (
		SELECT 
		  UpAofID,
		  dropOrderId,
		  dropOrderNum,
		  dropOrderDate,
		  dropOrderSign,
		  upOrderId,
		  upOrderNum,
		  upOrderDate,
		  upOrderSign,
		  doTrainNum,
		  doTrainIndex,
		  upTrainNum,
		  upTrainIndex,
		  aofIdReceiveRejection,
		  responceType,
		  responceName,
		  responceID,
		  responceTGNL
		FROM pi.dt.dbo.arg_DropProlongSearch
		WHERE UpAofID IN (SELECT aofId FROM @aofList)
	) as dtData on dtData.UpAofID = pl.aofIdfoll

WHERE	ps.sendNum = @sendNum 
		AND pl.aofIdfinal = @aofIdfinal 
		AND pl.aofIdfoll IN ( SELECT aofId FROM @aofList )
		AND pl.reasonDelay IN (215, 375)
		AND pl.solution IS NULL
		AND ps.resultProlong = 1
ORDER BY carFinal.CarriageNum, dtData.dropOrderDate
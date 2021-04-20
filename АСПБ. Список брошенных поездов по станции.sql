--Ебашить на 10.246.101.127
-- Сказ о том как АРЛ ищет поезда в АСПБ

DECLARE @st char(5) = '96030'; -- станция бросания
DECLARE @offset INT = 30;

SELECT
	do.trainIndex
	,do.trainNum AS trainNumber
	,do.[date] AS dropDate
	,do.id AS orderId
	,do.AktNum AS ordernum
	,do.[sign] AS ordersign
	,duo.id AS uporderId
	,duo.OrderNum AS UpOrderNum
	,trains.id AS trid
	,do.ReasonNum AS dropReason
	,duo.trainIndex AS upTrainIndex
	,duo.trainNum AS upTrainNum
	
	,(SELECT COUNT(DISTINCT sendNum) FROM dt.dbo.shipment WHERE TrainId = trains.id ) AS c_SendNum
	,(SELECT COUNT(DISTINCT carNum)  FROM dt.dbo.carriage WHERE TrainId = trains.id ) AS c_CarNum
	
	,(SELECT COUNT(DISTINCT AktId) FROM dt.[dbo].[Fakt_Akt]		WHERE OrderId = do.id  ) AS c_AofDrop
	,(SELECT COUNT(DISTINCT AktId) FROM dt.[dbo].[UpOrder_Akt]	WHERE OrderId = duo.id ) AS c_AofUp

FROM dt.dbo.Trains AS trains WITH(NOLOCK)
	INNER JOIN dt.dbo.DtOrder AS do WITH(NOLOCK)
		ON do.id = trains.OrderId
	LEFT JOIN dt.dbo.DtUpOrder AS duo WITH(NOLOCK)
		ON duo.DropOrderId=do.id
			AND (duo.acceptedInAsoup NOT IN (3,4,5) OR duo.[forced] IS NOT NULL)
					
WHERE do.ds = @st
	AND do.[date] BETWEEN GETDATE()-@offset AND GETDATE()
	AND (do.acceptedInAsoup NOT IN (3,4,5) OR do.[forced] IS NOT NULL)
	AND do.IsAccepted IN (1,2)
ORDER BY do.id DESC
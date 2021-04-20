SELECT DISTINCT 
	 car.carriageId
	,car.carNum
	,car.carTypeID
	,car.carOwnerName carOwnerAlt
	
	,car.carCurrentOwner AS carHolder
	,car.carAxles
	,s.sendNum
	,s.invDateReady sendDateTime
	,s.uno
	,s.stfrom stationFrom
	,s.stto stationTo
	,s.senderokpo
	,s.sender Sender
	,s.senderID
	,s.recipient Receiver
	,s.receiverID
	,cont.contNum
	,cargo.code cargoCode
FROM [dt].[dbo].[carriage] as car WITH(NOLOCK)
	LEFT JOIN [dt].[dbo].[SCarLinks] as sl WITH(NOLOCK)
		ON sl.CarriageID=car.carriageId
	LEFT JOIN [dt].[dbo].[shipment2] as s WITH(NOLOCK)
		ON s.id = sl.ShipmentID
	
	LEFT JOIN [dt].[dbo].[SCargoLinks] as scrg WITH(NOLOCK)
		ON scrg.ShipmentID=s.id
	LEFT JOIN [dt].[dbo].[cargo2] as cargo WITH(NOLOCK)
		ON cargo.id=scrg.CargoID
	LEFT JOIN (
		SELECT DISTINCT cont.ContNum, scl.ShipmentID, cont.[Order], cont.TrainId
		FROM [dt].[dbo].[containers2] as cont WITH(NOLOCK)
			INNER JOIN [dt].[dbo].[SContLinks] as scl WITH(NOLOCK)
				ON scl.ContainerID=cont.id
	) as cont 
		ON cont.ShipmentID = s.id AND cont.[Order] = car.[Order] 
			AND cont.TrainId = s.TrainId
WHERE s.TrainId = (SELECT id FROM dt.dbo.Trains WHERE OrderId = 484253)
ORDER BY car.carNum
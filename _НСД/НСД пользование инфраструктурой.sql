SELECT distinct t.id'trainId',kih.FaktDate,do.AktNum,kih.vagcount , s.SendNum, do.trainIndex, s.IsAffectedReceiver, pp.id, pp.tgnl, s.ReceiverCode, do.ReasonNum, do.AsoupDropDate
			FROM [dt].[dbo].[DtOrder] do
			LEFT JOIN [dt].[dbo].[DtInquiry] di ON di.id=do.Inquiry
			LEFT JOIN [dt].[dbo].[DtInquiry_AffectedReceiver] diar ON diar.inqid=di.id
			LEFT JOIN [alpha].[arg].[dbo].[T_ReceiverPP] pp ON pp.id=diar.receiver
			LEFT JOIN [dt].[dbo].[Trains] t ON t.OrderId=do.id
			LEFT JOIN [dt].[dbo].[shipment] s ON s.TrainId=t.id
			LEFT JOIN [dt].[dbo].[shipment_kihinfo] kih ON s.uno=kih.uno
			INNER JOIN dt.dbo.carriage AS c ON c.TrainId=t.id
			WHERE do.trainIndex='0494-358-0498'

ORDER BY do.trainIndex, do.AsoupDropDate


/*
Тут соответственно IsAffectedReceiver показывает имеет вагон основания для взыскания платы или нет. 
Соответственно, если tgnl и ReceiverCode отличаются он будет 0. 
TGNL - то шо в акте о невозможности приёма указано, ReceiverCode - это то шо этран нам присылает при загрузке отправок.			

Все поезда, которые бросались по причине 39, попадают в отчёт. Ну опять же, >10 вагонов, >1000рублей простой
А сравнение полей ReceiverCode и tgnl имеет смысл только при бросании поезда по 01 причине.
*/
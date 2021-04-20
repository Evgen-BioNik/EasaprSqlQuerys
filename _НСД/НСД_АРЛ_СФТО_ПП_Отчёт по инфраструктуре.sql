DECLARE @TrainIndex char(13)
DECLARE @DropID int

SET @TrainIndex='2264-030-5331'
SET @DropID=319281--(SELECT top 1 DropID FROM [dt].[dbo].[rpt_cfto0139] WHERE TrainIndex=@TrainIndex ORDER BY CreateDate desc)

--select * from [dt].[dbo].[DtOrder] where TrainIndex='2264-030-5331' ORDER BY [date] --на случай ошибки "Subquery returned more than 1 value...."

------------------------------Информация по вагонам и отправкам в поезде----------------------------
--SELECT DATEDIFF(d,null,'2016-10-19 04:06:00.000')

SELECT DISTINCT rpts.DropID, rpts.SendNum, rpts.uno, rpts.VagNum, isaffected as 'сравнение ТГНЛ',deliverydate AS 'план.дата приб.', faktdate as 'факт.дата прибытия', 
		CASE 
			WHEN IsAffected=1 AND DATEDIFF(d, DeliveryDate, FaktDate) >0 THEN 'Имеет'
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 1 THEN 'Не имеет - Срок доставки не нарушен' 
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 0 THEN 'Не имеет - Срок доставки не нарушен; Не совпадает ТГНЛ акта и обращения, либо в справочнике получателя ТГНЛ отсутстсвует, либо не совпадают наименования получателей' 
			WHEN FaktDate IS NULL AND IsAffected=1 THEN  'Нет информации из КИХ о прибытии отправки'
			WHEN IsAffected = 0 AND DATEDIFF(d, DeliveryDate, FaktDate) > 0 THEN 'Не имеет - Не совпадает ТГНЛ акта и обращения, либо в справочнике получателя ТГНЛ отсутстсвует, либо не совпадают наименования получателей'
			WHEN IsAffected = 0 AND FaktDate IS NULL THEN 'Нет информации из КИХ о прибытии отправки; Не имеет - Не совпадает ТГНЛ акта и обращения, либо в справочнике получателя ТГНЛ отсутстсвует, либо не совпадают наименования получателей'
			END as Osnovaniya,
		SummToPay, SummPayed, SummPret
			FROM [dt].[dbo].[rpt_cfto0139Sends] rpts
	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=rpts.DropID
	LEFT JOIN [dt].[dbo].[DtInquiry] di ON di.id=do.Inquiry
	LEFT JOIN [dt].[dbo].[DtInquiry_AffectedReceiver] diar ON diar.inqid=di.id
	LEFT JOIN [alpha].[arg].[dbo].[T_ReceiverPP] pp ON pp.id=diar.receiver
	WHERE rpts.DropID=@DropID 
	--WHERE VagNum=''
	--WHERE SendNum=''
	ORDER BY 
	CASE 
			WHEN IsAffected=1 AND DATEDIFF(d, DeliveryDate, FaktDate) >0 THEN 'Имеет'
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 1 THEN 'Не имеет - Срок доставки не нарушен' 
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 0 THEN 'Не имеет - Срок доставки не нарушен; Не совпадает ТГНЛ акта и обращения, либо в справочнике получателя ТГНЛ отсутстсвует, либо не совпадают наименования получателей' 
			WHEN FaktDate IS NULL AND IsAffected=1 THEN  'Нет информации из КИХ о прибытии отправки'
			WHEN IsAffected = 0 AND DATEDIFF(d, DeliveryDate, FaktDate) > 0 THEN 'Не имеет - Не совпадает ТГНЛ акта и обращения, либо в справочнике получателя ТГНЛ отсутстсвует, либо не совпадают наименования получателей'
			WHEN IsAffected = 0 AND FaktDate IS NULL THEN 'Нет информации из КИХ о прибытии отправки; Не имеет - Не совпадает ТГНЛ акта и обращения, либо в справочнике получателя ТГНЛ отсутстсвует, либо не совпадают наименования получателей'
			END

-----------------------------Информация по получателям акта и отправок, присланных из ЭТРАН-------------------

SELECT DISTINCT rpts.SendNum, rpts.uno, rpts.Receiver'получатель в Э на момент бросания', pp.Name'тогда же, но в АОФ', s.ReceiverCode'код получателя из приказа', pp.TGNL'из АОФ'
FROM [dt].[dbo].[rpt_cfto0139Sends] rpts
	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=rpts.DropID
	INNER JOIN [dt].[dbo].[shipment] s ON s.carriageId=rpts.VagID
	LEFT JOIN [dt].[dbo].[DtInquiry] di ON di.id=do.Inquiry
	LEFT JOIN [dt].[dbo].[DtInquiry_AffectedReceiver] diar ON diar.inqid=di.id
	LEFT JOIN [alpha].[arg].[dbo].[T_ReceiverPP] pp ON pp.id=diar.receiver
	WHERE rpts.DropID=@DropID
	/*
SELECT do.id 'DtOrder.Id',rpts.DropID'rpts.DropID', s.carriageId's.carriageId',rpts.VagID'rpts.VagID', di.id'di.id',do.Inquiry'do.Inquiry', diar.inqid'diar.inqid',di.id'di.id', pp.id'pp.id',diar.receiver'diar.receiver'
 FROM [dt].[dbo].[rpt_cfto0139Sends] rpts
 	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=rpts.DropID
	INNER JOIN [dt].[dbo].[shipment] s ON s.carriageId=rpts.VagID
	LEFT JOIN [dt].[dbo].[DtInquiry] di ON di.id=do.Inquiry
	LEFT JOIN [dt].[dbo].[DtInquiry_AffectedReceiver] diar ON diar.inqid=di.id
	LEFT JOIN [alpha].[arg].[dbo].[T_ReceiverPP] pp ON pp.id=diar.receiver
	WHERE rpts.DropID=320062

*/
---------------------------Информация по накопительным-------------------------------

SELECT DISTINCT rpts.SendNum, rpts.VagNum, dueSum, с.cumID, с.cumNumber, с.cumState, с.CumLastOper
	FROM [alpha].[prolong].[dbo].[DropProlong] dp
	INNER JOIN [dt].[dbo].[rpt_cfto0139Sends] rpts ON rpts.DropID=dp.DropOrderId
	LEFT JOIN [cfto].[dbo].[CumulativeDue] cd ON cd.dueEasaprid=dp.aofIdEnd AND dp.sendUno=rpts.uno AND rpts.VagNum=cd.carNumber
	LEFT JOIN [cfto].[dbo].[Cumulative] с ON с.cumID=cd.cumID
	WHERE rpts.DropID=@DropID AND cd.cumID IS NOT NULL
	
	-- AND c.cumState='Заготовка'
	-- AND (c.cumState='Согласован' OR c.cumState='Закрыт' OR c.cumState='Не согласован' OR c.cumState='Согласован с разногласиями' OR c.cumState='На подписи')
	-- AND c.cuMState='Претензия'
	ORDER BY VagNum, cumLastOper

-----------------------------Просмотр информации по накопительной по ID -----------------------------------

DECLARE @CumID int
SET @CumID=''

SELECT cd.cumID, c.cumLastOper, c.cumNumber, cd.carNumber, cd.dueSum, cd.dueEasaprid
	FROM [cfto].[dbo].[CumulativeDue] cd
	INNER JOIN [cfto].[dbo].[Cumulative] c ON c.cumID=cd.cumID
	WHERE cd.cumID=@CumID 
	
	--INSERT INTO dt.dbo.[DtInquiry_AffectedReceiver] (inqid,receiver,pnpowner)	VALUES('100399','64737','64737')
--	update dt.dbo.rpt_cfto0139Sends  SET IsAffected = 0	WHERE uno  in ('649825015', '649827764', '649829812', '649844068', '649846187', '650028999', '650035209', '650038742', '650039952')



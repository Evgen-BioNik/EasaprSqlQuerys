    -- ищем по приказу и берем DropID
SELECT*
	FROM [dt].[dbo].[DtOrder]
	WHERE AktNum='4991' AND vagNum=0       
	ORDER BY id DESC


	--  вставуляем DropID со всей жестокостью и выполняем

DECLARE @DropID INT
DECLARE @AllCarriages int
DECLARE @ResponseCarriages int

SET @DropID=385663                         
SET @AllCarriages = (SELECT COUNT(DISTINCT c.carriageId)
	FROM [dt].[dbo].[carriage] c
	INNER JOIN [dt].[dbo].[Trains] t ON t.id=c.TrainId
	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=t.OrderId
	WHERE t.OrderId=@DropID)

SET @ResponseCarriages = (SELECT COUNT(DISTINCT c.carriageId)
	FROM [dt].[dbo].[carriage] c
	INNER JOIN [dt].[dbo].[Trains] t ON t.id=c.TrainId
	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=t.OrderId
	INNER JOIN [dt].[dbo].[DtOrder_AffectedReceiver] doar ON doar.ORderID=do.id
	INNER JOIN [dt].[dbo].[shipment] s ON s.ResponseID=doar.id 
	WHERE t.OrderId=@DropID)

UPDATE [dt].[dbo].[DtOrder] SET VagNum=@AllCarriages WHERE id=@DropID;
UPDATE [dt].[dbo].[DtOrder_AffectedReceiver] SET VagsQuantity=@ResponseCarriages WHERE OrderID=@DropID

SELECT VagNum FROM [dt].[dbo].[DtOrder] WHERE id=@DropID
SELECT VagsQuantity FROM [dt].[dbo].[DtOrder_AffectedReceiver] WHERE OrderID=@DropID

-- Запрос инфы по индексу поезда. Действитель для приказов после изменения с кода 39 на код 05
DECLARE  
	 @trainIndex		VARCHAR(13)='8622-338-2902' --Внеси индекс поезда
	,@OrderID			INT=''
	,@DateDropOrder		DATE
	,@DateSearch		DATE=GETDATE()-90			--период поиска
	,@ReasonNum			INT=''
	,@ClaimID			INT=''
	,@log				BIT=0						--смотреть АСОУП логи или нет 0=нет 1=да

--SET @OrderID = 561910			--Нашли нужный приказ на бросание, подставили id, раскоментировали строку
-----------------Приказ на бросание----------------
SELECT 
	 dtOr.id			AS 'idБросания'
	,AktNum				AS 'Номер приказа'
	,dtOr.[date]		AS 'Дата'
	,dtOr.CreateDate	AS 'Когда создали'
	,ds					AS 'Код станции'
	,st.Name			AS 'Станция'
	,ReasonNum			AS 'Код бросания'
	,dtOr.acceptedInAsoup ,dtOr.doneInAsoup, dtOr.ArriveDate
	,dtOr.ClaimID		AS 'Заявка на 39(05)'
FROM dt.dbo.DtOrder AS dtOr WITH (NOLOCK)
inner join nsi.dbo.D_Station AS st
ON st.Code=dtOr.ds
WHERE trainIndex=@trainIndex OR dtOr.id=@OrderID
ORDER BY dtOr.[date]
------------------Сначало до сюда--------------------
IF @OrderID!=''  SET @DateDropOrder=(SELECT [date] FROM dt.dbo.DtOrder WHERE id=@OrderID) 
IF @OrderID!=''	 SET @ReasonNum=(SELECT ReasonNum FROM dt.dbo.DtOrder WHERE id=@OrderID)
IF @ReasonNum=05 SET @ClaimID=(SELECT ClaimID FROM dt.dbo.DtOrder WHERE id=@OrderID)
------------------Приказ на подъем-------------------
SELECT 
	 dtUp.id			AS 'idПодъема'
	,dtUp.OrderNum		AS 'Номер приказа'
	,dtUp.[date]		AS 'Дата'
	,dtUp.CreateDate	AS 'Когда создали'
	,dtUp.ds			AS 'Код станции'
	,st.Name			AS 'Станция'
	,dtUp.acceptedInAsoup
	,dtUp.doneInAsoup	
FROM dt.dbo.DtUpOrder AS dtUp WITH (NOLOCK)
INNER JOIN nsi.dbo.D_Station AS st
ON st.Code=dtUp.ds
WHERE (DropOrderId=@OrderID AND DropOrderId!='') OR trainIndex=@trainIndex
ORDER BY dtUp.[date]
-----------------Заявка на отстой-------------------
IF @ReasonNum=05 SELECT Cl.[id]
					,Cl.[ClaimID]		AS 'idЗаявки'
					,Cl.[ClaimNum]		AS '№ Заявки'
					,Cl.[DateFrom]		AS 'От'
					,Cl.[DateTo]		AS 'До'
					,st.Name			AS 'Станция'
					,Cl.[Date]			AS 'Создана'
					,Cl.[AgreedDate]	AS 'Согласована'
					,us.Name			AS 'Кто согласовал'
				 FROM dt.dbo.Claim2 AS Cl WITH (NOLOCK)
				 INNER JOIN dt.dbo.Claim2 AS daughter
				 ON daughter.ParentID=Cl.ClaimID
				 INNER JOIN nsi.dbo.D_Station AS st
				 ON st.Code=Cl.Station
				 INNER JOIN [admin].[dbo].[D_User] AS us
				 ON us.Code=Cl.WhoAgree
				 WHERE Cl.ClaimID=@ClaimID
				 ORDER BY Cl.[id]
------------------Сообщения в АРЛ--------------------
IF @ReasonNum=05
	SELECT * FROM dt.dbo.EASAPRMessages WITH (NOLOCK)
	WHERE documentid=@ClaimID
ELSE IF @ReasonNum=01
	SELECT * FROM dt.dbo.EASAPRMessages WITH (NOLOCK)
	WHERE documentid=@OrderID OR documentid=(SELECT id FROM dt.dbo.DtUpOrder WHERE DropOrderId=@OrderID)
-----------------АСОУП логи--------------------------
IF @log=1
SELECT [id]
      ,[text]
      ,[date]
      ,[akt]
      ,[incoming]
      ,[msgtype]
      ,TypeOrder='Бросание'
FROM dt.dbo.AsoupLog WITH (NOLOCK)
WHERE akt=@OrderID
------------------------------------------------------
IF @log=1
SELECT [id]
      ,[text]
      ,[date]
      ,[akt]
      ,[incoming]
      ,[msgtype]
      ,TypeOrder='Подъем'
FROM dt.dbo.AsoupLog WITH (NOLOCK)
WHERE akt=(SELECT id FROM dt.dbo.DtUpOrder WHERE DropOrderId=@OrderID)
---------------Внесение сообщений в АРЛ------------------------------

/*		На бросание

INSERT INTO [dt].[dbo].[EASAPRMessages] ([text],[type],[documentid],[date])
VALUES  (
		'{"OrderID":"565884","type":"DropOrder","Station":"28500","DropOrderDate":"2019-05-13 06:13:00.000","ReasonCode":"01"}',
		'Drop01AktCreate',565884,GETDATE()
		)
*/
---------------------------------------------------------------------
/*		На подъем

INSERT INTO [dt].[dbo].[EASAPRMessages] ([text],[type],[documentid],[date])
VALUES  (
		'{"OrderID":"565884","type":"UpOrder","Station":"28500","UpOrderDate":"2019-05-13 06:13:00.000","ReasonCode":"01"}',
		'Up01AktCreate',565884,GETDATE()
		)
*/
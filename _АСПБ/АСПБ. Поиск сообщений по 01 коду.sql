/*
	Поиск факта передачи сообщений по 01 коду для создания актов из АСПБ в АРЛ по ИД приказа на бросание/подъем
	Ебашить на .127
*/

DECLARE @dropOrderID INT, @upOrderID INT;

	SET @dropOrderID = 537094;
--	SET @upOrderID = 495405;

IF (@dropOrderID IS NULL) SELECT @dropOrderID = droporderid FROM dt.dbo.dtuporder WHERE id = @upOrderID


SELECT * FROM dt.dbo.easaprmessages
WHERE documentid IN (@dropOrderID, @upOrderID)
ORDER BY id DESC


/*
	Поиск результата обработки этого сообщения
	Ебашить на .18
*/

DECLARE @OrderID INT = 541038


-- Данные об обработке сообщения
select top 1000 *
from interface_buff.dbo.que_list
where messageID in (@OrderID) 
order by id DESC

select * 
from interface_buff.dbo.que_Messages as q
	inner join interface_buff.dbo.que_Messages_aof as qa
		on qa.messID = q.id

where q.docid = @OrderID


-- Логи факта получения запросов, при необходимости раскоментить
/*
DECLARE @offset int = 5, @date DATETIME = '2019-02-18 00:45';

SELECT TOP 500 *
FROM arg.dbo.logMess with(nolock)
WHERE dateMess BETWEEN @date AND DATEADD(day,@offset,@date)
	AND typeMess IN ('Ins_39', 'queErr', 'DropAof', 'queDrop')
	
	AND typeDoc IN ('Drop','droporder','uporder')
	AND textMess LIKE '%' + CAST(@OrderID AS VARCHAR(20))+ '%'
ORDER BY id 
*/


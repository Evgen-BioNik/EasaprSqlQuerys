/*
	Поиск факта передачи сообщений по 39/05 коду для создания актов из АСПБ в АРЛ по ИД приказа на брсоание/подъем
	Ебашить на .127
*/

declare @claimID int, @dropOrderID int, @upOrderID int;

	set @dropOrderID = 731222;
--	set @upOrderID = 495405;

if (@dropOrderID IS NULL) select @dropOrderID = droporderid from dt.dbo.dtuporder where id = @upOrderID
select @claimID = claimid from dt.dbo.dtorder where id = @dropOrderID

select @dropOrderID as dropID, @upOrderID as upID, @claimID as ClaimID
select * from dt.dbo.easaprmessages where documentid = @claimID order by id desc


/*
	Поиск результата обработки этого сообщения искать по ID prikaza
	Ебашить на .18
*/

DECLARE @OrderID INT = 731222

select top 1000 *
from interface_buff.dbo.que_list
where messageID in (@OrderID) 

order by id desc

 --logMess 05 по Id приказа
DECLARE @offset int = 5, @date DATETIME = '2021-02-18 00:45';
select * from arg.dbo.logMess with (nolock)  
where dateMess between @date and DATEADD(day,@offset,@date)
and docId = @OrderID
order by id


SELECT TOP 500 *
FROM arg.dbo.logMess with(nolock)
WHERE dateMess BETWEEN @date AND DATEADD(day,@offset,@date)
	AND typeMess IN ('Ins_39', 'queErr', 'DropAof', 'queDrop')
	
	AND typeDoc IN ('Drop','droporder','uporder')
	AND textMess LIKE '%' + CAST(@OrderID AS VARCHAR(20))+ '%'
ORDER BY id 

--Ебашь на 43
Declare @ServPlace int =2378, @sdate datetime = '2017-01-01';
--@ServPlace = id склада

select 
	t.NumRecord as SK_id,
	SK.[Number] SK_Num ,
	SK.[Date] SK_Date,
	t.minDate first_save,
	t.maxDate last_save
from (
  SELECT NumRecord, MAX(DateTimeSaving) as maxDate , MIN(DateTimeSaving) as minDate
  from [mch].[dbo].[WhoSaved] 
  where TableName ='mch.dbo.StoreAkt' and DateTimeSaving > @sdate
	and NumRecord in (select id from [mch].[dbo].[StoreAkt] where idServPlace=@ServPlace)
  group by NumRecord /*having COUNT(*)>1*/
) as t 
	inner join [mch].[dbo].[StoreAkt] as SK on SK.ID=t.NumRecord
where DATEDIFF(dd,SK.[Date],maxDate) > 14 
order by SK.[Date]

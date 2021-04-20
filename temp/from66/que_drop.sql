DECLARE @OrderID varchar(10) = 537094
-- Логи факта получения запросов
DECLARE @offset int = 5, @date DATETIME = '2019-02-18 00:45';

SELECT TOP 500 *
FROM arg.dbo.logMess with(nolock)
WHERE dateMess BETWEEN @date AND DATEADD(day,@offset,@date)
	AND typeMess IN ('Ins_39', 'queErr', 'DropAof', 'queDrop')
	
	AND typeDoc IN ('Drop','droporder','uporder')
	AND textMess LIKE '%' + @OrderID + '%'
ORDER BY id 
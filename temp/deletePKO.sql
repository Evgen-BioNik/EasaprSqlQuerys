
SELECT TOP 100 YEAR([Date]) as ddate, COUNT(*)
FROM [ukn].[dbo].[WeighingPKO]
where Date < '2019-01-01'
group by YEAR([Date])
/*
declare @n int = 0;
move10:

delete top (5000) [ukn].[dbo].[WeighingPKO]
where Date < '2015-01-01'

if @@ROWCOUNT > 0 
begin 
	set @n = @n +1
	RAISERROR( N'count is %d ' ,0,1, @n) WITH NOWAIT
	goto move10
end

*/
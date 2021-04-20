--select mc.returnDate, dt.*, dtNew.*
declare @c INT = 0, @cnt INT = 0, @total INT = 0;
declare @date date = '2018-04-01'
declare @sDate varchar(30);

move10:

select @c = @c +1

update  dtNew
set dtNew.endOperDateTime = dt.returnDate
from (

	SELECT top 500 dt.id, dt.carNum, dt.memoIdClean, mc.returnDate
	FROM memo.dbo.analyze_busyPNP_dt_new dt
		inner join memo.dbo.memo_car mc
			on mc.memoId = dt.memoIdClean and mc.carNum = dt.carNum
	where memoIdClean is not null
		and endOperDateTime is null
		and dateWrite between @date and DATEADD(d,1,@date)
		and returnDate is not null 

) as dt

inner join memo.dbo.analyze_busyPNP_dt_new dtNew
	on dtNew.id = dt.id

where returnDate is not null 


select @cnt = @@ROWCOUNT, @total = @total + @@ROWCOUNT;

if (@cnt > 300) 
begin 
	RAISERROR( N'total updated rows = %d, runs = %d' ,0,1, @total, @c ) WITH NOWAIT
	goto move10
end 

select @date = DATEADD(d,1,@date);
select @sDate = cast(@date as varchar)
RAISERROR( N'date changed to %s ' ,0,1, @sDate ) WITH NOWAIT
if (@date < GETDATE()) goto move10
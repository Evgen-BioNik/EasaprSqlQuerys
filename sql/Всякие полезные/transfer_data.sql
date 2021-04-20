declare @c INT = 0, @cnt INT = 0, @total INT = 0;

declare @lastdate datetime = getdate(), @runTime INT = 0;
declare @runs table ( run int, runtime int );
move10:

select @c = @c +1


DELETE TOP (100)
FROM hardcopy.dbo.paper_signs_arch_new2 OUTPUT
    DELETED.[id]
    ,DELETED.[paper_uuid]
    ,DELETED.[paper_type]
    ,DELETED.[paper_hash]
    ,DELETED.[user_code]
    ,DELETED.[fio]
    ,DELETED.[creator]
    ,DELETED.[status]
    ,DELETED.[status_change] 
    ,DELETED.[status_history]
    ,DELETED.[signature]
  INTO hardcopy.dbo.paper_signs_arch (
    [id]
    ,[paper_uuid]
    ,[paper_type]
    ,[paper_hash]
    ,[user_code]
    ,[fio]
    ,[creator]
    ,[status]
    ,[status_change]
    ,[status_history]
    ,[signature]
  )


select @cnt = @@ROWCOUNT, @total = @total + @@ROWCOUNT
    ,@runTime = datediff(ms, @lastdate, getdate())
    ,@lastdate = GETDATE();

insert into @runs values (@c, @runTime)

if ( (@c < 12950 AND @total < 100000) OR @cnt < 100) 
begin 
--  select @runTime = AVG (runtime) from ( select top 100 runtime from @runs order by run desc ) as t
    RAISERROR( N'total updated rows = %d, runs = %d, exec time %d ms' ,0,1, @total, @c, @runtime ) WITH NOWAIT
    goto move10
end 

--RAISERROR( N'total updated rows is %d ' ,0,1, @total ) WITH NOWAIT

select @total as total, AVG (runtime)/1000.00 as avg_time 
from @runs

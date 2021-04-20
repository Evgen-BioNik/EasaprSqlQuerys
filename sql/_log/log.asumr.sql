declare @offset int = 1, @date date = '2018-09-27';

select top 50 *
from arg.dbo.logMess
where dateMess between @date and DATEADD(day,@offset,@date)
	and (
		typeMess = 'asumr'  
		or (typeMess='queErr' and typeDoc in ('asumrend','asumrstart')) 
	)
	and textMess like '%54052394%'
--order by id desc


select * from arg.dbo.T_ReceiverPP
where TGNL = 9472 and station = '03550'
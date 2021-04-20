declare @offset int = 1, @date date = '2019-12-10';

select top 50 *
from arg.dbo.logMess
where dateMess between @date and DATEADD(day,@offset,@date)
	and typeMess in ('asumr', 'queErr')
	
	and typeDoc in ('asumrend','asumrstart')
	and textMess like '%52387537%'
order by id desc


select * from arg.dbo.T_ReceiverPP
where okpo = 0071115994 and station = '10000' and actual=1
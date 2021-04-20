declare @offset int = 1, @date date = '2018-11-01';

select top 50 *
from arg.dbo.logMess
where dateMess between @date and DATEADD(day,@offset,@date)
	and typeMess in ('asumr', 'queErr')
	
	and typeDoc in ('asumrend','asumrstart')
	and textMess like '%96695044%'
--order by id desc


select * from arg.dbo.T_ReceiverPP
where TGNL = 9472 and station = '03550'



select top 1000 *
from interface_buff.dbo.que_list
where 1=1
--	and gueueID in ('asumrend','asumrstart')
	and aofID in (875273250)
--	and messageStation = '88510'

order by id desc


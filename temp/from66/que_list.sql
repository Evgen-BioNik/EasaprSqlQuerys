select top 1000 *
from interface_buff.dbo.que_list
where 1=1
--	and gueueID in ('asumrend  ')
	and messageID in (33500) 
--	and aofID in (159637187)
--	and messageStation = '88510'

order by id desc


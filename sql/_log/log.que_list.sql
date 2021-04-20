select top 1000 *
from interface_buff.dbo.que_list
where 1=1
	--and gueueID in (17,13)
--	and messageID in (36019) 
	and aofID in (158617675)
--	and messageStation = '88510'

order by id desc
--update aof_oper.dbo.aof set Status = 4 where AktOfNum in (142486849, 142487201 , 142488121)


select * from arg.dbo.aktof where AktOfNum = 158768937
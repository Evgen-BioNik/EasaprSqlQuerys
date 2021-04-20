
declare @incID int = 723
declare @sendNum varchar(8) = 'ЭШ644847'


select *
from aof_arg.dbo.incident_work
where id = @incID

select * 
from interface_buff.dbo.Incident_Etran
where SendNum = @sendNum

update iw
set iw.SendNum = t.SendNum, iw.ID_row = t.rowID, iw.invID = t.invoiceID
from aof_arg.dbo.incident_work as iw
	left join (
		select id as rowID, invoiceID, SendNum
		from interface_buff.dbo.Incident_Etran
		where SendNum = @sendNum
	) as t on 1 = 1
where iw.id = @incID


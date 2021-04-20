select * from interface_buff.dbo.que_Messages qm
	inner join interface_buff.dbo.que_Messages_aof qn
		on qm.id = qn.messID
where docID = 505335



declare @dateOld datetime = '2018-09-30 21:31:00.000'
update interface_buff.dbo.que_Messages 
--set docDate = '2018-10-22 21:31:00.000'
set docDate = @dateOld
where id = 38020

update aof_oper.dbo.WhoSaved
set DateTimeSaving = @dateOld
where NumRecord = 159715821 and TableName = 'aktof'

update aof_oper.dbo.aof set AktDate = @dateOld where AktOfNum = 159715821
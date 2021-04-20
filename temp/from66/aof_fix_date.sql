/*
select * from interface_buff.dbo.que_Messages qm
	inner join interface_buff.dbo.que_Messages_aof qn
		on qm.id = qn.messID
where docID = 7166


declare @buffRowID int = 123;

update interface_buff.dbo.que_Messages 
set docDate = @dateOld
where id = @buffRowID

*/


declare @aofId int = 191556015,
	@dateOld datetime = '2020-02-23 12:50:00.000',
	@IKnowWhatIDo bit = 0



if @IKnowWhatIDo = 1 begin
	update top(1) aof_oper.dbo.WhoSaved
	set DateTimeSaving = @dateOld
	where NumRecord = @aofId and TableName = 'aktof'

	update aof_oper.dbo.aof set AktDate = @dateOld where AktOfNum = @aofId 
	
end


select * from aof_oper.dbo.aof 
where AktOfNum = @aofId
select * from aof_oper.dbo.WhoSaved 
where NumRecord = @aofId and TableName = 'aktof'
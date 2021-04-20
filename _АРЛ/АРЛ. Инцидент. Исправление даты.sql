declare @aofId int = 206215493,
	@dateOld datetime = '2020-12-02 09:35:00.000',
	@IKnowWhatIDo bit = 0



if @IKnowWhatIDo = 1 begin
	update top(1) aof_oper.dbo.WhoSaved
	set DateTimeSaving = @dateOld
	where NumRecord = @aofId and TableName = 'aktof'

	update aof_oper.dbo.aof set AktDate = @dateOld where AktOfNum = @aofId 
	
	update aof_arg.dbo.incident_work set IncDate = @dateOld where aofID = @aofId
	
	update tau.[askm].[dbo].[DangerCargoIncident_Case]
	set IncidentDate = @dateOld
	where IncidentId = (select top 1 id from aof_arg.dbo.incident_work  where aofID = @aofId)

end


select * from aof_oper.dbo.aof 
where AktOfNum = @aofId
select * from aof_oper.dbo.WhoSaved 
where NumRecord = @aofId and TableName = 'aktof'

select *
from aof_arg.dbo.incident_work
where aofID = @aofId

select *
from tau.[askm].[dbo].[DangerCargoIncident_Case]
where IncidentId = (select top 1 id from aof_arg.dbo.incident_work  where aofID = @aofId)

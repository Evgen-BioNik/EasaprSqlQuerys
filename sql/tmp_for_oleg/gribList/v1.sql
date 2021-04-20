declare @tab table (aofid int)

insert into @tab select distinct aofIDManual from arg.dbo.tempAOFGribList where aofIDManual is not null


select ds.Name, t.fullname
	,ao.AktOfNum, ao.AktDate
	,case when ao.aofDT = 0 then 'начало' when ao.aofDT = 1 then 'окончание' else 'не парный' end as AofType
	,case when ao.CreateBy = 72068 then 'автомат' else 'ручной' end as CreateBy
	,case when ao.Status > 1 then 'Испорчен' else 'Документ' end as statusName
	
	,man.AktOfNum, man.AktDate
	
	,case when ao.aofIDManual is null then ao.AgreedSum else man.AgreedSum end as AgreedSum
	,case when ao.aofIDManual is null then ao.AskedSum else man.AskedSum end as AskedSum
from arg.dbo.tempAofGribList as ao

	left join arg.dbo.tempAOFGribList as man
		on man.AktOfNum = ao.aofIDManual


	left join nsi.dbo.D_Station as ds on ds.Code = ao.Station
	left join nsi.dbo.T_aofType as t on t.id = ao.TypeADD
where ao.aktofnum not in (select aofid from @tab)
--	and ao.aofidmanual is not null
	and ao.typeadd = 1229

order by ao.typeadd,  ao.aktofnum


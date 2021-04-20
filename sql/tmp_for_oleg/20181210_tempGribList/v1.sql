select ds.Name,  t.fullname + case when tr.name is null then '' else ', '+ tr.Name end as ReasonName

	,ao.AktOfNum, ao.AktDate, ao.AktNum
	,case when ao.aofDT = 0 then 'начало' when ao.aofDT = 1 then 'окончание' else 'не парный' end as AofType
	,case when ao.CreateBy = 72068 then 'автомат' else 'ручной' end as CreateBy
	,case when ao.SpoilBy = 72068 then 'автомат' else 'ручной' end as SpoilBy
	
	,man.AktOfNum, man.AktDate, man.AktNum
	
from arg.dbo.tempGribList_20181210 as ao

	left join arg.dbo.tempGribList_20181210 as man
		on man.AktOfNum = ao.aofIDManual


	left join nsi.dbo.D_Station as ds on ds.Code = ao.Station
	left join nsi.dbo.T_aofType as t on t.id = ao.TypeADD
	left join nsi.dbo.T_ReasonDelay as tr on tr.id = ao.reasondelay

where ao.[Status] > 1
	and CodeRail = '96'
--	and ao.typeadd = 1131

order by ds.Name, ao.AktOfNum



SELECT distinct
       aos.[SendNum]	as 'Отправка'
      ,akt.[AktNum]
      ,akt.[AktOfNum]     
      ,st.[Name]		as 'Станция'     
      ,case 
			when akt.[TypeAdd]='498' 
				then 'Итоговый'
			when ext.[DateTimeBegin] is not null				then 'Начало' 			when ext.[DateTimeEnd] is not null				then 'Окончание'	
			else 'Попутный'
	   end as 'Тип Актэ'
	   	
      ,isnull(akt.ProlongDay,0) as 'Акт'
	  ,case when ps.resultProlong='2' then 'отказ от ИАОФ' else convert(varchar(16),isnull(pln.dayFakt,'0')) end	as 'Факт' 
	  ,CONVERT(varchar(16),akt.[AktDate],120)		as 'Дата акта'
	  ,CONVERT(varchar(16),(isnull(kih.[fact_vyd],isnull(kih.fact_uved,'хуй там'))),120) as 'Раскредитование'
	  ,CONVERT(varchar(16),kih.[lastUpdate],120)	as 'Дата Х'
	  
  FROM [arg].[dbo].[AktOfSend] as aos
  left join xi.[delay].[dbo].[kih_invoice] as kih on kih.[number] = aos.[SendNum]
  left join [arg].[dbo].[AktOf] as akt on akt.[AktOfNum] = aos.[AktOfNum]
  left join [arg].[dbo].[ProlongLink] as pln on pln.[SendNum] = aos.[SendNum] and pln.[AofIdFoll]=aos.[AktOfNum] and pln.[Cancel]=0
  inner join[arg].[dbo].[ProlongSend] ps on ps.uno=pln.uno
  left join [nsi].[dbo].[D_Station] as st on st.[Code] = akt.[Station]
  left join [arg].[dbo].[aof_extension_downtime] as ext on ext.AktOfNum = akt.AktOfNum
  
  
  
  where aos.[SendNum]='ЭЬ741840' and kih.[transferred] is not null and ext.[DateTimeBegin] is null
  
  --order by [AktOfNum] desc
  
  
 
 
Declare @otpr char(8);
		 Set @otpr='ЭЬ253624'

SELECT distinct--top 1
       [sendNum]
      ,pl.[uno]
      ,[AktNum]
      ,[Status]
      ,[AktOfNum]
      ,u.[name] as [User]
      ,st.name as [Station]
	  ,weight
      ,case when [DateTimeSaving]>[AktDate] then [DateTimeSaving] else [AktDate] end as AktRealDate
      ,case when [weight]=0 then [fact_uved] else [fact_vyd] end as dateX
      ,[plan]
      ,[fact] 
      ,[cancel]
      ,[dayAkt]
      ,[dayFakt]
      ,[TimeNorm]
      ,[TimeDelay] 
      ,[ParentUno]
      ,[ParentNumber]
      
  FROM [arg].[dbo].[ProlongLink] pl
  left join [arg].[dbo].[AktOf] aof on aof.aktofnum=pl.aofidfinal
  left join aof_oper.[dbo].[WhoSaved] wh on wh.NumRecord=pl.aofIdfinal
  left join pi.[admin].[dbo].[d_user] u on wh.UserId=u.code  
  left join xi.[delay].[dbo].[kih_invoice] kih on kih.uno=pl.uno and kih.number=pl.sendNum
  left join nsi.dbo.D_Station st on st.Code=u.station
  

  
  where pl.sendNum = @otpr and wh.[TableName] in ('aktof','aof')
    order by AktRealDate 


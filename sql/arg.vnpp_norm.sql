/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [vag].[dbo].[normVNPP]
  where station = '86320'
 -- where carnum = '60218682'
  
  select id, station, carNum, datearrive,normClearOper,normDepOper,normFeedOper,normGruzOper, *
  from vag.dbo.modelArrive m
  --order by id 
  
  where 1=1
--	and station = '86320'
	and dateArrive > '2018-05-01'
	
    and carnum  in (63188361, 54011077,62127212,62125968)
  order by m.id 
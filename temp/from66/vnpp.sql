/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [vag].[dbo].[normVNPP]
  where station = '04850'
 -- where carnum = '60218682'
  
  select id, station, carNum, datearrive,normClearOper,normDepOper,normFeedOper,normGruzOper, *
  from vag.dbo.modelArrive m
  --order by id 
  
  where 1=1
	and station = '04850'
--	and dateArrive > '2018-05-01'
	
    and carnum  in (63811574,61347951,61260303,62355680,54769781,52488962,63506745)
  order by m.id 
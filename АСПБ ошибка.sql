/****** Script for SelectTopNRows command from SSMS  ******/
update[dt].[dbo].[DtOrder]
set acceptedInAsoup=2
where AktNum=1376 and trainNum=1835

SELECT *
  FROM [dt].[dbo].[DtOrder]
  where AktNum=1376 and trainNum=1835
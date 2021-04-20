SELECT do.Rail, COUNT(DISTINCT do.id) as Trains FROM [dt].[dbo].[DtOrder] do
LEFT JOIN [dt].[dbo].[DtUpOrder] duo ON duo.DropOrderId=do.id
WHERE do.copyDs IN (SELECT DISTINCT StationCOde FROM [nsi].[dbo].[D_StationPortLinks]) AND (duo.acceptedInAsoup <> 2 OR duo.acceptedInAsoup IS NULL) AND do.doneInAsoup=1 AND do.AsoupDropDate > '01.01.2016'
GROUP BY do.Rail
ORDER BY do.Rail
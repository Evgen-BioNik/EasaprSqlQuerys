declare @carnum varchar(12) = '52275203';

SELECT *
FROM [analyze].[dbo].[do24ask]
where carNum = @carnum
order by idAsk desc


SELECT *
FROM [analyze].[dbo].[do24ans]
where carNum = @carnum
order by idAsk desc
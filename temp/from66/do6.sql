-- Ебашить на 44
declare @carnum varchar(12) = '52567211 ';

SELECT *
FROM [analyze].[dbo].[do24ask]
where carNum = @carnum
order by idAsk desc


SELECT *
FROM [analyze].[dbo].[do24ans]
where carNum = @carnum
order by idAsk desc
declare @d datetime = '2020-09-16'
declare @aofID int = 201115956

select *
from arg.dbo.AktOfDownTimeCar
where AktOfNum = @aofID

SELECT top 100 *
FROM arg.dbo.logMess AS lm
WHERE lm.typeDoc = 'StayingCar'
	and dateMess between @d-2 and @d+1
	and textMess like '%3673485289%'
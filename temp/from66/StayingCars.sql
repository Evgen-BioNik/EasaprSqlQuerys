select top 100*
from arg.dbo.logMess
where 1=1
	and textMess like '%3720950460%' 
	and typeDoc = 'StayingCar'
	and dateMess between '2020-10-18' and '2020-10-19'
/*
select *
from arg.dbo.AktOfDownTimeCar
where AktOfNum = 202637884

select *
from arg.dbo.AktOfCarriage
where AktOfNum = 202637884
*/
select *
from admin.dbo.D_User
where code = 107358
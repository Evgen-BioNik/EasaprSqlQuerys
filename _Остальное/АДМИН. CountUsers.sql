
 
 Select*from
 (select count(code) 'all'  from [admin].[dbo].[D_User]
where del is null
)t0

cross join(
 select count(code)'ЕАСАПР М' from [admin].[dbo].[D_User]
where del is null and roles like '%B%' or roles like '%H%' or roles like '%J%' or roles like '%C%'
) te

/*
cross join(
 select count(code)'АРЛ' from [admin].[dbo].[D_User]
where del is null and roles like 'B%'--арл
) t1
cross join (
  select count(code)'АСПБ' from [admin].[dbo].[D_User]
where del is null and roles like '%S%' --аспб
)t2

cross join (
  select count(code)'НСД' from [admin].[dbo].[D_User]
where del is null and roles like '%N%' --нсд
)t3
*/
cross join (
  select count(code)'СФТО' from [admin].[dbo].[D_User]
where del is null and roles like '%F%'
) t4
cross join (
  select count(code)'РЖДС' from [admin].[dbo].[D_User]
where del is null and roles like '%K%'
) t5
cross join (
  select count(code)'НТП' from [admin].[dbo].[D_User]
where del is null and roles like '%I%'
) t6
cross join (
  select count(code)'АСКМ' from [admin].[dbo].[D_User]
where del is null and roles like '%G%' or roles like '%D%' or roles like '%R%' or roles like '%V%' or roles like '%X%' or roles like '%Y%'
) t7
cross join (
  select count(code)'ТЕСКАД' from [admin].[dbo].[D_User]
where del is null and roles like '%O%' or roles like '%Z%' or roles like '%W%'
) t9




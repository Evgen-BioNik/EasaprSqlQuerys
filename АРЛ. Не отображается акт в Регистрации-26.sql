	
ЕАСАПР М (АРЛ)ARG-1843
ВП19-02612221

1) справки-20, берем id акта 

2) на 18 (alpha) выполняем :
	select * 
	from [aof_oper].[dbo].[aof_ecp] 
	where id in (185674406)
	отсюда нужен hardopy_uuid
	
3) на 43 (tau) выполняем :
	SELECT *  
	FROM [hardcopy].[dbo].[paper_signs] 
	WHERE paper_uuid='3806DA1D-C83B-493B-952D-7C847058481C'
	смотрим user_code Степановой = 89945
	
4) на 18
	select * 
	from [admin].[dbo].[D_User] 
	where name like '%Степанова_В_В%' or Code=89945
	видим 5 строк, 3 из который удалены	(смотрим колонку del=1), в числе которых учетка с кодом 89945
	
5) на 43
	update hardcopy.dbo.paper_signs 
	set user_code = 88884   --ну коль уж в впшке написали,что с этой учетки не могут увидеть
	where paper_uuid='3806DA1D-C83B-493B-952D-7C847058481C' and id=17069164

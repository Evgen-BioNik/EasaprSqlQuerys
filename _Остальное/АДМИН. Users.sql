SELECT NameShort,RailName,max(login) Login FROM

	(SELECT
		r.[Code] rcode,
		d.Code dcode,
		[NameShort],
		[RailName],
		[Login]
	FROM [nsi].[dbo].[D_Rail] r
	cross join [admin].[dbo].[D_Department] d
	inner join [admin].dbo.[D_User] u on  r.code=u.Rail and d.code=u.Department and u.del is null

 where asoup is not null and RailName is not null and NotRzd=0) t
	 group by NameShort,RailName,rcode,dcode
	 order by rcode
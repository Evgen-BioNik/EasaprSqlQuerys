--Хуярить на 43!
SELECT * FROM [nsi].[dbo].[D_Station]
WHERE [CodeRail] = '01' and [Name] not like '%экс%' and(
      [Name] like 'НазваниеОпорной%' 
   or [Name] like 'соблаго%' 
   or [Name] like 'НазваниеМалодеятельной2%' )

SELECT * FROM [admin].[dbo].[d_user]
 WHERE [Station] in ('КодМалодеятельной1','КодМалодеятельной2')

SELECT StIn.Stationmain StCode, st1.name StName,StIn.Code StCodeIn, st2.Name StNameIn,st2.forAof
FROM [nsi].[dbo].[D_StationInActive] StIn
	left join [nsi].[dbo].[D_Station] st1 on st1.Code=StIn.StationMain
	left join [nsi].[dbo].[D_Station] st2 on st2.Code=StIn.Code
WHERE  StIn.[StationMain]= '06920' 
            or StIn.[Code] in ('06813','КодМалодеятельной2')
order by st2.name


/*
insert into [nsi].[dbo].[D_StationInActive] (Code, Name, StationMain) 
values ('КодМалодейтельной','НазваниеМалодеятельной','КодОпорнойСтанции')   

update [nsi].[dbo].[D_StationInActive] --Поменять Опорную для какой либо Малодеятельной
set [code] = '06810'
where      [Code] = '06813'

*/
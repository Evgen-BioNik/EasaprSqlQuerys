-- Поиск ошибок при сохранении рода вагона
SELECT * FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'eVag' 
ORDER BY lm.dateMess DESC

-- последние значения из таблиц для инсерта
SELECT * FROM [nsi].[dbo].[D_TypeVagEtran] ORDER BY [typeid] DESC
SELECT * FROM nsi.dbo.D_TypeVag AS dtv ORDER BY dtv.Code DESC

-- сравнение таблиц
SELECT dtv.Code AS argCode, dtv.Name AS argName, dtve.name AS etranName,  dtve.typeid AS etranTypeID
FROM nsi.dbo.D_TypeVag AS dtv
INNER JOIN nsi.dbo.D_TypeVagEtran AS dtve ON dtve.argID = dtv.Code
ORDER BY dtve.typeid 

/*
INSERT INTO nsi.dbo.D_TypeVag (Code, NAME)
VALUES ('293', 'служебный рефрежераторный вагон') 

INSERT INTO [nsi].[dbo].[D_TypeVagEtran] ([id],[name],[typeid],[argID])
VALUES (146,'Полувагоны моделей 12-196-01, 12-196-02',265,291)


--ID 265

update [nsi].[dbo].[D_TypeVagEtran]
set argID = 293
where typeid = 170


--Удаляем записи в логе после внесения
delete from arg.dbo.logMess
WHERE typeMess = 'eVag' 
*/


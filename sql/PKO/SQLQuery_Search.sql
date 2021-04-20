/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [AktOfNum]
      ,[Station]
      ,st1.Name as stName
      ,[StationFrom]
      ,st2.Name as stFromName
      ,[StationAmenable]
      ,st3.Name as stAmName
      ,[DateLock]
      ,[isLock]
      ,[CarriageNum]
      ,[CargoCode]
      ,cargo.Name as crgName
      , nom.Code as nomCode
      ,nom.Name as nomName
      ,[distance]
      ,[carTypeFull]
      ,[carRodText]
      ,[carRodID]
  FROM [uhv].[dbo].[tempAof2] as aof
  inner join nsi.dbo.D_Station as st1 on st1.Code = aof.Station 
  inner join nsi.dbo.D_Station as st2 on st2.Code = aof.StationFrom
  inner join nsi.dbo.D_Station as st3 on st3.Code = aof.StationAmenable
  
  inner join nsi.dbo.D_Cargo as cargo on cargo.Code = aof.CargoCode
  inner join nsi.dbo.D_CargoNomenclature as nom on nom.Code = cargo.Nomenclature
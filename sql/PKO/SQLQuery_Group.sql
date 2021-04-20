	SELECT 
			[Station]
		  ,st1.Name as stName
		  ,[StationAmenable]
		  ,st3.Name as stAmName
		  ,[DateLock]
		  ,[isLock]
		  ,[CargoCode]
		  ,cargo.Name as crgName
		  , nom.Code as nomCode
		  ,nom.Name as nomName
		  ,[distance]
		  ,[carRodText]
		  ,[carRodID]
		  , COUNT(*)
	  FROM [uhv].[dbo].[tempAof2] as aof
	  inner join nsi.dbo.D_Station as st1 on st1.Code = aof.Station 
	  inner join nsi.dbo.D_Station as st3 on st3.Code = aof.StationAmenable
	  
	  inner join nsi.dbo.D_Cargo as cargo on cargo.Code = aof.CargoCode
	  inner join nsi.dbo.D_CargoNomenclature as nom on nom.Code = cargo.Nomenclature
	  group by aof.Station, st1.Name, aof.StationAmenable, st3.Name, aof.DateLock, aof.isLock, nom.code, nom.name, aof.[CargoCode], cargo.Name, aof.distance, aof.[carRodText], aof.[carRodID]
	  order by aof.Station
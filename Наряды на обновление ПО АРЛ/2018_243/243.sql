USE [memo]
GO

/****** Object:  View [dbo].[memoDailyList]    Script Date: 19.12.2018 16:50:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[memoDailyList]
as 

SELECT 
	ds.Name AS StationName, ds.Code as StationCode, dr.NameShort AS RailName, dr.Code AS RailCode
	,m.memoNum, m.dateWrite
 ,case m.[memoType] when '1' then 'подача'
					when '2' then 'уборка'
					when '3' then 'подача/уборка'
				end as memoType
	,m.placeFeed
	,mc.carNum,mc.cargoName,mc.feedDate,mc.returnDate,mc.cleanDate,mc.delayTime
	,mc.aktNum, mc.countWeighting, mc.descriptions
	
	
FROM memo.dbo.memo AS m
	INNER JOIN memo.dbo.memo_car AS mc
		ON mc.memoId = m.memoId
	LEFT JOIN nsi.dbo.D_Station AS ds
		ON ds.Code = m.memoStation
	LEFT JOIN nsi.dbo.D_Rail AS dr
		ON dr.code = ds.CodeRail
GO


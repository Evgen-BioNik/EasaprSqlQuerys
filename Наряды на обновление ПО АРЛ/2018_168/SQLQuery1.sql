USE [arg]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Flex_SPFAofList]
AS
SELECT        t.AktOfNum, dr.Code AS RailCode, dr.NameShort AS RailName, dn.Code AS NodCode, dn.Name AS NodName, t.StationCode, ds.Name AS StationName, t.AOF_Site, t.AOF_Num, t.AOF_Date, t.AOF_Status, 
                         t.ReasonCode, ta.fullname AS ReasonName, t.LocNum, t.CarNum, t.SendNum, t.uno, t.StationFromCode, dsfrom.Name AS StationFromName, t.StationToCode, dsto.Name AS StationToName, t.Downtime, 
                         t.isDT
FROM            (SELECT        aof.AktOfNum, aof.Station AS StationCode, aof.Site AS AOF_Site, aof.AktNum AS AOF_Num, aof.AktDate AS AOF_Date, aof.Status AS AOF_Status, aof.TypeAdd AS ReasonCode, 
                                                    car.CarriageNum AS LocNum, NULL AS CarNum, aos.SendNum, aos.uno, aof.StationFrom AS StationFromCode, aof.StationTo AS StationToCode, 0 AS Downtime, 0 AS isDT
                          FROM            dbo.AktOf AS aof WITH (NOLOCK) INNER JOIN
                                                    dbo.AktOfCarriage AS car WITH (NOLOCK) ON car.AktOfNum = aof.AktOfNum LEFT OUTER JOIN
                                                    dbo.AktOfSend AS aos ON aos.AktOfNum = aof.AktOfNum AND aos.idCar = car.AktOfCarriageNum
                          WHERE        (aof.TypeAdd IN (1259, 1263, 1264, 1266, 1267, 1269, 1270))
                          UNION
                          SELECT        aof.AktOfNum, aof.Station AS StationCode, aof.Site AS AOF_Site, aof.AktNum AS AOF_Num, aof.AktDate AS AOF_Date, aof.Status AS AOF_Status, aof.TypeAdd AS ReasonCode, 
                                                   CASE WHEN aof.TypeAdd IN (1260, 1261, 1262) THEN car.CarriageNum END AS LocNum, CASE WHEN aof.TypeAdd IN (1272, 1273) THEN car.CarriageNum END AS CarNum, aos.SendNum, aos.uno, 
                                                   dt.StationFrom AS StationFromCode, dt.StationTo AS StationToCode, DATEDIFF(hh, aB.AktDate, aof.AktDate) AS Downtime, 1 AS isDT
                          FROM            dbo.AktOf AS aof WITH (NOLOCK) INNER JOIN
                                                   dbo.AktOfDownTimeCar AS dt WITH (NOLOCK) ON dt.AktOfNumEnd = aof.AktOfNum INNER JOIN
                                                   dbo.AktOfCarriage AS car WITH (NOLOCK) ON car.AktOfCarriageNum = dt.AktOfCarriageNumEnd AND car.AktOfNum = aof.AktOfNum LEFT OUTER JOIN
                                                   dbo.AktOfSend AS aos ON aos.AktOfNum = aof.AktOfNum AND aos.idCar = car.AktOfCarriageNum INNER JOIN
                                                   dbo.AktOf AS aB WITH (NOLOCK) ON dt.AktOfNum = aB.AktOfNum
                          WHERE        (aof.TypeAdd IN (1260, 1261, 1262, 1272, 1273)) AND (aof.dt = 1) AND (dt.AktOfNumEnd IS NOT NULL)) AS t LEFT OUTER JOIN
                         nsi.dbo.D_Station AS ds ON ds.Code = t.StationCode LEFT OUTER JOIN
                         nsi.dbo.D_Rail AS dr ON dr.Code = ds.CodeRail LEFT OUTER JOIN
                         nsi.dbo.D_NOD AS dn ON dn.Code = ds.CodeRail + ds.CodeNOD LEFT OUTER JOIN
                         nsi.dbo.D_Station AS dsfrom ON dsfrom.Code = t.StationFromCode LEFT OUTER JOIN
                         nsi.dbo.D_Station AS dsto ON dsto.Code = t.StationToCode LEFT OUTER JOIN
                         nsi.dbo.T_aofType AS ta ON ta.id = t.ReasonCode

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ds"
            Begin Extent = 
               Top = 138
               Left = 252
               Bottom = 268
               Right = 435
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dr"
            Begin Extent = 
               Top = 138
               Left = 473
               Bottom = 268
               Right = 647
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dn"
            Begin Extent = 
               Top = 138
               Left = 685
               Bottom = 268
               Right = 859
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dsfrom"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dsto"
            Begin Extent = 
               Top = 270
               Left = 259
               Bottom = 400
               Right = 442
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ta"
            Begin Extent = 
               Top = 270
               Left = 480
               Bottom = 400
               Right = 662
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Flex_SPFAofList'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 23
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Flex_SPFAofList'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Flex_SPFAofList'
GO



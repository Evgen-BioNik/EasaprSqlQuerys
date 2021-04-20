USE [nsi]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[D_TypeVagCost](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[VagGroup] [int] NULL,
	[CostPerVag] [int] NULL,
	[DateBegin] [datetime] NULL,
	[DateEnd] [datetime] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[D_TypeVagCost] ADD  CONSTRAINT [DF_D_TypeVagCost_DateBegin]  DEFAULT (getdate()) FOR [DateBegin]
GO

USE [nsi]
GO

CREATE CLUSTERED INDEX [ix_cluster] ON [dbo].[D_TypeVagCost]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


  INSERT INTO [nsi].[dbo].[D_TypeVagCost] (
      [VagGroup]
      ,[CostPerVag])
  VALUES (-1,1180), (2,750), (3,850), (4,900)
  
  
 ALTER TABLE vag.dbo.modelArrive ADD dateMess410 datetime
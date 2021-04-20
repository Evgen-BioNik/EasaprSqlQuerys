USE [vag]
GO

/****** Object:  Table [dbo].[carOverLoad]    Script Date: 01.11.2018 11:21:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[carOverLoad](
	[carID] [int] IDENTITY(1,1) NOT NULL,
	[carNum] [varchar](12) NULL,
	[carWeightLim] [int] NULL,
	[carStatus] [tinyint] NULL,
	[carOverLoad] [int] NULL,
	[SendNum] [char](8) NULL,
	[uno] [int] NULL,
	[dateWrite] [datetime] NULL,
	[wID] [int] NULL,
	[wStation] [char](5) NULL,
	[wDate] [datetime] NULL,
	[wTara] [int] NULL,
	[wBrutto] [int] NULL,
	[wNetto] [int] NULL,
	[uhvAofID] [int] NULL,
	[dateNotif_1] [datetime] NULL,
	[statusNotif_1] [tinyint] NULL,
	[mwID] [int] NULL,
	[mwDate] [datetime] NULL,
	[mwNum] [int] NULL,
	[mwMetod] [smallint] NULL,
	[mwTara] [int] NULL,
	[mwBrutto] [int] NULL,
	[mwNetto] [int] NULL,
	[dozAofID] [int] NULL,
	[dateNotif_2] [datetime] NULL,
	[statusNotif_2] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[carID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[carOverLoad] ADD  CONSTRAINT [DF_carOverLoad_carStatus]  DEFAULT ((0)) FOR [carStatus]
GO

ALTER TABLE [dbo].[carOverLoad] ADD  CONSTRAINT [DF_carOverLoad_dateWrite]  DEFAULT (getdate()) FOR [dateWrite]
GO

ALTER TABLE [dbo].[carOverLoad] ADD  CONSTRAINT [DF_carOverLoad_statusSend_1]  DEFAULT ((0)) FOR [statusNotif_1]
GO

ALTER TABLE [dbo].[carOverLoad] ADD  CONSTRAINT [DF_carOverLoad_statusSend_2]  DEFAULT ((0)) FOR [statusNotif_2]
GO



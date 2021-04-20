USE [aof_arg]
GO
/****** Object:  Table [dbo].[incident_carriage]    Script Date: 20.08.2018 11:09:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[incident_carriage](
	[IncCarID] [int] IDENTITY(1,1) NOT NULL,
	[IncID] [int] NOT NULL,
	[CarNum] [char](8) NULL,
	[ContNum] [varchar](15) NULL,
	[aofID] [int] NULL,
	[IncDescription] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [ix_carID]    Script Date: 20.08.2018 11:09:08 ******/
CREATE CLUSTERED INDEX [ix_carID] ON [dbo].[incident_carriage]
(
	[IncCarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ix_incID]    Script Date: 20.08.2018 11:09:08 ******/
CREATE NONCLUSTERED INDEX [ix_incID] ON [dbo].[incident_carriage]
(
	[IncID] ASC
)
INCLUDE ( 	[CarNum],
	[aofID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

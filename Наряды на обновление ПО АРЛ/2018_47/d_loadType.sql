USE [nsi]
GO
/****** Object:  Table [dbo].[D_LoadType]    Script Date: 04.04.2018 18:02:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[D_LoadType](
	[TRANS_ID] [int] NULL,
	[NAME] [varchar](max) NULL,
	[PARAMID] [int] NULL,
	[ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [ix_cluster]    Script Date: 04.04.2018 18:02:38 ******/
CREATE CLUSTERED INDEX [ix_cluster] ON [dbo].[D_LoadType]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526258, N'СОБСТВЕННАЯ ПОГРУЗКА, ВЫГРУЗКА СТАНЦИИ', 122, 1)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526259, N'ПРИЕМ, СДАЧА С АВТОМОБИЛЬНОГО ТРАНСПОРТА', 122, 2)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526260, N'ПРИЕМ, СДАЧА, ПЕРЕГРУЗКА С ИНОСТРАННЫХ ДОРОГ', 122, 3)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526261, N'ПЕРЕГРУЗКА С УЗКОЙ КОЛЕИ И ЗАПАДНО-ЕВРОПЕЙСКОЙ КОЛЕИ НА ШИРОКУЮ', 122, 4)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526262, N'ПЕРЕГРУЗКА С ШИРОКОЙ КОЛЕИ НА УЗКУЮ И ЗАПАДНО-ЕВРОПЕЙСКУЮ КОЛЕЮ', 122, 5)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526263, N'ПРИЕМ, СДАЧА С ВОДНОГО ТРАНСПОРТА', 122, 6)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526264, N'ПРИЕМ ГРУЗОВ,ПЕРЕВЕЗЕННЫХ ПО ВОДНОМУ ПУТИ ТРАНЗИТОМ', 122, 7)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526265, N'ПРИЕМ, СДАЧА С НОВОСТРОЕК', 122, 8)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526266, N'ПОГРУЗКА В ВАГОНЫ НЕРАБОЧЕГО ПАРКА', 122, 9)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526267, N'ПЕРЕАДРЕСОВКА', 122, 10)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526268, N'БЕЗ ЗАЧЕТА В ПОГРУЗКУ', 122, 11)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526269, N'МИНУГЛЕПРОМ', 122, 12)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526270, N'РОСЛЕС', 122, 13)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526271, N'ЛЕС ПО ПЛАНУ МВД', 122, 14)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2526272, N'ПЕРЕГРУЗКА В АДРЕС Ж.Д. КЛИЕНТОВ', 122, 15)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (2606637, N'ПРИЕМ С ИНОСТРАННЫХ Ж.Д. (БЕЗ ПЕРЕГРУЗКИ)', 122, 16)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (13209704, N'ВОЗВРАТ ПОРОЖНИХ ВАГОНОВ ИЗ-ПОД ЭКСПОРТНОГО ГРУЗА ИЗ ПОРТОВ', 122, 17)
GO
INSERT [dbo].[D_LoadType] ([TRANS_ID], [NAME], [PARAMID], [ID]) VALUES (13209705, N'ВНУТРИХОЗЯЙСТВЕННАЯ ПЕРЕВОЗКА В ВАГОНАХ ОПЕРАТОРА', 122, 20)
GO

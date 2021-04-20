USE nsi
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[D_MetodEtranWeigh](
	[Code] [int] NULL,
	[Name] [varchar](50) NULL,
	[actual] [bit] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[D_MetodEtranWeigh] ADD  CONSTRAINT [DF_D_MetodEtranWeigh_actual]  DEFAULT ((1)) FOR [actual]
GO


INSERT INTO nsi.dbo.d_metodetranweigh (code,name)
VALUES ('01','На вагонных весах (50 кг)'),
('02','По стандарту'),
('03','По трафарету'),
('04','По замеру'),
('05','Расчетным путем'),
('06','Условно'),
('07','Стандартная масса одного места'),
('08','На товарных весах'),
('09','На вагонных весах (100 кг)'),
('10','На элеваторных весах'),
('11','Дозатор'),
('12','Вагонные в два деления'),
('13','Автомобильные весы')
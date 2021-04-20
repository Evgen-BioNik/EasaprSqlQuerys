/*

	 Изменить статус акта
	UPDATE [aof_oper].[dbo].[aof] SET [status]=0 WHERE aktofnum='89894119'


	 Разорвать связь актов по вагонам. Если storage = arg, то сперва акт нужно перенести в oper, например, с помощью пушиста
	 Для обычных актов на простой
	UPDATE [aof_oper].[dbo].[aof_carriage_downtime_link] SET aktofnumend=NULL, aktofcarriagenumend=NULL, dateforcibly=NULL
	WHERE aktofnum IN (89894119) AND aktofnumend=-1

	 Для актов на техническую неисправность. Причина 1130/203
	UPDATE [aof_oper].[dbo].[aof_carriage_downtime_link_tech] SET aktofnumend=NULL, aktofcarriagenumend=NULL, dateforcibly=NULL
	WHERE aktofnum IN (89894119) AND aktofnumend=-1

*/


DECLARE @AktOfNum INT = 176152801

-- Данные о связях вагонов
SELECT car.CarriageNum,
	link.AktOfNum, link.AktOfCarriageNum,
	link.AktOfNumEnd, link.AktOfCarriageNumEnd,
	link.DateForcibly, link.storage
FROM arg.dbo.AktOfDownTimeCarAll AS link WITH(NOLOCK)
	LEFT JOIN arg.dbo.AktOfCarriageAll AS car WITH(NOLOCK)
		ON car.AktOfCarriageNum = link.AktOfCarriageNum AND car.AktOfNum = link.AktOfNum
WHERE link.AktOfNum = @AktOfNum OR link.AktOfNumEnd = @AktOfNum

-- Данные о самом акте
SELECT * FROM arg.dbo.AktOfAll WITH(NOLOCK) WHERE [AktOfNum]= @AktOfNum


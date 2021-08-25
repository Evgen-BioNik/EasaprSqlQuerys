 --Ебашить на 10.246.101.18
DECLARE @SendNum CHAR(8) = 'ЭА781096';
  /*
    DELETE [arg].[dbo].[ProlongLink] WHERE [key] = 52247
    DELETE [arg].[dbo].[ProlongSend] WHERE [key] IN (203, 4199375)

    DELETE prolong.dbo.ProlongDtContracts     WHERE prolongID = 23993026
    DELETE prolong.dbo.ProlongWarrantyLetters WHERE prolongID = 23993026
    DELETE prolong.dbo.ProlongPayerContracts  WHERE prolongID = 23993026

    UPDATE [arg].[dbo].[ProlongLink] SET aofidfinal = NULL WHERE sendNum = 'ЭЫ522828'
    UPDATE [arg].[dbo].[ProlongSend] SET [resultProlong] = 1 WHERE [key] = 23869089
    UPDATE [arg].[dbo].[ProlongSend] SET [sendStatus] = 2 WHERE [key] = 3942203
    UPDATE [aof_oper].[dbo].[aof] SET [status] = 0 WHERE aktofnum='96853074'

    220369413
  */

SELECT * FROM [arg].[dbo].[ProlongLink] WHERE sendNum=@SendNum AND uno IS NOT NULL

SELECT  [key], SendNum,
    CASE WHEN parentuno IS NULL THEN 'Основная' ELSE 'Досылка' END AS WTF,
    invID, uno, parentuno, stationFrom, st1.name 'Откуда', stationTo, st2.name 'Куда',
    stationReg + ' ('+RTRIM(st3.Name)+')' AS 'Где зарегали', dateReg, dateArrive, resultProlong, resultText,
    CASE WHEN sendStatus = 2 THEN 'Потрачена' ELSE 'Активна' END AS 'Статус'
FROM (
  SELECT * FROM [arg].[dbo].[ProlongSend] WHERE sendNum = @SendNum
    UNION
  SELECT * FROM [arg].[dbo].[ProlongSend] WHERE uno   IN (SELECT parentuno FROM [arg].[dbo].[ProlongSend] WHERE sendNum = @SendNum)
    UNION
  SELECT * FROM [arg].[dbo].[ProlongSend] WHERE invId IN (SELECT parentuno FROM [arg].[dbo].[ProlongSend] WHERE sendNum = @SendNum)
) AS s
  LEFT JOIN nsi.dbo.d_station st1 ON st1.code = s.stationFrom 
  LEFT JOIN nsi.dbo.d_station st2 ON st2.code = s.stationTo 
  LEFT JOIN nsi.dbo.d_station st3 ON st3.code = s.stationReg 
ORDER BY parentuno

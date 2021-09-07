 --Ебашить на 10.246.101.17
DECLARE @invID INT = 1165287843;

SELECT * FROM alpha.arg.dbo.prolongsend WHERE invid = @invID



SELECT wl.id, wl.LetterDate, wl.LetterNumber, wl.Company, wl.DateFrom, wl.DateTo, wl.Cancelled
  ,wls.VagNum, wls.SendNum, wls.uno, wls.stationFrom, wls.stationTo
FROM [delay].dbo.WarrantyLetter AS wl
  INNER JOIN [delay].dbo.WarrantyLetterSends AS wls ON wls.letterid = wl.id
  INNER JOIN [alpha].arg.dbo.prolongSend as ps
    ON ps.invID = wls.uno
      AND wl.LetterDate < ps.dateArrive
      AND wls.stationFrom = ps.stationFrom
      AND wls.stationTo = ps.stationTo

WHERE (wl.Cancelled IS NULL OR wl.Cancelled = 0) AND wls.uno = @invID
ORDER BY wl.id DESC


SELECT wl.id, wl.LetterDate, wl.LetterNumber, wl.Company, wl.DateFrom, wl.DateTo, wl.Cancelled
  ,wls.VagNum, wls.SendNum, wls.uno, wls.stationFrom, wls.stationTo
FROM [delay].dbo.WarrantyLetter AS wl
  INNER JOIN [delay].dbo.WarrantyLetterSends AS wls ON wls.letterid = wl.id
WHERE  wls.sendnum = 'ЭА781096'

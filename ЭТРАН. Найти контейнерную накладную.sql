SELECT TOP 10 *
FROM arg.dbo.ProlongSend_cont AS psc
  LEFT JOIN arg.dbo.ProlongSend_car AS psc2
    ON psc2.uno = psc.uno
WHERE psc2.carNum IS NULL 
ORDER BY psc.uno desc

SELECT trd.name,dd.Name
  FROM nsi.dbo.T_ReasonDelay trd
  INNER JOIN nsi.dbo.D_Department AS dd ON dd.Code=trd.Department2
    WHERE trd.department IS null

ORDER BY dd.Name
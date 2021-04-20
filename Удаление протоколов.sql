SELECT *
  FROM [delay].[dbo].[InvestDelayProtocol]
  where number='НомерПротокола'
SELECT *
  FROM [delay].[dbo].[InvestDelayRail]
  where protocol='ID'
  
/*проверка на наличие в протоколе отправок
  delete FROM [delay].[dbo].[InvestDelayProtocol]  where id='ID'
  */
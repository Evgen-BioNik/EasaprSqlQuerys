
/* Выполнять на .127
   Заносим в ClaimNum номер заявки которую надо отправить.
   Выполняем запрос, получем ссылку. Запускаем ссылку в браузере, аля оп результат согласования заявки отпрвилися в Этран.
*/


--если есть [AgreedDate]

SELECT 'http://easapr.gvc.oao.rzd/dt/etran/etran_out.php?Type=accept_with_station&MessageType=18&ClaimID='+CONVERT(varchar,ClaimID)+'&ParentID=&DropStationCode='+AgreedStation FROM [dt].[dbo].[Claim2] 
WHERE ClaimNum IN (
'23285','23330'
)


--если нет[AgreedDate]

SELECT 'http://easapr.gvc.oao.rzd/dt/etran/etran_out.php?Type=accept_with_station&MessageType=18&ClaimID='+CONVERT(varchar,ClaimID)+'&ParentID=&DropStationCode=' FROM [dt].[dbo].[Claim2] 
WHERE ClaimNum IN (
'28660'
)
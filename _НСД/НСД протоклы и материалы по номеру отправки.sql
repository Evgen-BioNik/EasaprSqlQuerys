DECLARE @le_number CHAR(8)='ЭУ005608', @stage VARCHAR(10);

IF EXISTS (SELECT * FROM delaypaid.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delaypaid
else IF EXISTS (SELECT * FROM delayisk.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delayisk
else IF EXISTS (SELECT * FROM delaypret.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delaypret
else IF EXISTS (SELECT * FROM delay.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delay



	USE delaypaid
--	USE delayisk
--	USE delaypret
--	USE delay


SELECT wm.id,wmids.[service] AS 'ids.id',ids.DateAdded'добавление в ids',ids.ParentId'пред. ids.id',wm.number AS '№ материала',wm.[date] AS 'дата материала',
case when wm.Closed='1' THEN 'закрыт' ELSE 'ОТКРЫТ'end AS 'материал',wm.CloseDate AS 'дата закрытия материала',
case when wmids.NotReviewed ='1' THEN 'не рассмотрена' ELSE 'рассмотрена'end AS 'в материале',
case ids.[Status] 
		WHEN 0 THEN 'отклонено'
		WHEN 3 THEN 'признано РГ'
		when 4 THEN 'отпр. на РГ'
	ELSE 'хз'
END AS 'статус',

idp.number AS '№протокола', idp.closed ,idp.CloseDate AS 'дата закрытия протокола',
CASE wm.stage
 WHEN 'delay' THEN 'Допретензионный' 
 WHEN 'delaypret' THEN 'Претензионный'  
 WHEN 'delayisk' THEN 'Исковой'   
 WHEN 'delaypaid' THEN 'Исковой(выплаты)' ELSE idp.stage end 

AS'этап протокола'

 FROM DelaySend AS ds
INNER JOIN investdelayservice ids ON ds.sendid=ids.sendid
left JOIN delaycommon.dbo.WgMaterial_InvestDelayService AS wmids ON wmids.[service]=ids.id --AND wmids.Protocol IS NOT null
left JOIN delaycommon.dbo.WgMaterial AS wm ON wm.id=wmids.wgmaterial AND wm.stage=db_name()
left JOIN delaycommon.dbo.InvestDelayProtocol AS idp ON idp.id=wm.protocolid
WHERE ds.SendNum  =@le_number

ORDER BY wmids.[service], wm.[date]

SELECT * FROM delaypaid.dbo.InvestDelayService AS ids WHERE ids.id='1286591' OR ids.parentid='1399873'
OR sendid='408194'

SELECT * FROM delaycommon.dbo.WgMaterial_InvestDelayService AS wmids WHERE wmids.sendid='445870'
SELECT TOP 100* FROM delaycommon.dbo.InvestDelayProtocol AS idp
/*
 SELECT * FROM 	delaycommon.dbo.WgMaterial_InvestDelayService where wgmaterial='1359'
 SELECT count(*) FROM 	delaycommon.dbo.WgMaterial_InvestDelayService where wgmaterial='1359'
 and notreviewed='1'
 */
 
 /*
 use delay
 SELECT * FROM delaysend WHERE SendNum='ЭЕ504577'
 SELECT * FROM InvestDelayService AS ids WHERE Sendid='4103369'
 SELECT * FROM delaycommon.dbo.WgMaterial_InvestDelayService AS wmids WHERE wmids.[service] IN (9350452
,9577426)


SELECT*FROM delaycommon.dbo.WgMaterial AS wm WHERE number ='М-НЗ1-СЕВ-15/2016'

SELECT*FROM delaycommon.dbo.InvestDelayProtocol AS idp WHERE  number ='Д-СЕВ-1/2016'
*/




--SELECT*FROM delaycommon.dbo.WgMaterial AS wm WHERE number ='М-НЗ1-КБШ-11/2016'
--SELECT * FROM delaycommon.dbo.WgMaterial_InvestDelayService AS wmids WHERE wmids.wgmaterial='1455'
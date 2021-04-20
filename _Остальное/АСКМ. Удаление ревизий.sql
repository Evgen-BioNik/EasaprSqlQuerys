--≈башить на 10.246.101.43
SELECT c.*,du.[Login] FROM [sv].[dbo].[Check] AS c
	INNER JOIN admin.dbo.D_User AS du ON c.UserCode = du.Code
WHERE c.Rail='80' 
	and DateCheckBegin='2016-02-24' and DateCheckEnd='2016-02-24'
		
SELECT cd.*, count(DISTINCT a.Code) ans, count(DISTINCT act.Id) act
FROM sv.dbo.Check_Division AS cd
	LEFT JOIN sv.dbo.Answer AS a ON a.DivNum = cd.DivNum AND a.CheckNum = cd.CheckNum
	LEFT JOIN sv.dbo.[Action] AS act ON act.CheckNum = a.CheckNum AND act.DivNum = a.DivNum
WHERE cd.CheckNum='99598'
GROUP BY cd.DivNum,cd.CheckNum, cd.Division, cd.NameDivision

/*


не удал€ем € простомен€ем дату на 90 год
update [sv].[dbo].[Check] set DateCheckBegin = '2090-02-01',  DateCheckEnd = '2090-02-13' where cheknum = '99598'




delete [sv].[dbo].[Check] where checknum='52773'

delete [sv].[dbo].[action] where DivNum='47440'
delete [sv].[dbo].[Answer] where DivNum='47440'
delete [sv].[dbo].[Check_Division] where DivNum='47440'
 */
----------------------------------------------------------------------
---- Информация о всех пришедших нам ВУ-23М и ВУ-36М, имевшим etdID
---- docId = etdID
SELECT top 100 * FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'vu23ins' --AND lm.docId='97306303'
ORDER BY id DESC

SELECT top 100 * FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'vu36ins' 
ORDER BY lm.docId DESC

--DELETE arg.dbo.logMess WHERE docId=97306303 AND typeMess='vu23ins' OR id = 12078264
----------------------------------------------------------------------
---- Информация об ошибках сохранения ВУ-23М и ВУ-36М
---- docId = etdID
SELECT top 100 * FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'vu23err' 
--	AND lm.textMess LIKE '%59550657%'
ORDER BY id DESC


SELECT top 1000 * FROM arg.dbo.logMess AS lm
WHERE lm.typeMess = 'vu36err'
ORDER BY id DESC


SELECT * FROM arg.dbo.logMess AS lm
WHERE lm.typeMess IN ( 'linkAOF','linkErr')
--AND lm.docId = 96968971
ORDER BY id DESC


--DELETE arg.dbo.logMess WHERE scriptName='ManualVu36.php' AND typeMess='linkAOF'




SELECT  ins.typeMess, count(ins.docId) [count]
FROM arg.dbo.logMess AS ins
WHERE ins.typeMess LIKE 'vu%'
	AND ins.dateMess > DATEADD(DAY,-1,GETDATE())
GROUP BY ins.typeMess

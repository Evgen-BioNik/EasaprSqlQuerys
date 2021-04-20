SELECT TOP 1000 * FROM arg.dbo.logMess AS lm
WHERE lm.typeMess='notice' AND lm.typedoc='all_notice'
	AND lm.dateMess BETWEEN '2016-09-29' AND '2016-10-11'
	AND lm.textMess LIKE '%putReqNotice%<noticeId>1000061868%'
ORDER BY id DESC
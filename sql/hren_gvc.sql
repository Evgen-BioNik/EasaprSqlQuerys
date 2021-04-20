DECLARE @currDate DATE, @date INT;
SELECT @currDate = GETDATE(), @date = CAST(CAST(DATEPART(YEAR, @currDate)*10000 + DATEPART(MONTH, @currDate)*100 + DATEPART(DAY, @currDate)-1 AS VARCHAR(255)) AS INT);

SELECT TOP 1 run_status
FROM msdb.dbo.sysjobhistory AS sjh WITH(NOLOCK)
	INNER JOIN msdb.dbo.sysjobs AS sj WITH(NOLOCK)
		ON sj.job_id = sjh.job_id
WHERE sj.name = 'que_cleanup' AND sjh.run_date > @date
ORDER BY sjh.instance_id desc 

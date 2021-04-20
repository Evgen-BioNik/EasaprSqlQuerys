DECLARE @tab TABLE (uuid UNIQUEIDENTIFIER, aofId INT);
DECLARE @fixAof TABLE (aofId INT);

DECLARE @d1 DATETIME, @d2 DATETIME, @st CHAR(5);

SELECT @d1 = GETDATE()-100, @d2 = GETDATE(), @st = '21190';


/************************************/
/************************************/

	DECLARE @UPDATED BIT = 0;

/************************************/
/************************************/

INSERT INTO @tab
SELECT ep.hardcopy_uuid, ao.AktOfNum
FROM aof_oper.dbo.aof_ecp AS ep WITH (NOLOCK)
	INNER JOIN arg.dbo.AktOf AS ao WITH (NOLOCK)
		ON ao.AktOfNum = ep.id
	

WHERE ao.AktDate BETWEEN @d1 AND @d2 AND ep.status_ep = 2 AND ao.[status] < 2
	AND ao.Station = @st

SELECT ps.paper_uuid, tab.aofId,
		COUNT(*) AS countSigh,
		SUM( CASE WHEN ps.[status] = 4 THEN 1 ELSE 0 END ) AS countSigned 
	FROM tau.hardcopy.dbo.paper_signs AS ps with(nolock)
		INNER JOIN @tab AS tab 
			ON tab.uuid = ps.paper_uuid
	
	
	WHERE ps.paper_uuid in (select uuid from @tab)
	GROUP BY ps.paper_uuid, tab.aofId
	HAVING COUNT(*) = SUM( CASE WHEN ps.[status] = 4 THEN 1 ELSE 0 END )
	
IF (@UPDATED = 1 AND @@ROWCOUNT > 0)
BEGIN

	INSERT INTO @fixAof SELECT aofId
	FROM (
		SELECT ps.paper_uuid, tab.aofId,
			COUNT(*) AS countSigh,
			SUM( CASE WHEN ps.[status] = 4 THEN 1 ELSE 0 END ) AS countSigned 
		FROM tau.hardcopy.dbo.paper_signs AS ps with(nolock)
			INNER JOIN @tab AS tab 
				ON tab.uuid = ps.paper_uuid
	
	
		WHERE ps.paper_uuid in (select uuid from @tab)
		GROUP BY ps.paper_uuid, tab.aofId
		HAVING COUNT(*) = SUM( CASE WHEN ps.[status] = 4 THEN 1 ELSE 0 END )
	) AS ep


	UPDATE aof_oper.dbo.aof_ecp
	SET status_ep = 4
		OUTPUT INSERTED.id, 'aof','db', GETDATE(), 'arg','aof','Status_ep changed to 4 by Support'
		INTO arg.dbo.logMess (docId, typeMess,scriptName,dateMess,[system],typeDoc, textMess)
	WHERE id IN (SELECT aofId FROM @fixAof)

END 

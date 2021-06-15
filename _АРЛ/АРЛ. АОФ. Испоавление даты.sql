/*
	SELECT * from interface_buff.dbo.que_Messages qm
		INNER join interface_buff.dbo.que_Messages_aof qn
			ON qm.id = qn.messID
	WHERE docID = 7166


	DECLARE @buffRowID int = 123;

	UPDATE interface_buff.dbo.que_Messages
	SET docDate = @dateOld
	WHERE id = @buffRowID
*/


DECLARE @aofId INT  = 191556015,
	@dateOld DATETIME = '2020-02-23 12:50:00.000',
	@IKnowWhatIDo BIT = 0



IF @IKnowWhatIDo = 1 BEGIN
	UPDATE TOP(1) aof_oper.dbo.WhoSaved
	SET DateTimeSaving = @dateOld
	WHERE NumRecord = @aofId AND TableName = 'aktof'

	UPDATE aof_oper.dbo.aof SET AktDate = @dateOld WHERE AktOfNum = @aofId
END


SELECT * FROM aof_oper.dbo.aof 
WHERE AktOfNum = @aofId
SELECT * FROM aof_oper.dbo.WhoSaved 
WHERE NumRecord = @aofId AND TableName = 'aktof'

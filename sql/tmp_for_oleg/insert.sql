DECLARE @d DATETIME = GETDATE();

INSERT INTO interface_buff.dbo.Quality_aof
(
  AktOfNum,
  AktDate,
  Station,
  [Status],
  TypeAdd,
  ReasonDelay,
  CreateBy,
  CreateDate
)
SELECT ao.AktOfNum,ao.AktDate,ao.Station,ao.[Status], ao.TypeAdd, ao.ReasonDelay, ws.UserId, ws.DateTimeSaving
FROM arg.dbo.AktOf AS ao
	INNER JOIN arg.dbo.AktOfWhoSaved AS ws WITH (NOLOCK)
		ON TableName = 'AktOf' AND ws.NumRecord = ao.AktOfNum AND ws.WhoSavedNum = (
			SELECT TOP 1 WhoSavedNum
			FROM arg.dbo.AktOfWhoSaved WITH (NOLOCK)
			WHERE TableName = 'AktOf' AND NumRecord = ao.AktOfNum
			ORDER BY WhoSavedNum 
		)
WHERE ao.AktDate BETWEEN @d-15 AND @d
  AND ao.[Status] < 4
  AND (
     ao.TypeAdd IN (584, 1019, 1178, 1188, 1189, 1190)
     OR ao.TypeAdd BETWEEN 1212 AND 1221 
     OR ao.TypeAdd BETWEEN 1223 AND 1229
     OR (ao.TypeAdd = 1131 AND ao.ReasonDelay IN (215,324))
  )
  AND AktOfNum NOT IN ( SELECT AktOfNum FROM interface_buff.dbo.Quality_aof )
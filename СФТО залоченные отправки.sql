--≈башить на 10.246.101.127
DECLARE @SendNum varchar(8) = 'Ё“425701';
DECLARE @FolderNum int;

SELECT @FolderNum = FolderNum FROM [cfto].[dbo].[Send] WHERE [Send] = @SendNum
SELECT [DateAdded], [Locked] FROM [cfto].[dbo].[PACKAGE] WHERE [FolderNum] = @FolderNum
SELECT [ids].[StatusDate], [ids].[Status]
FROM [delta].[delaypret].[dbo].[DelaySend] [ds]
left join [delta].[delaypret].[dbo].[InvestDelayService] [ids] on [ids].[SendId] = [ds].[SendId]
WHERE [ds].[FolderNum] = @FolderNum
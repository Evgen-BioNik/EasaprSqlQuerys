declare @orderid int = 426627;

SELECT TOP 100 *
FROM pi.dt.dbo.EASAPRMessages AS em where documentid = @orderid


SELECT TOP 1000 *
 FROM [interface_buff].[dbo].[que_list]
 where [gueueID] in ('DropOrder', 'UpOrder')
  and messageId = @orderid
 order by id desc
  
  
SELECT * FROM interface_buff.dbo.que_Messages AS qm
	LEFT JOIN interface_buff.dbo.que_Messages_aof AS qma
		ON qm.id = qma.messID
WHERE qm.docID = @orderid
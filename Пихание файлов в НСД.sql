--http://easapr.gvc.oao.rzd/delivery/debug/attach_file_to_comment.php
SELECT sendnum,dsc.* FROM DELAY.dbo.DelaySend AS ds 
INNER JOIN DELAY.dbo.DelaySendComments AS dsc ON dsc.SendId = ds.SendId
WHERE ds.SendNum='ще408285'
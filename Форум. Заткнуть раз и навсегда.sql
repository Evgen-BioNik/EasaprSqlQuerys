DECLARE @text varchar(255) = 'Здравствуйте. В связи с переходом на авторскую поддержку проектов ЕАСАПР на ЕСПП (Единую службу поддержки пользователей) просим все обращения формировать через неё. В обращении указывайте систему, в которой работаете, и логин для доступа в нее.'


UPDATE TOP (1000) admin.dbo.forum
SET MsgSolvingStatus = 1
	OUTPUT INSERTED.MsgNumRec, 2467, GETDATE(), 1, 1, @text
	INTO admin.dbo.forum (ParentId, MsgAuthor, MsgDate, Subsystem, MsgSolvingStatus, MsgText )
where Subsystem = 1 
	and MsgSolvingStatus is null
	and MsgDate > '2020'
	and ParentId = 0
	and MsgStatus is null


--Добавляем колонки увеличенного размера с именем с приставкой "2"
USE prolong 
ALTER TABLE dbo.DropProlong ADD Sender2 varchar(255), receiver2 varchar(255)
ALTER TABLE dbo.DropProlong_spoiled ADD Sender2 varchar(255), receiver2 varchar(255)

-- Обновляем вьюху (тут было нужно)
USE prolong 
EXECUTE sp_refreshview N'dbo.DropProlongAll'; 

-- Переносим значения
UPDATE dbo.DropProlong SET Sender2 = sender, receiver2 = receiver
UPDATE dbo.DropProlong_spoiled SET Sender2 = sender, receiver2 = receiver

-- Переименовываем "старую" колонку в 3ю
-- Переименовываем 2ю колонку в "новую"
USE prolong 
EXEC sp_rename 'dbo.DropProlong.sender', 'sender3', 'COLUMN'
EXEC sp_rename 'dbo.DropProlong.sender2', 'sender', 'COLUMN'
GO

USE prolong 
EXEC sp_rename 'dbo.DropProlong.receiver', 'receiver3', 'COLUMN'
EXEC sp_rename 'dbo.DropProlong.receiver2', 'receiver', 'COLUMN'
GO


-- Удаляем лишние 3и колнки
USE prolong 
ALTER TABLE dbo.DropProlong DROP COLUMN Sender3, receiver3
ALTER TABLE dbo.DropProlong_spoiled DROP COLUMN Sender3, receiver3


-- Обновляем вьюху (тут было нужно)
USE prolong 
EXECUTE sp_refreshview N'dbo.DropProlongAll'; 
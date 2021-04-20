INSERT INTO [dt].[dbo].[EASAPRMessages] ([text],[type],[documentid],[date])
VALUES
('{"OrderID":723493,"type":"DropOrder","Station":"22200","DropOrderDate":"2020-10-26 15:47:00","ReasonCode":"01"}','Drop01AktCreate',723493,GETDATE())

INSERT INTO [dt].[dbo].[EASAPRMessages] ([text],[type],[documentid],[date])
VALUES
('{"OrderID":596562,"type":"UpOrder","Station":"04600","UpOrderDate":"2020-01-17 17:55:00","ReasonCode":"01"}','Up01AktCreate',596562,GETDATE())

--OrderID - айдишник приказа
--Station = значение из ds
--DropOrderDate = дата приказа из БД
--после Drop01AktCreate/Up01AktCreate продублировать айди приказа.
--Выполнять только один из двух инсертов на приказ, сообщени к которому отсутствует в системе.
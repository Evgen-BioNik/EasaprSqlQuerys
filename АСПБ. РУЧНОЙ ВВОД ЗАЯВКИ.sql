DECLARE @ID int, @ClaimID int, @CurID int


select @CurID = max([ClaimID]) from [dt].[dbo].[Claim2] WHERE ContractID=1
INSERT INTO [dt].[dbo].[Claim2] ([ContractID],[ContractNum],[ContractDateFrom],[ContractDateTo],[Client],[ClaimID],[ClaimNum],[Date],[DateFrom],[DateTo],
[DownTime],[Rail],[AgreedRail],[AgreedDate],[Status],[ForCD],[Cancelled],[IsActive])
		VALUES

(
'1', --id договора
'1028', -- Номер договора
'2015-12-29 00:00:00.000', -- Дата начала договора
'2099-12-31 00:00:00.000', -- Дата окончания договора
'ОАО «РЖД Логистика»', -- Наименование клиента
@CurID+1, -- Увеличиваем на единицу при каждом сохранении
'109', -- Номер заявки
GETDATE(), -- Не трогать!
NULL, 
'2016-12-20 23:59:00.000',  -- Дата окончания заявки 23 59
NULL, -- Количество дней простоя не вводим
'96', -- Дорога бросания
'96 ', -- Тоже указываем дорогу бросания
GETDATE(), -- Не трогать
1,0,0,1 -- Не трогать
); SET @ID=SCOPE_IDENTITY();

SET @ClaimID=(SELECT ClaimID FROM [dt].[dbo].[Claim2] WHERE id=@ID)
INSERT INTO [dt].[dbo].[ClaimLinks2] ([ClaimID],[SendID],[VagID]) VALUES (@ClaimID, 1,1)

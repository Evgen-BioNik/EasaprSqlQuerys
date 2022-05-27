--Ебашить на 10.246.101.43
DECLARE @uch INT, @UserID INT, @IKnowWhatIDo BIT, @year char(2) = YEAR( GETDATE() ) % 100 ;

------------------------ ////// ОЧЕНЬ ВАЖНЫЕ ДЕЙСТВИЯ ///// ------------------------
  -- Указать ID пользователя (можно узнать в Админе)
  SET @UserID = 15177;


  -- Автоматическая перенумеровка, пользоваться если знаешь, что делаешь
  -- Для автоматической перенумерации установить этот флаг равным 1
  -- SET @IKnowWhatIDo = 0;

------------------------ ////// ОЧЕНЬ ВАЖНЫЕ ДЕЙСТВИЯ ///// ------------------------

/* Блок для ручной работы

  INSERT INTO arnod.dbo.D_UserUch (code,Uch) VALUES (57966,'6303')
  UPDATE arnod.dbo.ArnodDNum SET dnum = 412 WHERE NumRec = 154
  DELETE arnod.dbo.ArnodFolder WHERE FolderNum = 75190
  UPDATE arnod.dbo.ArnodFolder SET WorkNum = '16/1' WHERE FolderNum = 70825
  UPDATE arnod.dbo.ArnodFolder SET WorkNum = '16/2' WHERE FolderNum = 70208

*/

-- Получаем ID участка
SELECT @uch=Uch FROM arnod.dbo.D_UserUch WHERE Code = @UserID

  -- Автоматическая перенумеровка, пользоваться если знаешь, что делаешь
  IF (@IKnowWhatIDo = 1)
  BEGIN
    UPDATE t
    SET t.WorkNum = @year + '/' + CAST (u.WorkNum_New AS VARCHAR(7))
    FROM arnod.dbo.ArnodFolder AS t
    INNER JOIN (
      SELECT ROW_NUMBER() OVER (ORDER BY FolderNum) AS WorkNum_New, *
      FROM arnod.dbo.ArnodFolder t
      WHERE nod = @uch AND WorkNum LIKE @year + '/%'
    ) AS u ON t.FolderNum = u.FolderNum

    UPDATE arnod.dbo.ArnodDNum
    SET DNum = 1 + (
      SELECT MAX( CAST( SUBSTRING( WorkNum,4,LEN(WorkNum) ) AS INT) )
      FROM arnod.dbo.ArnodFolder
      WHERE nod = @uch AND WorkNum LIKE @year + '/%'
    )
    WHERE uch = @uch AND Vnum = 'Uch'
  END

-- Получаем текущие значения нумерации по участку
SELECT * FROM arnod.dbo.ArnodDNum
WHERE uch = @uch AND Vnum = 'Uch'

-- Получаем последние составленные дела по данному участку
SELECT TOP 200 *
FROM arnod.dbo.ArnodFolder
WHERE nod = @uch
ORDER BY FolderNum DESC

-- Получаем дела за этот год, которые будут перенумерованы в автоматическом режиме
SELECT ROW_NUMBER() OVER (ORDER BY FolderNum) AS NewNum,*
FROM arnod.dbo.ArnodFolder
WHERE nod = @uch AND WorkNum LIKE @year + '/%'
ORDER BY FolderNum

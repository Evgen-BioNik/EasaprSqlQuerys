--Ебашить на 10.246.101.43

SELECT * FROM [mch].[dbo].[D_PRMFactory] WHERE Marka=341
SELECT * FROM [mch].[dbo].[D_PRMMarka] 
WHERE  NAME LIKE '%МККС%'

-- Выделять до сюда
/--------------- --------------/
-- Выделять от сюда
DECLARE @idMarka INT, @idFactory int, @Name VARCHAR(100);

SET @Name = 'МККС-42М'; -- Имя добавляемой марки механизма
INSERT INTO [mch].[dbo].[D_PRMMarka] (
    [Name]
   ,[Type]
   ,[Capacity]
   ,[BayLength]
   ,[Lift]
   ,[BucketCapacity]
   ,[Boom]
   ,[Factory]
   ,[kvo5]
) VALUES (
	@Name
   ,'1'			-- [Type] - тип механизма, берем такой же как у других
   ,'33.5'		-- [Capacity] - грузоподъемность, из паспорта
   ,'32'		-- [BayLength] - длинна пролета, из паспорта
   ,'9'			-- [Lift] - высота подъема, из паспорта
   ,''			-- [BucketCapacity] - вместимость ковша, из паспорта
   ,''			-- [Boom] - предположительно, макс вылет стрелы
   ,'ОАО '		-- [Factory] - завод-производитель, из паспорта
   ,'1'			-- [kvo5] - метка КВО, берем такой же как у других
 )
  SELECT @idMarka = @@identity
  
  INSERT INTO [mch].[dbo].[D_PRMFactory] (
  	[Name],[Marka]
  ) VALUES (
  	@Name,@idMarka
  )
SELECT @idFactory = @@identity
    
UPDATE [mch].[dbo].[D_PRMMarka] SET fact = @idFactory WHERE id = @idMarka
    
SELECT * FROM [mch].[dbo].[D_PRMMarka] WHERE id = @idMarka
    
    
    
                       
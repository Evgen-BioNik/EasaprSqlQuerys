SELECT * FROM ka.dbo.komakt WHERE KomAktNum=''
/*
	USE ka
DECLARE @Year            INT
       ,@Rail            VARCHAR(15)
       ,@TNum            INT
       ,@SNum            INT
       ,@KomAktNum       VARCHAR(12)
       ,@StationCode     VARCHAR(5)
       ,@OwnerDoc        INT
       ,@alert           VARCHAR(32)
       
SET @Year = 15 
SET @Rail = 'ДВС'
SET @KomAktNum = '713126'
SET @OwnerDoc = 0
SET @StationCode = '91160'

BEGIN TRANSACTION SetNum
BEGIN TRY

	IF (SELECT CASE 
					WHEN TNum='' THEN NULL
					ELSE '1'
				END AS NumReg
		FROM   KomAkt
		WHERE  KomAktNum = @KomAktNum
		) IS NULL
	BEGIN 
		SELECT @TNum = Num FROM TNum WHERE Rail = @Rail and [Year] = @Year
		UPDATE TNum SET Num=@TNum+1 WHERE Num = @TNum and Rail = @Rail and [Year]= @Year
		
		UPDATE KomAkt
		SET    TNum          = @Rail+CAST(@Year AS CHAR(2))+RIGHT('00000'+CAST(@TNum AS VARCHAR(5)),5)
		WHERE  KomAktNum     = @KomAktNum
				AND [status] IN (0,1)
			
		SELECT KomAktNum,TNum,SNum,'Номер присвоен успешно!' as ans
			FROM arg.dbo.KomAkt where KomAktNum = @KomAktNum

	END
		ELSE
		SELECT KomAktNum,TNum,SNum,'У этого акта уже есть номер!' as ans
			FROM arg.dbo.KomAkt where KomAktNum = @KomAktNum
END TRY

BEGIN catch
	PRINT ERROR_MESSAGE()
	PRINT 'Rolling back transaction'
	ROLLBACK TRANSACTION SetNum
END catch

IF @@TRANCOUNT > 0 COMMIT TRANSACTION SetNum	
*/
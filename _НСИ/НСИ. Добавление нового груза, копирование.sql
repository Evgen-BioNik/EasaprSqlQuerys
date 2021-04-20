DECLARE @Code INT, @copyCode INT, @Name VARCHAR(MAX)

SELECT @Code = '47229', @copyCode = '47201'
SELECT @Name = 'Масло каменноугольное поглотительное'

SELECT * FROM nsi.dbo.D_Cargo
WHERE Code = @Code OR [Name] LIKE '%масло%угол%'

IF NOT EXISTS (SELECT code FROM nsi.dbo.D_Cargo WHERE code = @Code)
BEGIN
	INSERT INTO nsi.dbo.D_Cargo
	(
		NameOld,
		Code,
		CodeM01,
		CodeM01_New,
		CodeFGP,
		Nomenclature,
		[Empty],
		actual,
		Name
	)
	SELECT 
		 ''
		,@Code
		,CodeM01
		,CodeM01_New
		,CodeFGP
		,Nomenclature
		,[Empty]
		,1
		,@Name
	FROM   nsi.dbo.D_Cargo
	WHERE code = @copyCode
END

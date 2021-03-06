--Актуально для записей за 15 год и старше. Ебашить на 10.246.101.18 
DECLARE @Do1Num      VARCHAR(6)
       ,@Do2Num      VARCHAR(6)
       ,@IDDO_1      VARCHAR(38)
       ,@IDDO_2      VARCHAR(38)
       ,@SendNum     VARCHAR(9)
       ,@SendId		 VARCHAR(15)
       ,@date        DATE = GETDATE()-10
       ,@log		 BIT = 0;   -- Отображать ли лог общения с ФТС 

--	В соответсвии с необходимостью должна быть одна строка:
--	SET @Do1Num		= '31869'				--	по номеру ДО-1
--	SET @Do2Num		= '8451'				--	по номеру ДО-2
	SET @SendNum	= '28970483'				--	по номеру отправки
--	SET @SendId		= '536807882'			--	и по SendId

/* БЛОК UPDATE-ОВ
	update arg.dbo.ztk set putinaofnum = NULL  where  ztknum in ('40')
	update arg.dbo.ztk set outaofnum = NULL  where  ztknum in ('40')
	update arg.dbo.ztk  where  ztknum in ('362413')
	update [fts].[dbo].[DoReg] set aofIdput = '92231300' where id = '14349'
	update [fts].[dbo].[DoReg] set aofIdout = '92231300' where id = '14349'
	update [fts].[dbo].[DoShipment] SET SendId = '568451454' WHERE SendId = '554143646'
	update [fts].[dbo].[DoShipment] set do1cargoCostCode = 'UAH' where id='6658'
	

	select * from arg.dbo.ztk where		 ztksend = '73970045 ' 
	update [fts].[dbo].[DoReg] set Do1Result = 0 where id IN ('17363')
	delete [fts].[dbo].[DoReg] where id in(13065)
	UPDATE fts.dbo.Do2CustomsDocs SET Do2Num = 


	USE fts IF NOT EXISTS (SELECT*FROM sendtofts WHERE DoNum IS NOT NULL)
	BEGIN UPDATE sendtofts SET DoNum='4783 ' WHERE id='2' END
*/ 
-- 1. Ищем данные уществующие записи в зтк и до по критериям и записываем данные по ним в переменные
USE fts
IF ISNUMERIC (@SendNum)='1'	SET @SendNum = cast(@SendNum AS INT) ELSE SET @SendNum = rtrim(@SendNum);

SELECT distinct @IDDO_1=processIdDo1,@IDDO_2=processIdDo2,@SendId=SendId,@SendNum=sendnum, @date = DATEADD(dd,-10,Do1Date)
FROM [DoReg] WITH (NOLOCK)
WHERE (SendNum like '%'+@SendNum OR Do1Num=@Do1Num or Do2Num=@Do2Num) 
AND sendid like CASE WHEN @SendId IS NOT NULL THEN @SendId ELSE '%' END

--	set @IDDO_2	= '04F4EDAD-24D9-497F-AF97-AF4B20DA4E5B'
	SELECT @IDDO_1='%'+@IDDO_1+'%',@IDDO_2='%'+@IDDO_2+'%';
IF ISNUMERIC (@SendNum)='1'	SET @SendNum = cast(@SendNum AS INT) ELSE SET @SendNum = rtrim(@SendNum);


-- 2. По известным переменным ищем и оторажаем записи в ЗТК, DoReg, DoShipment
SELECT	'arg.ZTK' AS tab,ZtkNum,status,isnull(ZtkCont,ZtkVag)'Vag/Cont',ZtkSend,
		PutInStation+' ('+RTRIM(st.Name)+')' 'Где зарегали',
		PutInAofnum,PutInDateTime,OutAofNum,OutDateTime,SendId,ZtkSendDate,z.do1Num
FROM arg.dbo.ztk z WITH (NOLOCK)
left join nsi.dbo.d_station st on z.PutInStation=st.Code
WHERE z.[Status]=1 and (ztksend LIKE '%'+@SendNum AND PutInDateTime>@date OR z.SendId=@SendId)

SELECT 'fts.DoReg'  AS tab,* FROM [DoReg]      WITH (NOLOCK) WHERE SendId=@SendId
SELECT 'fts.DoShip' AS tab,* FROM [DoShipment] WITH (NOLOCK) WHERE SendId=@SendId

-- 3. Поиск в логе сообдений по ид ДО
IF @@ROWCOUNT > 0 AND @log > 0
BEGIN
	DECLARE @tab TABLE (mType CHAR(4),mId INT ,mDate DATETIME, direct VARCHAR(80), mess VARCHAR(max),isOut SMALLINT, script VARCHAR(255))
	
	IF @IDDO_1 is not null
	BEGIN
		INSERT INTO @tab
		SELECT 1, id,[date],[from],[message],0,'- -'
		FROM [xi].[que].[dbo].[input_que] WITH(NOLOCK) 
		WHERE [from]='RU:FTSP' and [date] > @date
			AND ([message] LIKE @IDDO_1)
	END

	IF @IDDO_2 is not null
	BEGIN
		INSERT INTO @tab
		SELECT 2, id,[date],[from],[message],0,'- -'
		FROM [xi].[que].[dbo].[input_que] WITH(NOLOCK) 
		WHERE [from]='RU:FTSP' and [date] > @date
			AND ([message] LIKE @IDDO_2)
	END

	IF @IDDO_1 is not null
	BEGIN
		INSERT INTO @tab
		SELECT 1, id,[date],[to],[message],1,script
		FROM [xi].[que].[dbo].[output_que] WITH(NOLOCK) 
		WHERE [to]='RU:FTS' and [date] > @date
			AND ([message] LIKE @IDDO_1)
	END

	IF @IDDO_2 is not null
	BEGIN
		INSERT INTO @tab
		SELECT 2, id,[date],[to],[message],1,script
		FROM [xi].[que].[dbo].[output_que] WITH(NOLOCK) 
		WHERE [to]='RU:FTS' and [date] > @date
			AND ([message] LIKE @IDDO_2)
	END

	SELECT
		CASE
			WHEN mType = 1 THEN 'ДО-1'
			WHEN mType = 1 THEN 'ДО-1'
		END AS 'Тип'
		,mId,CONVERT(VARCHAR(20),mDate,120) AS mDate,mess
		,CASE WHEN isOut = 1 THEN 'output' ELSE 'input' END AS 'Куды'
		,direct,script
	FROM @tab
	ORDER BY mDate DESC
END



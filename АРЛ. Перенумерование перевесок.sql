declare @st CHAR(5) = '10101',
	@startID INT = 14318639,
	@startNum INT = 531,
	@startDate date = '2019-08-01',
	
	@IKnowWhatIDo BIT = 0,
	@year CHAR(4), @yearShort CHAR(2),
	@max36 INT, @max78 INT;

SELECT @year = YEAR(@startDate), @yearShort = SUBSTRING(CAST(YEAR(@startDate) AS varchar(4)),3,2)

SELECT top 100 @startNum-1+ROW_NUMBER() OVER (ORDER BY WeighingNum) AS NumNew, *
FROM arg.dbo.Weighing
WHERE Station = @st
--	AND WeighingNum >= @startID
	AND DateW > @startDate
	AND Type = 1
order by WeighingNum

SELECT * FROM arg.dbo.WeighingSNum
WHERE Station = @st AND [Year] = @yearShort

SELECT 
	1+ ISNULL(MAX(CASE WHEN type = 1 THEN NumRecWBook ELSE 0 END),0) AS newGu68Num,
	1+ ISNULL(MAX(CASE WHEN type !=1 THEN NumRecWBook ELSE 0 END),0) AS newGu36Num
FROM arg.dbo.Weighing
WHERE Station = @st
	AND DateW > @year


IF (@IKnowWhatIDo = 1) 
BEGIN
	--SELECT w.WeighingNum, t.*
	UPDATE w SET w.NumRecWBook = t.NumNew
	FROM arg.dbo.Weighing AS w
		INNER JOIN (
			SELECT top 1000 WeighingNum,NumRecWBook,@startNum-1+ROW_NUMBER() OVER (ORDER BY WeighingNum) AS NumNew
			FROM arg.dbo.Weighing
			WHERE Station = @st
				AND WeighingNum >= @startID
				AND DateW > @startDate
				AND Type = 1
			order by WeighingNum	
		) AS t
			on t.WeighingNum = w.WeighingNum
			
	SELECT
		@max78 = 1+ ISNULL(MAX(CASE WHEN type = 1 THEN NumRecWBook ELSE 0 END),0), 
		@max36 = 1+ ISNULL(MAX(CASE WHEN type !=1 THEN NumRecWBook ELSE 0 END),0)
	FROM arg.dbo.Weighing
	WHERE Station = @st AND DateW > @year
		
	UPDATE arg.dbo.WeighingSNum
	SET num = @max36
	WHERE Station = @st AND [Year] = @yearShort
		AND type = 'gu36'
		
	UPDATE arg.dbo.WeighingSNum
	SET num = @max78
	WHERE Station = @st AND [Year] = @yearShort
		AND type = 'gu78' AND [Quarter] = 1
	
END


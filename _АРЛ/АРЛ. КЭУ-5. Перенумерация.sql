
DECLARE @IKnowWhatIDo bit = 0, @maxOldNum INT, @maxOldID int;


DECLARE @station CHAR(5) = '98830';

 SET @IKnowWhatIDo = 0

SELECT *
FROM arg.dbo.PSAkt
WHERE Station = @station AND DateAkt > '2020'
	AND (Site IS NULL OR Site = '' OR Site = 0)

SELECT * FROM arg.dbo.AktSNum 
WHERE Station = @station AND [year]=20 AND Type = 'aktps5' 



SELECT @maxOldNum = Num - 1
FROM arg.dbo.AktSNum
WHERE Station = @station AND [Year] = 20 AND Type = 'aktps5'
	AND Site = ''

SELECT @maxOldID = PSAktNum
FROM arg.dbo.PSAkt
WHERE Station = @station AND DateAkt > '2020'
	AND Site = 0
	AND PSNum = @maxOldNum


--select @maxOldID = 698265, @maxOldNum = 86

SELECT @maxOldID, @maxoldNum
SELECT 
	ROW_NUMBER() OVER (ORDER BY PSAktNum) + @maxOldNum -1 as NewNum
	,PSAktNum
	,PSNum
	,Site
FROM arg.dbo.PSAkt
WHERE Station = @station AND DateAkt > '2020'
	AND Site = 0
	AND PSAktNum >= @maxOldID

	

IF @IKnowWhatIDo = 1 AND  @maxOldID IS NOT NULL
BEGIN 

	UPDATE u SET u.PSNum = d.NewNum
	FROM arg.dbo.PSAkt as u
		inner join (

			SELECT 
				ROW_NUMBER() OVER (ORDER BY PSAktNum) + @maxOldNum -1 as NewNum
				,PSAktNum
			FROM arg.dbo.PSAkt
			WHERE Station = @station AND DateAkt > '2020'
				AND Site = 0
				AND PSAktNum >= @maxOldID
		) as d on d.PSAktNum = u.PSAktNum


	delete
	FROM arg.dbo.AktSNum
	WHERE Station = @station AND [Year] = 20 AND Type = 'aktps5'
		AND Site = ''


	UPDATE arg.dbo.AktSNum
	SET Num = (
		SELECT MAX(psnum) +1
		FROM arg.dbo.PSAkt
		WHERE Station = @station AND DateAkt > '2020'
			AND Site = 0
			AND PSAktNum >= CASE WHEN @maxOldID IS NOT NULL THEN @maxOldID ELSE 0 END 
		)
	WHERE Station = @station AND [Year] = 20 AND Type = 'aktps5'
		AND Site = '0'

END 

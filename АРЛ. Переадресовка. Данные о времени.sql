/*
	http://jira.easapr/browse/ARG-8237
*/


-- ИД акта на начало или окончание переадресовки
DECLARE @aofID INT = 190222989;


DECLARE @b_id INT, @e_id INT;
SELECT distinct @b_id = AktOfNum, @e_id = AktOfNumEnd
FROM arg.dbo.AktOfDownTimeCar AS dt
WHERE dt.AktOfNum = @aofID OR dt.AktOfNumEnd = @aofID


;WITH begin_data AS (
  SELECT TOP 1 aof.AktDate AS beginAktDate, rw.petVizaDate, rw.orderDateTime
    ,CASE WHEN aof.AktDate >= rw.petVizaDate THEN aof.AktDate ELSE rw.petVizaDate END AS freeStartDate
  FROM aof_arg.dbo.readdressing_work AS rw WITH(NOLOCK)
    INNER JOIN arg.dbo.AktOf AS aof WITH(NOLOCK)
      ON aof.AktOfNum = rw.AktOfNum
  WHERE rw.AktOfNum = @b_id
)
,end_data AS (
  SELECT AktDate AS endAktDate
  FROM arg.dbo.AktOf WITH(NOLOCK)
  WHERE AktOfNum = @e_id
)
SELECT *
  ,ABS(DATEDIFF (n, beginAktDate, endAktDate))     AS delayTime
  ,ABS(DATEDIFF (n, freeStartDate, orderDateTime)) AS freeTime
FROM begin_data
  CROSS JOIN end_data

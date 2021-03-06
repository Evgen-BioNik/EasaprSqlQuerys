SELECT
	ds.CodeRail,count(t.memoId) AS c_id, SUM (CASE WHEN t.haveCargo > 0 THEN 1 ELSE 0 end) AS haveCargo
FROM (


	SELECT m.memoId, m.memoStation, SUM (CASE WHEN mc.cargoCode IS NULL THEN 0 ELSE 1 end) AS haveCargo
	FROM memo.dbo.memo AS m with(nolock)
		INNER JOIN memo.dbo.memo_car AS mc with(nolock)
			ON mc.memoId = m.memoId
	WHERE m.memoDate > '2018-06-01'

	GROUP BY m.memoId, m.memoStation
) AS t
	INNER JOIN nsi.dbo.D_Station AS ds
		ON ds.Code = t.memoStation
group by ds.CodeRail
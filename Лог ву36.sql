SELECT TOP 50 v.etdid vu36EtdId, v.repair_date dateRepair,COUNT(vc.vagon_id) cars, COUNT(tp.carNum) aofs
FROM vu.dbo.Vu_36 AS v
INNER JOIN vu.dbo.Vu_36_car AS vc ON vc.vu36Id = v.id
LEFT JOIN arg.dbo.tech_processing AS tp ON tp.vu36EtdId = v.etdId AND tp.carNum = vc.vagon_id
--WHERE v.etdId='96850241'
GROUP BY v.etdid, v.id, v.repair_date
ORDER BY v.repair_date DESC


/*
SELECT DISTINCT TOP 50 tp.dateDetect,tp.id,vu.etdid, vu.id ,tp.vu23EtdId, 
aa.TechDefectCode, aa.DefectName, vu.disrepair_item1_name, aa.TechDefectCode_2, aa.DefectName_2, aa.TechDefectCode_3, aa.DefectName_3
--,count(tp.aofIdTechEnd) aofs,count(vc.vagon_id) cars
FROM arg.dbo.tech_processing AS tp
RIGHT JOIN arg.dbo.Vu_23 AS vu ON vu.etdId = tp.vu23EtdId
INNER JOIN aof_oper.dbo.album_aof AS aa ON tp.aofIdTechBegin = aa.AktOfNum
ORDER BY tp.dateDetect DESC
*/


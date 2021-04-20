--Ебашить на 10.246.101.18

SELECT *
FROM   [PI].ukn.dbo.Correct
WHERE  Vagnum          = '54404658'
	   AND DelAkt IS NULL
	   /*
       AND Station    in (
               SELECT Code
               FROM   [nsi].[dbo].[D_Station]
               WHERE  NAME LIKE 'Ульяновск-Центральный КБШ%'
           )
           */
/*
update [pi].ukn.dbo.Correct 
set DelAkt = '1'
where CorrectNum = '29368809'
*/
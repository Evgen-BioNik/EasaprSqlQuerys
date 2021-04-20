--Ебашить на 10.246.101.43
/*
DECLARE @StCode         INT
       ,@namest         CHAR(32)
       ,@rightKey       INT
       ,@level          INT
       ,@parentid       INT
       ,@department     INT
       ,@codedep        INT
       
SET @namest = 'ДИ %'
SET @StCode = 27582


-- тут начинается запрос

SET @parentid = 33387;		-- id подразделения, в которое пихаем
SET @department = 13;	-- Служба
SET @codedep = 27373;	-- сюда код станции


        SELECT @rightKey = rightKey
              ,@level     = [level]
        FROM   nsi.dbo.T_DepartmentBranch
        WHERE  id         = @parentid;
        UPDATE nsi.dbo.T_DepartmentBranch
        SET    leftKey      = CASE 
                              WHEN leftKey<@rightKey THEN leftKey
                              ELSE leftKey+2
                         END
              ,rightKey     = rightKey+2
        WHERE  rightKey>= @rightKey;
        
        INSERT INTO [nsi].[dbo].[T_DepartmentBranch]
          (
            [name]
           ,[leftKey]
           ,[rightKey]
           ,[level]
           ,[nameshort]
           ,[Department]
           ,[Rail]
           ,[Region]
           ,[Station]
           ,[Dcs]
          )
        VALUES('ТЧ-17 Абдулино'
              ,@rightKey
              ,@rightKey+1 
              ,@level+1
              ,'ТЧ-17 Абдулино'
              ,@department
              ,'63'
              ,'6303'
              ,NULL
              ,NULL
			  )
        
*/

DECLARE @namedep CHAR(32) SET @namedep='т куй'
DECLARE @Rkey INT; DECLARE @Lkey INT;
SET @Rkey=(SELECT rightkey FROM nsi.dbo.T_DepartmentBranch WHERE NAME LIKE rtrim(@namedep)+'%')
SET @Lkey=(SELECT leftkey FROM nsi.dbo.T_DepartmentBranch WHERE NAME LIKE rtrim(@namedep)+'%')
SELECT * FROM nsi.dbo.T_DepartmentBranch AS tdep
WHERE tdep.leftKey>=@Lkey AND tdep.rightkey<=@Rkey
--and LEVEL<='4' 
ORDER BY tdep.leftkey,tdep.[level]

  
/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP 1000 [id]
      ,[leftKey]
      ,[rightKey]
      ,[level]
      ,[Name]
      ,[station]
      ,[code]
      ,[TGNL]
      ,[OKPO]
      ,[ContractNum]
      ,[parentId]
      ,[pcalid]
      ,[state]
      ,[dateBegin]
      ,[dateEnd]
      ,[dogType]
      ,[city]
      ,[streetAndHouse]
      ,[postIndex]
      ,[actual]
      ,[noCharge]
      ,[NoChargeTimeOrg]
      ,[typeClient]
      ,[countryCode]
      ,[countryName]
      ,[par]
      ,[empty]
  FROM [arg].[dbo].[T_ReceiverPP]




/*


USE [arg]
GO
INSERT INTO [dbo].[T_ReceiverPP]
           ( [leftkey]
		    ,[rightkey]
			,[level]
		    ,[Name]
            ,[station]
		    ,[TGNL]
            ,[OKPO]
		    ,[state]
            ,[actual]
		    ,[empty]
           )
	VALUES('123','124','1','ООО "ФЛАГМАН"','20070','9999','25984204','85','1','1')
	
	
	*/

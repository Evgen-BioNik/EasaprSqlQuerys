--	Ебашить на 10.246.101.43

Declare @StationName varchar(32),@StationCode char(5),@CopyStation char(5);

-- Данные новой станции:
Set @StationName='Лосево 1 ОКТ';
Set @StationCode='02265';

-- Код станции данные которой будут скопированы
Set @CopyStation='02261';

INSERT INTO [nsi].[dbo].[D_Station]
           ([Code]
           ,[Name]
           ,[CodeNOD]
           ,[CodeRail]
           ,[StatusSt]
           ,[On_Off]
           ,[Cargo_on_off]
           ,[TK]
           ,[TlgfEmail]
           ,[direction_id]
           ,[NameTel]
           ,[CodeDirection]
           ,[AspbCode]
           ,[Norma]
           ,[ProcessingNorma]
           ,[DepartNorma]
           ,[ArriveNorma]
           ,[Region]
           ,[WashNorma]
           ,[TechNorma]
           ,[IsTechCD]
           ,[modelTech]
           ,[modelProcessing]
           ,[modelWash]
           ,[export]
           ,[forAof])
select	top 1
			@StationCode
           ,@StationName
           ,[CodeNOD]
           ,[CodeRail]
           ,[StatusSt]
           ,[On_Off]
           ,[Cargo_on_off]
           ,[TK]
           ,[TlgfEmail]
           ,[direction_id]
           ,[NameTel]
           ,[CodeDirection]
           ,@StationCode
           ,[Norma]
           ,[ProcessingNorma]
           ,[DepartNorma]
           ,[ArriveNorma]
           ,[Region]
           ,[WashNorma]
           ,[TechNorma]
           ,[IsTechCD]
           ,[modelTech]
           ,[modelProcessing]
           ,[modelWash]
           ,[export]
           ,1
FROM nsi.[dbo].[D_Station]
WHERE code = @CopyStation and on_off=1 

select * from nsi.[dbo].[D_Station] where name =@StationName


declare  @doc_uuid TABLE
(
	uuid uniqueidentifier PRIMARY KEY
)

insert into @doc_uuid(uuid) values ('8028A6E6-4023-44AA-9311-3E1E471CE541')

begin try
begin transaction


	insert into hardcopy.dbo.paper ([uuid]
      ,[created]
      ,[source]
      ,[type]
      ,[mimeType]
      ,[filename]
      ,[body]
      ,[isuzhtDocID]
      ,[removed])
	select [uuid]
      ,[created]
      ,[source]
      ,[type]
      ,[mimeType]
      ,[filename]
      ,[body]
      ,[isuzhtDocID]
      ,[removed] from hardcopy.dbo.paper_arch where uuid in (select uuid from @doc_uuid)
	delete from hardcopy.dbo.paper_arch where uuid in (select uuid from @doc_uuid)

commit transaction

begin transaction
	SET IDENTITY_INSERT hardcopy.dbo.paper_signs ON;

	insert into hardcopy.dbo.paper_signs ([id]
      ,[paper_uuid]
      ,[paper_type]
      ,[paper_hash]
      ,[user_code]
      ,[fio]
      ,[creator]
      ,[status]
      ,[status_change]
      ,[status_history]
      ,[signature])
	select [id]
      ,[paper_uuid]
      ,[paper_type]
      ,[paper_hash]
      ,[user_code]
      ,[fio]
      ,[creator]
      ,[status]
      ,[status_change]
      ,[status_history]
      ,[signature] from hardcopy.dbo.paper_signs_arch where paper_uuid in (select uuid from @doc_uuid)
	delete from hardcopy.dbo.paper_signs_arch where paper_uuid in (select uuid from @doc_uuid)

	SET IDENTITY_INSERT hardcopy.dbo.paper_signs OFF;
commit transaction

begin transaction
	SET IDENTITY_INSERT hardcopy.dbo.paper_external_signs ON;

	insert into hardcopy.dbo.paper_external_signs ([id]
      ,[paper_uuid]
      ,[paper_type]
      ,[paper_hash]
      ,[user_code]
      ,[fio]
      ,[status]
      ,[status_change]
      ,[status_history]
      ,[signature]
      ,[system]
      ,[reason_revoke]
      ,[position_revoke]
      ,[name_revoke]
      ,[auto_agreement]
      ,[date_toClient]
      ,[user_orgName]
      ,[simple_sign]
      ,[signature_simple])
	select [id]
      ,[paper_uuid]
      ,[paper_type]
      ,[paper_hash]
      ,[user_code]
      ,[fio]
      ,[status]
      ,[status_change]
      ,[status_history]
      ,[signature]
      ,[system]
      ,[reason_revoke]
      ,[position_revoke]
      ,[name_revoke]
      ,[auto_agreement]
      ,[date_toClient]
      ,[user_orgName]
      ,[simple_sign]
      ,[signature_simple] from hardcopy.dbo.paper_external_signs_arch where paper_uuid in (select uuid from @doc_uuid)
	delete from hardcopy.dbo.paper_external_signs_arch where paper_uuid in (select uuid from @doc_uuid)

	SET IDENTITY_INSERT hardcopy.dbo.paper_external_signs OFF;
commit transaction

end try	
begin catch
	if(@@TRANCOUNT>0) rollback transaction
	print ERROR_MESSAGE()
	select uuid from @doc_uuid
end catch

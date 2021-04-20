declare @claimID int, @dropOrderID int, @upOrderID int;

	set @dropOrderID = 534756;
	set @upOrderID = 495405;

if (@dropOrderID IS NULL) select @dropOrderID = droporderid from dt.dbo.dtuporder where id = @upOrderID
select @claimID = claimid from dt.dbo.dtorder where id = @dropOrderID

select @dropOrderID as dropID, @upOrderID as upID, @claimID as ClaimID
select * from dt.dbo.easaprmessages where documentid = @claimID
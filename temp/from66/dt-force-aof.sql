declare @dropOrderID int = 654898
declare @AktOfNum int = 194297581

declare @updateBegin bit = 0, @updateEnd bit = 0;

if @updateBegin = 1
begin
	update dt.dbo.shipment2
	set aktofnum = @AktOfNum
	where trainid = (select id from dt.dbo.trains where orderid = @dropOrderID) --and isaffectedreceiver = 0
end


if @updateEnd = 1
begin
	update dt.dbo.shipment2
	set aktofnumend = @AktOfNum
	where trainid = (select id from dt.dbo.trains where orderid = @dropOrderID) -- and isaffectedreceiver = 0
end

select *
from dt.dbo.shipment2
where trainid = (select id from dt.dbo.trains where orderid = @dropOrderID)
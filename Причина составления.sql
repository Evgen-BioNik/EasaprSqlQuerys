select * from nsi.dbo.T_aofType where id=600

declare @leftKey int;
declare @rightKey int;
select @leftKey = leftKey, @rightKey = rightKey from nsi.dbo.t_aofType where id='600';
select name from nsi.dbo.t_aofType where leftKey <= @leftKey and rightKey >= @rightKey and level<>0 
order by level
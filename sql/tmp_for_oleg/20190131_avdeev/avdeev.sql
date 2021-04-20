declare @stList table (Code char(5))

insert into @stList values ('98790'),( '98690'),( '96760'),( '96770'),( '96780'),( '98000'),( '98020'),( '98540'),( '98550'),( '98560'),( '98570'),( '98080'),( '98090'),( '98450'),( '98590'),( '98610'),( '98470'),( '98770'),( '98780'),( '98530'),( '98510')


select st.Code
	,count (distinct AktOfNumB) as sumAofB
	,count (distinct AktOfNumE) as sumAofE
	,count (CarriageNum) as sumCar
	,SUM(isnull(DATEDIFF(hour,AktDateB,AktDateE),0)) as Downtime
from @stList as st
	left join (

	select distinct ao.AktOfNum as AktOfNumB , ao.AktDate as AktDateE, ao.Station, aoc.CarriageNum, aoB.AktOfNum as AktOfNumE ,aoB.AktDate as AktDateB
	from arg.dbo.aktof as ao
		inner join arg.dbo.AktOfCarriage as aoc on aoc.AktOfNum = ao.AktOfNum
		inner join arg.dbo.AktOfDownTimeCar as dtc on dtc.AktOfNumEnd = ao.AktOfNum and dtc.AktOfCarriageNumEnd = aoc.AktOfCarriageNum
		
		inner join arg.dbo.aktof as aoB on aoB.AktOfNum = dtc.AktOfNum
		
		inner join arg.dbo.AktOfCargo as carg on carg.AktOfNum = ao.AktOfNum
		inner join nsi.dbo.D_Cargo as dc on dc.Code = carg.cargoCode

	where ao.Station in (select Code from @stList) and ao.dt =1
		and ao.AktDate between '2019-01-01' and '2019-02-01'
		
		and AktOfCarriageNumEnd > 0
		and dc.Nomenclature = 1
		and dtc.StationTo in (select Code from @stList)
) as t on st.Code = t.Station
group by st.Code
order by st.Code

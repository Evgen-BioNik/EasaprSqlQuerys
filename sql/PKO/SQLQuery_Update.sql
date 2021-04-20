update  uuu
  set	uuu.carTypeFull = t.typeName,
		uuu.carRodText = t.rodName,
		uuu.carRodID = t.rodID
from [uhv].[dbo].[tempAof2] as uuu
inner join (
		select vpt.name as typeName, pas.name as rodName, pas.rod as rodID, vag.NUM_VAG
		from [delta].[nsi].[dbo].[D_VagPassport] as vag with(nolock)
		inner join [delta].[nsi].[dbo].D_VagPassportTypeVag as vpt with(nolock) on vag.TIP = vpt.tip
		inner join [delta].[nsi].[dbo].[D_VagPassportRodVag] as pas with(nolock) on vpt.rod = pas.rod
) as t on t.NUM_VAG = uuu.CarriageNum
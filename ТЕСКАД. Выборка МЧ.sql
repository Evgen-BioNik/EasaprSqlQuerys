--на 43.
select top 100 st.Code,st.Name,d_U.Name,mch.Name,dm.Name from  mch.dbo.D_MSites st
		LEFT JOIN mch.dbo.D_StationUch stU ON stU.Code = st.CodeStation
		LEFT JOIN mch.dbo.D_UchMch m ON m.Uch = stU.Uch
		LEFT JOIN nsi.dbo.D_Mch mch ON mch.Code = m.Mch
		LEFT JOIN nsi.dbo.D_DM dm ON dm.Code = mch.DM
		left join mch.dbo.D_Uch d_U on d_U.Code=m.Uch
		
where st.Name like '%волга%'	--сюда название станции. 
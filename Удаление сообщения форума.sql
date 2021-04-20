SELECT *
  FROM [admin].[dbo].[Forum]
  
  where MsgDate > '2014-03-30'
  and MsgText like 'Здравствуйте. На текущий момент нами проблема не обнаружена. Попробуйте еще раз пожалуйста. Если проблема сохраняется обратитесь к нам через ЕСПП.'
  --or ParentId='105382'
  
--  delete from admin.dbo.Forum  where MsgNumRec='113040'
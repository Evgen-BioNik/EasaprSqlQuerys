SELECT fp.TCFTO
      ,tcfto.name AS TCFTOName
      ,fp.station
      ,dstation.Name AS stationName
      ,pcc.number AS ContractNumber
      ,fp.name
      ,fp.ForceCompletedRequestState
      --I ОБЩИЕ ХАРАКТЕРИСТИКИ
      ,CASE WHEN fp.Owner_CEODocumentType IS NULL THEN 0 ELSE 1 END AS Owner_CEODocumentType
      ,CASE WHEN fp.Owner_CEODocumentDate IS NULL THEN 0 ELSE 1 END AS Owner_CEODocumentDate
      ,CASE WHEN fp.Owner_CEODocument IS NULL THEN 0 ELSE 1 END AS Owner_CEODocument
      ,CASE WHEN fp.Owner_CEOPhone IS NULL THEN 0 ELSE 1 END AS Owner_CEOPhone
      ,CASE WHEN COALESCE(fp.Owner_INN,fp.Owner_KPP) IS NULL THEN 0 ELSE 1 END AS Owner_INN_KPP
      ,CASE WHEN 
      COALESCE(fp.Owner_JurAddres_Region,fp.Owner_FizAddres_Region) IS null 
      OR COALESCE(fp.Owner_JurAddres_City, fp.Owner_FizAddres_City) IS NULL
      OR COALESCE(fp.Owner_JurAddres_Addres,fp.Owner_FizAddres_Addres) IS NULL THEN 0 ELSE 1 END AS OwnerAddress
      --II ТЕХНИЧЕСКИЕ ХАРАКТЕРИСТИКИ
      ,ISNULL(pway.WayNumber,0) as WayNumber
      ,ISNULL(pway.BorderFrom ,0) as BorderFrom
      ,ISNULL(pway.BorderTo ,0) as BorderTo
      ,ISNULL(pway.LengthFull,0) as LengthFull
      ,ISNULL(pway.LengthRZD,0) as LengthRZD
      ,ISNULL(pway.LengthUsefull,0) as LengthUsefull
      ,ISNULL(pway.Specialisation ,0) as Specialisation
      ,ISNULL(PsWayCargoFront.PsWayCargoFrontName ,0) as PsWayCargoFrontName
      ,ISNULL(PsWayCargoFront.PsWayCargoFrontWay  ,0) as PsWayCargoFrontWay
      ,ISNULL(PsWayCargoFront.PsWayCargoFrontLength  ,0) as PsWayCargoFrontLength
      ,ISNULL(PsWayCargoFront.PsWayCargoFrontCapacity   ,0) as PsWayCargoFrontCapacity
      ,ISNULL(PsWayCargoFront.PsWayCargoFrontLoadUnload   ,0) as PsWayCargoFrontLoadUnload
      ,ISNULL(PsWayCargoFront.PsWayCargoFrontCargo   ,0) as PsWayCargoFrontCargo
      ,ISNULL(PsWayCargoFront.PsWayCargoFrontSpecialisation   ,0) as PsWayCargoFrontSpecialisation
      --III УСЛОВИЯ ПОДАЧИ И УБОРКИ ВАГОНОВ
      ,CASE WHEN fp.Feed_NoticeType IS NULL THEN 0 ELSE 1 END AS Feed_NoticeType
      ,CASE WHEN fp.Remove_NoticeType IS NULL THEN 0 ELSE 1 END AS Remove_NoticeType
      ,CASE WHEN fp.Way_Group IS NOT NULL THEN (CASE WHEN fp.Way_GroupReviewPeriod IS NULL THEN 0 ELSE 1 END) ELSE 1 END AS Way_GroupReviewPeriod
      --IV ОБСЛЕДОВАНИЯ
      ,ISNULL(PsExam.ExamPlanDate ,0) as ExamPlanDate
      ,ISNULL(PsExam.ExamAktDate  ,0) as ExamAktDate
      ,ISNULL(PsExam.ExamType ,0) as ExamType
      ,ISNULL(PsExam.ExamContractType ,0) as ExamContractType
      ,ISNULL(PsExam.ExamOutgoingNum ,0) as ExamOutgoingNum
      ,ISNULL(PsExam.ExamOutgoingDate ,0) as ExamOutgoingDate
      ,ISNULL(PsExam.ExamMeetingPoint ,0) as ExamMeetingPoint
      ,ISNULL(PsExam.ExamSignPost  ,0) as ExamSignPost
      ,ISNULL(PsExam.ExamSignFio ,0) as ExamSignFio
      --IV.1 состав комиссии
      ,ISNULL(PsExamComission.ExamComissionPost ,0) as ExamComissionPost
      ,ISNULL(PsExamComission.ExamComissionFio ,0) as ExamComissionFio
      --IV.2 телеграмма
      ,ISNULL(PsExamTelegram.ExamTelegramPost ,0) as ExamTelegramPost
      ,ISNULL(PsExamTelegram.ExamTelegramFio ,0) as ExamTelegramFio
      ,ISNULL(PsExam.ExamTelegramFileId,0) as ExamTelegramFileId
      --IV.3 акт обследования
      ,ISNULL(PsExam.ExamFileId ,0) as ExamFileId
      ,CASE WHEN ((CHARINDEX('1', Feed_Remove.Feed_Place) > 0 OR  CHARINDEX('3', Feed_Remove.Feed_Place) > 0)) AND PsExam.Akt_ServeRemovePayDistance = 0 THEN 0 ELSE 1 END AS ExamDistance
      ,CASE WHEN PsExam.Akt_ServeRemovePayDistance = 1 AND PsExam.Akt_CarriageDailyAmount = 0 THEN 0 ELSE 1 END AS ExamCarAmmount
      --V ТЕХНОЛОГИЧЕСКИЕ ПАРАМЕТРЫ И УСЛОВИЯ
      --V.1 параметры
      ,CASE WHEN ((CHARINDEX('2', Feed_Remove.Feed_Place) > 0 OR  CHARINDEX('3', Feed_Remove.Feed_Place) > 0)) AND pt.TechParamsRound = 0 THEN 0 ELSE 1 END AS TechParamsRound
      ,CASE WHEN CHARINDEX('1', Feed_Remove.Feed_Place) > 0 AND PsTechParamsLoadUnload.TechParamsLoadUnload = 0 THEN 0 ELSE 1 END AS TechParamsLoadUnload
      ,ISNULL(PsTechParamsProcessing.TechParamsCapacity,0) as TechParamsCapacity
      --V.2 договор
      ,ISNULL(PsContract.HasContractNumber ,0) as HasContractNumber
      ,ISNULL(PsContract.ContractType ,0) as ContractType
      ,ISNULL(PsContract.ContractState,0) as ContractState
      ,CASE WHEN PsExam.Akt_ServeRemovePayDistance = 1 AND PsContract.ServeRemovePayType = 0 THEN 0 ELSE 1 END AS ContractServeRemovePayType
      ,CASE WHEN fp.Way_OwnType IN (1,3) AND PsContract.WayUsagePayType = 0 THEN 0 ELSE 1 END AS ContractWayUsagePayType
      ,ISNULL(PsContract.PsContractPeriod,0) as PsContractPeriod
      --VI ОБЩИЕ ХАРАКТЕРИСТИКИ
      ,CASE WHEN fp.[name] IS NULL THEN 0 ELSE 1 END AS HasName
      ,CASE WHEN fp.[station] IS NULL THEN 0 ELSE 1 END AS HasStation
      ,CASE WHEN fp.[TCFTO] IS NULL THEN 0 ELSE 1 END AS HasTCFTO
      ,CASE WHEN fp.Owner_Type IS NULL THEN 0 ELSE 1 END AS Owner_Type
      ,CASE WHEN fp.Way_OwnType IS NULL THEN 0 ELSE 1 END AS Way_OwnType
      ,CASE WHEN fp.[Owner_FullName] IS NULL THEN 0 ELSE 1 END AS Owner_FullName
      ,CASE WHEN fp.Owner_ShortName IS NULL THEN 0 ELSE 1 END AS Owner_ShortName
      ,CASE WHEN fp.Owner_OPF IS NULL THEN 0 ELSE 1 END AS Owner_OPF
      --VII МЕСТА ПРИМЫКАНИЯ
      ,ISNULL(pcon.ConnectionRail ,0) as ConnectionRail
      ,ISNULL(pcon.ConnectionStation ,0) as ConnectionStation
      ,ISNULL(pcon.ConnectionWay_Arrow_Number,0) as ConnectionWay_Arrow_Number
      ,ISNULL(pcon.ConnectionBorderSignPlace ,0) as ConnectionBorderSignPlace
      --VIII УСЛОВИЯ ПОДАЧИ И УБОРКИ ВАГОНОВ
      --VIII.1 подача вагонов на ПНП
      ,ISNULL(PsFeedRemove.PsFeed_Place ,0) as PsFeed_Place
      ,ISNULL(PsFeedRemove.PsFeed_Locomotive,0) as PsFeed_Locomotive
      --VIII.2 уборка вагонов с ПНП
      ,ISNULL(PsFeedRemove.PsRemove_Place ,0) as PsRemove_Place
      ,ISNULL(PsFeedRemove.PsRemove_Locomotive,0) as PsRemove_Locomotive

  FROM [pnp].[dbo].[Passport] fp with(nolock)
  INNER JOIN pnp.dbo.Passport_Current_Contract pcc with(nolock) ON pcc.passport = fp.id
  LEFT JOIN nsi.dbo.d_station dstation ON dstation.Code = fp.station
  LEFT JOIN (
  SELECT passport
      ,CASE WHEN SUM(CASE WHEN pcon.rail IS NULL THEN 0 ELSE 1 END) = COUNT(pcon.id) THEN 1 ELSE 0 END AS ConnectionRail 
      ,CASE WHEN SUM(CASE WHEN pcon.station IS NULL THEN 0 ELSE 1 END) = COUNT(pcon.id) THEN 1 ELSE 0 END  AS ConnectionStation 
      ,CASE WHEN SUM(CASE WHEN pcon.WayNumber IS NULL AND pcon.ArrowNumber is null THEN 0 ELSE 1 END) = COUNT(pcon.id) THEN 1 ELSE 0 END  as ConnectionWay_Arrow_Number
      ,CASE WHEN SUM(CASE WHEN pcon.BorderSignPlace IS NULL THEN 0 ELSE 1 END) = COUNT(pcon.id) THEN 1 ELSE 0 END  as ConnectionBorderSignPlace
  FROM  pnp.dbo.Passport_Connections pcon with(nolock)
  GROUP BY passport) pcon  ON pcon.passport = fp.id
  LEFT JOIN 
  (
  SELECT passport
    ,CASE WHEN SUM(CASE WHEN pway.number IS NULL THEN 0 ELSE 1 END) = COUNT(pway.id) THEN 1 ELSE 0 END AS WayNumber 
    ,CASE WHEN SUM(CASE WHEN pway.BorderFrom IS NULL THEN 0 ELSE 1 END) = COUNT(pway.id) THEN 1 ELSE 0 END AS BorderFrom 
    ,CASE WHEN SUM(CASE WHEN pway.BorderTo IS NULL THEN 0 ELSE 1 END) = COUNT(pway.id) THEN 1 ELSE 0 END AS BorderTo 
    ,CASE WHEN SUM(CASE WHEN pway.LengthFull IS NULL THEN 0 ELSE 1 END) = COUNT(pway.id) THEN 1 ELSE 0 END AS LengthFull 
    ,CASE WHEN SUM(CASE WHEN pway.LengthRZD IS NULL THEN 0 ELSE 1 END) = COUNT(pway.id) THEN 1 ELSE 0 END AS LengthRZD 
    ,CASE WHEN SUM(CASE WHEN pway.LengthUsefull IS NULL THEN 0 ELSE 1 END) = COUNT(pway.id) THEN 1 ELSE 0 END AS LengthUsefull 
    ,CASE WHEN SUM(CASE WHEN pway.Specialisation IS NULL THEN 0 ELSE 1 END) = COUNT(pway.id) THEN 1 ELSE 0 END AS Specialisation 
  FROM  pnp.dbo.Passport_Way pway with(nolock)
  GROUP BY passport) pway ON pway.passport = fp.id
  LEFT JOIN 
   (
  SELECT passport
    ,CASE WHEN SUM(CASE WHEN COALESCE( [TechTimeRound_Common_Confirmed],[TechTimeRound_Winter_Confirmed],[TechTimeRound_Summer_Confirmed]
      ,[TechTimeRound_Marsh_Confirmed],[TechTimeRound_NotMarsh_Confirmed],[TechTimeRound_1Oper_Confirmed],[TechTimeRound_2Oper_Confirmed]) IS NULL THEN 0 ELSE 1 END) = COUNT(pt.id) THEN 1 ELSE 0 END AS TechParamsRound 
  FROM  pnp.dbo.Passport_TechParams pt with(nolock)
  GROUP BY passport) pt  ON pt.passport = fp.id
  LEFT JOIN 
   (
  SELECT passport
    ,CASE WHEN SUM(CASE WHEN PsWayCargoFront.name IS NULL THEN 0 ELSE 1 END) = COUNT(PsWayCargoFront.id) THEN 1 ELSE 0 END AS PsWayCargoFrontName 
    ,CASE WHEN SUM(CASE WHEN PsWayCargoFront.Way IS NULL THEN 0 ELSE 1 END) = COUNT(PsWayCargoFront.id) THEN 1 ELSE 0 END AS PsWayCargoFrontWay 
    ,CASE WHEN SUM(CASE WHEN PsWayCargoFront.[length] IS NULL THEN 0 ELSE 1 END) = COUNT(PsWayCargoFront.id) THEN 1 ELSE 0 END AS PsWayCargoFrontLength 
    ,CASE WHEN SUM(CASE WHEN PsWayCargoFront.capacity IS NULL THEN 0 ELSE 1 END) = COUNT(PsWayCargoFront.id) THEN 1 ELSE 0 END AS PsWayCargoFrontCapacity 
    ,CASE WHEN SUM(CASE WHEN PsWayCargoFront.SimultaneousLoadUnload IS NULL THEN 0 ELSE 1 END) = COUNT(PsWayCargoFront.id) THEN 1 ELSE 0 END AS PsWayCargoFrontLoadUnload 
    ,CASE WHEN SUM(CASE WHEN PsWayCargoFront.CargoETSNG IS NULL AND PsWayCargoFront.DangerCargo IS null THEN 0 ELSE 1 END) = COUNT(PsWayCargoFront.id) THEN 1 ELSE 0 END AS PsWayCargoFrontCargo 
    ,CASE WHEN SUM(CASE WHEN PsWayCargoFront.specialisation IS NULL THEN 0 ELSE 1 END) = COUNT(PsWayCargoFront.id) THEN 1 ELSE 0 END AS PsWayCargoFrontSpecialisation 
    FROM  pnp.dbo.Passport_Way_CargoFront PsWayCargoFront with(nolock)
  GROUP BY passport) PsWayCargoFront ON PsWayCargoFront.passport = fp.id
  LEFT JOIN 
   (
    SELECT passport
    ,CASE WHEN SUM(CASE WHEN PsExam.PlanDate IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamPlanDate 
    ,CASE WHEN SUM(CASE WHEN PsExam.Akt_FactDate IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamAktDate 
    ,CASE WHEN SUM(CASE WHEN PsExam.[type] IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamType 
    ,CASE WHEN SUM(CASE WHEN PsExam.ContractType IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamContractType 
    ,CASE WHEN SUM(CASE WHEN PsExam.Telegram_OutgoingNum IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamOutgoingNum 
    ,CASE WHEN SUM(CASE WHEN PsExam.Telegram_OutgoingDate IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamOutgoingDate 
    ,CASE WHEN SUM(CASE WHEN PsExam.Telegram_MeetingPoint IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamMeetingPoint 
    ,CASE WHEN SUM(CASE WHEN PsExam.Telegram_SignPost IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamSignPost 
    ,CASE WHEN SUM(CASE WHEN PsExam.Telegram_SignFio IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamSignFio 
    ,CASE WHEN SUM(CASE WHEN PsExam.Telegram_Fileid IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamTelegramFileId 
    ,CASE WHEN SUM(CASE WHEN PsExam.Akt_Fileid IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS ExamFileId 
    ,CASE WHEN SUM(CASE WHEN PayDistance.ServeRemovePayDistance = 0 THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS Akt_ServeRemovePayDistance 
    ,CASE WHEN SUM(CASE WHEN PsExam.Akt_CarriageDailyAmount IS NULL THEN 0 ELSE 1 END) = COUNT(PsExam.id) THEN 1 ELSE 0 END AS Akt_CarriageDailyAmount 
    
    FROM  pnp.dbo.Passport_Examination PsExam with(nolock)
    LEFT JOIN (
        SELECT examination, SUM(ISNULL(ServeRemovePayDistance,0)) as ServeRemovePayDistance
        FROM pnp.dbo.Passport_Examination_PayDistance 
        GROUP BY examination
    ) PayDistance ON PayDistance.examination = PsExam.id
  GROUP BY passport) PsExam ON PsExam.passport = fp.id
  LEFT JOIN 
   (
    SELECT PsExamComission.passport
    ,CASE WHEN SUM(CASE WHEN PsExamComission.type IS NULL THEN 0 ELSE 1 END) = COUNT(PsExamComission.id) THEN 1 ELSE 0 END AS ExamComissionPost 
    ,CASE WHEN SUM(CASE WHEN PsExamComission.fio IS NULL THEN 0 ELSE 1 END) = COUNT(PsExamComission.id) THEN 1 ELSE 0 END AS ExamComissionFio 
    FROM  pnp.dbo.Passport_Examination_Comission PsExamComission with(nolock)
    INNER JOIN pnp.dbo.Passport_Examination pe with(nolock) ON pe.id =  PsExamComission.examination
  GROUP BY PsExamComission.passport) PsExamComission ON PsExamComission.passport = fp.id
  LEFT JOIN 
   (
  SELECT passport
    ,CASE WHEN SUM(CASE WHEN PsExamTelegram.post IS NULL THEN 0 ELSE 1 END) = COUNT(PsExamTelegram.id) THEN 1 ELSE 0 END AS ExamTelegramPost 
    ,CASE WHEN SUM(CASE WHEN PsExamTelegram.fio IS NULL THEN 0 ELSE 1 END) = COUNT(PsExamTelegram.id) THEN 1 ELSE 0 END AS ExamTelegramFio 
    FROM  pnp.dbo.Passport_Examination_TelegramRecipient PsExamTelegram with(nolock)
  GROUP BY passport) PsExamTelegram ON PsExamTelegram.passport = fp.id
  LEFT JOIN
   (
  SELECT passport
    ,CASE WHEN SUM(CASE WHEN PsTechParamsLoadUnload.Cargo IS NOT NULL 
    AND (PsTechParamsLoadUnload.Loading_Confirmed IS NOT NULL OR PsTechParamsLoadUnload.Unloading_Confirmed IS not null)
    THEN 1 ELSE 0 END) = COUNT(PsTechParamsLoadUnload.id) THEN 1 ELSE 0 END AS TechParamsLoadUnload 
    
    FROM  pnp.dbo.Passport_TechParams_LoadUnload PsTechParamsLoadUnload with(nolock)
  GROUP BY passport) PsTechParamsLoadUnload ON PsTechParamsLoadUnload.passport = fp.id
  LEFT JOIN 
  (
  SELECT passport
    ,CASE WHEN SUM(CASE WHEN PsTechParamsProcessing.CargoNomenclature IS NOT NULL 
    AND (PsTechParamsProcessing.ProcessingCapacity_Common_Confirmed IS NOT NULL 
            OR PsTechParamsProcessing.ProcessingCapacity_Common_Load_Confirmed IS not null
            OR PsTechParamsProcessing.ProcessingCapacity_Common_Unload_Confirmed IS not null
            OR PsTechParamsProcessing.ProcessingCapacity_Winter_Confirmed IS not null
            OR PsTechParamsProcessing.ProcessingCapacity_Winter_Load_Confirmed IS not null
            OR PsTechParamsProcessing.ProcessingCapacity_Winter_Unload_Confirmed IS not null
            OR PsTechParamsProcessing.ProcessingCapacity_Summer_Confirmed IS not null
            OR PsTechParamsProcessing.ProcessingCapacity_Summer_Load_Confirmed IS not null
            OR PsTechParamsProcessing.ProcessingCapacity_Summer_Unload_Confirmed IS not null
            )
    THEN 1 ELSE 0 END) = COUNT(PsTechParamsProcessing.id) THEN 1 ELSE 0 END AS TechParamsCapacity 
  FROM  pnp.dbo.Passport_TechParams_Processing PsTechParamsProcessing with(nolock)
  GROUP BY passport) PsTechParamsProcessing ON PsTechParamsProcessing.passport = fp.id
  LEFT JOIN 
    (
  SELECT PsContract.passport
    ,CASE WHEN SUM(CASE WHEN PsContract.number IS NULL THEN 0 ELSE 1 END) = COUNT(PsContract.id) THEN 1 ELSE 0 END AS HasContractNumber 
,CASE WHEN SUM(CASE WHEN PsContract.[type] IS NULL THEN 0 ELSE 1 END) = COUNT(PsContract.id) THEN 1 ELSE 0 END AS ContractType 
,CASE WHEN SUM(CASE WHEN PsContract.[state] IS NULL THEN 0 ELSE 1 END) = COUNT(PsContract.id) THEN 1 ELSE 0 END AS ContractState 
,CASE WHEN SUM(CASE WHEN PsContract.ServeRemovePayType IS NULL THEN 0 ELSE 1 END) = COUNT(PsContract.id) THEN 1 ELSE 0 END AS ServeRemovePayType 
,CASE WHEN SUM(CASE WHEN PsContract.WayUsagePayType IS NULL THEN 0 ELSE 1 END) = COUNT(PsContract.id) THEN 1 ELSE 0 END AS WayUsagePayType 
,CASE WHEN SUM(CASE WHEN  PsContract.DateFrom IS NULL OR PsContract.DateTo IS NULL THEN 0 ELSE 1 END) = COUNT(PsContract.id) THEN 1 ELSE 0 END AS PsContractPeriod 
FROM  pnp.dbo.Passport_Contract PsContract with(nolock)
INNER JOIN pnp.dbo.Passport_Current_Contract pcc with(nolock) ON pcc.id = PsContract.id
  GROUP BY PsContract.passport) PsContract  ON PsContract.passport = fp.id
  LEFT JOIN nsi.dbo.T_TCFTO tcfto ON tcfto.id = fp.TCFTO
  LEFT JOIN (
    SELECT p.id as passport, 
        (SELECT
            REPLACE(stuff
               ((SELECT       cast('*' AS varchar(max)) + ISNULL(cast(Passport_Feed_Remove.Feed_Place AS varchar(max)), '')
                           FROM pnp.dbo.Passport_Feed_Remove with(nolock)
                                 WHERE        Passport_Feed_Remove.passport = p.id 
                                                           FOR xml path('')), 1, 1, ''), '*', ';') AS Feed_Place
          ) Feed_Place  ,
          (SELECT
          REPLACE(stuff
                             ((SELECT       cast('*' AS varchar(max)) + ISNULL(cast(Passport_Feed_Remove.Remove_Place AS varchar(max)), '')
                                FROM pnp.dbo.Passport_Feed_Remove with(nolock)
                                 WHERE        Passport_Feed_Remove.passport = p.id 
                                                           FOR xml path('')), 1, 1, ''), '*', ';') AS Remove_Place    
    ) Remove_Place ,
    (SELECT
    REPLACE(stuff
                             ((SELECT       cast('*' AS varchar(max)) + ISNULL(cast(Passport_Feed_Remove.Feed_Locomotive AS varchar(max)), '')
                                FROM pnp.dbo.Passport_Feed_Remove with(nolock)
                                 WHERE        Passport_Feed_Remove.passport = p.id 
                                                           FOR xml path('')), 1, 1, ''), '*', ';') AS Feed_Locomotive
    ) Feed_Locomotive ,
    (SELECT
    REPLACE(stuff
                             ((SELECT       cast('*' AS varchar(max)) + ISNULL(cast(Passport_Feed_Remove.Remove_Locomotive AS varchar(max)), '')
                                FROM pnp.dbo.Passport_Feed_Remove with(nolock)
                                 WHERE        Passport_Feed_Remove.passport = p.id 
                                                           FOR xml path('')), 1, 1, ''), '*', ';') AS Remove_Locomotive
    
    ) Remove_Locomotive 
    FROM pnp.dbo.Passport p
    ) Feed_Remove ON Feed_Remove.passport = fp.id
 LEFT JOIN 
    (
  SELECT passport
    ,CASE WHEN SUM(CASE WHEN PsFeedRemove.Feed_Place IS NULL THEN 0 ELSE 1 END) = COUNT(PsFeedRemove.id) THEN 1 ELSE 0 END AS PsFeed_Place 
    ,CASE WHEN SUM(CASE WHEN PsFeedRemove.Feed_Locomotive IS NULL THEN 0 ELSE 1 END) = COUNT(PsFeedRemove.id) THEN 1 ELSE 0 END AS PsFeed_Locomotive 
    ,CASE WHEN SUM(CASE WHEN PsFeedRemove.Remove_Place IS NULL THEN 0 ELSE 1 END) = COUNT(PsFeedRemove.id) THEN 1 ELSE 0 END AS PsRemove_Place 
    ,CASE WHEN SUM(CASE WHEN PsFeedRemove.Remove_Locomotive IS NULL THEN 0 ELSE 1 END) = COUNT(PsFeedRemove.id) THEN 1 ELSE 0 END AS PsRemove_Locomotive 

FROM  pnp.dbo.Passport_Feed_Remove PsFeedRemove with(nolock)
  GROUP BY passport) PsFeedRemove  ON PsFeedRemove.passport = fp.id
WHERE fp.Name = 'ФИЛИАЛ ПУБЛИЧНОГО АКЦИОНЕРНОГО ОБЩЕСТВА "ОГК-2" СУРГУТСКАЯ ГРЭС-1'
<?
//Функции для записи данных о ГУ-45 в разные вспомогательные режимы
include_once 'sql_functions.php';
include_once 'date_from_sql.php';
include_once 'time_from_sql.php';
include_once 'rus_ajax.php';

include_once ($_SERVER['DOCUMENT_ROOT'].'/arg/Fun/MyLittleLog.php');
include_once ($_SERVER['DOCUMENT_ROOT'].'/arg/Fun/CheckIsset.php');
include_once ($_SERVER['DOCUMENT_ROOT'].'/aof/interfaces/create_aof_interface.php');
include_once ($_SERVER['DOCUMENT_ROOT'].'/aof/interfaces/que/to_que.php');
//========================================================================================
// фиксация времени подачи/уборки вагона по памятке гу-45
function fact_gu45($memo,$id) {
	$q = '';
	switch ($memo->memoType) {
		//для тех. неисправноти
		case 1 : //памятка подачи
		case 3 : //памятка подачи-уборки
			$q = ins_tech($memo,$id);
			if ($q) $res = sql_query($q);
			break;
		case 2 : //памятка уборки
			ins_memoPort($memo, $id);
			break;
	}
	ins_ukn($memo, $id);
	//Rabbit::put(array("type"=>"gu45","body"=>utf8_encode_deep($memo)), "VagModel", "gu45");
	to_VagModel_que("gu45",$memo);
	
	$arr = objectToArray($memo);
	$arr['memoId'] = $id;
	//$arr = array_to_utf($arr);
	to_publishArl("gu45",$arr,$id);
}

//========================================================================================
// Запись данных в таблицу для АОФ по исправлению технической неисправности
function ins_tech($memo,$id) {
	$q = "DECLARE @CarNum CHAR(8), @FeedDate DATETIME, @MemoId INT = $id, @st char(5) = '{$memo->memoStation}';";
	foreach($memo->car as $car) {
		if (!$car->feedDate || !$car->carNum) continue;
		/*
			-- Удалить строки в tech_gu45 по данному вагону и данному ГУ45, если дата ГУ45 в разных таблицах не совпадают 
			-- Добавить ГУ45 всем записям в tech, если эти записи проходят условия
		*/
		$q .= "				
			SET @CarNum = '{$car->carNum}';
			SET @FeedDate = '{$car->feedDate}';
			
			DELETE tg
			FROM arg.dbo.tech_gu45 tg
				INNER JOIN arg.dbo.tech_processing tp ON tg.techId = tp.id
			WHERE memoIdPod = @MemoId AND feedDate <> @FeedDate AND tp.carNum = @CarNum
			
			INSERT INTO arg.dbo.tech_gu45 (techId, memoIdPod, feedDate)	
			SELECT
				tp.id, @MemoId memo, @FeedDate d
			FROM arg.dbo.tech_processing AS tp
				LEFT JOIN arg.dbo.tech_gu45 AS tg 
					ON tp.id = tg.techId AND tg.memoIdPod = @MemoId
			WHERE carnum = @CarNum
				AND @st IN (station, stationRepair)
				AND tp.vu23EtdId IS NOT NULL
				AND tg.feedDate IS NULL
				AND dateDetect BETWEEN DATEADD(DAY, -30, @FeedDate) AND @FeedDate	
		";
	}
	return $q;
}

// Запись памяток для УКН
function ins_ukn($memo,$id) {
	$memoType = $memo->memoType;
	
	$q_feed = "
		UPDATE ukn.dbo.Correct
		SET gu45InID = @memoID, CorInDT = @memoDate
		WHERE Station = @st AND VagNum = @carNum
			AND ArrivalDT < @memoDate
			AND DelAkt IS NULL
			AND CorInDT IS NULL
	";
	$q_cleen = "
		UPDATE ukn.dbo.Correct
		SET gu45OutID = @memoID, CorOutDT = @memoDate
		WHERE Station = @st AND VagNum = @carNum
			AND ArrivalDT < @memoDate
			AND (CorInDT IS NULL OR CorInDT < @memoDate)
			AND DelAkt IS NULL
			AND CorOutDT IS NULL
	";
	
	$q_dec = "DECLARE @CarNum VARCHAR(12), @memoDate DATETIME, @memoID INT = $id, @st char(5) = '{$memo->memoStation}';";
	$q = '';
	foreach($memo->car as $car) {
		if (!$car->carNum) continue;
		if ($memoType == 1 && !$car->feedDate) continue;
		if ($memoType == 2 && !$car->cleanDate) continue;
		if ($memoType == 3 && !$car->feedDate && !$car->cleanDate) continue;
		
		
		if (in_array($memoType, [1,3]) && $car->feedDate) {
			$q.= "\r\t\tSELECT @CarNum = '{$car->carNum}', @memoDate = '{$car->feedDate}';  ".$q_feed;
		}
		if (in_array($memoType, [2,3]) && $car->cleanDate) {
			$q.= "\r\t\tSELECT @CarNum = '{$car->carNum}', @memoDate = '{$car->cleanDate}'; ".$q_cleen;
		}
		
		
	}
	if ($q) {
		
		include_once('sql.php');
		$conDB = MSSQL::ConnectDB('ukn');
		$conDB->q($q_dec.$q);
		
		file_put_contents('/var/log/easapr/m_ukn.txt',$q_dec.$q);
	}

}
//========================================================================================
// Запись данных в таблицу припортовой станции и создание АОФ
function ins_memoPort($memo,$id) {
	if (!$id) return;
	// Получаем код станции ГУ45
	$StationCode = (string)$memo->memoStation;
	// Проверяем, что станция является припортовой
	$cache_st = sql_cache_query("SELECT Code, CodeRail FROM [nsi].[dbo].[D_Station] WHERE priport = 1 ORDER BY code");
	$priport = 0;
	foreach ($cache_st as $item) if ($item['Code'] == $StationCode) $priport = 1;

	// Смотрим, есть ли дата уборки у вагона
	$aof_date = ''; $err_cars = []; $norm_cars = []; $carInfoList = [];			
	foreach ($memo->car as $car) {
		if (!$car->cleanDate) $err_cars[] = (string)$car->carNum;
		else if (!in_array($car->carNum, $norm_cars)) {
			$norm_cars[] = (string)$car->carNum;
			$carInfoList[] = [
				 'carNum' => (string)$car->carNum
				,'cleanDate' => $car->cleanDate
			];
			// Спорное решение, дата у разных вагонов может быть разной. Спросить Олега
			$aof_date = $car->cleanDate;
		}
	}
	
	// Вагоны без даты памятки пишем в лог
	if (count($err_cars) > 0) {
		MyLittleLog($id, "Нет даты уборки у вагонов: ".implode(',', $err_cars), 'NoDate', 'memo', 'asuST', 1);
	}
	
	// Нет даты уборки вообще - ничего с памяткой не делаем, а в лог записали на предыдущем шаге по идее
	if (!$aof_date) return;
	
	// Проверяем, что дата памятки - это вменяемое число вообще
	$gu_date = str_replace("T", " ", $aof_date);
	$date_gu = new DateTime($gu_date);
	$curr_date = new DateTime(date("Y-m-d H:s"));
	$interval = date_diff($curr_date, $date_gu)->format('%r%a'); //знак и разница в днях

	if ($interval > 1) {
		MyLittleLog($id, "Слишком большая дата памятки: ".print_r($interval,true), 'BadDate', 'memo', 'asuST', 1);
		return;
	}
	
	if ($interval < -3) {
		MyLittleLog($id, "Слишком маленькая дата памятки: ".print_r($interval,true), 'BadDate', 'memo', 'asuST', 1);
		return;
	}
	// Запроос АС ЭТРАН по "норм" вагонам. Очистка массива вагонов
	$a_Car = ask_etran(implode(',',$norm_cars),'vag',1);
	if (!count($a_Car)) {
		MyLittleLog($id, "Etran, nodata: \n".print_r($norm_cars,true), 'noCars', 'memo', 'asuST');
		return;
	}
	
	// ВЕТВЛЕНИЕ
	if ($priport == 1) ins_priport($memo, $id, $StationCode, $a_Car, $aof_date);
	if ($priport == 0) ins_notpriport($memo, $id, $StationCode, $a_Car, $carInfoList);
}


// Создание актов на подачу по ПРИПОРТОВОЙ станции
function ins_priport($memo, $id, $StationCode, $a_Car, $aof_date){
	$bad_cars = $norm_cars = [];
	// Получить массив станций связанных cо станцией перемещения (включительно саму переданную станцию)
	$a_MasterStation = GetMasterStation($StationCode);

	foreach ($a_Car as $i => $Car) {
		$addCar = 0; // Метка добавления вагона
		foreach ($Car['shipment'] as $Ship) {
			
			// Если станция назначения накладной равна станции ГУ45 - добавляем вагон
			if (in_array($Ship['send']['stationToCode'], $a_MasterStation)) $addCar = 1;
			
			/* Убрано к чертям, заявка №6688 12.03.2019
			// Проверить, что в случае, если электронная накладная имеет тип бланка «требование на перемещение порожнего грузового вагона» (код=98), заготовка АОФ на подачу создаётся. Иначе - не создается
			if ((int)$Ship['send']['BlankType'] != 98) continue;
				
			
			// Есть ли вообще условия для проверки? Добавить вагон в новый массив, если:
			if ((int)$Ship['cargo']['cargoCode'] > 0 && (int)$Ship['send']['stationFromCode'] > 0) {
				if (substr($Ship['cargo']['cargoCode'],0,3) == '421') {
					// 1. Вагон порожний и статус отправки "Заготовка"
					if ($Ship['send']['StateID'] == 1) $addCar = 1;
				} else {
					// 2. Вагон груженый и станция отправления вагона не входит в массив связанных станций
					if (!in_array($Ship['send']['stationFromCode'], $a_MasterStation)) $addCar = 1;
				}
			}
			*/
		}
		// Если условия пройдены - добавить вагон в заново созданный массив
		if ($addCar) $norm_cars[ (string)$Car['carNum'] ] = $Car;
		else $bad_cars[ (string)$Car['carNum'] ] = $Car;
	}	 
	$json_Cars = @json_encode($a_Car,JSON_UNESCAPED_UNICODE);
	// Если вагоны не прошли проверку на вшивость - сунуть все в лог
	if (!count($norm_cars)) {
		MyLittleLog($id, "Etran priport, stGu45 = $StationCode, bad info cars: \n$json_Cars", 'noCars', 'memo', 'asuST');
		return;
	}
	if (count($bad_cars)) {
		MyLittleLog($id, "Etran priport, stGu45 = $StationCode, norm cars count = ".count($norm_cars)."\nbad info cars: \n$json_Cars", 'noCars', 'memo', 'asuST');
	}
	// Убрать временные переменные
	unset ($a_Car, $Car, $Ship, $a_MasterStation);
	// Ищем "норм" вагоны из ГУ-45
	// - нашли: добавляем ГУ-45 в существующей строке в базе
	// - не нашли: добавляем новую строку вагона в базу 
	$q_ins = 'DECLARE @id INT, @AktDate DATETIME;';
	foreach ($memo->car as $car) {
		// есть ли вагон в массиве "норм" вагонов?
		if (!array_key_exists((string)$car->carNum, $norm_cars)) continue;
	
		$q_ins .= "	
			IF NOT EXISTS (SELECT * FROM arg.dbo.port_station_working WHERE gu45ID = $id AND carnum = '".$car->carNum."')
			BEGIN
				SET @AktDate = '$aof_date';
				SELECT @id = id
				FROM   arg.dbo.port_station_working
				WHERE	stationReg = '$StationCode'
					AND carnum     = '".$car->carNum."'
					AND dateReg BETWEEN DATEADD(DAY, -3, @AktDate ) AND @AktDate 
					AND gu45ID IS NULL
				
				IF @id IS NOT NULL
					UPDATE	arg.dbo.port_station_working
					SET 	gu45ID = $id, 
							aofBeforeGu = 1
					WHERE	id = @id
				ELSE
					INSERT INTO arg.dbo.port_station_working (gu45ID, dateReg, stationReg, carNum)
					VALUES ($id, @AktDate, '$StationCode', '".$car->carNum."') 
			END
		";
	}	
	
	//в конце выбираем вагоны, у которых эта ГУ-45 и нет акта на постановку
	$q_ins .= "	
		SELECT carNum
		FROM   arg.dbo.port_station_working
		WHERE  aofNoDocID IS NULL
		   AND stationReg = '$StationCode'
		   AND gu45ID = $id 
		ORDER BY id";

	$res = sql_query($q_ins);
	$str_car = '';
	while ($item = sql_fetch_assoc($res)){
		// Если вагон без акта среди наших "норм" - добавим его к запросу собственников
		if (array_key_exists($item['carNum'], $norm_cars))
			$str_car .= $item['carNum'].',';
	}
	if (!$str_car) {
		MyLittleLog($id, "Нет вагонов для создания АОФ: ".print_r($q_ins,true), 'noCars', 'memo', 'asuST', 1);	
		return;
	}
	
	$ans = '';
	//Запрос собственников вагонов
	include_once ($_SERVER['DOCUMENT_ROOT'].'/arg/Fun/askCarNsi.php');
	if ($str_car) $ans = askCarNsi(trim($str_car,','), true);
	
	if (is_array($ans) && count($ans)) {
		//Разбиваем вагоны по собственникам
		$carData = checkCarOwners($ans);
		//Если нашли какие-то вагоны, пытаемся сделать акты
		if (count($carData['cars']) > 0) {
			//Основные поля акта на подачу
			$req = array();
			$req['aof']['aofReason']	= 1188;						
			$req['aof']['aofOwner']		= 0;
			$req['aof']['aofStation']	= $StationCode;
			$req['aof']['aofDate']		= $aof_date;
			
			$req['aof']['portNoDoc']['gu45ID'] = $id;
			$req['aof']['portNoDoc']['Gu45Num'] = (string)$memo->memoNum;
			
			$aof_date = str_replace("T", " ", $aof_date);
			$req['aof']['portNoDoc']['Gu45Date'] = date_from_sql($aof_date);
			$req['aof']['portNoDoc']['Gu45Time'] = time_from_sql($aof_date);

			
			//формируем строку вагонов для акта и пробуем создать акт
			foreach($carData['cars'] as $i => $a_Car) {
				if (!count($a_Car) || !is_array($a_Car)) continue;
				
				$req['aof']['portNoDoc']['carOwnerText'] = $carData['owners'][$i];
				$req['aof']['carriage'] = [];
				$str_car = implode(',',$a_Car);
				foreach ($a_Car as $carNum)
					$req['aof']['carriage'][] = $norm_cars[$carNum];
				unset($carNum);
				
				//!!!! Тут делаем акт!
				$result = create_aof_byCar($req);
				
				if ((gettype($result) == 'object') && $result->verify == 'ok') {
					$q_ok = "	UPDATE arg.dbo.port_station_working 
								SET aofNoDocID = $result->aofId 
								WHERE carNum IN ($str_car) AND gu45ID = $id ";
					$res = sql_query($q_ok);	
				}
				else MyLittleLog($id, "Ошибка создания АОФ: ".print_r($req,true)."\n\nResponse: ".print_r($result,true), 'noAkt', 'memo', 'asuST', 1);	
			}
		}				
	}
	else MyLittleLog($id, "Ошибка запроса данных собственников из АС ЭТРАН для вагонов: ".$str_car, 'noOwner', 'memo', 'asuST', 1);
}


function ins_notpriport($memo, $id, $StationCode, $a_Car, $carInfoList){
	// Пишем в лог исходники
	MyLittleLog($id, "notpriport carInfoList: ".json_encode($carInfoList), 'memoCars', 'memo', 'asuST', 1);
	
	// Определяем путь из гу45
	$wayID = 0;
	if ($memo->placeFeed) {	
		$query_way = "
			SELECT ways.ID
			FROM arg.dbo.D_StationWays AS ways
			WHERE	ways.StationCode = '$StationCode'
					AND ways.WayNum = '{$memo->placeFeed}'
					AND ways.WayType = 1
		";
		$res_way = sql_query($query_way);
		if (sql_num_rows($res_way) > 0) {
			$way = sql_fetch_assoc($res_way);
			$wayID = $way["ID"];
		}
	}
	
	// Перебираем полученный массив вагонов памятки и дописываем необходимые для группировки значения
	$a_clean = $a_notif = $a_gu2b = $a_holder = [];
	foreach($carInfoList as &$carInfo) {
		if (!count($carInfo)) continue;
		
		$carNum = $carInfo['carNum'];
		
		// Ищем в данных ЭТРАН выбранный вагон и дату уведомления
		foreach($a_Car as $Car) {
			if ($Car['carNum'] == $carNum) {
				$carInfo['carShip'] = $Car;
				
				$carInfo['carHolder'] = $Car['carHolder'];
				$a_holder[] = $Car['carHolder'];	// << пихаем владельца вагона в массив для ключа
				
				$dateNotification = DateParseSilent($Car['dateNotification']);				
				
				if ($dateNotification) {
					$carInfo['dateNotification'] = $dateNotification;
					$a_notif[] = $dateNotification;		// << пихаем дату уведомления в массив для ключа
				}
				break;
			}
		}
		unset($Car);
		
		$cleanDate = DateParseSilent($carInfo['cleanDate']);
		if ($cleanDate) {
			$carInfo['cleanDate'] = $cleanDate;
			$a_clean[] = $cleanDate;					// << пихаем дату уборки в массив для ключа
			
			// Ищем данные о гу2б за период 4 дней от даты гу45 на выбранный вагон по станции памятки
			$q_find_gu2b = "
				SELECT TOP 1 gu2bID
				FROM arg.dbo.port_station_working
				WHERE aofNoDocID IS NULL AND gu2bID IS NOT NULL
					AND isPort = 2
					AND stationReg = '$StationCode'
					AND carNum = '$carNum'
					AND DATEDIFF(d,dateReg,'$cleanDate') BETWEEN 0 AND 4
				ORDER BY id DESC
			";
			$res_gu2b = sql_query($q_find_gu2b);
			
			MyLittleLog($id, "notpriport find_gu2b: \n$q_find_gu2b\n".mssql_get_last_message(), 'gu2b', 'memo', 'asuST', 1);
			
			if (sql_num_rows($res_gu2b) > 0) {
				$r_gu2b = sql_fetch_assoc($res_gu2b);
				// $carInfo = array_merge($carInfo,$r_gu2b);
				$carInfo['gu2bID'] = $r_gu2b['gu2bID'];
				$a_gu2b[] = $r_gu2b['gu2bID'];			// << пихаем ид ГУ-2б в массив для ключа
				unset($r_gu2b);
			}
			unset($q_find_gu2b, $res_gu2b, $cleanDate);
		}
	}
	unset($carInfo);

	// Убираем дубли
	$a_clean = array_unique($a_clean);
	$a_notif = array_unique($a_notif);
	$a_gu2b = array_unique($a_gu2b);
	$a_holder = array_unique($a_holder);
	
	// Перебираем вагоны и группируем по 4м критериям
	$groupedCars = [];
	foreach($carInfoList as $carInfo) {
		$k_clean = $k_notif = $k_gu2b = $k_holder = -1;
		// Ищем индексы массивов
		if (CheckIsset($carInfo,'cleanDate'))			$k_clean  = array_search($carInfo['cleanDate'],$a_clean);
		if (CheckIsset($carInfo,'dateNotification'))	$k_notif  = array_search($carInfo['dateNotification'],$a_notif);
		if (CheckIsset($carInfo,'gu2bID'))				$k_gu2b   = array_search($carInfo['gu2bID'],$a_gu2b);
		if (CheckIsset($carInfo,'carHolder'))			$k_holder = array_search($carInfo['carHolder'],$a_holder);
		
		// Если хотя  бы одного критерия группировки нет, вагон пропускается
		if ($k_clean < 0 || $k_notif < 0 || $k_gu2b < 0 || $k_holder < 0) {
			$json_Cars = @json_encode($carInfo,JSON_UNESCAPED_UNICODE);
			MyLittleLog($id, "notpriport, key=$k_clean.$k_notif.$k_gu2b.$k_holder BadCar: ".print_r($json_Cars,true), 'badCars', 'memo', 'asuST', 1);	
			continue;
		}
		
		$key = '_'.$k_clean.$k_notif.$k_gu2b.$k_holder;
		
		$groupedCars[$key]['cleanDate']			= $carInfo['cleanDate'];
		$groupedCars[$key]['dateNotification']	= $carInfo['dateNotification'];
		$groupedCars[$key]['gu2bID']			= $carInfo['gu2bID'];
		$groupedCars[$key]['carHolder']			= $carInfo['carHolder'];
		
		$groupedCars[$key]['carList'][] = $carInfo['carShip'];
	}
	unset($carInfoList);


	$info_gu2b = $info_client = [];
	$groupID = 0;
	// Перебираем сгруппированные вагоны и создаем акты на каждую группу
	foreach($groupedCars as $groupKey => $group) {
		$groupID++;
		// Пишем в лог исходники
		
		$groupCopy = $group;
		unset($groupCopy['carList']);
		MyLittleLog($id, "notpriport, group=$groupID, key=$groupKey : ".@json_encode($groupCopy,JSON_UNESCAPED_UNICODE), 'group', 'memo', 'asuST', 1);
		
		// Собираем инфу для шаблона АОФ
		$NoPortNoDoc_Contract = []; $ClientCode = '';
		// Поиск инфы про гу2б
		if (!array_key_exists($group['gu2bID'], $info_gu2b)) {
			$q_gu2b = "
				SELECT TOP 1 g.etranIdMsg AS etranID
					,gu2bID, g.gu2bDate
					,crgWay AS pnpWay, g.crgOrgID
				FROM interface_buff.dbo.Gu2b AS g
				WHERE g.gu2bId = {$group['gu2bID']}
				ORDER BY id DESC
			";
			$res_gu2b = sql_query($q_gu2b);
			if (sql_num_rows($res_gu2b) > 0) {
				$info_gu2b[$group['gu2bID']] = sql_fetch_assoc($res_gu2b);
			}
			unset($q_gu2b, $res_gu2b);
		}
		if (CheckIsset($info_gu2b, $group['gu2bID'])) {
			$NoPortNoDoc_Contract = $info_gu2b[$group['gu2bID']];

			$ClientCode = $NoPortNoDoc_Contract['crgOrgID'];
			unset($NoPortNoDoc_Contract['crgOrgID']);
		}
		if (!$ClientCode) {
			MyLittleLog($id, "notpriport, no ClientCode group=$groupID, key=$groupKey", 'group', 'memo', 'asuST', 1);
			continue;
		}
		
/*
	данные договора (если он один)
	1
	3 - На подачу/уборку вагонов (лок. пользователя)
	4 - На подачу/уборку по временному соглашению
	5 - На подачу/уборку вагонов (лок. перевозчика)
	
	0
	1 - На эксплуатацию ПНП (лок. организации)
	2 - На эксплуатацию ПНП (лок. перевозчика)					
	9 - На эксплуатацию ПНП по нескольким станциям
	
	6 - Приказ начальника дороги
	7 - Не заполнено
	8 - По ст.56 Устава
	10 - Приказ НОД
	11 - Регламент взаимодействия
*/
		// Поиск инфы про клиента
		if (!array_key_exists($ClientCode, $info_client)) {
			$query_doc = "
				SELECT CASE WHEN (trp.ContractNum IS NULL) THEN 'б/н' ELSE trp.ContractNum END AS contractNum
					,trp.dateBegin AS contractDate
					,CASE WHEN trp.dogType IN (3,4,5) THEN 1 ELSE 0 END AS contractType
					,CASE WHEN trp.typeClient = 'owner' THEN 0 ELSE 1 END AS pnpResponceType
					,trp.id AS companyCode
				FROM   arg.dbo.T_ReceiverPP AS trp
				WHERE	trp.code = '$ClientCode'
						AND trp.station = '$StationCode'
						AND trp.emptyNotDoc = 1
						AND trp.actual = 1
			";
			$res_doc = sql_query($query_doc);
			if (sql_num_rows($res_doc) == 1) {
				$info_client[$ClientCode] = sql_fetch_assoc($res_doc);
			}
		}
		if (CheckIsset($info_client, $ClientCode)) {
			$doc = $info_client[$ClientCode];
			$NoPortNoDoc_Contract = array_merge($NoPortNoDoc_Contract, $doc);
		}		
		$NoPortNoDoc_Contract['carHolder'] = $group['carHolder'];
		// $NoPortNoDoc_Contract['companyCode'] = $ClientCode;
		if ($memo->placeFeed)	$NoPortNoDoc_Contract['pnpWay']   = $memo->placeFeed;
		if ($wayID)				$NoPortNoDoc_Contract['pnpWayID'] = $wayID;
		

		// Создаем массив акта
		$aof = [];
		$aof['aofOwner']	= 0;
		$aof['aofReason']	= 1248;
		$aof['aofDate']		= $group['cleanDate'];
		$aof['aofStation']	= $StationCode;
		
		// Пихаем вагоны
		$aof['carriage'] = $group['carList'];
		
		// json
		$aof_json = [];
		$carsCount = 5;
		if (count($aof['carriage']) > 1) $carsCount = 6;
		
		$aof_json['selCarsCount_nodt'] = $carsCount;
		$aof_json['pnpWay'] = $NoPortNoDoc_Contract['pnpWay'];
		$aof_json['contractType'] = $NoPortNoDoc_Contract['contractType'];
		$aof_json['contractNum'] = $NoPortNoDoc_Contract['contractNum'];
		$aof_json['companyActualType'] = $NoPortNoDoc_Contract['pnpResponceType'];
		
		
		$gu2bDate = DateParseSilent($NoPortNoDoc_Contract['gu2bDate'], 'obj');
		$notifDate = DateParseSilent($group['dateNotification'], 'obj');
		$contractDate = DateParseSilent($NoPortNoDoc_Contract['contractDate'], 'obj');
		
		if ($gu2bDate) {
			$aof_json['gu2bDate'] = $gu2bDate->format('d.m.y');
			$aof_json['gu2bTime'] = $gu2bDate->format('H:i');
		}
		if ($notifDate) {
			$aof_json['popDate'] = $notifDate->format('d.m.y');
			$aof_json['popTime'] = $notifDate->format('H:i');
		}
		if ($contractDate) {
			$aof_json['contractDate'] = $contractDate->format('d.m.y');
		}
		/*
		$aof_json = '{"selCarsCount_nodt":'.$carsCount.', "pnpWay":"'.$NoPortNoDoc_Contract['pnpWay'].'", "gu2bDate":"'.$gu2bDate->format('d.m.y').'", "gu2bTime":"'.$gu2bDate->format('H:i').'", "contractType":"'.$NoPortNoDoc_Contract['contractType'].'", "contractNum":"'.$NoPortNoDoc_Contract['contractNum'].'", "contractDate":"'.$contractDate->format('d.m.y').'", "contractTime":"'.$contractDate->format('H:i').'", "companyActualType":"'.$NoPortNoDoc_Contract['pnpResponceType'].'", "popDate":"'.$notifDate->format('d.m.y').'", 
		"popTime":"'.$notifDate->format('H:i').'"}';
		*/
		$aof['aof_json'] = json_encode_ru($aof_json);
		$aof['NoPortNoDoc_Contract'] = $NoPortNoDoc_Contract;
		
		// Создаем акты
		$result = create_aof_byCar(['aof' => $aof]);
		
		MyLittleLog($id, "notpriport create aof for group=$groupID, key=$groupKey, result is ".@json_encode($result,JSON_UNESCAPED_UNICODE), 'memoAOF', 'memo', 'asuST', 1);
	}
}

function GetMasterStation($StCode) {
	if (!$StCode) return [];
	$ans = [$StCode];
	$res = sql_query("
		SELECT st.Code, st.Name
		FROM nsi.dbo.D_Station AS st
			INNER JOIN nsi.dbo.d_station AS stM ON stM.Code = st.MasterCode
		WHERE stM.code='$StCode'
	");
	
	if (sql_num_rows($res) > 0)
		while ($r = sql_fetch_assoc($res))
			$ans[] = $r['Code'];
	
	return $ans;
}

?>